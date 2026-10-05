import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/models/tag.dart';
import '../../data/providers.dart';
import '../../widgets/chip_bar.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/stash_image.dart';
import '../shell/navigation.dart';
import 'tag_editor.dart';
import '../../l10n/l10n.dart';

/// Discover: every tag that has scenes, most used first (8.2).
class TagsPage extends ConsumerStatefulWidget {
  const TagsPage({super.key});

  @override
  ConsumerState<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends ConsumerState<TagsPage> {
  var _query = const TagQuery();

  @override
  Widget build(BuildContext context) {
    final provider = tagListProvider(_query);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.tagsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(context.l10n.newTag),
        onPressed: () async {
          final tag = await showCreateTagDialog(context, ref);
          if (tag != null) openTag(ref, tag.id);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshFuture(ref, provider.future),
        child: LoadMoreListener(
          onLoadMore: () => ref.read(provider.notifier).loadMore(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: ChipBar<TagSort>(
                  values: TagSort.values,
                  selected: _query.sort,
                  labelOf: (s) => s.label(context.l10n),
                  onSelected: (s) => setState(() => _query = TagQuery(sort: s)),
                ),
              ),
              PagedSliver<Tag>(
                value: ref.watch(provider),
                emptyMessage: context.l10n.tagsEmpty,
                emptyIcon: Icons.sell_outlined,
                emptyHint: context.l10n.tagsEmptyHint,
                padding: const EdgeInsets.all(12),
                gridDelegate: tagGridDelegate,
                onRetry: () => ref.invalidate(provider),
                onLoadMore: () => ref.read(provider.notifier).loadMore(),
                itemBuilder: (_, tag) => TagTile(tag: tag),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const tagGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 200,
  childAspectRatio: 1.6,
  mainAxisSpacing: 8,
  crossAxisSpacing: 8,
);

/// Tag card: image (or the accent color) with the name and scene count.
class TagTile extends ConsumerWidget {
  const TagTile({super.key, required this.tag});

  final Tag tag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: '${tag.name}, ${context.l10n.scenesCount(tag.sceneCount)}',
      excludeSemantics: true,
      child: Material(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => openTag(ref, tag.id),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (tag.imageUrl != null)
                Opacity(opacity: 0.55, child: StashImage(tag.imageUrl, fallbackIcon: Icons.sell_outlined)),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '#${tag.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colors.onPrimaryContainer, fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    Text(
                      context.l10n.scenesCount(tag.sceneCount),
                      style: TextStyle(color: colors.onPrimaryContainer, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
