import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../data/models/list_queries.dart';
import '../../data/repositories/stash_repository.dart';

/// When the user last used the app on the active server (NOTIF-1), stored
/// on the device per server as `last_visit:<serverId>`.
///
/// The state is the time "new" is measured from: the end of the previous
/// visit. It stays the same while the app is used, so the home banner and
/// the subscriptions' dots don't vanish mid-visit, and moves on when the
/// app comes back after [newVisitAfter] in the background, or when the
/// user has looked at the new scenes ([markSeen]). Null on the very first
/// visit: then nothing counts as new.
class LastVisitNotifier extends Notifier<DateTime?> {
  static const _key = 'last_visit';

  /// A shorter time in the background (a call, another app) continues the
  /// visit.
  static const newVisitAfter = Duration(minutes: 30);

  /// Replaced in tests.
  @visibleForTesting
  static DateTime Function() clock = DateTime.now;

  DateTime? _hiddenAt;

  String? get _serverKey {
    final server = ref.read(activeServerIdProvider);
    return server == null ? null : '$_key:$server';
  }

  @override
  DateTime? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    ref.watch(activeServerIdProvider);
    _hiddenAt = null;
    final key = _serverKey;
    if (key == null) return null;
    final stored = prefs.getInt(key);
    if (stored == null) {
      // The first visit: from now on, scenes count as new.
      prefs.setInt(key, clock().millisecondsSinceEpoch);
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(stored);
  }

  /// The app went to the background: this visit ends here, unless it comes
  /// back soon ([returned]).
  Future<void> left() async {
    final now = clock();
    _hiddenAt = now;
    await _store(now);
  }

  /// The app is visible again; after a long break, a new visit starts and
  /// counts from when the previous one ended.
  void returned() {
    final hiddenAt = _hiddenAt;
    _hiddenAt = null;
    if (hiddenAt != null && clock().difference(hiddenAt) >= newVisitAfter) state = hiddenAt;
  }

  /// The user opened (or dismissed) the new scenes: nothing is new anymore.
  Future<void> markSeen() async {
    final now = clock();
    state = now;
    await _store(now);
  }

  Future<void> _store(DateTime time) async {
    final key = _serverKey;
    if (key != null) await ref.read(sharedPreferencesProvider).setInt(key, time.millisecondsSinceEpoch);
  }
}

final lastVisitProvider = NotifierProvider<LastVisitNotifier, DateTime?>(LastVisitNotifier.new);

/// How many scenes were added since the last visit; 0 on the first visit.
final newScenesSinceLastVisitProvider = FutureProvider.autoDispose<int>((ref) async {
  final since = ref.watch(lastVisitProvider);
  if (since == null) return 0;
  final page = await ref.watch(stashRepositoryProvider).findScenes(SceneQuery(createdAfter: since), perPage: 1);
  return page.totalCount;
});

/// Favorite performers with scenes added since the last visit (the dots
/// on their avatars). Looks at the newest [_sample] such scenes, which is
/// plenty between two visits.
final performersWithNewScenesProvider = FutureProvider.autoDispose<Set<String>>((ref) async {
  final since = ref.watch(lastVisitProvider);
  if (since == null) return const {};
  final page = await ref
      .watch(stashRepositoryProvider)
      .findScenes(SceneQuery(favoritePerformersOnly: true, createdAfter: since), perPage: _sample);
  return {
    for (final scene in page.items)
      for (final performer in scene.performers)
        if (performer.favorite) performer.id,
  };
});

const _sample = 100;

/// Records the end of a visit when the app goes to the background, and
/// starts a new one when it comes back after a while. Placed once around
/// the shell.
class LastVisitRecorder extends ConsumerStatefulWidget {
  const LastVisitRecorder({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<LastVisitRecorder> createState() => _LastVisitRecorderState();
}

class _LastVisitRecorderState extends ConsumerState<LastVisitRecorder> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onHide: () => ref.read(lastVisitProvider.notifier).left(),
      onShow: () => ref.read(lastVisitProvider.notifier).returned(),
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
