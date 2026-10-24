import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/widgets/paged_sliver.dart';
import 'package:stash_app_mobile/widgets/scene_feed.dart';
import 'package:stash_app_mobile/widgets/scene_shelf.dart';
import 'package:stash_app_mobile/widgets/skeleton.dart';
import 'package:stash_app_mobile/widgets/status_views.dart';

import '../helpers.dart';

/// Answers once [gate] completes, with no scenes.
class _Repo implements StashRepository {
  final gate = Completer<void>();

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    await gate.future;
    return const PageResult(items: [], totalCount: 0);
  }

  @override
  Future<List<SavedFilter>> savedSceneFilters() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Widget sliver({SliverGridDelegate? grid, WidgetBuilder? skeleton}) => CustomScrollView(slivers: [
        PagedSliver<String>(
          value: const AsyncLoading(),
          gridDelegate: grid,
          skeletonBuilder: skeleton,
          onRetry: () {},
          onLoadMore: () {},
          itemBuilder: (_, item) => Text(item),
        ),
      ]);

  testWidgets('the first page loads with placeholders instead of a spinner', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: sliver())));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListTileSkeleton), findsNWidgets(4));
    // Announced once, the boxes themselves are hidden from screen readers.
    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
    semantics.dispose();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: sliver(grid: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200)),
      ),
    ));
    expect(find.byType(GridTileSkeleton), findsNWidgets(8));

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: sliver(skeleton: (_) => const SceneCardSkeleton()))));
    expect(find.byType(SceneCardSkeleton), findsWidgets);
  });

  testWidgets('the placeholders pulse, but not with reduced motion', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: sliver())));
    double opacity() => tester.widget<FadeTransition>(
          find.descendant(of: find.byType(SkeletonPulse), matching: find.byType(FadeTransition)),
        ).opacity.value;
    final start = opacity();
    await tester.pump(const Duration(milliseconds: 450));
    expect(opacity(), isNot(start));

    await tester.pumpWidget(MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Scaffold(body: sliver()),
      ),
    ));
    await tester.pumpAndSettle(); // would time out if it kept pulsing
    expect(opacity(), 1);
  });

  testWidgets('the colors come from the theme', (tester) async {
    final theme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark));
    await tester.pumpWidget(MaterialApp(theme: theme, home: const Scaffold(body: SkeletonBox(width: 10, height: 10))));
    await tester.pumpAndSettle();
    final box = tester.widget<Container>(find.byType(Container));
    expect((box.decoration! as BoxDecoration).color, theme.colorScheme.surfaceContainerHighest);
  });

  testWidgets('a shelf shows placeholders while it loads and disappears when empty', (tester) async {
    final repo = _Repo();
    await tester.pumpWidget(ProviderScope(
      overrides: [...testServer, stashRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(home: Scaffold(body: SceneShelf(title: 'Shelf', query: SceneQuery()))),
    ));
    await tester.pump();
    expect(find.text('Shelf'), findsOneWidget);
    expect(find.byType(ShelfSkeleton), findsOneWidget);

    repo.gate.complete();
    await tester.pumpAndSettle();
    expect(find.text('Shelf'), findsNothing);
  });

  testWidgets('the empty view for an unscanned library is not shown for a search without results', (tester) async {
    final repo = _Repo()..gate.complete();
    Future<void> pump(SceneQuery query) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [...testServer, stashRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          home: Scaffold(
            body: SceneFeedView(
              key: UniqueKey(),
              initialQuery: query,
              unfilteredEmptyView: const EmptyView(message: 'Scan first'),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
    }

    await pump(SceneQuery());
    expect(find.text('Scan first'), findsOneWidget);
    await pump(SceneQuery(search: 'nothing'));
    expect(find.text('Scan first'), findsNothing);
    expect(find.text('No scenes found'), findsOneWidget);
  });
}
