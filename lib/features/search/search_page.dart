import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/models/performer.dart';
import '../../data/models/scene_filter.dart';
import '../../data/models/studio.dart';
import '../../data/providers.dart';
import '../../widgets/scene_shelf.dart';
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
import 'search_completions.dart';
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
  Timer? _suggestDebounce;
  Timer? _record;
  String _term = '';
  late var _scope = widget.initialScope;

  /// The scene filters; kept here (not in the result view) so the empty
  /// results can offer to clear them (SEARCH-2).
  SceneFilter _sceneFilter = const SceneFilter();

  /// Whether the completions (SEARCH-1) are shown: while the field has focus
  /// and text, until a search runs or the list is dismissed (Escape, a tap
  /// beside it, leaving the field). Meanwhile the results underneath keep the
  /// last searched term, so they don't reload while typing.
  bool _suggest = false;

  /// The text the library completions are loaded for: the typed text after a
  /// short pause, so they follow quickly without a request per keystroke.
  String _suggestTerm = '';

  static const _suggestDelay = Duration(milliseconds: 150);

  /// The completion row picked with the arrow keys (hardware keyboards), or
  /// -1; Enter searches it. The field keeps the focus meanwhile.
  int _highlight = -1;
  final _completionsKey = GlobalKey<_CompletionsState>();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _suggestDebounce?.cancel();
    _record?.cancel();
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Focusing the field with text in it shows its completions again; leaving
  /// it hides them, keeping the results (a tap beside the field may land on
  /// them, so they must not change under the finger).
  void _onFocusChanged() {
    if (_focus.hasFocus) {
      if (!_suggest && _controller.text.trim().isNotEmpty) {
        setState(() {
          _suggest = true;
          _suggestTerm = _controller.text.trim();
        });
      }
    } else if (_suggest) {
      _dismissSuggestions();
    }
  }

  /// Hides the completions; with [search] also shows the results of the
  /// typed text.
  void _dismissSuggestions({bool search = false}) {
    _suggestDebounce?.cancel();
    _highlight = -1;
    if (_suggest) setState(() => _suggest = false);
    if (search && _controller.text.trim() != _term) _search(_controller.text);
  }

  void _onChanged(String value) {
    _suggestDebounce?.cancel();
    _highlight = -1;
    if (value.trim().isEmpty) {
      setState(() {
        _suggest = false;
        _suggestTerm = '';
      });
      _search('');
      return;
    }
    // Rebuilds for the highlighted part and the history matches.
    setState(() => _suggest = true);
    _suggestDebounce = Timer(_suggestDelay, () {
      if (mounted) setState(() => _suggestTerm = value.trim());
    });
  }

  void _submit(String value) {
    // Enter with a row picked by the arrow keys searches that row.
    final picked = _highlightedText;
    if (picked != null) {
      _pick(picked);
      return;
    }
    _suggestDebounce?.cancel();
    setState(() => _suggest = false);
    _search(value, submitted: true);
  }

  /// Searches for a picked completion or recent search.
  void _pick(String term) {
    _highlight = -1;
    _setText(term);
    _submit(term);
    _focus.unfocus();
  }

  /// Puts a completion into the field to type on, without searching.
  void _fillIn(String text) {
    _setText(text);
    _focus.requestFocus();
    _onChanged(text);
  }

  void _setText(String text) =>
      _controller.value = TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));

  /// Leaves the search for a suggested performer, tag or studio, with the
  /// results of the typed text waiting on return.
  void _open(Completion completion) {
    _dismissSuggestions(search: true);
    _focus.unfocus();
    final id = completion.id!;
    switch (completion.kind) {
      case CompletionKind.performer:
        openPerformer(ref, id);
      case CompletionKind.tag:
        openTag(ref, id);
      case CompletionKind.studio:
        openStudio(ref, id);
      case CompletionKind.history || CompletionKind.scene:
        break;
    }
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

  /// The completion row highlighted with the arrow keys, if still shown.
  String? get _highlightedText {
    if (!_suggest || _highlight < 0) return null;
    final rows = _completionsKey.currentState?.rowTexts ?? const <String>[];
    return _highlight < rows.length ? rows[_highlight] : null;
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_suggest || event is KeyUpEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.escape && event is KeyDownEvent) {
      _dismissSuggestions(search: true);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.arrowUp) {
      final count = _completionsKey.currentState?.rowTexts.length ?? 0;
      if (count == 0) return KeyEventResult.ignored;
      // From the field (-1) down to the first row or up to the last; past
      // either end back to the field.
      final current = _highlight < count ? _highlight : -1;
      final next = key == LogicalKeyboardKey.arrowDown
          ? (current + 1 >= count ? -1 : current + 1)
          : (current <= -1 ? count - 1 : current - 1);
      setState(() => _highlight = next);
      return KeyEventResult.handled;
    }
    if ((key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) && event is KeyDownEvent) {
      final picked = _highlightedText;
      if (picked == null) return KeyEventResult.ignored;
      _pick(picked);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final typed = _controller.text.trim();
    // Back first closes the completions (and shows the typed text's results).
    return PopScope(
      canPop: !_suggest,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _dismissSuggestions(search: true);
        _focus.unfocus();
      },
      child: Scaffold(
      appBar: AppBar(
        // Next to the back button; as a tab root the field keeps the margin.
        titleSpacing: (ModalRoute.of(context)?.canPop ?? false) ? 0 : null,
        title: Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onKeyEvent: _onKey,
          child: TextField(
            controller: _controller,
            focusNode: _focus,
            autofocus: widget.autofocus,
            textInputAction: TextInputAction.search,
            onChanged: _onChanged,
            onSubmitted: _submit,
            onTapOutside: (_) => _focus.unfocus(),
            decoration: InputDecoration(
              hintText: _scope.hint(context.l10n),
              border: InputBorder.none,
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _controller.clear();
                        _onChanged('');
                        _focus.requestFocus();
                      },
                    ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: ChipBar<SearchScope>(
            values: SearchScope.values,
            selected: _scope,
            labelOf: (s) => s.label(context.l10n),
            onSelected: (s) {
              setState(() => _scope = s);
              // The new area shows what is in the field.
              if (typed != _term) _search(typed);
            },
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
            // Scrolling closes the keyboard.
            child: NotificationListener<ScrollStartNotification>(
              onNotification: (n) {
                if (n.dragDetails != null) _focus.unfocus();
                return false;
              },
              child: _term.isEmpty ? _Discover(onPick: _pick) : _results(context),
            ),
          ),
          if (_suggest && typed.isNotEmpty)
            Positioned.fill(
              // Taps here count as taps on the field, so it keeps its focus.
              child: TextFieldTapRegion(
                child: Stack(
                  children: [
                    // Tapping or dragging beside the list closes it and shows
                    // the results of the typed text.
                    Positioned.fill(
                      child: GestureDetector(
                        onVerticalDragStart: (_) {
                          _dismissSuggestions(search: true);
                          _focus.unfocus();
                        },
                        child: ModalBarrier(
                          color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.32),
                          semanticsLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                          onDismiss: () {
                            _dismissSuggestions(search: true);
                            _focus.unfocus();
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: _Completions(
                        key: _completionsKey,
                        highlighted: _highlight,
                        typed: typed,
                        term: _suggestTerm,
                        scope: _scope,
                        onSearch: _pick,
                        onFill: _fillIn,
                        onOpen: _open,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
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

/// Autocomplete under the search field (SEARCH-1): texts to search for, first
/// matching recent searches, then names and titles from the library, and a
/// compact row that opens matching performers, tags and studios directly.
///
/// The library completions load for [term] (the typed text after a pause)
/// through the list providers, which are keyed by it, so responses for older
/// terms never show. Until the new term's lists are in, the last complete
/// lists stay, filtered to what still completes [typed] (no flicker).
class _Completions extends ConsumerStatefulWidget {
  const _Completions({
    super.key,
    this.highlighted = -1,
    required this.typed,
    required this.term,
    required this.scope,
    required this.onSearch,
    required this.onFill,
    required this.onOpen,
  });

  /// The trimmed text in the field; completions match and highlight it.
  final String typed;
  final String term;
  final SearchScope scope;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onFill;
  final ValueChanged<Completion> onOpen;

  /// The row picked with the arrow keys, or -1.
  final int highlighted;

  static const _limit = 8;
  static const _historyLimit = 3;
  static const _goToLimit = 5;

  @override
  ConsumerState<_Completions> createState() => _CompletionsState();
}

class _CompletionsState extends ConsumerState<_Completions> {
  List<Completion> _lastPool = const [];

  /// The texts of the rows as last built, for the arrow keys.
  List<String> rowTexts = const [];

  /// The completions in [value], null while it loads; a failed list adds
  /// none.
  List<Completion>? _load<T>(AsyncValue<PagedState<T>> value, Completion Function(T item) toCompletion) {
    if (value.hasError) return const [];
    final state = value.current;
    return state == null ? null : [for (final item in state.items) toCompletion(item)];
  }

  /// The library's candidates for [_Completions.term], by kind; from the
  /// lists that fit the scope.
  List<Completion> _pool() {
    final term = widget.term;
    if (term.isEmpty) return _lastPool;
    final scope = widget.scope;
    final parts = <List<Completion>?>[
      if (scope != SearchScope.studios)
        _load(
          ref.watch(performerListProvider(PerformerQuery(search: term))),
          (p) => Completion(p.name, CompletionKind.performer, id: p.id, imageUrl: p.imageUrl),
        ),
      if (scope != SearchScope.performers && scope != SearchScope.studios)
        _load(ref.watch(tagListProvider(TagQuery(search: term))), (t) => Completion(t.name, CompletionKind.tag, id: t.id)),
      if (scope != SearchScope.performers)
        _load(
          ref.watch(studioListProvider(StudioQuery(search: term))),
          (s) => Completion(s.name, CompletionKind.studio, id: s.id, imageUrl: s.imageUrl),
        ),
      if (scope == SearchScope.scenes)
        _load(ref.watch(sceneListProvider(SceneQuery(search: term))), (s) => Completion(s.title, CompletionKind.scene)),
    ];
    if (parts.every((p) => p != null)) return _lastPool = [for (final p in parts) ...p!];
    return [..._lastPool, for (final p in parts) ...?p];
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final typed = widget.typed;
    final pool = _pool();
    final history = historyCompletions(ref.watch(searchHistoryProvider), typed, limit: _Completions._historyLimit);
    final library = rankCompletions(
      typed,
      pool,
      limit: _Completions._limit - history.length,
      exclude: [for (final h in history) h.text],
    );
    final goTo = rankCompletions(typed, pool.where((c) => c.isEntity), limit: _Completions._goToLimit, perKind: 3);
    final rows = [...history, ...library];
    rowTexts = [for (final c in rows) c.text];
    if (history.isEmpty && library.isEmpty && goTo.isEmpty) return const SizedBox.shrink();

    return Material(
      color: theme.colorScheme.surfaceContainer,
      elevation: 4,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4),
        children: [
          for (final (i, c) in rows.indexed)
            _CompletionRow(
              completion: c,
              highlighted: i == widget.highlighted,
              typed: typed,
              onSearch: () => widget.onSearch(c.text),
              onFill: () => widget.onFill(c.text),
              onRemove: c.kind == CompletionKind.history
                  ? () => ref.read(searchHistoryProvider.notifier).remove(c.text)
                  : null,
            ),
          if (goTo.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                l.searchGoTo,
                style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Row(
                spacing: 8,
                children: [
                  for (final c in goTo)
                    ActionChip(
                      avatar: c.kind == CompletionKind.tag
                          ? const Icon(Icons.sell_outlined, size: 18)
                          : ChannelAvatar(name: c.text, imageUrl: c.imageUrl, radius: 12),
                      label: Text(c.text),
                      onPressed: () => widget.onOpen(c),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// One completion: tapping searches it, the arrow puts it into the field to
/// type on, and a recent search can be removed (its x or a long press).
class _CompletionRow extends StatelessWidget {
  const _CompletionRow({
    required this.completion,
    required this.typed,
    required this.onSearch,
    required this.onFill,
    this.onRemove,
    this.highlighted = false,
  });

  final Completion completion;

  /// Picked with the arrow keys: Enter searches it.
  final bool highlighted;
  final String typed;
  final VoidCallback onSearch;
  final VoidCallback onFill;
  final VoidCallback? onRemove;

  static IconData _icon(CompletionKind kind) => switch (kind) {
        CompletionKind.history => Icons.history,
        CompletionKind.performer => Icons.person_outline,
        CompletionKind.tag => Icons.sell_outlined,
        CompletionKind.studio => Icons.subscriptions_outlined,
        CompletionKind.scene => Icons.search,
      };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final text = completion.text;
    final muted = theme.colorScheme.onSurfaceVariant;
    final row = Row(
      children: [
        Expanded(
          child: Semantics(
            button: true,
            selected: highlighted,
            label: l.searchFor(text),
            excludeSemantics: true,
            child: InkWell(
              onTap: onSearch,
              onLongPress: onRemove,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
                  child: Row(
                    children: [
                      Icon(_icon(completion.kind), size: 20, color: muted),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text.rich(
                          highlightedSpan(text, typed),
                          style: theme.textTheme.bodyLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (onRemove != null)
          Semantics(
            button: true,
            label: l.searchRemoveFromHistory(text),
            excludeSemantics: true,
            onTap: onRemove,
            child: IconButton(
              tooltip: l.remove,
              icon: Icon(Icons.close, size: 18, color: muted),
              onPressed: onRemove,
            ),
          ),
        Semantics(
          button: true,
          label: l.searchFillInText(text),
          excludeSemantics: true,
          onTap: onFill,
          child: IconButton(
            tooltip: l.searchFillIn,
            icon: Icon(Icons.north_west, size: 20, color: muted),
            onPressed: onFill,
          ),
        ),
      ],
    );
    return highlighted ? Material(color: theme.colorScheme.secondaryContainer, child: row) : row;
  }
}

/// [text] with the parts matching [typed] in bold and the rest in normal
/// weight.
@visibleForTesting
TextSpan highlightedSpan(String text, String typed) {
  const bold = TextStyle(fontWeight: FontWeight.w700);
  final children = <TextSpan>[];
  var pos = 0;
  for (final (start, end) in highlightRanges(text, typed)) {
    if (start > pos) children.add(TextSpan(text: text.substring(pos, start)));
    children.add(TextSpan(text: text.substring(start, end), style: bold));
    pos = end;
  }
  if (pos < text.length) children.add(TextSpan(text: text.substring(pos)));
  return TextSpan(style: const TextStyle(fontWeight: FontWeight.w400), children: children);
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
              actionLabel: filtersActive ? l.searchClearFilters : null,
              actionIcon: Icons.filter_alt_off_outlined,
              onAction: filtersActive ? onClearFilters : null,
            ),
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
          ShelfHeader(
            title: context.l10n.performersTitle,
            onSeeAll: onSeeAll,
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
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
            child: ShelfHeader(
              title: context.l10n.popularTags,
              onSeeAll: () => openTags(ref),
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 4, 4),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: tagGridDelegate(context),
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
