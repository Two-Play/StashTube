import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../core/utils/external_links.dart';
import '../../data/models/gallery.dart';
import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../l10n/l10n.dart';
import '../../widgets/channel_header.dart';
import '../../widgets/chip_bar.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/skeleton.dart';
import '../../widgets/status_views.dart';
import '../library/galleries_tab.dart';
import '../shell/navigation.dart';
import '../shorts/short_tile.dart';
import '../shorts/shorts_feed.dart';
import '../shorts/shorts_page.dart';

/// The tabs of a performer or studio channel (CH-2), in this order: the
/// video tabs (videos, shorts, markers: moments in the videos) before the
/// pictures.
enum ChannelTab { videos, shorts, markers, images, galleries, about }

extension ChannelTabLabel on ChannelTab {
  String label(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      ChannelTab.videos => l.channelTabVideos,
      ChannelTab.shorts => l.channelTabShorts,
      ChannelTab.markers => l.channelTabMarkers,
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
///
/// A horizontal swipe over a tab switches to the next or previous one: the
/// tab follows the finger a little and the new one slides in. Horizontal
/// scrollables inside a tab (shelves, chip bars, the tab bar) win their own
/// drags in the gesture arena, as they are hit first, and drags from the
/// screen's leading edge are left to the system's back gesture.
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

  /// The swipe's horizontal offset of the shown tab, in logical pixels.
  late final AnimationController _swipe = AnimationController.unbounded(vsync: this);
  double _dragDistance = 0;

  /// How far the tab follows the finger, and how far a new one slides in.
  static const _swipeShift = 56.0;

  /// A drag at least this long, or a fling, switches the tab.
  static const _switchDistance = 72.0;

  /// Drags starting this close to the leading edge are the back gesture's.
  static const _edgeWidth = 24.0;

  @override
  void initState() {
    super.initState();
    _visited.add(_current);
    _controller = _newController(0);
  }

  bool _startsAwayFromEdge(Offset globalPosition) {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return true;
    final local = box.globalToLocal(globalPosition);
    return Directionality.of(context) == TextDirection.ltr
        ? local.dx > _edgeWidth
        : local.dx < box.size.width - _edgeWidth;
  }

  void _onSwipeStart(DragStartDetails details) {
    _swipe.stop();
    _dragDistance = 0;
  }

  void _onSwipeUpdate(DragUpdateDetails details) {
    _dragDistance += details.primaryDelta ?? 0;
    // The tab follows the finger with resistance, less so at either end.
    final step = _neighbour(_dragDistance) == null ? 0.15 : 0.4;
    _swipe.value = (_dragDistance * step).clamp(-_swipeShift, _swipeShift);
  }

  void _onSwipeEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final flung = velocity.abs() > kMinFlingVelocity * 4;
    // A fling decides by its direction, a slow drag by its distance.
    final direction = flung ? velocity : (_dragDistance.abs() >= _switchDistance ? _dragDistance : 0.0);
    final next = direction == 0 ? null : _neighbour(direction);
    _dragDistance = 0;
    final animate = !MediaQuery.disableAnimationsOf(context);
    if (next == null) {
      animate
          ? _swipe.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeOutCubic)
          : _swipe.value = 0;
      return;
    }
    Haptics.selection();
    final index = widget.tabs.indexOf(next);
    if (animate) {
      _controller.animateTo(index);
      // The new tab comes in from the side the finger moved away from.
      _swipe.value = direction < 0 ? _swipeShift : -_swipeShift;
      _swipe.animateTo(0, duration: const Duration(milliseconds: 220), curve: Curves.easeOutCubic);
    } else {
      _controller.index = index;
      _swipe.value = 0;
    }
  }

  void _onSwipeCancel() {
    _dragDistance = 0;
    _swipe.value = 0;
  }

  /// The tab a swipe in [direction] (negative: towards the end) leads to.
  ChannelTab? _neighbour(double direction) {
    if (direction == 0) return null;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final forward = (direction < 0) != rtl;
    final index = widget.tabs.indexOf(_current) + (forward ? 1 : -1);
    return index >= 0 && index < widget.tabs.length ? widget.tabs[index] : null;
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
    _swipe.dispose();
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
    final stack = IndexedStack(
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
    if (widget.tabs.length < 2) return stack;
    return RawGestureDetector(
      gestures: {
        _TabSwipeRecognizer: GestureRecognizerFactoryWithHandlers<_TabSwipeRecognizer>(
          () => _TabSwipeRecognizer(debugOwner: this, allowStart: _startsAwayFromEdge),
          (recognizer) => recognizer
            ..allowStart = _startsAwayFromEdge
            ..onStart = _onSwipeStart
            ..onUpdate = _onSwipeUpdate
            ..onEnd = _onSwipeEnd
            ..onCancel = _onSwipeCancel,
        ),
      },
      child: AnimatedBuilder(
        animation: _swipe,
        builder: (context, child) {
          final shift = _swipe.value;
          if (shift == 0) return child!;
          return Opacity(
            opacity: 1 - (shift.abs() / _swipeShift) * 0.35,
            child: Transform.translate(offset: Offset(shift, 0), child: child),
          );
        },
        child: stack,
      ),
    );
  }
}

/// A horizontal drag that may only start where [allowStart] says.
class _TabSwipeRecognizer extends HorizontalDragGestureRecognizer {
  _TabSwipeRecognizer({super.debugOwner, required this.allowStart});

  bool Function(Offset globalPosition) allowStart;

  @override
  bool isPointerAllowed(PointerEvent event) => super.isPointerAllowed(event) && allowStart(event.position);
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
              (_, i) => ShortTile(
                short: items[i],
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

/// The channel's links: tapping one opens it in the browser, a long press
/// copies it.
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
            onTapHint: l.openLink,
            onLongPressHint: l.copyLink,
            child: ListTile(
              leading: const Icon(Icons.link),
              title: Text(
                url,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              trailing: Icon(Icons.open_in_new, size: 20, color: theme.colorScheme.onSurfaceVariant),
              onTap: () => openExternalUrl(context, url),
              onLongPress: () async {
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
