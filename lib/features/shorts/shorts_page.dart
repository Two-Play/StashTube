import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../core/config/server_config.dart';
import '../../core/config/theme.dart';
import '../../data/models/scene.dart';
import '../../data/repositories/stash_repository.dart';
import '../../l10n/l10n.dart';
import '../../widgets/stash_image.dart';
import '../../widgets/status_views.dart';
import '../library/watch_later.dart';
import '../player/player_providers.dart';
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
  int _index = 0;

  /// Only loads and creates players once the page was shown the first time.
  bool _started = false;
  bool _visible = false;

  /// Paused by a tap, or because the main player started playing.
  bool _paused = false;
  bool _appVisible = true;
  bool _mainExpanded = false;
  bool _wasCoveredByMain = false;

  StreamSubscription<Duration>? _positionSub;
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

  /// Opens the current short and its neighbours in the pool's players and
  /// plays only the current one.
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
      reassigned = true;
      players[slot].open(Media(scene.streamUrl!, httpHeaders: ref.read(authHeadersProvider)), play: false);
    }
    if (reassigned) setState(() {});

    final current = _slot(_index);
    for (var slot = 0; slot < _poolSize; slot++) {
      final player = players[slot];
      if (slot == current && _visible && !_paused) {
        if (!player.state.playing) player.play();
      } else if (player.state.playing) {
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
    _players?[_slot(index)].seek(Duration.zero);
    _watchPosition(items[index]);
    _sync(items);
    final feed = ref.read(shortsFeedProvider);
    if (index >= feed.items.length - 5) ref.read(shortsFeedProvider.notifier).loadMore();
  }

  /// Counts a play once the short was watched halfway (at most 15 s).
  void _watchPosition(Scene scene) {
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
        if (previous != null && previous.items.isNotEmpty && next.items.isEmpty) {
          _slotScene.fillRange(0, _poolSize, null);
          _index = 0;
          if (_pageController.hasClients) _pageController.jumpToPage(0);
        }
        if (previous?.items.isEmpty != false && next.items.isNotEmpty) _watchPosition(next.items[_index]);
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
              _TopBar(onRefresh: () => ref.read(shortsFeedProvider.notifier).refresh()),
            ],
          ),
        ),
      ),
    );
  }

}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      bottom: false,
      child: Row(
        children: [
          if (Navigator.of(context).canPop()) const BackButton(color: Colors.white) else const SizedBox(width: 16),
          Text(l.tabShorts, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const Spacer(),
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
    );
  }
}

/// One page: the video (or its screenshot until it is loaded), the info at
/// the bottom, the actions on the right and a thin progress bar.
class _ShortView extends ConsumerWidget {
  const _ShortView({required this.scene, required this.controller, required this.paused, required this.onTap});

  final Scene scene;
  final VideoController? controller;
  final bool paused;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final width = scene.width;
    final height = scene.height;
    // Fill the screen with portrait videos; show wide ones whole.
    final fit = width != null && height != null && height > width ? BoxFit.cover : BoxFit.contain;
    final saved = ref.watch(watchLaterProvider.select((ids) => ids.contains(scene.id)));
    final performer = scene.performers.firstOrNull;
    final controller = this.controller;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (scene.screenshotUrl != null) StashImage(scene.screenshotUrl!, fit: fit),
        if (controller != null)
          Video(
            controller: controller,
            fit: fit,
            fill: Colors.transparent,
            controls: _noControls,
          ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Center(
            child: AnimatedOpacity(
              opacity: paused ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: const Icon(Icons.play_arrow_rounded, size: 88, color: Colors.white70),
            ),
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 220,
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
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (scene.performers.isNotEmpty)
                Text(
                  scene.performers.map((p) => p.name).join(', '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              Text(
                scene.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              ),
              if (scene.tags.isNotEmpty)
                Text(
                  scene.tags.take(4).map((t) => '#${t.name}').join(' '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70),
                ),
            ],
          ),
        ),
        Positioned(
          right: 8,
          bottom: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (performer != null)
                _Action(
                  label: performer.name,
                  onTap: () => openPerformer(ref, performer.id),
                  child: ChannelAvatar(name: performer.name, imageUrl: performer.imageUrl, radius: 22),
                ),
              _Action(
                label: l.tabWatchLater,
                onTap: () => ref.read(watchLaterProvider.notifier).toggle(scene.id),
                child: Icon(saved ? Icons.watch_later : Icons.watch_later_outlined, color: Colors.white, size: 32),
              ),
              _Action(
                label: l.shortsFullVideo,
                onTap: () => ref.read(nowPlayingProvider.notifier).play(scene),
                child: const Icon(Icons.open_in_full, color: Colors.white, size: 30),
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

class _Action extends StatelessWidget {
  const _Action({required this.label, required this.onTap, required this.child});

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 72,
            child: Column(
              children: [
                child,
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      );
}

/// Thin progress line; tap or drag along it to seek.
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.player});

  final Player player;

  void _seek(BuildContext context, double dx) {
    final width = context.size?.width ?? 0;
    final duration = player.state.duration;
    if (width <= 0 || duration == Duration.zero) return;
    player.seek(duration * (dx / width).clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (d) => _seek(context, d.localPosition.dx),
        onHorizontalDragUpdate: (d) => _seek(context, d.localPosition.dx),
        child: SizedBox(
          height: 16,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: StreamBuilder<Duration>(
              stream: player.stream.position,
              initialData: player.state.position,
              builder: (context, snapshot) {
                final duration = player.state.duration.inMilliseconds;
                final value = duration == 0 ? 0.0 : snapshot.data!.inMilliseconds / duration;
                return LinearProgressIndicator(
                  value: value.clamp(0.0, 1.0),
                  minHeight: 2,
                  backgroundColor: Colors.white24,
                );
              },
            ),
          ),
        ),
      );
}
