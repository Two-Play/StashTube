import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../core/config/theme.dart';
import '../../core/utils/format.dart';
import '../../data/models/scene.dart';
import '../../data/models/scene_details.dart';
import '../../data/models/scrub_thumbnails.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_session.dart';
import '../../widgets/scene_card.dart';
import '../../widgets/stash_image.dart';
import 'player_providers.dart';
import 'preview_seek_bar.dart';
import 'video_controls.dart';
import '../../l10n/l10n.dart';

/// Claims single taps inside the expanded player.
///
/// The miniplayer package wraps the whole panel in a `GestureDetector` whose
/// `onTap` collapses an expanded panel. media_kit detects single taps with a
/// raw `Listener`, so without this guard every tap on the video (or on empty
/// space in the details) ends up collapsing the player. A deeper tap
/// recognizer wins the gesture arena; buttons, double-tap and drag still work.
class PanelTapGuard extends StatelessWidget {
  const PanelTapGuard({super.key, this.enabled = true, required this.child});

  /// When false, taps reach the miniplayer again (e.g. tap-to-expand on the
  /// collapsed bar). Toggling keeps the widget tree stable.
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      GestureDetector(behavior: HitTestBehavior.opaque, onTap: enabled ? () {} : null, child: child);
}

/// media_kit's state of the one [PlayerVideo], to enter fullscreen when the
/// phone is turned.
final playerVideoKey = GlobalKey<VideoState>();

/// True while the fullscreen was entered by turning the phone; turning it
/// back to portrait then leaves it again.
final fullscreenByRotation = ValueNotifier<bool>(false);

/// Whether gravity (an accelerometer reading in m/s²) shows the phone held
/// upright, not sideways or lying flat.
bool isHeldUpright(double x, double y) => y.abs() > 7 && y.abs() > 2 * x.abs();

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
/// fullscreen a collapse button. Turning the phone to landscape then opens
/// fullscreen for wide videos (4.19).
class PlayerVideo extends ConsumerStatefulWidget {
  const PlayerVideo({super.key, required this.scene, required this.showControls});

  final Scene scene;
  final bool showControls;

  @override
  ConsumerState<PlayerVideo> createState() => _PlayerVideoState();
}

class _PlayerVideoState extends ConsumerState<PlayerVideo> {
  Orientation? _orientation;

  /// Held in portrait after leaving fullscreen while sideways (see
  /// [_onExitFullscreen]) until the phone is upright again ([_upright]) or
  /// the panel collapses.
  bool _portraitLocked = false;
  StreamSubscription<AccelerometerEvent>? _upright;

  @override
  void didUpdateWidget(PlayerVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.showControls) _releasePortrait();
  }

  @override
  void dispose() {
    _releasePortrait();
    super.dispose();
  }

  void _releasePortrait() {
    _stopWatchingUpright();
    if (!_portraitLocked) return;
    _portraitLocked = false;
    SystemChrome.setPreferredOrientations([]);
  }

  void _stopWatchingUpright() {
    _upright?.cancel();
    _upright = null;
  }

  /// Without a lock, leaving fullscreen while the phone is held sideways
  /// keeps the app in landscape: the expanded player then fills the screen
  /// with its controls hidden and looks stuck in fullscreen. Like YouTube,
  /// go back to portrait. The UI can't turn then, so the accelerometer tells
  /// when the phone is upright again: the lock goes, and turning the phone
  /// enters fullscreen as before. Without a sensor the lock stays until the
  /// panel collapses (releasing it sideways would enter fullscreen again).
  Future<void> _onExitFullscreen() async {
    final sideways = _orientation == Orientation.landscape;
    fullscreenByRotation.value = false;
    await defaultExitNativeFullscreen();
    if (!sideways || !mounted || !widget.showControls || !(Platform.isAndroid || Platform.isIOS)) return;
    _portraitLocked = true;
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (!mounted || !_portraitLocked) return;
    _stopWatchingUpright();
    _upright = accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval).listen(
      (event) {
        if (isHeldUpright(event.x, event.y)) _releasePortrait();
      },
      onError: (Object _) => _stopWatchingUpright(),
      cancelOnError: true,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final orientation = MediaQuery.orientationOf(context);
    final turned = _orientation != null && orientation != _orientation;
    _orientation = orientation;
    if (turned && orientation == Orientation.landscape) _onTurnedToLandscape();
  }

  void _onTurnedToLandscape() {
    final aspect = videoAspect(ref.read(playerProvider).state, widget.scene);
    final video = playerVideoKey.currentState;
    if (!widget.showControls || video == null || video.isFullscreen() || (aspect ?? 16 / 9) <= 1) return;
    fullscreenByRotation.value = true;
    // Not while the dependencies change.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) video.enterFullscreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scene = widget.scene;
    return Video(
      key: playerVideoKey,
      controller: ref.watch(videoControllerProvider),
      // backgroundPlaybackProvider decides (4.12): keep the sound, or pause.
      pauseUponEnteringBackgroundMode: false,
      onEnterFullscreen: () {
        // The fullscreen sets its own orientations.
        _portraitLocked = false;
        _stopWatchingUpright();
        return _enterFullscreen(ref.read(playerProvider).state, scene);
      },
      onExitFullscreen: _onExitFullscreen,
      // The same builder is used by media_kit's fullscreen route.
      controls: widget.showControls
          ? (state) => StashVideoControls(
                fullscreen: state.isFullscreen(),
                onToggleFullscreen: state.toggleFullscreen,
                scene: scene,
                onQuality: () => showQualitySheet(context, scene.id),
              )
          : _noControls,
    );
  }
}

/// Like media_kit's default, but locks the orientation to match the video:
/// landscape for wide videos, portrait for portrait videos (the default
/// always rotates to landscape, so portrait videos end up small and
/// pillarboxed). Entered by turning the phone, portrait stays allowed so
/// that turning it back leaves fullscreen.
Future<void> _enterFullscreen(PlayerState state, Scene scene) async {
  if (!Platform.isAndroid && !Platform.isIOS) return defaultEnterNativeFullscreen();
  final portrait = (videoAspect(state, scene) ?? 16 / 9) < 1;
  await Future.wait([
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []),
    SystemChrome.setPreferredOrientations([
      if (portrait || fullscreenByRotation.value) DeviceOrientation.portraitUp,
      if (!portrait) ...[DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    ]),
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
  });

  final SceneMarker marker;
  final double width;
  final bool current;
  final ScrubThumbnails? sprite;
  final VoidCallback onTap;

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
