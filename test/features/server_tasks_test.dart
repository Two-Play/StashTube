import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/server_task.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/server_tasks/server_tasks_page.dart';
import 'package:stash_app_mobile/l10n/gen/app_localizations.dart';

import '../helpers.dart';

class FakeRepository implements StashRepository {
  final jobs = <ServerJob>[];
  final generated = <Set<GenerateOption>>[];
  final stopped = <String>[];
  var check = const PreviewCheck(scenes: 8, animated: 0, videos: 8, markers: 4, markerAnimated: 0);

  @override
  Future<List<ServerJob>> jobQueue() async => [...jobs];

  @override
  Future<PreviewCheck> checkPreviews({int sample = 8}) async => check;

  @override
  Future<String> generate(Set<GenerateOption> options) async {
    generated.add(options);
    jobs.add(const ServerJob(id: '7', state: JobState.running, description: 'Generating...', progress: 0.25));
    return '7';
  }

  @override
  Future<void> stopJob(String id) async {
    stopped.add(id);
    jobs.clear();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeRepository repo;

  Future<void> pumpPage(WidgetTester tester) async {
    // Tall enough for the whole list.
    tester.view
      ..physicalSize = const Size(800, 2000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [stashRepositoryProvider.overrideWithValue(repo), ...testServer],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ServerTasksPage(),
        ),
      ),
    );
    await tester.pump();
  }

  setUp(() => repo = FakeRepository());

  testWidgets('missing animated previews can be generated, the job shows and stops', (tester) async {
    await pumpPage(tester);
    expect(find.text('Found for 0 of 8 random samples'), findsOneWidget);
    expect(find.text('Found for 8 of 8 random samples'), findsOneWidget);
    expect(find.text('No tasks running'), findsOneWidget);

    await tester.tap(find.text('Generate animated previews'));
    await tester.pump();
    expect(repo.generated.single, GenerateOption.animatedPreviews);
    expect(find.text('Task started on the server'), findsOneWidget);
    expect(find.text('Generating...'), findsOneWidget);
    expect(find.text('Running · 25 %'), findsOneWidget);

    // The job finished: the check runs again.
    repo.check = const PreviewCheck(scenes: 8, animated: 8, videos: 8, markers: 4, markerAnimated: 4);
    await tester.tap(find.byTooltip('Stop task'));
    await tester.pump();
    expect(repo.stopped, ['7']);
    await tester.pump();
    expect(find.text('No tasks running'), findsOneWidget);
    expect(find.text('Generate animated previews'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the generate sheet starts the chosen options', (tester) async {
    repo.check = const PreviewCheck(scenes: 8, animated: 8, videos: 8);
    await pumpPage(tester);
    await tester.tap(find.text('Generate'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Covers'));
    await tester.pump();
    await tester.tap(find.text('Start'));
    await tester.pump();
    expect(repo.generated.single, GenerateOption.standard.difference({GenerateOption.covers}));
    // Unmount, so the queue's poll timer stops.
    await tester.pumpWidget(const SizedBox());
  });
}
