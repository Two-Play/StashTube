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

/// Subscriptions (SUB-1), the "Favorites" tab: only performers marked as
/// favorite (Stash's `favorite` flag; star ratings play no part here).
///
/// The avatars at the top pick whose videos show below, like a channel
/// filter: "All" (the default) lists the newest scenes of all favorites
/// ([SceneQuery.newFromFavorites], shared with home's shelf), one avatar
/// only that performer's scenes, newest first, with "View channel". The
/// avatars open the channel only on a long press, so a tap never leaves the
/// page. A dot marks performers with scenes added since the last visit. An
/// optional tab, a tile on the "You" page and home's "New from favorites"
/// "See all".
class SubscriptionsPage extends ConsumerStatefulWidget {
  const SubscriptionsPage({super.key});

  /// The favorite performers, by name.
  static final favorites = PerformerQuery(sort: PerformerSort.favorites);

  @override
  ConsumerState<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends ConsumerState<SubscriptionsPage> {
  // The same query as home's shelf, so both share one list.
  final _allFeed = SceneQuery.newFromFavorites();

  /// The performer whose videos show; null: all favorites.
  Performer? _selected;

  /// Kept across the feed's rebuild for another selection.
  final _avatarScroll = ScrollController();

  @override
  void dispose() {
    _avatarScroll.dispose();
    super.dispose();
  }

  void _refresh() {
    ref.invalidate(performerListProvider(SubscriptionsPage.favorites));
    ref.invalidate(performersWithNewScenesProvider);
  }

  /// Selects [performer] (null: all); selecting the selected one again
  /// goes back to all.
  void _select(Performer? performer) {
    Haptics.selection();
    setState(() => _selected = performer?.id == _selected?.id ? null : performer);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final favorites = ref.watch(performerListProvider(SubscriptionsPage.favorites));
    final none = favorites.current?.items.isEmpty ?? false;
    final selected = _selected;
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
          // A feed of its own per selection: it starts at the top.
          : SceneFeedView(
              key: ValueKey(selected?.id),
              initialQuery: selected == null
                  ? _allFeed
                  : SceneQuery(sort: SceneSort.recentlyAdded, performerId: selected.id),
              filterable: true,
              onRefresh: _refresh,
              emptyMessage: selected == null ? null : l.subscriptionsPerformerEmpty(selected.name),
              headerSlivers: [
                SliverToBoxAdapter(
                  child: FavoritePerformersRow(
                    selectedId: selected?.id,
                    onSelected: _select,
                    controller: _avatarScroll,
                  ),
                ),
                SliverToBoxAdapter(child: _SelectionHeader(performer: selected)),
              ],
            ),
    );
  }
}

/// What the feed below shows: all favorites, or one performer with a way
/// to their channel.
class _SelectionHeader extends ConsumerWidget {
  const _SelectionHeader({required this.performer});

  final Performer? performer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final performer = this.performer;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(AppSpacing.l, AppSpacing.s, AppSpacing.s, 0),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.s,
        children: [
          Text(
            performer?.name ?? l.subscriptionsLatest,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
          if (performer != null)
            TextButton.icon(
              icon: const Icon(Icons.account_circle_outlined),
              label: Text(l.subscriptionsViewChannel),
              onPressed: () {
                Haptics.selection();
                openPerformer(ref, performer.id);
              },
            ),
        ],
      ),
    );
  }
}

/// The favorite performers' avatars in a horizontal row. With [onSelected]
/// it starts with "All", and a tap selects ([onSelected] with null for
/// "All") while a long press opens the channel; without, a tap opens the
/// channel. Loads further pages as it scrolls.
class FavoritePerformersRow extends ConsumerWidget {
  const FavoritePerformersRow({super.key, this.selectedId, this.onSelected, this.controller});

  final String? selectedId;
  final ValueChanged<Performer?>? onSelected;
  final ScrollController? controller;

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
    final onSelected = this.onSelected;
    final lead = onSelected == null ? 0 : 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: height,
          child: ListView.builder(
            controller: controller,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.s),
            itemCount: items.length + lead,
            itemBuilder: (context, index) {
              if (onSelected != null && index == 0) {
                return _AllAvatar(
                  selected: selectedId == null,
                  width: _itemWidth,
                  radius: _avatarRadius,
                  onTap: () => onSelected(null),
                );
              }
              final i = index - lead;
              if (i >= items.length - 4 && state.hasMore && !state.isLoadingMore && state.loadMoreError == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(provider.notifier).loadMore());
              }
              final performer = items[i];
              return _Avatar(
                performer: performer,
                hasNew: withNew.contains(performer.id),
                selected: performer.id == selectedId,
                width: _itemWidth,
                radius: _avatarRadius,
                onTap: onSelected == null ? null : () => onSelected(performer),
              );
            },
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

/// The ring (in the accent) around a selected avatar; its room is kept
/// unselected too, so selecting doesn't move anything.
class _SelectionRing extends StatelessWidget {
  const _SelectionRing({required this.selected, required this.child});

  static const width = 2.5;
  static const gap = 2.0;

  final bool selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(gap),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: selected ? scheme.primary : Colors.transparent, width: width),
      ),
      child: child,
    );
  }
}

/// The avatar's radius inside the [_SelectionRing], so the row keeps its size.
double _innerRadius(double radius) => radius - _SelectionRing.width - _SelectionRing.gap;

class _AllAvatar extends StatelessWidget {
  const _AllAvatar({required this.selected, required this.width, required this.radius, required this.onTap});

  final bool selected;
  final double width;
  final double radius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: l.subscriptionsAllLabel,
      excludeSemantics: true,
      child: InkWell(
        key: const ValueKey('favorites-all'),
        borderRadius: AppRadius.cardBorder,
        onTap: onTap,
        child: SizedBox(
          width: width,
          child: Column(
            children: [
              _SelectionRing(
                selected: selected,
                child: CircleAvatar(
                  radius: _innerRadius(radius),
                  backgroundColor: selected ? scheme.primaryContainer : scheme.surfaceContainerHighest,
                  foregroundColor: selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
                  child: const Icon(Icons.favorite),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l.subscriptionsAll,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: selected ? FontWeight.w700 : null,
                  color: selected ? scheme.primary : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends ConsumerWidget {
  const _Avatar({
    required this.performer,
    required this.hasNew,
    required this.selected,
    required this.width,
    required this.radius,
    this.onTap,
  });

  final Performer performer;
  final bool hasNew;
  final bool selected;
  final double width;
  final double radius;

  /// Selects the performer; null: a tap opens the channel.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    void openChannel() {
      Haptics.selection();
      openPerformer(ref, performer.id);
    }

    final select = onTap;
    return Semantics(
      button: true,
      selected: select == null ? null : selected,
      label: hasNew ? l.performerHasNewScenes(performer.name) : performer.name,
      hint: select == null ? null : l.subscriptionsSelectHint,
      excludeSemantics: true,
      onLongPress: select == null ? null : openChannel,
      child: InkWell(
        borderRadius: AppRadius.cardBorder,
        onTap: select ?? openChannel,
        onLongPress: select == null ? null : openChannel,
        child: SizedBox(
          width: width,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _SelectionRing(
                    selected: selected,
                    child: ChannelAvatar(
                      name: performer.name,
                      imageUrl: performer.imageUrl,
                      radius: _innerRadius(radius),
                    ),
                  ),
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
                  fontWeight: hasNew || selected ? FontWeight.w700 : null,
                  color: selected ? scheme.primary : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
