import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../core/config/theme.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/performer.dart';
import '../../data/providers.dart';
import '../../l10n/l10n.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/skeleton.dart';
import '../../widgets/stash_image.dart';
import '../../widgets/status_views.dart';
import '../auth/server_avatar.dart';
import '../performers/performers_page.dart';
import '../shell/navigation.dart';
import 'last_visit.dart';

/// Subscriptions (SUB-1): the favorite performers as a row of avatars (a
/// dot on those with scenes added since the last visit), then the newest
/// scenes of all of them. An optional tab, a tile on the "You" page and
/// home's "New from favorites" "See all".
class SubscriptionsPage extends ConsumerStatefulWidget {
  const SubscriptionsPage({super.key});

  /// The favorite performers, by name.
  static final favorites = PerformerQuery(sort: PerformerSort.favorites);

  @override
  ConsumerState<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends ConsumerState<SubscriptionsPage> {
  // The same query as home's shelf, so both share one list.
  final _feed = SceneQuery.newFromFavorites();

  void _refresh() {
    ref.invalidate(performerListProvider(SubscriptionsPage.favorites));
    ref.invalidate(performersWithNewScenesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final favorites = ref.watch(performerListProvider(SubscriptionsPage.favorites));
    final none = favorites.current?.items.isEmpty ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.tabSubscriptions),
        actions: [
          IconButton(tooltip: l.search, icon: const Icon(Icons.search), onPressed: () => openSearch(ref)),
          const ServerAvatarButton(),
        ],
      ),
      body: none
          ? RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: EmptyView(
                      message: l.subscriptionsEmpty,
                      hint: l.subscriptionsEmptyHint,
                      icon: Icons.favorite_border,
                      actionLabel: l.tabPerformers,
                      actionIcon: Icons.people_outline,
                      onAction: () {
                        Haptics.selection();
                        openPage(ref, const PerformersPage());
                      },
                    ),
                  ),
                ),
              ),
            )
          : SceneFeedView(
              initialQuery: _feed,
              filterable: true,
              onRefresh: _refresh,
              headerSlivers: const [SliverToBoxAdapter(child: FavoritePerformersRow())],
            ),
    );
  }
}

/// The favorite performers' avatars in a horizontal row; tapping one opens
/// their channel. Loads further pages as it scrolls.
class FavoritePerformersRow extends ConsumerWidget {
  const FavoritePerformersRow({super.key});

  static const _avatarRadius = 30.0;
  static const _itemWidth = 76.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = performerListProvider(SubscriptionsPage.favorites);
    final value = ref.watch(provider);
    final state = value.current;
    final withNew = ref.watch(performersWithNewScenesProvider).value ?? const {};
    final textHeight = MediaQuery.textScalerOf(context).scale(36);
    final height = _avatarRadius * 2 + AppSpacing.s * 3 + textHeight;
    if (state == null) {
      if (value.hasError) return const SizedBox.shrink();
      return ShelfSkeleton(height: height, itemWidth: _itemWidth);
    }
    final items = state.items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.s),
            itemCount: items.length,
            itemBuilder: (context, i) {
              if (i >= items.length - 4 && state.hasMore && !state.isLoadingMore && state.loadMoreError == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(provider.notifier).loadMore());
              }
              final performer = items[i];
              return _Avatar(
                performer: performer,
                hasNew: withNew.contains(performer.id),
                width: _itemWidth,
                radius: _avatarRadius,
              );
            },
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _Avatar extends ConsumerWidget {
  const _Avatar({required this.performer, required this.hasNew, required this.width, required this.radius});

  final Performer performer;
  final bool hasNew;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      button: true,
      label: hasNew ? l.performerHasNewScenes(performer.name) : performer.name,
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Haptics.selection();
          openPerformer(ref, performer.id);
        },
        child: SizedBox(
          width: width,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ChannelAvatar(name: performer.name, imageUrl: performer.imageUrl, radius: radius),
                  if (hasNew)
                    PositionedDirectional(
                      end: 0,
                      bottom: 2,
                      child: Container(
                        key: ValueKey('new-${performer.id}'),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: scheme.surface, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                performer.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: hasNew ? FontWeight.w700 : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
