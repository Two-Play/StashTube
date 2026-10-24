import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/server_task.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/server_tasks/server_tasks_page.dart';

import '../helpers.dart';

class _Repo implements StashRepository {
  var jobs = <ServerJob>[];
  var polls = 0;

  @override
  Future<List<ServerJob>> jobQueue() async {
    polls++;
    return [...jobs];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ServerJob _job(JobState state) => ServerJob(id: '7', state: state, description: 'Scanning...');

void main() {
  late _Repo repo;
  late ProviderContainer container;

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [...testServer, stashRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(
        home: JobFinishedListener(child: Scaffold(body: Text('Home'))),
      ),
    ));
    container = ProviderScope.containerOf(tester.element(find.text('Home')));
  }

  Future<void> poll(WidgetTester tester) async {
    await tester.pump(JobQueueNotifier.interval);
    await tester.pump();
  }

  setUp(() => repo = _Repo());

  testWidgets('reports a job started from the app when it finishes', (tester) async {
    await pumpApp(tester);
    await poll(tester);
    expect(repo.polls, 0, reason: 'no polling without a job of ours');

    repo.jobs = [_job(JobState.running)];
    container.read(startedJobsProvider.notifier).add('7', 'Scan library');
    await tester.pump();
    await poll(tester);
    expect(find.text('Finished: Scan library'), findsNothing);

    repo.jobs = [_job(JobState.finished)];
    await poll(tester);
    expect(find.text('Finished: Scan library'), findsOneWidget);
    expect(container.read(startedJobsProvider), isEmpty);

    final polls = repo.polls;
    await poll(tester);
    expect(repo.polls, polls, reason: 'stops polling');
  });

  testWidgets('a job that left the queue counts as finished; a failed one says so', (tester) async {
    await pumpApp(tester);
    repo.jobs = [];
    container.read(startedJobsProvider.notifier).add('7', 'Clean');
    await tester.pump();
    await poll(tester);
    expect(find.text('Finished: Clean'), findsOneWidget);

    ScaffoldMessenger.of(tester.element(find.text('Home'))).removeCurrentSnackBar();
    repo.jobs = [_job(JobState.failed)];
    container.read(startedJobsProvider.notifier).add('7', 'Generate');
    await tester.pump();
    await poll(tester);
    expect(find.text('Failed: Generate'), findsOneWidget);
  });

  testWidgets('a stopped job is not reported', (tester) async {
    await pumpApp(tester);
    repo.jobs = [_job(JobState.cancelled)];
    container.read(startedJobsProvider.notifier).add('7', 'Scan library');
    await tester.pump();
    await poll(tester);
    expect(find.byType(SnackBar), findsNothing);
    expect(container.read(startedJobsProvider), isEmpty);
  });

  testWidgets('a job ending in the background is reported on return', (tester) async {
    await pumpApp(tester);
    repo.jobs = [_job(JobState.running)];
    container.read(startedJobsProvider.notifier).add('7', 'Scan library');
    await tester.pump();
    await poll(tester);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    addTearDown(() => tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed));
    repo.jobs = [_job(JobState.finished)];
    await poll(tester);
    expect(find.byType(SnackBar), findsNothing);
    expect(container.read(startedJobsProvider), isNotEmpty);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await poll(tester);
    expect(find.text('Finished: Scan library'), findsOneWidget);
  });
}
