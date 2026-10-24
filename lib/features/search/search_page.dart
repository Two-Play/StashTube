import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/models/performer.dart';
import '../../data/models/scene_filter.dart';
import '../../data/models/studio.dart';
import '../../data/providers.dart';
import '../../widgets/chip_bar.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/performer_tile.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/scene_filter_sheet.dart';
import '../../widgets/stash_image.dart';
import '../../widgets/status_views.dart';
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
  final _focus = FocusNode();
  Timer? _debounce;
  Timer? _record;
  String _term = '';
  late var _scope = widget.initialScope;

  /// The scene filters; kept here (not in the result view) so the empty
  /// results can offer to clear them (SEARCH-2).
  SceneFilter _sceneFilter = const SceneFilter();

  /// Whether the typeahead suggestions (SEARCH-1) are shown: from typing until
  /// the term is submitted, a suggestion is picked or the field loses focus.
  bool _suggest = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _record?.cancel();
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focus.hasFocus && _suggest) setState(() => _suggest = false);
  }

  void _onChanged(String value) {
    if (!_suggest) setState(() => _suggest = true);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(value));
  }

  void _submit(String value) {
    _debounce?.cancel();
    setState(() => _suggest = false);
    _search(value, submitted: true);
  }

  /// Leaves the search for a suggested performer, tag or studio.
  void _openSuggestion(void Function(WidgetRef ref, String id) open, String id) {
    setState(() => _suggest = false);
    _focus.unfocus();
    open(ref, id);
  }

  Future<void> _openFilters() async {
    final next = await showSceneFilterSheet(context, _sceneFilter);
    if (next != null && mounted) setState(() => _sceneFilter = next);
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
          focusNode: _focus,
          autofocus: widget.autofocus,
          textInputAction: TextInputAction.search,
          onChanged: _onChanged,
          onSubmitted: _submit,
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
        actions: [
          if (_scope == SearchScope.scenes && _term.isNotEmpty)
            IconButton(
              tooltip: context.l10n.filter,
              onPressed: _openFilters,
              icon: Badge(
                isLabelVisible: _sceneFilter.activeCount > 0,
                label: Text('${_sceneFilter.activeCount}'),
                child: const Icon(Icons.tune),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _term.isEmpty
                ? _Discover(onPick: _pick)
                // Scrolling the results closes the keyboard and the suggestions.
                : NotificationListener<ScrollStartNotification>(
                    onNotification: (n) {
                      if (n.dragDetails != null) _focus.unfocus();
                      return false;
                    },
                    child: _results(context),
                  ),
          ),
          if (_suggest && _term.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: _Suggestions(
                term: _term,
                scope: _scope,
                controller: _controller,
                onSubmit: () => _submit(_controller.text),
                onPerformer: (id) => _openSuggestion(openPerformer, id),
                onTag: (id) => _openSuggestion(openTag, id),
                onStudio: (id) => _openSuggestion(openStudio, id),
              ),
            ),
        ],
      ),
    );
  }

  /// Whether the results of [_term] in [_scope] are known to be empty. Looks
  /// at the default-sorted list, which the result view shares unless the user
  /// picked another sort (the count doesn't depend on the sort).
  bool _resultsEmpty() {
    bool empty<T>(AsyncValue<PagedState<T>> value) {
      final state = value.current;
      return state != null && state.items.isEmpty;
    }

    return switch (_scope) {
      SearchScope.scenes => empty(ref.watch(sceneListProvider(SceneQuery(search: _term, filter: _sceneFilter)))),
      SearchScope.images => empty(ref.watch(imageListProvider(ImageQuery(search: _term)))),
      SearchScope.galleries => empty(ref.watch(galleryListProvider(GalleryQuery(search: _term)))),
      SearchScope.performers => empty(ref.watch(performerListProvider(PerformerQuery(search: _term)))),
      SearchScope.studios => empty(ref.watch(studioListProvider(StudioQuery(search: _term)))),
    };
  }

  /// The results for [_term] in [_scope]. Each view keeps its sort and
  /// filters while the term changes; with no results it stays mounted (so it
  /// keeps them) behind a message with ways out (SEARCH-2).
  Widget _results(BuildContext context) {
    final empty = _resultsEmpty();
    return Stack(
      children: [
        Positioned.fill(child: Offstage(offstage: empty, child: _resultView(context))),
        if (empty)
          Positioned.fill(
            child: _NoResults(
              term: _term,
              scope: _scope,
              filtersActive: _scope == SearchScope.scenes && !_sceneFilter.isEmpty,
              onClearFilters: () => setState(() => _sceneFilter = const SceneFilter()),
              onScope: (s) => setState(() => _scope = s),
            ),
          ),
      ],
    );
  }

  Widget _resultView(BuildContext context) {
    final l = context.l10n;
    return switch (_scope) {
      SearchScope.scenes => SceneFeedView(
          layout: SceneFeedLayout.list,
          initialQuery: SceneQuery(search: _term, filter: _sceneFilter),
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

/// Typeahead under the search field (SEARCH-1): a row that submits the term,
/// then up to three matching performers, tags and studios. Shows only the
/// lists for [term] (the debounced term), so results of older terms never
/// appear; their providers are dropped as soon as the term changes.
class _Suggestions extends ConsumerWidget {
  const _Suggestions({
    required this.term,
    required this.scope,
    required this.controller,
    required this.onSubmit,
    required this.onPerformer,
    required this.onTag,
    required this.onStudio,
  });

  final String term;
  final SearchScope scope;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final ValueChanged<String> onPerformer;
  final ValueChanged<String> onTag;
  final ValueChanged<String> onStudio;

  static const _perKind = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    List<T> first<T>(AsyncValue<PagedState<T>> value) => (value.current?.items ?? <T>[]).take(_perKind).toList();
    final performers = first(ref.watch(performerListProvider(PerformerQuery(search: term))));
    final tags = first(ref.watch(tagListProvider(TagQuery(search: term))));
    final studios = first(ref.watch(studioListProvider(StudioQuery(search: term))));

    Widget header(String text) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
          child: Text(text, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        );

    // Taps here count as taps on the field, so it keeps its focus.
    return TextFieldTapRegion(
      child: Material(
        color: theme.colorScheme.surfaceContainer,
        elevation: 4,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.5),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 8),
            children: [
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (_, value, _) => ListTile(
                  leading: const Icon(Icons.search),
                  title: Text(l.searchSubmitIn(scope.name, value.text.trim())),
                  onTap: onSubmit,
                ),
              ),
              if (performers.isNotEmpty) ...[
                header(l.performersTitle),
                for (final p in performers)
                  ListTile(
                    dense: true,
                    leading: ChannelAvatar(name: p.name, imageUrl: p.imageUrl),
                    title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () => onPerformer(p.id),
                  ),
              ],
              if (tags.isNotEmpty) ...[
                header(l.tagsTitle),
                for (final t in tags)
                  ListTile(
                    dense: true,
                    leading: const SizedBox(width: 36, child: Icon(Icons.sell_outlined)),
                    title: Text(t.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () => onTag(t.id),
                  ),
              ],
              if (studios.isNotEmpty) ...[
                header(l.studiosTitle),
                for (final s in studios)
                  ListTile(
                    dense: true,
                    leading: ChannelAvatar(name: s.name, imageUrl: s.imageUrl),
                    title: Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () => onStudio(s.id),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// No results for [term] in [scope] (SEARCH-2): offers the other areas and,
/// with active scene filters, to clear them.
class _NoResults extends StatelessWidget {
  const _NoResults({
    required this.term,
    required this.scope,
    required this.filtersActive,
    required this.onClearFilters,
    required this.onScope,
  });

  final String term;
  final SearchScope scope;
  final bool filtersActive;
  final VoidCallback onClearFilters;
  final ValueChanged<SearchScope> onScope;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            EmptyView(
              message: scope == SearchScope.scenes ? l.searchNoScenes(term) : l.searchNoResults(term),
              icon: Icons.search_off,
              hint: filtersActive ? l.searchFiltersActiveHint : l.searchNoScenesHint,
            ),
            if (filtersActive) ...[
              FilledButton.tonalIcon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.filter_alt_off_outlined),
                label: Text(l.searchClearFilters),
              ),
              const SizedBox(height: 24),
            ],
            Text(l.searchOtherAreas, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in SearchScope.values)
                    if (s != scope) ActionChip(label: Text(s.label(l)), onPressed: () => onScope(s)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
        onLoadMore: () => ref.read(provider.notifier).loadMore(retry: true),
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
        onLoadMore: () => ref.read(provider.notifier).loadMore(retry: true),
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
