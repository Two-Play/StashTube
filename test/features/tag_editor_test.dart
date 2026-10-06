import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/player/scene_edits.dart';
import 'package:stash_app_mobile/features/tags/tag_editor.dart';

import '../helpers.dart';

class FakeRepository implements StashRepository {
  final created = <String>[];
  List<String>? savedIds;
  bool failCreate = false;

  @override
  Future<PageResult<Tag>> findTags(TagQuery query, {int page = 1, int perPage = 24}) async {
    const all = [Tag(id: '1', name: 'Outdoor'), Tag(id: '2', name: 'Beach'), Tag(id: '3', name: 'Sunset')];
    final q = query.search?.toLowerCase();
    final items = q == null ? all : all.where((t) => t.name.toLowerCase().contains(q)).toList();
    return PageResult(items: items, totalCount: items.length);
  }

  @override
  Future<Tag> createTag(String name) async {
    if (failCreate) throw const StashApiException('Tag already exists');
    created.add(name);
    return Tag(id: 'new-${created.length}', name: name);
  }

  @override
  Future<List<Tag>> setSceneTags(String sceneId, List<String> tagIds) async {
    savedIds = tagIds;
    return [for (final id in tagIds) Tag(id: id, name: 'saved $id')];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const scene = Scene(id: 's1', title: 'A', tags: [Tag(id: '1', name: 'Outdoor')]);

void main() {
  late FakeRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = FakeRepository();
    container = ProviderContainer(overrides: [stashRepositoryProvider.overrideWithValue(repo), ...testServer]);
  });
  tearDown(() => container.dispose());

  Future<void> openEditor(WidgetTester tester) async {
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showSceneTagEditor(context, scene, scene.tags),
              child: const Text('edit'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('edit'));
    await tester.pumpAndSettle();
  }

  testWidgets('remove a tag, add a suggestion, create a new one and save', (tester) async {
    await openEditor(tester);
    expect(find.text('#Outdoor'), findsOneWidget);

    // Remove the existing tag.
    await tester.tap(find.byTooltip('Delete'));
    await tester.pump();
    expect(find.text('No tags yet'), findsOneWidget);

    // Add a suggested tag.
    await tester.tap(find.text('#Beach'));
    await tester.pump();

    // Search for a tag that doesn't exist and create it.
    await tester.enterText(find.byType(TextField), 'Rooftop');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create #Rooftop'));
    await tester.pumpAndSettle();
    expect(repo.created, ['Rooftop']);
    expect(find.text('#Rooftop'), findsOneWidget);

    await tester.tap(find.text('Save tags'));
    await tester.pumpAndSettle();
    expect(repo.savedIds, ['2', 'new-1']);
    expect(container.read(sceneEditsProvider)['s1']?.tags?.map((t) => t.id), ['2', 'new-1']);
    expect(find.text('Save tags'), findsNothing, reason: 'sheet closed');
  });

  testWidgets('no "create" option when the tag already exists', (tester) async {
    await openEditor(tester);
    await tester.enterText(find.byType(TextField), 'sunset');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    expect(find.textContaining('Create'), findsNothing);
    expect(find.text('#Sunset'), findsOneWidget);
  });

  testWidgets('create-tag dialog shows server errors', (tester) async {
    repo.failCreate = true;
    Tag? result;
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Consumer(
          builder: (context, ref, _) => TextButton(
            onPressed: () async => result = await showCreateTagDialog(context, ref),
            child: const Text('new'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('new'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Outdoor');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(find.text('Tag already exists'), findsOneWidget);
    expect(result, isNull);

    repo.failCreate = false;
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(result?.name, 'Outdoor');
  });
}
