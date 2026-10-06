import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../core/config/server_config.dart';
import '../../core/config/theme.dart';
import '../../core/utils/format.dart';
import '../../data/models/scene.dart';
import '../../data/repositories/stash_repository.dart';
import '../../l10n/l10n.dart';
import '../../widgets/scene_card.dart';
import '../../widgets/stash_image.dart';
import '../../widgets/status_views.dart';
import '../library/watch_later.dart';
import '../player/player_providers.dart';
import '../player/scene_edits.dart';
import '../shell/navigation.dart';
import 'shorts_feed.dart';
import 'shorts_settings_sheet.dart';

/// Whether the app's main player is playing.
final _mainPlayingProvider = StreamProvider.autoDispose<bool>((ref) => ref.watch(playerProvider).stream.playing);

/// TikTok/Shorts-style feed (4.17): one short video per page, swiped
/// vertically, looping, with the chosen tags shown more often.
///
/// Has its own small pool of players next to the app's main player: the
/// current short plays, its neighbours are opened paused so swiping starts
/// them without delay. Plays only while its tab and route are on top, the
/// main player isn't expanded and the app is visible; starting it pauses
/// the main player.
class ShortsPage extends ConsumerStatefulWidget {
  const ShortsPage({super.key});

  @override
  ConsumerState<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends ConsumerState<ShortsPage> {
  static const _poolSize = 3;

  /// The tab this page lives in; it stays mounted (IndexedStack) while
  /// another tab is shown.
  late final AppTab _tab = ref.read(currentTabProvider);
  // Not restored from page storage: a new feed starts at its first short.
  final _pageController = PageController(keepPage: false);
  late final AppLifecycleListener _lifecycle;
  late final ValueNotifier<double> _miniplayerHeight;

  List<Player>? _players;
  List<VideoController>? _controllers;
  final _slotScene = List<String?>.filled(_poolSize, null);

  /// Whether the slot's `open` finished. media_kit's `open(play: false)`
  /// pauses only once the file is loaded, so a `play()` sent earlier would
  /// be undone: playback starts after this.
  final _slotReady = List<bool>.filled(_poolSize, false);
  int _index = 0;

  /// Only loads and creates players once the page was shown the first time.
  bool _started = false;
  bool _visible = false;

  /// Paused by a tap, or because the main player started playing.
  bool _paused = false;
  bool _muted = false;
  bool _appVisible = true;
  bool _mainExpanded = false;
  bool _wasCoveredByMain = false;

  StreamSubscription<Duration>? _positionSub;
  String? _watchedScene;
  final _counted = <String>{};

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onShow: () => setState(() => _appVisible = true),
      onHide: () => setState(() => _appVisible = false),
    );
    _miniplayerHeight = ref.read(miniplayerHeightProvider)..addListener(_onMiniplayerHeight);
  }

  @override
  void dispose() {
    _miniplayerHeight.removeListener(_onMiniplayerHeight);
    _lifecycle.dispose();
    _positionSub?.cancel();
    _pageController.dispose();
    for (final player in _players ?? const <Player>[]) {
      player.dispose();
    }
    super.dispose();
  }

  void _onMiniplayerHeight() {
    final expanded = _miniplayerHeight.value > kMiniPlayerHeight + 1;
    if (expanded != _mainExpanded) setState(() => _mainExpanded = expanded);
  }

  int _slot(int index) => index % _poolSize;

  /// Opens the current short and its neighbours in the pool's players.
  void _sync(List<Scene> items) {
    if (items.isEmpty) return;
    final players = _players ??= [
      for (var i = 0; i < _poolSize; i++) Player()..setPlaylistMode(PlaylistMode.single),
    ];
    _controllers ??= [for (final p in players) VideoController(p)];

    var reassigned = false;
    for (var i = _index - 1; i <= _index + 1; i++) {
      if (i < 0 || i >= items.length) continue;
      final scene = items[i];
      final slot = _slot(i);
      if (_slotScene[slot] == scene.id) continue;
      _slotScene[slot] = scene.id;
      _slotReady[slot] = false;
      reassigned = true;
      final player = players[slot];
      unawaited(player.setVolume(_muted ? 0 : 100));
      player
          .open(Media(scene.streamUrl!, httpHeaders: ref.read(authHeadersProvider)), play: false)
          .then((_) {
        if (!mounted || _slotScene[slot] != scene.id) return;
        _slotReady[slot] = true;
        _applyPlayback();
      }, onError: (Object _) {});
    }
    if (reassigned) setState(() {});
    if (_index < items.length) _watchPosition(items[_index]);
    _applyPlayback();
  }

  /// Plays the current short if it may play; pauses all others.
  void _applyPlayback() {
    final players = _players;
    if (players == null) return;
    final current = _slot(_index);
    for (var slot = 0; slot < _poolSize; slot++) {
      final player = players[slot];
      final play = slot == current && _slotReady[slot] && _visible && !_paused;
      if (play && !player.state.playing) {
        player.play();
      } else if (!play && player.state.playing) {
        player.pause();
      }
    }
  }

  void _onPageChanged(int index, List<Scene> items) {
    setState(() {
      _index = index;
      _paused = false;
    });
    // Start the short from the beginning when coming back to it.
    final slot = _slot(index);
    if (_slotReady[slot]) _players?[slot].seek(Duration.zero);
    _sync(items);
    final feed = ref.read(shortsFeedProvider);
    if (index >= feed.items.length - 5) ref.read(shortsFeedProvider.notifier).loadMore();
  }

  /// Counts a play once the short was watched halfway (at most 15 s).
  void _watchPosition(Scene scene) {
    if (_watchedScene == scene.id) return;
    _watchedScene = scene.id;
    _positionSub?.cancel();
    final player = _players?[_slot(_index)];
    if (player == null || _counted.contains(scene.id)) return;
    final threshold = Duration(milliseconds: (scene.duration * 500).round().clamp(1000, 15000));
    _positionSub = player.stream.position.listen((position) {
      if (position < threshold || !_counted.add(scene.id)) return;
      _positionSub?.cancel();
      unawaited(ref.read(stashRepositoryProvider).addPlay(scene.id).catchError((Object _) {}));
    });
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
    // Playing a short again takes over from the main player.
    if (!_paused && ref.read(nowPlayingProvider) != null) ref.read(playerProvider).pause();
    _applyPlayback();
  }

  void _toggleMute() {
    setState(() => _muted = !_muted);
    for (final player in _players ?? const <Player>[]) {
      player.setVolume(_muted ? 0 : 100);
    }
  }

  void _onVisibilityChanged(bool visible, {required bool fromMainPlayer}) {
    if (visible && ref.read(nowPlayingProvider) != null) {
      final main = ref.read(playerProvider);
      if (fromMainPlayer && main.state.playing) {
        // Collapsing the main player keeps it playing; the short waits.
        _paused = true;
      } else {
        main.pause();
      }
    }
    _visible = visible;
  }

  void _resetFeed() {
    _slotScene.fillRange(0, _poolSize, null);
    _slotReady.fillRange(0, _poolSize, false);
    _watchedScene = null;
    _index = 0;
    if (_pageController.hasClients) _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    final nowPlaying = ref.watch(nowPlayingProvider);
    final mainCovers = nowPlaying != null && _mainExpanded;
    final visible = ref.watch(currentTabProvider) == _tab &&
        (ModalRoute.of(context)?.isCurrent ?? true) &&
        _appVisible &&
        !mainCovers;
    if (visible != _visible) _onVisibilityChanged(visible, fromMainPlayer: !mainCovers && _wasCoveredByMain);
    _wasCoveredByMain = mainCovers;
    if (visible) _started = true;

    if (nowPlaying != null) {
      ref.listen(_mainPlayingProvider, (_, next) {
        if (next.value == true && _visible && !_paused) setState(() => _paused = true);
      });
    }

    final theme = AppTheme.dark(ref.watch(accentColorProvider));
    final feed = _started ? ref.watch(shortsFeedProvider) : const ShortsFeedState(isLoading: true);
    final items = feed.items;
    if (_started) {
      ref.listen(shortsFeedProvider, (previous, next) {
        // A new feed (settings changed, refresh): back to the first short.
        if (previous != null && previous.items.isNotEmpty && next.items.isEmpty) _resetFeed();
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _sync(items);
    });

    return Theme(
      data: theme,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              if (items.isNotEmpty)
                PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: items.length,
                  onPageChanged: (i) => _onPageChanged(i, items),
                  itemBuilder: (_, i) {
                    final slot = _slot(i);
                    final controller = _slotScene[slot] == items[i].id ? (_controllers?[slot]) : null;
                    return _ShortView(
                      key: ValueKey(items[i].id),
                      scene: items[i],
                      controller: controller,
                      paused: i == _index && _paused,
                      onTap: _togglePause,
                    );
                  },
                )
              else if (feed.error != null)
                ErrorView(error: feed.error!, onRetry: () => ref.read(shortsFeedProvider.notifier).refresh())
              else if (feed.isLoading)
                const LoadingView()
              else
                EmptyView(
                  message: context.l10n.shortsEmpty,
                  hint: context.l10n.shortsEmptyHint,
                  icon: Icons.slow_motion_video,
                ),
              _TopBar(
                muted: _muted,
                onToggleMute: _toggleMute,
                onRefresh: () => ref.read(shortsFeedProvider.notifier).refresh(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.muted, required this.onToggleMute, required this.onRefresh});

  final bool muted;
  final VoidCallback onToggleMute;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black54, Colors.transparent],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (Navigator.of(context).canPop()) const BackButton(color: Colors.white) else const SizedBox(width: 16),
            Text(l.tabShorts, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
            const Spacer(),
            IconButton(
              tooltip: muted ? l.unmute : l.mute,
              color: Colors.white,
              icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
              onPressed: onToggleMute,
            ),
            IconButton(
              tooltip: l.sortShuffle,
              color: Colors.white,
              icon: const Icon(Icons.shuffle),
              onPressed: onRefresh,
            ),
            IconButton(
              tooltip: l.shortsSettings,
              color: Colors.white,
              icon: const Icon(Icons.tune),
              onPressed: () => showShortsSettingsSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

const _shadow = [Shadow(blurRadius: 6, color: Colors.black54)];

/// One page: the video (or its screenshot until it is loaded), the info at
/// the bottom, the actions on the right and a progress bar.
class _ShortView extends ConsumerStatefulWidget {
  const _ShortView({
    super.key,
    required this.scene,
    required this.controller,
    required this.paused,
    required this.onTap,
  });

  final Scene scene;
  final VideoController? controller;
  final bool paused;
  final VoidCallback onTap;

  @override
  ConsumerState<_ShortView> createState() => _ShortViewState();
}

class _ShortViewState extends ConsumerState<_ShortView> {
  bool _rating = false;
  bool _fast = false;

  Player? get _player => widget.controller?.player;

  void _setFast(bool fast) {
    final player = _player;
    if (player == null || fast == _fast) return;
    if (fast) HapticFeedback.lightImpact();
    player.setRate(fast ? 2 : 1);
    setState(() => _fast = fast);
  }

  void _showError(Object e) {
    final l = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.saveFailed(errorText(l, e)))));
  }

  void _rate(int stars) {
    HapticFeedback.selectionClick();
    final current = effectiveStars(ref, widget.scene);
    // Tapping the current rating again removes it.
    ref.read(sceneEditsProvider.notifier).rate(widget.scene, stars == current ? 0 : stars).catchError(_showError);
    setState(() => _rating = false);
  }

  Future<void> _addO() async {
    HapticFeedback.mediumImpact();
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final notifier = ref.read(sceneEditsProvider.notifier);
    try {
      final count = await notifier.addO(widget.scene);
      messenger.showSnackBar(SnackBar(
        content: Text(l.oCountValue(count)),
        action: SnackBarAction(label: l.undo, onPressed: () => notifier.removeO(widget.scene).catchError(_showError)),
      ));
    } catch (e) {
      if (mounted) _showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scene = widget.scene;
    final width = scene.width;
    final height = scene.height;
    // Fill the screen with portrait videos; show wide ones whole.
    final fit = width != null && height != null && height > width ? BoxFit.cover : BoxFit.contain;
    final saved = ref.watch(watchLaterProvider.select((ids) => ids.contains(scene.id)));
    final stars = effectiveStars(ref, scene);
    final oCount = effectiveOCounter(ref, scene);
    final tags = effectiveTags(ref, scene);
    final performer = scene.performers.firstOrNull;
    final studio = scene.studio;
    final controller = widget.controller;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (scene.screenshotUrl != null) StashImage(scene.screenshotUrl!, fit: fit),
        if (controller != null)
          Video(controller: controller, fit: fit, fill: Colors.transparent, controls: _noControls),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (_rating) {
              setState(() => _rating = false);
            } else {
              widget.onTap();
            }
          },
          // Hold for double speed, like TikTok.
          onLongPressStart: (_) => _setFast(true),
          onLongPressEnd: (_) => _setFast(false),
          onLongPressCancel: () => _setFast(false),
          child: Center(child: _CenterIndicator(player: _player, paused: widget.paused)),
        ),
        if (_fast)
          Positioned(
            top: MediaQuery.paddingOf(context).top + 56,
            left: 0,
            right: 0,
            child: Center(child: _Pill(child: Text(l.shortsFastForward, style: const TextStyle(color: Colors.white)))),
          ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 260,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 88,
          bottom: 28,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                children: [
                  if (studio != null)
                    _Link(
                      text: studio.name,
                      bold: true,
                      onTap: () => openStudio(ref, studio.id),
                    ),
                  for (final p in scene.performers)
                    _Link(text: '@${p.name}', bold: true, onTap: () => openPerformer(ref, p.id)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                scene.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 15, shadows: _shadow),
              ),
              if (tags.isNotEmpty) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final t in tags.take(5)) _Link(text: '#${t.name}', onTap: () => openTag(ref, t.id)),
                  ],
                ),
              ],
              const SizedBox(height: 4),
              Text(
                [
                  l.playsCount(scene.playCount),
                  if (scene.duration > 0) formatDuration(scene.duration),
                ].join(' • '),
                style: const TextStyle(color: Colors.white70, fontSize: 12, shadows: _shadow),
              ),
            ],
          ),
        ),
        Positioned(
          right: 4,
          bottom: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (performer != null)
                _Action(
                  label: performer.name,
                  onTap: () => openPerformer(ref, performer.id),
                  child: DecoratedBox(
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    child: ChannelAvatar(name: performer.name, imageUrl: performer.imageUrl, radius: 22),
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSize(
                    duration: const Duration(milliseconds: 150),
                    child: _rating ? _StarPicker(stars: stars, onRate: _rate) : const SizedBox.shrink(),
                  ),
                  _Action(
                    label: stars == 0 ? l.shortsRate : '$stars',
                    onTap: () => setState(() => _rating = !_rating),
                    child: Icon(
                      stars == 0 ? Icons.star_outline_rounded : Icons.star_rounded,
                      color: stars == 0 ? Colors.white : Colors.amber,
                      size: 36,
                      shadows: _shadow,
                    ),
                  ),
                ],
              ),
              _Action(
                label: '$oCount',
                tooltip: l.addO,
                onTap: _addO,
                child: const Icon(Icons.water_drop_outlined, color: Colors.white, size: 32, shadows: _shadow),
              ),
              _Action(
                label: l.tabWatchLater,
                onTap: () => ref.read(watchLaterProvider.notifier).toggle(scene.id),
                child: Icon(
                  saved ? Icons.watch_later : Icons.watch_later_outlined,
                  color: Colors.white,
                  size: 32,
                  shadows: _shadow,
                ),
              ),
              _Action(
                label: l.shortsFullVideo,
                onTap: () => ref.read(nowPlayingProvider.notifier).play(scene),
                child: const Icon(Icons.open_in_full, color: Colors.white, size: 30, shadows: _shadow),
              ),
              _Action(
                label: l.moreActions,
                onTap: () => showSceneMenu(context, ref, scene),
                child: const Icon(Icons.more_horiz, color: Colors.white, size: 30, shadows: _shadow),
              ),
            ],
          ),
        ),
        if (controller != null)
          Positioned(left: 0, right: 0, bottom: 0, child: _ProgressBar(player: controller.player)),
      ],
    );
  }
}

Widget _noControls(VideoState state) => const SizedBox.shrink();

/// Play icon while paused, a spinner while the video buffers.
class _CenterIndicator extends StatelessWidget {
  const _CenterIndicator({required this.player, required this.paused});

  final Player? player;
  final bool paused;

  @override
  Widget build(BuildContext context) {
    final player = this.player;
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: paused ? 1 : 0,
          duration: const Duration(milliseconds: 150),
          child: const Icon(Icons.play_arrow_rounded, size: 88, color: Colors.white70),
        ),
        if (player != null && !paused)
          StreamBuilder<bool>(
            stream: player.stream.buffering,
            initialData: player.state.buffering,
            builder: (_, snapshot) => snapshot.data!
                ? const SizedBox.square(
                    dimension: 40,
                    child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white70),
                  )
                : const SizedBox.shrink(),
          ),
      ],
    );
  }
}

/// Five stars in a pill, left of the rating button.
class _StarPicker extends StatelessWidget {
  const _StarPicker({required this.stars, required this.onRate});

  final int stars;
  final ValueChanged<int> onRate;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: _Pill(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= 5; i++)
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: i == stars ? l.removeRating : l.rateStars(i),
                icon: Icon(
                  i <= stars ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: i <= stars ? Colors.amber : Colors.white,
                ),
                onPressed: () => onRate(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(24)),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), child: child),
      );
}

class _Link extends StatelessWidget {
  const _Link({required this.text, required this.onTap, this.bold = false});

  final String text;
  final VoidCallback onTap;
  final bool bold;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            shadows: _shadow,
          ),
        ),
      );
}

class _Action extends StatelessWidget {
  const _Action({required this.label, required this.onTap, required this.child, this.tooltip});

  final String label;
  final VoidCallback onTap;
  final Widget child;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final action = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            child,
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, shadows: _shadow),
            ),
          ],
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: tooltip == null ? action : Tooltip(message: tooltip, child: action),
    );
  }
}

/// Progress line; tap or drag along it to seek. Thicker and with the time
/// while dragging.
class _ProgressBar extends StatefulWidget {
  const _ProgressBar({required this.player});

  final Player player;

  @override
  State<_ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<_ProgressBar> {
  /// Fraction while dragging.
  double? _drag;

  double _fraction(double dx) {
    final width = context.size?.width ?? 0;
    return width <= 0 ? 0 : (dx / width).clamp(0.0, 1.0);
  }

  void _seek(double fraction) {
    final duration = widget.player.state.duration;
    if (duration > Duration.zero) widget.player.seek(duration * fraction);
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (d) => _seek(_fraction(d.localPosition.dx)),
      onHorizontalDragStart: (d) => setState(() => _drag = _fraction(d.localPosition.dx)),
      onHorizontalDragUpdate: (d) => setState(() => _drag = _fraction(d.localPosition.dx)),
      onHorizontalDragEnd: (_) {
        final drag = _drag;
        if (drag != null) _seek(drag);
        setState(() => _drag = null);
      },
      onHorizontalDragCancel: () => setState(() => _drag = null),
      child: SizedBox(
        height: 24,
        child: StreamBuilder<Duration>(
          stream: player.stream.position,
          initialData: player.state.position,
          builder: (context, snapshot) {
            final duration = player.state.duration;
            final ms = duration.inMilliseconds;
            final value = _drag ?? (ms == 0 ? 0.0 : snapshot.data!.inMilliseconds / ms);
            return Stack(
              alignment: Alignment.bottomCenter,
              // The time sits above the bar.
              clipBehavior: Clip.none,
              children: [
                if (_drag != null)
                  Positioned(
                    bottom: 8,
                    child: Text(
                      '${formatDuration(duration.inMilliseconds * _drag! / 1000)} / ${formatDuration(ms / 1000)}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, shadows: _shadow),
                    ),
                  ),
                LinearProgressIndicator(
                  value: value.clamp(0.0, 1.0),
                  minHeight: _drag == null ? 2 : 5,
                  backgroundColor: Colors.white24,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
