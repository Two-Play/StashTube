import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/haptics.dart';
import '../core/config/server_config.dart';
import '../data/connection_status.dart';
import '../data/providers.dart';
import '../data/repositories/stash_repository.dart';
import '../features/auth/server_switcher.dart';
import '../features/library/watch_later.dart';
import '../l10n/l10n.dart';

/// Puts a banner above [child] while the active server can't be reached
/// (STATE-1, [connectionStatusProvider]), instead of only an error page per
/// list. The banner takes the status bar's space, so [child] loses its top
/// padding meanwhile. It goes away by itself once any call succeeds; then
/// the lists reload, so the ones that failed meanwhile recover.
class ConnectionBannerScope extends ConsumerStatefulWidget {
  const ConnectionBannerScope({super.key, required this.child});

  final Widget child;

  static const _duration = Duration(milliseconds: 250);

  @override
  ConsumerState<ConnectionBannerScope> createState() => _ConnectionBannerScopeState();
}

class _ConnectionBannerScopeState extends ConsumerState<ConnectionBannerScope> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: ConnectionBannerScope._duration);
  late final _size = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

  /// Whether [child] still gives the status bar's space to the banner (until
  /// it has slid away).
  bool _bannerShown = false;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && _bannerShown) setState(() => _bannerShown = false);
    });
    if (ref.read(connectionStatusProvider) == ServerReachability.unreachable) {
      _controller.value = 1;
      _bannerShown = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onStatus(ServerReachability? previous, ServerReachability next) {
    final offline = next == ServerReachability.unreachable;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (offline) {
      setState(() => _bannerShown = true);
      reduceMotion ? _controller.value = 1 : _controller.forward();
    } else {
      reduceMotion ? _controller.value = 0 : _controller.reverse();
    }
    if (previous == ServerReachability.unreachable && next == ServerReachability.reachable) reloadLists(ref);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(connectionStatusProvider, _onStatus);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizeTransition(
          sizeFactor: _size,
          alignment: Alignment.topCenter,
          child: _bannerShown ? const ConnectionBanner() : const SizedBox.shrink(),
        ),
        Expanded(
          child: MediaQuery.removePadding(context: context, removeTop: _bannerShown, child: widget.child),
        ),
      ],
    );
  }
}

/// Reloads the server's lists and pages after the connection came back:
/// they failed while it was gone, and Riverpod stops retrying after a few
/// attempts. The player (its tracker and details) is left alone.
void reloadLists(WidgetRef ref) {
  ref
    ..invalidate(sceneListProvider)
    ..invalidate(performerListProvider)
    ..invalidate(studioListProvider)
    ..invalidate(markerListProvider)
    ..invalidate(imageListProvider)
    ..invalidate(galleryListProvider)
    ..invalidate(tagListProvider)
    ..invalidate(groupListProvider)
    ..invalidate(performerProvider)
    ..invalidate(studioProvider)
    ..invalidate(galleryProvider)
    ..invalidate(tagProvider)
    ..invalidate(groupProvider)
    ..invalidate(libraryStatsProvider)
    ..invalidate(activityStatsProvider)
    ..invalidate(savedSceneFiltersProvider)
    ..invalidate(watchLaterScenesProvider);
}

/// Material 3 banner: "Server not reachable", the server's name, and the
/// actions "Retry" and "Switch server". Announced to screen readers.
class ConnectionBanner extends ConsumerStatefulWidget {
  const ConnectionBanner({super.key});

  @override
  ConsumerState<ConnectionBanner> createState() => _ConnectionBannerState();
}

class _ConnectionBannerState extends ConsumerState<ConnectionBanner> {
  bool _checking = false;

  /// Asks the server for its version, a small query: success hides the
  /// banner (the repository reports it) and reloads the lists.
  Future<void> _retry() async {
    Haptics.light();
    setState(() => _checking = true);
    try {
      await ref.read(stashRepositoryProvider).serverVersion();
    } on StashApiException catch (e) {
      // The server answered, but with an error (e.g. the API key): it is
      // reachable, and the lists show what is wrong.
      if (!e.isNetworkError && mounted) ref.read(connectionStatusProvider.notifier).report(reachable: true);
    } catch (_) {
      // Stays offline.
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final name = ref.watch(serverProfilesProvider.select((s) => s.active?.name));
    return Semantics(
      liveRegion: true,
      container: true,
      child: Material(
        color: scheme.surfaceContainerHigh,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2, right: 16),
                      child: Icon(Icons.cloud_off_outlined, color: scheme.error),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.connectionLostTitle, style: Theme.of(context).textTheme.titleSmall),
                          if (name != null)
                            Text(
                              l.connectionLostBody(name),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => showServerSwitcher(context),
                      child: Text(l.switchServer),
                    ),
                    TextButton(
                      onPressed: _checking ? null : _retry,
                      child: _checking
                          ? SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, semanticsLabel: l.retry),
                            )
                          : Text(l.retry),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
