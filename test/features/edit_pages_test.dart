import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/studio.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/edit/edit_pages.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';

import '../helpers.dart';

class FakeRepository implements StashRepository {
  final calls = <String, Map<String, dynamic>>{};

  @override
  Future<Scene> updateScene(String id, Map<String, dynamic> changes) async {
    calls['scene'] = changes;
    return Scene(id: id, title: changes['title'] as String? ?? 'unchanged', organized: changes['organized'] == true);
  }

  @override
  Future<List<String>?> sceneUrls(String id) async => null;

  @override
  Future<List<String>?> performerUrls(String id) async => null;

  @override
  Future<Performer> updatePerformer(String id, Map<String, dynamic> changes) async {
    calls['performer'] = changes;
    return Performer(id: id, name: 'x');
  }

  @override
  Future<Tag> updateTag(String id, Map<String, dynamic> changes) async {
    calls['tag'] = changes;
    return Tag(id: id, name: 'x');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = FakeRepository();
    container = ProviderContainer(overrides: [stashRepositoryProvider.overrideWithValue(repo), testServer]);
    addTearDown(container.dispose);
  });

  /// Opens [page] on top of a home route so saving can pop back.
  Future<void> open(WidgetTester tester, Widget page) async {
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page)),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  const scene = Scene(
    id: 's1',
    title: 'Old title',
    studio: Studio(id: '7', name: 'Studio'),
    performers: [Performer(id: '1', name: 'Alice'), Performer(id: '2', name: 'Bob')],
  );

  testWidgets('scene: sends only changed fields and updates the player', (tester) async {
    container.read(nowPlayingProvider.notifier).state = scene;
    await open(tester, const SceneEditPage(scene: scene));

    await tester.enterText(find.widgetWithText(TextField, 'Old title'), 'New title');
    await tester.tap(find.byTooltip('Clear')); // studio
    await tester.scrollUntilVisible(find.text('Organized'), 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Organized'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(repo.calls['scene'], {'title': 'New title', 'studio_id': null, 'organized': true});
    expect(container.read(nowPlayingProvider)?.title, 'New title');
    expect(find.text('open'), findsOneWidget, reason: 'back on the previous page');
    expect(find.text('Saved'), findsOneWidget);
  });

  testWidgets('saving without changes sends nothing', (tester) async {
    await open(tester, const SceneEditPage(scene: scene));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(repo.calls, isEmpty);
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('performer: country is upper-cased, cleared fields become null', (tester) async {
    await open(
      tester,
      const PerformerEditPage(performer: Performer(id: 'p', name: 'Alice', disambiguation: 'old')),
    );
    await tester.enterText(find.widgetWithText(TextField, 'old'), '');
    await tester.scrollUntilVisible(
      find.widgetWithText(TextField, 'Country code'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(find.widgetWithText(TextField, 'Country code'), 'de');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(repo.calls['performer'], {'disambiguation': null, 'country': 'DE'});
  });

  testWidgets('tag: an empty name is rejected with a message', (tester) async {
    await open(tester, const TagEditPage(tag: Tag(id: 't', name: 'Beach')));
    await tester.enterText(find.widgetWithText(TextField, 'Beach'), ' ');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(repo.calls, isEmpty);
    expect(find.textContaining('A name is required'), findsOneWidget);
    expect(find.text('Edit tag'), findsOneWidget, reason: 'stays on the form');
  });
}
