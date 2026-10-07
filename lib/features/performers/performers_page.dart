import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/models/performer.dart';
import '../../data/providers.dart';
import '../../widgets/chip_bar.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/performer_tile.dart';
import '../shell/navigation.dart';
import '../../l10n/l10n.dart';
import '../settings/settings_button.dart';

class PerformersPage extends ConsumerStatefulWidget {
  const PerformersPage({super.key});

  @override
  ConsumerState<PerformersPage> createState() => _PerformersPageState();
}

class _PerformersPageState extends ConsumerState<PerformersPage> {
  var _query = PerformerQuery();

  @override
  Widget build(BuildContext context) {
    final provider = performerListProvider(_query);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.performersTitle),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => openSearch(ref)),
          const SettingsButton(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshFuture(ref, provider.future),
        child: LoadMoreListener(
          onLoadMore: () => ref.read(provider.notifier).loadMore(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: ChipBar<PerformerSort>(
                  values: PerformerSort.values,
                  selected: _query.sort,
                  labelOf: (s) => s.label(context.l10n),
                  onSelected: (s) => setState(() => _query = PerformerQuery(sort: s)),
                ),
              ),
              PagedSliver<Performer>(
                value: ref.watch(provider),
                emptyMessage: context.l10n.performersEmpty,
                emptyIcon: Icons.people_outline,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: 0.62,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                ),
                onRetry: () => ref.invalidate(provider),
                onLoadMore: () => ref.read(provider.notifier).loadMore(),
                itemBuilder: (_, performer) => PerformerTile(performer: performer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
