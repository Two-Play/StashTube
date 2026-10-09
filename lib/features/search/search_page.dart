import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/models/performer.dart';
import '../../data/models/studio.dart';
import '../../data/providers.dart';
import '../../widgets/chip_bar.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/performer_tile.dart';
import '../../widgets/scene_feed.dart';
import '../library/galleries_tab.dart';
import '../library/images_tab.dart';
import '../shell/navigation.dart';
import '../studios/studios_page.dart';
import '../tags/tags_page.dart';
import 'search_history.dart';
import '../../l10n/l10n.dart';

/// What the search page searches; picked with the chips below the field.
enum SearchScope {
  scenes,
  images,
  galleries,
  performers,
  studios;

  String label(AppLocalizations l) => switch (this) {
        scenes => l.libraryScenes,
        images => l.libraryImages,
        galleries => l.libraryGalleries,
        performers => l.performersTitle,
        studios => l.studiosTitle,
      };

  String hint(AppLocalizations l) => switch (this) {
        scenes => l.searchScenes,
        images => l.searchImages,
        galleries => l.searchGalleries,
        performers => l.searchPerformers,
        studios => l.searchStudios,
      };
}

/// Live search with one field for everything: chips switch between scenes
/// (with filters, sort chips and matching performers on top), images,
/// galleries, performers and studios, keeping the term.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key, this.autofocus = true, this.initialScope = SearchScope.scenes});

  /// Off when the page is a tab of the navigation bar, which is built in the
  /// background and shouldn't open the keyboard.
  final bool autofocus;

  final SearchScope initialScope;

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  Timer? _debounce;
  Timer? _record;
  String _term = '';
  late var _scope = widget.initialScope;

  @override
  void dispose() {
    _debounce?.cancel();
    _record?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(value));
  }

  /// Shows results for [value]. A term goes into the history once its results
  /// were on screen for a moment (or right away when submitted), so half-typed
  /// words don't clutter it.
  void _search(String value, {bool submitted = false}) {
    if (!mounted) return;
    final term = value.trim();
    setState(() => _term = term);
    _record?.cancel();
    if (term.isEmpty) return;
    if (submitted) {
      ref.read(searchHistoryProvider.notifier).add(term);
    } else {
      _record = Timer(const Duration(seconds: 2), () {
        if (mounted && _term == term) ref.read(searchHistoryProvider.notifier).add(term);
      });
    }
  }

  void _pick(String term) {
    _controller.text = term;
    _controller.selection = TextSelection.collapsed(offset: term.length);
    _debounce?.cancel();
    _search(term, submitted: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Next to the back button; as a tab root the field keeps the margin.
        titleSpacing: (ModalRoute.of(context)?.canPop ?? false) ? 0 : null,
        title: TextField(
          controller: _controller,
          autofocus: widget.autofocus,
          textInputAction: TextInputAction.search,
          onChanged: _onChanged,
          onSubmitted: (v) {
            _debounce?.cancel();
            _search(v, submitted: true);
          },
          decoration: InputDecoration(
            hintText: _scope.hint(context.l10n),
            border: InputBorder.none,
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _controller.clear();
                      _search('');
                    },
                  ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: ChipBar<SearchScope>(
            values: SearchScope.values,
            selected: _scope,
            labelOf: (s) => s.label(context.l10n),
            onSelected: (s) => setState(() => _scope = s),
          ),
        ),
      ),
      body: _term.isEmpty ? _Discover(onPick: _pick) : _results(context),
    );
  }

  /// The results for [_term] in [_scope]. Each view keeps its sort and
  /// filters while the term changes.
  Widget _results(BuildContext context) {
    final l = context.l10n;
    return switch (_scope) {
      SearchScope.scenes => SceneFeedView(
          layout: SceneFeedLayout.list,
          initialQuery: SceneQuery(search: _term),
          filterable: true,
          showCount: true,
          emptyMessage: l.searchNoScenes(_term),
          emptyIcon: Icons.search_off,
          emptyHint: l.searchNoScenesHint,
          headerSlivers: [
            _PerformerResults(term: _term, onSeeAll: () => setState(() => _scope = SearchScope.performers)),
          ],
        ),
      SearchScope.images => ImageGridView(
          initialQuery: ImageQuery(search: _term),
          sorts: ImageSort.browse,
          searchable: false,
        ),
      SearchScope.galleries => GalleryGridView(search: _term),
      SearchScope.performers => _PerformerGrid(term: _term),
      SearchScope.studios => _StudioList(term: _term),
    };
  }
}

/// Matching performers as a row above the scene results.
class _PerformerResults extends ConsumerWidget {
  const _PerformerResults({required this.term, required this.onSeeAll});

  final String term;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performers = ref.watch(performerListProvider(PerformerQuery(search: term))).current?.items ?? const [];
    if (performers.isEmpty) return const SliverToBoxAdapter();

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
            child: Row(
              children: [
                Expanded(child: Text(context.l10n.performersTitle, style: Theme.of(context).textTheme.titleMedium)),
                TextButton(onPressed: onSeeAll, child: Text(context.l10n.seeAll)),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: performers.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => PerformerBubble(performer: performers[i]),
            ),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}

/// All performers matching [term], as a grid.
class _PerformerGrid extends ConsumerWidget {
  const _PerformerGrid({required this.term});

  final String term;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = performerListProvider(PerformerQuery(search: term));
    return _ResultScrollView(
      onRefresh: () => refreshFuture(ref, provider.future),
      onLoadMore: () => ref.read(provider.notifier).loadMore(),
      sliver: PagedSliver<Performer>(
        value: ref.watch(provider),
        emptyMessage: context.l10n.searchNoResults(term),
        emptyIcon: Icons.search_off,
        emptyHint: context.l10n.searchNoScenesHint,
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          childAspectRatio: 0.62,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
        ),
        onRetry: () => ref.invalidate(provider),
        onLoadMore: () => ref.read(provider.notifier).loadMore(),
        onGoToPage: (page) => ref.read(provider.notifier).goToPage(page),
        itemBuilder: (_, performer) => PerformerTile(performer: performer),
      ),
    );
  }
}

/// All studios matching [term], as channel rows.
class _StudioList extends ConsumerWidget {
  const _StudioList({required this.term});

  final String term;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = studioListProvider(StudioQuery(search: term));
    return _ResultScrollView(
      onRefresh: () => refreshFuture(ref, provider.future),
      onLoadMore: () => ref.read(provider.notifier).loadMore(),
      sliver: PagedSliver<Studio>(
        value: ref.watch(provider),
        emptyMessage: context.l10n.searchNoResults(term),
        emptyIcon: Icons.search_off,
        emptyHint: context.l10n.searchNoScenesHint,
        onRetry: () => ref.invalidate(provider),
        onLoadMore: () => ref.read(provider.notifier).loadMore(),
        onGoToPage: (page) => ref.read(provider.notifier).goToPage(page),
        columnWidth: 400,
        itemBuilder: (_, studio) => StudioListTile(studio: studio),
      ),
    );
  }
}

/// Pull-to-refresh and endless scrolling around one result sliver.
class _ResultScrollView extends StatelessWidget {
  const _ResultScrollView({required this.onRefresh, required this.onLoadMore, required this.sliver});

  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final Widget sliver;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: onRefresh,
        child: LoadMoreListener(
          onLoadMore: onLoadMore,
          child: CustomScrollView(physics: const AlwaysScrollableScrollPhysics(), slivers: [sliver]),
        ),
      );
}

/// Shown before typing: recent searches (5.3) and popular tags (8.2).
class _Discover extends ConsumerWidget {
  const _Discover({required this.onPick});

  final ValueChanged<String> onPick;

  static const _shown = 12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tags = ref.watch(tagListProvider(const TagQuery())).current?.items ?? const [];
    final history = ref.watch(searchHistoryProvider);

    return CustomScrollView(
      slivers: [
        if (history.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 4, 0),
              child: Row(
                children: [
                  Expanded(child: Text(context.l10n.recentSearches, style: theme.textTheme.titleMedium)),
                  TextButton(
                    onPressed: () => ref.read(searchHistoryProvider.notifier).clear(),
                    child: Text(context.l10n.clear),
                  ),
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: history.length.clamp(0, 8),
            itemBuilder: (_, i) => ListTile(
              dense: true,
              leading: const Icon(Icons.history),
              title: Text(history[i]),
              onTap: () => onPick(history[i]),
              trailing: IconButton(
                tooltip: context.l10n.remove,
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => ref.read(searchHistoryProvider.notifier).remove(history[i]),
              ),
            ),
          ),
        ],
        if (tags.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 4, 4),
              child: Row(
                children: [
                  Expanded(child: Text(context.l10n.popularTags, style: theme.textTheme.titleMedium)),
                  TextButton(onPressed: () => openTags(ref), child: Text(context.l10n.seeAll)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: tagGridDelegate,
              delegate: SliverChildBuilderDelegate(
                (_, i) => TagTile(tag: tags[i]),
                childCount: tags.length.clamp(0, _shown),
              ),
            ),
          ),
        ] else if (history.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 64, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text(context.l10n.searchIntro, style: theme.textTheme.titleMedium),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
