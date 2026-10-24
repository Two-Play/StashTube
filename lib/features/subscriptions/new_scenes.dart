import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../core/config/theme.dart';
import '../../data/models/list_queries.dart';
import '../../l10n/l10n.dart';
import '../../widgets/scene_feed.dart';
import '../shell/navigation.dart';
import 'last_visit.dart';

/// "N new videos since your last visit" on home (NOTIF-1). Opens the new
/// scenes; both that and the close button mark them as seen. Nothing while
/// there is nothing new (or the count failed: it is only a hint).
class NewSinceLastVisitBanner extends ConsumerWidget {
  const NewSinceLastVisitBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counted = ref.watch(newScenesSinceLastVisitProvider);
    // Not the previous count while counting again (e.g. after "seen").
    final count = counted.isLoading ? 0 : counted.value ?? 0;
    final since = ref.watch(lastVisitProvider);
    if (count == 0 || since == null) return const SizedBox.shrink();
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.s, AppSpacing.l, 0),
      child: Material(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(Icons.fiber_new_outlined, color: scheme.onSecondaryContainer),
          title: Text(l.newSinceLastVisit(count), style: TextStyle(color: scheme.onSecondaryContainer)),
          trailing: IconButton(
            tooltip: l.close,
            icon: Icon(Icons.close, color: scheme.onSecondaryContainer),
            onPressed: () {
              Haptics.light();
              ref.read(lastVisitProvider.notifier).markSeen();
            },
          ),
          onTap: () {
            Haptics.selection();
            openPage(ref, NewScenesPage(since: since));
            ref.read(lastVisitProvider.notifier).markSeen();
          },
        ),
      ),
    );
  }
}

/// The scenes added after [since], newest first.
class NewScenesPage extends StatefulWidget {
  const NewScenesPage({super.key, required this.since});

  final DateTime since;

  @override
  State<NewScenesPage> createState() => _NewScenesPageState();
}

class _NewScenesPageState extends State<NewScenesPage> {
  late final _query = SceneQuery(createdAfter: widget.since);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(context.l10n.newSinceLastVisitTitle)),
        body: SceneFeedView(
          initialQuery: _query,
          filterable: true,
          showCount: true,
          emptyMessage: context.l10n.newSinceLastVisitEmpty,
        ),
      );
}
