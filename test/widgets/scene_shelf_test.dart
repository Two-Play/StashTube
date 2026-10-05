import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/widgets/scene_shelf.dart';

class FakeRepository implements StashRepository {
  FakeRepository(this.scenes);

  final List<Scene> scenes;

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async =>
      PageResult(items: scenes, totalCount: scenes.length);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final query = SceneQuery(inProgressOnly: true);

  Future<ProviderContainer> pumpShelf(WidgetTester tester, List<Scene> scenes) async {
    final container = ProviderContainer(overrides: [
      stashRepositoryProvider.overrideWithValue(FakeRepository(scenes)),
    ]);
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(body: SceneShelf(title: 'Continue watching', query: query, hideFinished: true)),
      ),
    ));
    await tester.pump();
    return container;
  }

  testWidgets('renders nothing when there are no scenes', (tester) async {
    await pumpShelf(tester, const []);
    expect(find.text('Continue watching'), findsNothing);
  });

  testWidgets('shows scenes and hides ones finished in this session', (tester) async {
    final container = await pumpShelf(tester, const [
      Scene(id: '1', title: 'Half watched', duration: 100, resumeTime: 50),
      Scene(id: '2', title: 'Just finished', duration: 100, resumeTime: 80),
    ]);
    expect(find.text('Continue watching'), findsOneWidget);
    expect(find.text('Just finished'), findsOneWidget);

    container.read(resumeTimesProvider.notifier).set('2', 0);
    await tester.pump();
    expect(find.text('Half watched'), findsOneWidget);
    expect(find.text('Just finished'), findsNothing);
  });
}
