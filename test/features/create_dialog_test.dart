import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/studio.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/edit/create_dialog.dart';

import '../helpers.dart';

class _Repository implements StashRepository {
  final created = <String>[];
  bool fail = false;

  @override
  Future<Performer> createPerformer(String name) async {
    if (fail) throw const StashApiException('Performer already exists');
    created.add('performer $name');
    return Performer(id: 'p${created.length}', name: name);
  }

  @override
  Future<Studio> createStudio(String name) async {
    created.add('studio $name');
    return Studio(id: 's${created.length}', name: name);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _Repository repo;
  late ProviderContainer container;
  Object? result;

  setUp(() {
    repo = _Repository();
    result = null;
    container = ProviderContainer(overrides: [stashRepositoryProvider.overrideWithValue(repo), ...testServer]);
  });
  tearDown(() => container.dispose());

  /// A button opening the dialog for a performer or a studio.
  Future<void> open(WidgetTester tester, {bool studio = false}) async {
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(
          body: Consumer(
            builder: (context, ref, _) => TextButton(
              onPressed: () async => result = studio
                  ? await showCreateDialog(context, title: 'New studio', create: (n) => createStudio(ref, n))
                  : await showCreateDialog(context, title: 'New performer', create: (n) => createPerformer(ref, n)),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('creates a performer with the trimmed name and returns it', (tester) async {
    await open(tester);
    expect(find.text('New performer'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '  Proog ');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(repo.created, ['performer Proog']);
    expect((result! as Performer).name, 'Proog');
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('creates a studio, also from the keyboard', (tester) async {
    await open(tester, studio: true);
    await tester.enterText(find.byType(TextField), 'Orange');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(repo.created, ['studio Orange']);
    expect(result, isA<Studio>());
  });

  testWidgets('an empty name creates nothing; cancel returns nothing', (tester) async {
    await open(tester);
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(repo.created, isEmpty);
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result, isNull);
  });

  testWidgets('a server error shows in the dialog, which stays open', (tester) async {
    repo.fail = true;
    await open(tester);
    await tester.enterText(find.byType(TextField), 'Proog');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('Performer already exists'), findsOneWidget);
  });
}
