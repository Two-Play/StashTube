import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../core/config/theme.dart';
import '../../core/utils/format.dart';
import '../../data/models/scene.dart';
import '../../data/models/scene_details.dart';
import '../../data/models/scrub_thumbnails.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_session.dart';
import '../../widgets/scene_card.dart';
import '../../widgets/stash_image.dart';
import '../pip/pip.dart';
import '../security/app_lock.dart';
import '../../widgets/sliver_columns.dart';
import '../../widgets/app_orientation.dart';
import 'fullscreen_morph.dart';
import 'fullscreen_route.dart';
import 'held_orientation.dart';
import 'player_providers.dart';
import 'preview_seek_bar.dart';
import 'scene_actions.dart' show showMarkerMenu;
import 'video_controls.dart';
import '../../l10n/l10n.dart';

/// media_kit's state of the one [PlayerVideo].
final playerVideoKey = GlobalKey<VideoState>();

/// True while the fullscreen was entered by turning the phone, or the phone
/// was turned sideways in it; turning it back upright then leaves it.
final fullscreenByRotation = ValueNotifier<bool>(false);

/// Width / height of [scene]'s video: the decoded size once known (it
/// accounts for rotation metadata), else the file's size from Stash. With
/// [sceneFirst], Stash's size wins: right after switching scenes the
/// player still reports the previous video.
double? videoAspect(PlayerState state, Scene scene, {bool sceneFirst = false}) {
  final width = sceneFirst ? scene.width ?? state.width : state.width ?? scene.width;
  final height = sceneFirst ? scene.height ?? state.height : state.height ?? scene.height;
  return width == null || height == null || width <= 0 || height <= 0 ? null : width / height;
}

/// The one video surface of the player, used both in the miniplayer and in
/// the expanded view so it is never rebuilt during the transition.
///
/// With [showControls] it shows [StashVideoControls]: double tap to seek
/// ±10 s (4.11), quality (4.10), scrubbing with previews (4.14), and outside
/// fullscreen a collapse button. On a phone, turning it sideways then opens
/// fullscreen for wide videos and turning it back upright leaves it (4.19):
/// the app itself stays portrait, [heldOrientationProvider] reports the
/// turn, and [enterPlayerFullscreen]'s morph carries the video into the
/// fullscreen before the screen turns underneath.
class PlayerVideo extends ConsumerStatefulWidget {
  const PlayerVideo({super.key, required this.scene, required this.showControls});

  final Scene scene;
  final bool showControls;

  @override
  ConsumerState<PlayerVideo> createState() => _PlayerVideoState();
}

class _PlayerVideoState extends ConsumerState<PlayerVideo> {
  StreamSubscription<HeldOrientation>? _turns;
  HeldOrientation? _held;

  /// A turn counts once the phone was held that way for [_settleTime]:
  /// held at an angle, the system's report flips back and forth.
  Timer? _settle;
  static const _settleTime = Duration(milliseconds: 350);

  /// Left fullscreen (its button, back) while held sideways: sideways
  /// doesn't enter it again until the phone was upright.
  bool _waitForUpright = false;
  bool _fullscreen = false;

  /// How the phone was held in fullscreen: the morph back starts turned
  /// that way. Null when it wasn't known (entered by the button upright).
  HeldOrientation? _fullscreenHeld;

  /// The controls' contexts, below the [Video], inline and in the
  /// fullscreen route: fullscreen is entered and left from there.
  BuildContext? _controlsContext;
  BuildContext? _fullscreenControlsContext;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _watchTurns();
  }

  @override
  void dispose() {
    _turns?.cancel();
    _settle?.cancel();
    super.dispose();
  }

  /// Turns are watched on a phone for as long as the player lives, also
  /// while it is collapsed: the panel isn't "expanded" for a moment while
  /// the screen turns, and listening anew reported the phone's sideways
  /// hold at once, which entered fullscreen again right after leaving it.
  /// Tablets keep their side-by-side player
  /// (PlayerTransition.splitBreakpoint) and turn as a whole.
  void _watchTurns() {
    final phone = MediaQuery.sizeOf(context).shortestSide < kWideLayoutBreakpoint;
    if (phone == (_turns != null)) return;
    if (phone) {
      _turns = ref.read(heldOrientationProvider).listen(_onReported);
    } else {
      _turns?.cancel();
      _settle?.cancel();
      _turns = null;
      _held = null;
    }
  }

  void _onReported(HeldOrientation held) {
    _settle?.cancel();
    _settle = Timer(_settleTime, () {
      if (mounted) _onTurned(held);
    });
  }

  void _onTurned(HeldOrientation held) {
    _held = held;
    // Not behind the lock screen nor while the app is away: coming back
    // reported turns that each opened another fullscreen.
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (ref.read(appLockedProvider) || (lifecycle != null && lifecycle != AppLifecycleState.resumed)) return;
    if (!held.isLandscape) {
      _waitForUpright = false;
      final controls = _fullscreenControlsContext;
      if (_fullscreen && fullscreenByRotation.value && controls != null && controls.mounted) {
        exitPlayerFullscreen(controls);
      }
      return;
    }
    if (_fullscreen) {
      // Turned over in fullscreen; or entered by its button and now turned,
      // so turning back upright leaves it.
      if (_fullscreenHeld != null || _isWide) {
        _fullscreenHeld = held;
        fullscreenMorphKey.currentState?.held = held;
      }
      if (_isWide) fullscreenByRotation.value = true;
      return;
    }
    // In the open player (not the mini bar nor Android's picture-in-picture
    // window), with a wide video.
    final controls = _controlsContext;
    if (_waitForUpright || !widget.showControls || ref.read(pipProvider) || !_isWide) return;
    if (controls == null || !controls.mounted) return;
    fullscreenByRotation.value = true;
    enterPlayerFullscreen(controls, held: held, inline: inlineVideoRect);
  }

  bool get _isWide => (videoAspect(ref.read(playerProvider).state, widget.scene) ?? 16 / 9) > 1;

  Future<void> _onEnterFullscreen() {
    _fullscreen = true;
    final held = _held;
    _fullscreenHeld = held != null && held.isLandscape && _isWide ? held : null;
    return _enterFullscreen(ref.read(playerProvider).state, widget.scene);
  }

  /// Called as the fullscreen route goes (its button, back, turning the
  /// phone upright): the morph shows the fullscreen pose at once, the
  /// screen turns back underneath, and the video moves back into its place.
  Future<void> _onExitFullscreen() async {
    _fullscreen = false;
    fullscreenByRotation.value = false;
    _waitForUpright = _held?.isLandscape ?? false;
    final morph = fullscreenMorphKey.currentState;
    final controller = ref.read(videoControllerProvider);
    morph?.show(
      (controller: controller, aspect: playingAspect(controller), held: _fullscreenHeld, inline: inlineVideoRect),
      at: 1,
    );
    try {
      await _exitFullscreen();
      await morph?.animateTo(0);
    } finally {
      morph?.hide();
    }
  }

  /// For the fullscreen button: turned the way the phone is held, or
  /// unturned when that isn't known (the screen then turns in view).
  HeldOrientation? get _buttonHeld => _held != null && _held!.isLandscape ? _held : null;

  @override
  Widget build(BuildContext context) {
    final scene = widget.scene;
    return Video(
      key: playerVideoKey,
      controller: ref.watch(videoControllerProvider),
      // backgroundPlaybackProvider decides (4.12): keep the sound, or pause.
      pauseUponEnteringBackgroundMode: false,
      onEnterFullscreen: _onEnterFullscreen,
      onExitFullscreen: _onExitFullscreen,
      // The same builder is used by the fullscreen route. Fullscreen is read
      // from the controls' own place in the tree: VideoState's
      // isFullscreen()/toggleFullscreen() use the last context media_kit
      // remembered, which is still the fullscreen route's while that route
      // goes away (leaving picture-in-picture), and looking up its ancestors
      // then throws "Looking up a deactivated widget's ancestor is unsafe".
      controls: widget.showControls
          ? (state) => Builder(
                builder: (controlsContext) {
                  final fullscreen = isFullscreen(controlsContext);
                  if (fullscreen) {
                    _fullscreenControlsContext = controlsContext;
                  } else {
                    _controlsContext = controlsContext;
                  }
                  return StashVideoControls(
                    fullscreen: fullscreen,
                    onToggleFullscreen: () =>
                        togglePlayerFullscreen(controlsContext, held: _buttonHeld, inline: inlineVideoRect),
                    scene: scene,
                    onQuality: () => showQualitySheet(context, scene.id),
                  );
                },
              )
          : _noControls,
    );
  }
}

/// Where the player's own video is on screen, for [FullscreenMorph].
Rect? inlineVideoRect() {
  final box = playerVideoKey.currentContext?.findRenderObject();
  if (box is! RenderBox || !box.attached || !box.hasSize) return null;
  return box.localToGlobal(Offset.zero) & box.size;
}

/// Like media_kit's default, but locks the orientation to match the video:
/// landscape for wide videos, portrait for portrait videos (the default
/// always turns to landscape, so portrait videos end up small and
/// pillarboxed). Returns once the screen has turned.
Future<void> _enterFullscreen(PlayerState state, Scene scene) async {
  if (!Platform.isAndroid && !Platform.isIOS) return defaultEnterNativeFullscreen();
  final portrait = (videoAspect(state, scene) ?? 16 / 9) < 1;
  await Future.wait([
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []),
    AppOrientation.turnTo(
      portrait
          ? const [DeviceOrientation.portraitUp]
          : const [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    ),
  ]);
}

/// Like media_kit's default, but hands the orientations back to
/// [AppOrientation] (the default allows all, also on a phone's lists).
/// Returns once the screen has turned back.
Future<void> _exitFullscreen() async {
  if (!Platform.isAndroid && !Platform.isIOS) return defaultExitNativeFullscreen();
  await Future.wait([
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values),
    AppOrientation.turnTo(null),
  ]);
}

/// Shown while the panel isn't fully open. media_kit's `NoVideoControls` is
/// `null`, and `Video` ignores a change to `null`, so the expanded controls
/// would stay visible in the miniplayer.
Widget _noControls(VideoState state) => const SizedBox.shrink();

String _streamDescription(AppLocalizations l, SceneStream stream) {
  if (stream.isDirect) return l.streamOriginal;
  if (stream.isHls) return l.streamAdaptive;
  return l.streamTranscoded;
}

/// Bottom sheet listing the scene's `sceneStreams`.
Future<void> showQualitySheet(BuildContext context, String sceneId) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _QualitySheet(sceneId: sceneId),
    );

class _QualitySheet extends ConsumerWidget {
  const _QualitySheet({required this.sceneId});

  final String sceneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(sceneDetailsProvider(sceneId));
    final current = ref.watch(currentStreamProvider);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
        child: switch (details) {
          AsyncData(:final value) when value.streams.isNotEmpty => ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(context.l10n.quality, style: Theme.of(context).textTheme.titleMedium),
                ),
                for (final stream in value.streams)
                  ListTile(
                    leading: Icon(
                      (current == null ? stream.isDirect : current.label == stream.label)
                          ? Icons.check
                          : null,
                    ),
                    title: Text(stream.label),
                    subtitle: Text(_streamDescription(context.l10n, stream)),
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(nowPlayingProvider.notifier).selectStream(stream);
                    },
                  ),
              ],
            ),
          AsyncData() => ListTile(title: Text(context.l10n.noAlternativeStreams)),
          AsyncError(:final error) => ListTile(
              leading: const Icon(Icons.error_outline),
              title: Text(context.l10n.streamsLoadFailed),
              subtitle: Text(errorText(context.l10n, error)),
            ),
          _ => const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator())),
        },
      ),
    );
  }
}

/// A marker's time as the chapters and the markers grid show it: `1:15`, or
/// for a ranged marker `0:40–1:10`, with [withLength] `0:40–1:10 · 0:30`.
String markerTimeLabel(AppLocalizations l, double start, double? end, {bool withLength = false}) {
  if (end == null) return formatDuration(start);
  final range = l.markerRange(formatDuration(start), formatDuration(end));
  return withLength ? l.markerRangeWithLength(range, formatDuration(end - start)) : range;
}

/// What a screen reader says for a marker's time.
String spokenMarkerTime(AppLocalizations l, double start, double? end) => end == null
    ? l.markerAt(spokenDuration(l, start))
    : l.markerFromTo(spokenDuration(l, start), spokenDuration(l, end));

/// Horizontal list of chapters; tapping one seeks there (a ranged marker to
/// its start). Highlights the chapter currently playing: a ranged marker
/// while the position is inside its range, a moment until the next marker.
///
/// Each chapter shows the marker's screenshot with its time as a badge and
/// the title below. Markers without a screenshot use the scene's sprite
/// frame at that time; when there are no images at all, the chapters are
/// plain text tiles.
class ChapterList extends ConsumerWidget {
  const ChapterList({super.key, required this.sceneId, required this.details});

  final String sceneId;
  final SceneDetails details;

  /// Width of a chapter's thumbnail at normal text size: compact enough that
  /// "Up next" still starts within the first screen.
  static const thumbnailWidth = 120.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final player = ref.watch(playerProvider);
    // The sprite (and its WebVTT) only for markers without a screenshot.
    final needsSprite = details.vttUrl != null && details.markers.any((m) => m.screenshotUrl == null);
    final thumbs = needsSprite ? ref.watch(scrubThumbnailsProvider(sceneId)).value : null;
    final withImages = thumbs != null || details.markers.any((m) => m.screenshotUrl != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(context.l10n.chapters, style: theme.textTheme.titleSmall),
        ),
        StreamBuilder<Duration>(
          stream: player.stream.position,
          initialData: player.state.position,
          builder: (context, snapshot) {
            final current = details.markerAt(snapshot.data!.inMilliseconds / 1000);
            final scaler = MediaQuery.textScalerOf(context);
            void seek(SceneMarker marker) => ref.read(nowPlayingProvider.notifier).seekTo(marker.seconds);
            // Edit or delete it.
            void menu(SceneMarker marker) {
              final scene = ref.read(nowPlayingProvider);
              if (scene != null && scene.id == sceneId) showMarkerMenu(context, scene: scene, marker: marker);
            }

            if (withImages) {
              // Wider with large text, so titles keep a few words per line.
              final width = scaler.scale(thumbnailWidth).clamp(thumbnailWidth, 200.0);
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (i, marker) in details.markers.indexed) ...[
                      if (i > 0) const SizedBox(width: 4),
                      _ChapterThumbnailTile(
                        marker: marker,
                        width: width,
                        current: identical(marker, current),
                        sprite: thumbs,
                        onTap: () => seek(marker),
                        onLongPress: () => menu(marker),
                      ),
                    ],
                  ],
                ),
              );
            }

            // Tiles as tall as their text, so large text isn't cut off; wider too.
            final tileWidth = scaler.scale(140).clamp(140.0, 240.0);
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, marker) in details.markers.indexed) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Material(
                        color: identical(marker, current)
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => seek(marker),
                          onLongPress: () => menu(marker),
                          child: Container(
                            width: tileWidth,
                            constraints: const BoxConstraints(minHeight: 64),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  markerTimeLabel(context.l10n, marker.seconds, marker.endSeconds, withLength: true),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                                ),
                                Text(
                                  marker.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// A chapter with its picture (16:9, time badge) and a two-line title; the
/// current one sits on the accent's container color with a bold title.
class _ChapterThumbnailTile extends ConsumerWidget {
  const _ChapterThumbnailTile({
    required this.marker,
    required this.width,
    required this.current,
    required this.sprite,
    required this.onTap,
    this.onLongPress,
  });

  final SceneMarker marker;
  final double width;
  final bool current;
  final ScrubThumbnails? sprite;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final badge = AppColors.of(context);
    final height = width * 9 / 16;

    // The sprite frame stands in while the screenshot loads, if it fails
    // (not generated) and when there is none.
    final sprite = this.sprite;
    final cue = sprite?.cueAt(marker.seconds);
    final Widget standIn = sprite != null && cue != null
        ? ColoredBox(
            color: Colors.black,
            child: Center(
              child: SpriteFrame(
                spriteUrl: sprite.spriteUrl,
                cue: cue,
                width: width,
                height: width * cue.height / cue.width,
                headers: ref.watch(authHeadersProvider),
              ),
            ),
          )
        : ColoredBox(
            color: colors.surfaceContainerHighest,
            child: Center(child: Icon(Icons.bookmark_outline, color: colors.onSurfaceVariant)),
          );

    return Semantics(
      button: true,
      selected: current,
      child: Material(
        color: current ? colors.primaryContainer : Colors.transparent,
        borderRadius: AppRadius.cardBorder,
        child: InkWell(
          borderRadius: AppRadius.cardBorder,
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: SizedBox(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: AppRadius.thumbnailBorder,
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (marker.screenshotUrl case final url?)
                            StashImage(url, width: width, height: height, standIn: standIn)
                          else
                            standIn,
                          Positioned(
                            right: AppSpacing.xs,
                            bottom: AppSpacing.xs,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 1),
                              decoration:
                                  BoxDecoration(color: badge.badgeBackground, borderRadius: AppRadius.badgeBorder),
                              child: Text(
                                markerTimeLabel(context.l10n, marker.seconds, marker.endSeconds),
                                style: TextStyle(
                                  color: badge.onBadge,
                                  fontSize: AppTextSize.overlayLabel,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    marker.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: current ? colors.onPrimaryContainer : colors.onSurface,
                      fontWeight: current ? FontWeight.w600 : null,
                    ),
                  ),
                  // A ranged marker's length; the badge has its range.
                  if (marker.rangeSeconds case final length?)
                    Text(
                      formatDuration(length),
                      maxLines: 1,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: current ? colors.onPrimaryContainer : colors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
