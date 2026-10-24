import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/gallery.dart';
import 'package:stash_app_mobile/data/models/image_item.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/studio.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/search/search_history.dart';
import 'package:stash_app_mobile/features/search/search_page.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';
import 'package:stash_app_mobile/widgets/scene_feed.dart';

import '../helpers.dart';

/// A small library searched like Stash does (the name contains the term),
/// plus a performer whose alias matches every term starting with "an".
class _Repository implements StashRepository {
  final sceneQueries = <SceneQuery>[];
  final imageQueries = <ImageQuery>[];
  final performerQueries = <PerformerQuery>[];

  /// Performer searches that wait for their completer and then return the
  /// given names instead of the library's.
  final slowPerformers = <String, (Completer<void>, List<String>)>{};

  static const _performers = ['Anna 1', 'Anna 2', 'Joanna', 'Big Ann'];

  List<T> _match<T>(String? term, List<T> items, String Function(T) name) {
    if (term == null || term.isEmpty) return items;
    return [for (final i in items) if (name(i).toLowerCase().contains(term.toLowerCase())) i];
  }

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    sceneQueries.add(query);
    final items = _match(query.search, const [
      Scene(id: 'sc1', title: 'Anna at the beach'),
      Scene(id: 'sc2', title: 'Banana split'),
    ], (s) => s.title);
    return PageResult(items: items, totalCount: items.length);
  }

  @override
  Future<PageResult<Performer>> findPerformers(PerformerQuery query, {int page = 1, int perPage = 24}) async {
    performerQueries.add(query);
    final term = query.search ?? '';
    if (slowPerformers[term] case (final gate, final names)) {
      await gate.future;
      final items = [for (final (i, n) in names.indexed) Performer(id: 'slow$i', name: n)];
      return PageResult(items: items, totalCount: items.length);
    }
    final items = [
      ..._match(term, [for (final (i, n) in _performers.indexed) Performer(id: 'p${i + 1}', name: n)], (p) => p.name),
      if (term.toLowerCase().startsWith('an')) const Performer(id: 'z', name: 'Zoe'),
    ];
    return PageResult(items: items, totalCount: items.length);
  }

  @override
  Future<PageResult<Tag>> findTags(TagQuery query, {int page = 1, int perPage = 24}) async {
    final items = _match(query.search, const [Tag(id: 't1', name: 'Animals', sceneCount: 2)], (t) => t.name);
    return PageResult(items: items, totalCount: items.length);
  }

  @override
  Future<PageResult<Studio>> findStudios(StudioQuery query, {int page = 1, int perPage = 24}) async {
    final items = _match(query.search, const [Studio(id: 's1', name: 'Andromeda')], (s) => s.name);
    return PageResult(items: items, totalCount: items.length);
  }

  @override
  Future<PageResult<ImageItem>> findImages(ImageQuery query, {int page = 1, int perPage = 24}) async {
    imageQueries.add(query);
    return const PageResult(items: [], totalCount: 0);
  }

  @override
  Future<PageResult<Gallery>> findGalleries(GalleryQuery query, {int page = 1, int perPage = 24}) async =>
      const PageResult(items: [], totalCount: 0);

  @override
  Future<List<SavedFilter>> savedSceneFilters() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// The completion rows on screen, top to bottom, by their screen reader label
/// (`Search for <text>`).
List<String> _rows() {
  const prefix = 'Search for ';
  final rows = [
    for (final e in find
        .byWidgetPredicate((w) => w is Semantics && (w.properties.label?.startsWith(prefix) ?? false))
        .evaluate())
      (
        (e.renderObject! as RenderBox).localToGlobal(Offset.zero).dy,
        (e.widget as Semantics).properties.label!.substring(prefix.length),
      ),
  ]..sort((a, b) => a.$1.compareTo(b.$1));
  return [for (final r in rows) r.$2];
}

Finder _row(String text) =>
    find.byWidgetPredicate((w) => w is Semantics && w.properties.label == 'Search for $text');

Finder _fillIn(String text) => find.descendant(
      of: find.byWidgetPredicate((w) => w is Semantics && w.properties.label == 'Fill in $text'),
      matching: find.byType(IconButton),
    );

/// The leaf spans of the row for [text] as (text, bold).
List<(String, bool)> _spans(WidgetTester tester, String text) {
  final rich = tester.widget<RichText>(find.descendant(
    of: _row(text),
    matching: find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText() == text),
  ));
  final spans = <(String, bool)>[];
  void visit(InlineSpan span, bool bold) {
    if (span is! TextSpan) return;
    final b = span.style?.fontWeight == null ? bold : span.style!.fontWeight == FontWeight.w700;
    if (span.text != null) spans.add((span.text!, b));
    for (final c in span.children ?? const <InlineSpan>[]) {
      visit(c, b);
    }
  }

  visit(rich.text, false);
  return spans;
}

void main() {
  late _Repository repo;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repo = _Repository();
  });

  Future<ProviderContainer> pumpSearch(WidgetTester tester, {List<String> history = const []}) async {
    // Tall enough for all completions.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final c = ProviderContainer(overrides: [
      ...testServer,
      sharedPreferencesProvider.overrideWithValue(prefs),
      stashRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(c.dispose);
    for (final h in history.reversed) {
      await c.read(searchHistoryProvider.notifier).add(h);
    }
    final navigatorKey = c.read(tabNavigatorKeysProvider)[c.read(currentTabProvider)];
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(navigatorKey: navigatorKey, home: const SearchPage()),
    ));
    await tester.pumpAndSettle();
    return c;
  }

  Future<void> typeOnly(WidgetTester tester, String term) async {
    await tester.enterText(find.byType(TextField), term);
    await tester.pump(const Duration(milliseconds: 200)); // completion debounce
    await tester.pumpAndSettle();
  }

  TextEditingController field(WidgetTester tester) => tester.widget<TextField>(find.byType(TextField)).controller!;

  /// The term the results show, or null while the discover view is shown.
  String? resultTerm(WidgetTester tester) {
    // Offstage while it has no results.
    final feed = find.byType(SceneFeedView, skipOffstage: false);
    return feed.evaluate().isEmpty ? null : tester.widget<SceneFeedView>(feed).initialQuery.search;
  }

  group('autocomplete (SEARCH-1)', () {
    testWidgets('completes with recent searches first, then ranked library names', (tester) async {
      await pumpSearch(tester, history: ['animal facts', 'zebra', 'band']);
      await typeOnly(tester, 'an');

      expect(_rows(), [
        // Recent searches: starts-with before contains.
        'animal facts', 'band',
        // Starts with "an", by kind: performers, tag, studio, scene.
        'Anna 1', 'Anna 2', 'Animals', 'Andromeda', 'Anna at the beach',
        // A word starts with "an".
        'Big Ann',
      ]);
      // Zoe matched only by an alias; Joanna and "Banana split" (contains)
      // don't fit into the eight rows.
      expect(_row('Zoe'), findsNothing);
      expect(_row('Joanna'), findsNothing);
      expect(find.widgetWithIcon(Row, Icons.history), findsWidgets);
      // Results wait for the search.
      expect(resultTerm(tester), isNull);
    });

    testWidgets('bolds the typed part', (tester) async {
      await pumpSearch(tester);
      await typeOnly(tester, 'an');

      expect(_spans(tester, 'Big Ann'), [('Big ', false), ('An', true), ('n', false)]);
      expect(_spans(tester, 'Animals'), [('An', true), ('imals', false)]);
    });

    testWidgets('the arrow fills in the completion without searching', (tester) async {
      final c = await pumpSearch(tester);
      await typeOnly(tester, 'an');

      await tester.tap(_fillIn('Animals'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(field(tester).text, 'Animals');
      expect(field(tester).selection, const TextSelection.collapsed(offset: 7));
      expect(tester.testTextInput.hasAnyClients, isTrue);
      expect(c.read(searchHistoryProvider), isEmpty);
      expect(resultTerm(tester), isNull);
      // Still typing: the completions follow the new text.
      expect(_rows(), ['Animals']);
    });

    testWidgets('tapping a completion searches it and records it', (tester) async {
      final c = await pumpSearch(tester);
      await typeOnly(tester, 'an');

      await tester.tap(_row('Andromeda'));
      await tester.pumpAndSettle();

      expect(field(tester).text, 'Andromeda');
      expect(c.read(searchHistoryProvider), ['Andromeda']);
      expect(resultTerm(tester), 'Andromeda');
      expect(_rows(), isEmpty);
      expect(FocusManager.instance.primaryFocus?.context?.widget, isNot(isA<EditableText>()));
    });

    testWidgets('the keyboard search action searches the typed text', (tester) async {
      final c = await pumpSearch(tester);
      await typeOnly(tester, 'an');

      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(_rows(), isEmpty);
      expect(resultTerm(tester), 'an');
      expect(c.read(searchHistoryProvider), ['an']);
    });

    testWidgets("results don't reload while typing", (tester) async {
      await pumpSearch(tester);
      await typeOnly(tester, 'an');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await typeOnly(tester, 'and');
      await tester.pump(const Duration(seconds: 1));
      expect(_rows(), contains('Andromeda'));
      expect(resultTerm(tester), 'an');
    });

    testWidgets('a recent search can be removed from the completions', (tester) async {
      final c = await pumpSearch(tester, history: ['animal facts']);
      await typeOnly(tester, 'an');

      await tester.tap(find.descendant(
        of: find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Remove animal facts from recent searches',
        ),
        matching: find.byType(IconButton),
      ));
      await tester.pumpAndSettle();
      expect(c.read(searchHistoryProvider), isEmpty);
      expect(_row('animal facts'), findsNothing);
      expect(_row('Anna 1'), findsOneWidget);
    });

    testWidgets('tapping beside the list closes it and shows the results', (tester) async {
      await pumpSearch(tester);
      await typeOnly(tester, 'an');

      await tester.tapAt(const Offset(400, 2300));
      await tester.pumpAndSettle();
      expect(_rows(), isEmpty);
      expect(resultTerm(tester), 'an');
    });

    testWidgets('back closes the list before leaving the page', (tester) async {
      await pumpSearch(tester);
      await typeOnly(tester, 'an');
      expect(_rows(), isNotEmpty);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(_rows(), isEmpty);
      expect(resultTerm(tester), 'an');
      expect(find.byType(SearchPage), findsOneWidget);
    });

    testWidgets('Escape closes the list', (tester) async {
      await pumpSearch(tester);
      await typeOnly(tester, 'an');

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(_rows(), isEmpty);
      expect(resultTerm(tester), 'an');
    });

    testWidgets('losing focus hides the completions, focusing shows them again', (tester) async {
      await pumpSearch(tester);
      await typeOnly(tester, 'an');
      expect(_rows(), isNotEmpty);

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      expect(_rows(), isEmpty);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(_rows(), contains('Andromeda'));
    });

    testWidgets('responses for an older text never show', (tester) async {
      final older = Completer<void>();
      final newer = Completer<void>();
      repo.slowPerformers['an'] = (older, ['Andre Old']);
      repo.slowPerformers['and'] = (newer, ['Andy New']);
      await pumpSearch(tester);

      await typeOnly(tester, 'an');
      await typeOnly(tester, 'and');
      expect(_rows(), ['Andromeda']);

      newer.complete();
      await tester.pumpAndSettle();
      older.complete();
      await tester.pumpAndSettle();
      expect(_rows(), ['Andy New', 'Andromeda']);
      expect(find.textContaining('Andre Old', findRichText: true), findsNothing);
    });

    testWidgets('screen readers hear what a row does', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpSearch(tester);
      await typeOnly(tester, 'an');

      expect(find.bySemanticsLabel('Search for Animals'), findsOneWidget);
      expect(find.bySemanticsLabel('Fill in Animals'), findsOneWidget);
      expect(find.byTooltip('Fill in'), findsWidgets);
      semantics.dispose();
    });

    testWidgets('a performer under "Go to" opens the performer', (tester) async {
      await pumpSearch(tester);
      await typeOnly(tester, 'an');

      expect(find.text('Go to'), findsOneWidget);
      await tester.tap(find.widgetWithText(ActionChip, 'Anna 2'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SearchPage), findsNothing);
    });
  });

  group('no results (SEARCH-2)', () {
    testWidgets('offers the other areas', (tester) async {
      await pumpSearch(tester);
      await tester.enterText(find.byType(TextField), 'zebra');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.text('No scenes match "zebra"'), findsOneWidget);
      expect(find.text('Search other areas'), findsOneWidget);
      expect(find.text('Clear filters'), findsNothing);

      await tester.tap(find.widgetWithText(ActionChip, 'Images'));
      await tester.pumpAndSettle();
      expect(repo.imageQueries.last.search, 'zebra');
      expect(find.text('Nothing matches "zebra"'), findsOneWidget);
      expect(find.widgetWithText(ActionChip, 'Scenes'), findsOneWidget);
    });

    testWidgets('clears active scene filters', (tester) async {
      await pumpSearch(tester);
      await tester.enterText(find.byType(TextField), 'zebra');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Over 30 min'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Over 30 min'));
      await tester.pump();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(repo.sceneQueries.last.filter.isEmpty, isFalse);

      await tester.tap(find.text('Clear filters'));
      await tester.pumpAndSettle();
      expect(repo.sceneQueries.last.filter.isEmpty, isTrue);
      expect(find.text('Clear filters'), findsNothing);
    });
  });
}
