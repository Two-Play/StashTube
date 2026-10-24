import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../core/config/theme.dart';
import '../../core/utils/format.dart';
import '../../data/models/gallery.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/scene.dart';
import '../../data/providers.dart';
import '../../l10n/l10n.dart';
import '../../widgets/channel_header.dart';
import '../../widgets/chip_bar.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/scene_card.dart';
import '../../widgets/skeleton.dart';
import '../../widgets/stash_image.dart';
import '../../widgets/status_views.dart';
import '../library/galleries_tab.dart';
import '../shell/navigation.dart';
import '../shorts/shorts_feed.dart';
import '../shorts/shorts_page.dart';

/// The tabs of a performer or studio channel (CH-2), in this order.
enum ChannelTab { videos, shorts, images, galleries, about }

extension ChannelTabLabel on ChannelTab {
  String label(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      ChannelTab.videos => l.channelTabVideos,
      ChannelTab.shorts => l.channelTabShorts,
      ChannelTab.images => l.channelTabImages,
      ChannelTab.galleries => l.channelTabGalleries,
      ChannelTab.about => l.channelTabAbout,
    };
  }
}

/// Builds one tab's scroll view. Its slivers must start with
/// [headerSlivers] (the channel header and the pinned tab bar), and it
/// should be refreshable and use the [PrimaryScrollController] (the
/// default for a vertical scroll view without a controller).
typedef ChannelTabBuilder = Widget Function(BuildContext context, ChannelTab tab, List<Widget> headerSlivers);

/// A channel page's body: [header] collapses as a tab scrolls, then the
/// tab bar stays pinned at the top (CH-2, wireframe 3.4).
///
/// Every tab is a scroll view of its own with its own copy of the header,
/// so each tab keeps its position, paging and pull-to-refresh like any
/// list. Switching tabs keeps the header where it was: a tab is scrolled
/// to the same offset while the header shows, or at least to below the
/// header once it has collapsed. Tabs are built when first shown and kept
/// afterwards. Only the shown tab's header is the [ChannelTitleAnchor] of
/// the surrounding [ChannelScaffold].
class ChannelTabsView extends StatefulWidget {
  const ChannelTabsView({super.key, required this.tabs, required this.header, required this.builder})
      : assert(tabs.length > 0);

  /// The tabs with content; may change while counts load. The selected tab
  /// stays selected if it is still there.
  final List<ChannelTab> tabs;
  final Widget header;
  final ChannelTabBuilder builder;

  @override
  State<ChannelTabsView> createState() => _ChannelTabsViewState();
}

class _ChannelTabsViewState extends State<ChannelTabsView> with TickerProviderStateMixin {
  late TabController _controller;
  late ChannelTab _current = widget.tabs.first;
  final _visited = <ChannelTab>{};

  /// Where a tab should be once its content is long enough (it may still
  /// be loading when it is shown); dropped once the user scrolls it.
  final _pendingOffsets = <ChannelTab, double>{};
  final _headerKeys = {for (final tab in ChannelTab.values) tab: GlobalKey(debugLabel: 'channel header ${tab.name}')};

  @override
  void initState() {
    super.initState();
    _visited.add(_current);
    _controller = _newController(0);
  }

  TabController _newController(int index) =>
      TabController(length: widget.tabs.length, initialIndex: index, vsync: this)..addListener(_onTabChanged);

  @override
  void didUpdateWidget(ChannelTabsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (listEquals(oldWidget.tabs, widget.tabs)) return;
    if (!widget.tabs.contains(_current)) {
      _current = widget.tabs.first;
      _visited.add(_current);
    }
    _controller
      ..removeListener(_onTabChanged)
      ..dispose();
    _controller = _newController(widget.tabs.indexOf(_current));
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  ScrollPosition? _positionOf(ChannelTab tab) {
    final context = _headerKeys[tab]!.currentContext;
    return context == null ? null : Scrollable.maybeOf(context)?.position;
  }

  double? _headerHeightOf(ChannelTab tab) {
    final box = _headerKeys[tab]!.currentContext?.findRenderObject();
    return box is RenderBox && box.hasSize ? box.size.height : null;
  }

  void _onTabChanged() {
    final next = widget.tabs[_controller.index];
    if (next == _current) return;
    final from = _positionOf(_current);
    final offset = from != null && from.hasPixels ? from.pixels : 0.0;
    final headerHeight = _headerHeightOf(_current) ?? 0;
    setState(() {
      _current = next;
      _visited.add(next);
    });
    // Once the tab is laid out (it may be new): the header where it was.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _current != next) return;
      final to = _positionOf(next);
      if (to == null || !to.hasContentDimensions) return;
      _pendingOffsets[next] = offset < headerHeight ? offset : math.max(to.pixels, headerHeight);
      _applyPendingOffset(next, to);
    });
  }

  void _applyPendingOffset(ChannelTab tab, ScrollPosition position) {
    final target = _pendingOffsets[tab];
    if (target == null) return;
    final clamped = target.clamp(position.minScrollExtent, position.maxScrollExtent);
    if (clamped >= target) _pendingOffsets.remove(tab);
    if ((clamped - position.pixels).abs() > 0.5) position.jumpTo(clamped);
  }

  bool _onTabNotification(ChannelTab tab, Notification notification) {
    if (!_pendingOffsets.containsKey(tab)) return false;
    if (notification is ScrollStartNotification && notification.depth == 0 && notification.dragDetails != null) {
      _pendingOffsets.remove(tab);
    } else if (notification is ScrollMetricsNotification &&
        notification.depth == 0 &&
        notification.metrics.axis == Axis.vertical) {
      // E.g. the first page arrived: now there is room to scroll there.
      final position = _positionOf(tab);
      if (position != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _applyPendingOffset(tab, position);
        });
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    // Room for the labels with large text.
    final tabHeight = math.max(kTextTabBarHeight, textScaler.scale(14) * 1.4 + 26);
    final tabBar = TabBar(
      controller: _controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      tabs: [for (final tab in widget.tabs) Tab(height: tabHeight, text: tab.label(context))],
    );
    return IndexedStack(
      index: widget.tabs.indexOf(_current),
      sizing: StackFit.expand,
      children: [
        for (final tab in widget.tabs)
          if (_visited.contains(tab))
            NotificationListener<Notification>(
              key: ValueKey(tab),
              onNotification: (n) => _onTabNotification(tab, n),
              child: widget.builder(context, tab, [
                SliverToBoxAdapter(
                  child: KeyedSubtree(
                    key: _headerKeys[tab],
                    child: ChannelTitleAnchorScope(enabled: tab == _current, child: widget.header),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(tabBar: tabBar, height: tabHeight),
                ),
              ]),
            )
          else
            SizedBox.shrink(key: ValueKey(tab)),
      ],
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate({required this.tabBar, required this.height});

  final TabBar tabBar;
  final double height;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant, width: 0.5)),
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) => old.tabBar != tabBar || old.height != height;
}

/// A channel's shorts as a grid of 9:16 tiles; a tile opens the shorts
/// player at that short, continuing with the same (shuffled) feed.
class ChannelShortsGrid extends ConsumerStatefulWidget {
  const ChannelShortsGrid({super.key, required this.source, required this.headerSlivers});

  final ShortsSource source;
  final List<Widget> headerSlivers;

  @override
  ConsumerState<ChannelShortsGrid> createState() => _ChannelShortsGridState();
}

class _ChannelShortsGridState extends ConsumerState<ChannelShortsGrid> {
  static const _gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 180,
    childAspectRatio: 9 / 16,
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
  );

  /// Reshuffles and waits until the first page is there.
  Future<void> _refresh() async {
    final provider = shortsFeedFamily(widget.source);
    ref.read(provider.notifier).refresh();
    final loaded = Completer<void>();
    final subscription = ref.listenManual(provider, (_, next) {
      if (!next.isLoading && !loaded.isCompleted) loaded.complete();
    });
    await loaded.future.timeout(const Duration(seconds: 30), onTimeout: () {});
    subscription.close();
    Haptics.medium();
  }

  @override
  Widget build(BuildContext context) {
    final provider = shortsFeedFamily(widget.source);
    final state = ref.watch(provider);
    final l = context.l10n;
    final items = state.items;

    final Widget content;
    if (items.isEmpty && state.error != null) {
      content = SliverToBoxAdapter(child: ErrorView(error: state.error!, onRetry: _refresh));
    } else if (items.isEmpty && (state.isLoading || state.hasMore)) {
      content = SliverPadding(
        padding: const EdgeInsets.all(12),
        sliver: SliverGrid(
          gridDelegate: _gridDelegate,
          delegate: SliverChildBuilderDelegate((_, _) => const SkeletonBox(), childCount: 6),
        ),
      );
    } else if (items.isEmpty) {
      content = SliverToBoxAdapter(
        child: EmptyView(message: l.shortsEmpty, icon: Icons.slow_motion_video, hint: l.shortsEmptyHint),
      );
    } else {
      content = SliverMainAxisGroup(slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            gridDelegate: _gridDelegate,
            delegate: SliverChildBuilderDelegate(
              (_, i) => ChannelShortTile(
                scene: items[i],
                onTap: () => openPage(ref, ShortsPage(source: widget.source, initialIndex: i)),
              ),
              childCount: items.length,
            ),
          ),
        ),
        if (state.error != null)
          SliverToBoxAdapter(
            child: ErrorView(error: state.error!, onRetry: () => ref.read(provider.notifier).loadMore()),
          )
        else if (state.isLoading)
          const SliverToBoxAdapter(child: LoadingView()),
      ]);
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: LoadMoreListener(
        onLoadMore: () {
          if (state.error == null) ref.read(provider.notifier).loadMore();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [...widget.headerSlivers, content],
        ),
      ),
    );
  }
}

/// A short's 9:16 tile: still, title and length.
class ChannelShortTile extends StatelessWidget {
  const ChannelShortTile({super.key, required this.scene, required this.onTap});

  final Scene scene;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: AppRadius.thumbnailBorder,
        child: Material(
          color: Colors.black,
          child: TileSemantics(
            label: [scene.title, if (scene.duration > 0) spokenDuration(context.l10n, scene.duration)].join(', '),
            child: InkWell(
              onTap: onTap,
              child: ExcludeSemantics(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    StashImage(scene.screenshotUrl, fallbackIcon: Icons.slow_motion_video),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [AppColors.of(context).videoScrim, Colors.transparent],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 6,
                      right: 6,
                      bottom: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            scene.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: AppTextSize.overlayLabel,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (scene.duration > 0)
                            Text(
                              formatDuration(scene.duration),
                              style: const TextStyle(color: Colors.white70, fontSize: AppTextSize.overlayCaption),
                            ),
                        ],
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

/// A channel's galleries as a grid of covers with sort chips.
class ChannelGalleryGrid extends ConsumerStatefulWidget {
  const ChannelGalleryGrid({super.key, required this.initialQuery, required this.headerSlivers});

  final GalleryQuery initialQuery;
  final List<Widget> headerSlivers;

  @override
  ConsumerState<ChannelGalleryGrid> createState() => _ChannelGalleryGridState();
}

class _ChannelGalleryGridState extends ConsumerState<ChannelGalleryGrid> {
  late GalleryQuery _query = widget.initialQuery;

  @override
  void didUpdateWidget(ChannelGalleryGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    // E.g. sub-studios switched on or off: keeps the chosen sort.
    if (oldWidget.initialQuery != widget.initialQuery) _query = widget.initialQuery.withSort(_query.sort);
  }

  @override
  Widget build(BuildContext context) {
    final provider = galleryListProvider(_query);
    final value = ref.watch(provider);
    final theme = Theme.of(context);
    final l = context.l10n;

    return RefreshIndicator(
      onRefresh: () => refreshFuture(ref, provider.future),
      child: LoadMoreListener(
        onLoadMore: () => ref.read(provider.notifier).loadMore(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ...widget.headerSlivers,
            SliverToBoxAdapter(
              child: ChipBar<GallerySort>(
                values: GallerySort.values,
                selected: _query.sort,
                labelOf: (s) => s.label(l),
                onSelected: (s) => setState(() => _query = _query.withSort(s)),
              ),
            ),
            if (value.current case final state?)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    l.galleriesCount(state.totalCount),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            PagedSliver<Gallery>(
              value: value,
              emptyMessage: l.galleriesEmpty,
              emptyIcon: Icons.photo_library_outlined,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 0.72,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              onRetry: () => ref.invalidate(provider),
              onLoadMore: () => ref.read(provider.notifier).loadMore(retry: true),
              onGoToPage: (page) => ref.read(provider.notifier).goToPage(page),
              itemBuilder: (_, gallery) => GalleryTile(gallery: gallery),
            ),
          ],
        ),
      ),
    );
  }
}

/// The about tab: [sections] (facts, links, text) or, without any, a
/// "nothing here" message.
class ChannelAboutView extends StatelessWidget {
  const ChannelAboutView({super.key, required this.headerSlivers, required this.sections, required this.onRefresh});

  final List<Widget> headerSlivers;
  final List<Widget> sections;

  /// Reloads the data, e.g. with [refreshFuture].
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ...headerSlivers,
            if (sections.isEmpty)
              SliverToBoxAdapter(
                child: EmptyView(message: context.l10n.channelAboutEmpty, icon: Icons.info_outline),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                sliver: SliverList.list(children: sections),
              ),
          ],
        ),
      );
}

/// One fact of the about tab: a label above its value.
class ChannelFact extends StatelessWidget {
  const ChannelFact({super.key, required this.label, required this.value, this.leading});

  final String label;
  final String value;

  /// Shown before the value, e.g. a country flag.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 2),
            Row(
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 8)],
                Expanded(child: SelectableText(value, style: theme.textTheme.bodyLarge)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A longer text of the about tab (details, description) under a label.
class ChannelAboutText extends StatelessWidget {
  const ChannelAboutText({super.key, required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          SelectableText(text, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

/// The channel's links; tapping one copies it (the app opens no browser).
class ChannelLinks extends StatelessWidget {
  const ChannelLinks({super.key, required this.label, required this.urls});

  final String label;
  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Text(label, style: theme.textTheme.titleSmall),
        ),
        for (final url in urls)
          Semantics(
            onTapHint: l.copyLink,
            child: ListTile(
            leading: const Icon(Icons.link),
            title: Text(
              url,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: theme.colorScheme.primary),
            ),
            trailing: Icon(Icons.copy, size: 20, color: theme.colorScheme.onSurfaceVariant),
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: url));
              Haptics.light();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(l.linkCopied)));
            },
            ),
          ),
      ],
    );
  }
}

/// The about tab's place holder while its data loads, or its error.
List<Widget> channelAboutStatus(AsyncValue<Object?> value, VoidCallback onRetry) => [
      if (value.isLoading && !value.hasValue) const LoadingView(),
      if (value.hasError && !value.hasValue) ErrorView(error: value.error!, onRetry: onRetry),
    ];
