import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/server_task.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/notifications/notifications.dart';
import 'package:stash_app_mobile/features/server_tasks/server_tasks_page.dart';

import 'server_tasks_test.dart' show FakeRepository;

class FakeNotificationService implements NotificationService {
  FakeNotificationService({this.grant = true, this.launch});

  bool grant;
  String? launch;
  var permissionRequests = 0;
  final shown = <AppNotification>[];
  final tapController = StreamController<String>.broadcast();

  @override
  bool get isSupported => true;

  @override
  Stream<String> get taps => tapController.stream;

  @override
  Future<void> init() async {}

  @override
  Future<String?> launchPayload() async {
    final payload = launch;
    launch = null;
    return payload;
  }

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return grant;
  }

  @override
  Future<void> show(AppNotification notification) async => shown.add(notification);
}

ServerJob _job(JobState state) => ServerJob(id: '7', state: state, description: 'Scanning...');

void main() {
  late FakeNotificationService service;
  late FakeRepository repo;
  late ProviderContainer container;

  Future<void> pump(WidgetTester tester, Widget home, {Map<String, Object> prefs = const {}}) async {
    SharedPreferences.setMockInitialValues({'url': 'http://my-stash', ...prefs});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        notificationServiceProvider.overrideWithValue(service),
        stashRepositoryProvider.overrideWithValue(repo),
        serverVersionProvider.overrideWith((ref) async => 'v0.28.0'),
      ],
      child: MaterialApp(home: home),
    ));
    container = ProviderScope.containerOf(tester.element(find.byWidget(home)));
    await tester.pump();
  }

  setUp(() {
    service = FakeNotificationService();
    repo = FakeRepository();
  });

  group('settings', () {
    testWidgets('are off by default, discreet by default', (tester) async {
      await pump(tester, const Scaffold(body: NotificationSettingsSection()));
      expect(container.read(notificationSettingsProvider), const NotificationSettings());
      final toggle = tester.widget<SwitchListTile>(find.widgetWithText(SwitchListTile, 'System notifications'));
      expect(toggle.value, isFalse);
      final discreet = tester.widget<SwitchListTile>(find.widgetWithText(SwitchListTile, 'Discreet notifications'));
      expect(discreet.value, isTrue);
      expect(discreet.onChanged, isNull, reason: 'only while notifications are on');
      expect(service.permissionRequests, 0, reason: 'asks only when switched on');
    });

    testWidgets('switching on asks for the permission', (tester) async {
      await pump(tester, const Scaffold(body: NotificationSettingsSection()));
      await tester.tap(find.text('System notifications'));
      await tester.pumpAndSettle();
      expect(service.permissionRequests, 1);
      expect(container.read(notificationSettingsProvider).enabled, isTrue);
      expect(container.read(sharedPreferencesProvider).getBool('notifications_enabled'), isTrue);
    });

    testWidgets('a denied permission keeps them off and explains why', (tester) async {
      service.grant = false;
      await pump(tester, const Scaffold(body: NotificationSettingsSection()));
      await tester.tap(find.text('System notifications'));
      await tester.pumpAndSettle();
      expect(service.permissionRequests, 1);
      expect(container.read(notificationSettingsProvider).enabled, isFalse);
      expect(find.text('Notifications not allowed'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      final toggle = tester.widget<SwitchListTile>(find.widgetWithText(SwitchListTile, 'System notifications'));
      expect(toggle.value, isFalse);
    });
  });

  group('server tasks', () {
    Future<void> pumpListener(WidgetTester tester, {bool discreet = true}) => pump(
      tester,
      const JobFinishedListener(child: Scaffold(body: Text('Home'))),
      prefs: {'notifications_enabled': true, 'notifications_discreet': discreet},
    );

    /// The settings sheet, then the tasks page on top (pumpAndSettle would
    /// wait for the job queue's polling).
    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }
    }

    Future<void> poll(WidgetTester tester) async {
      await tester.pump(JobQueueNotifier.interval);
      await tester.pump();
    }

    Future<void> finishInBackground(WidgetTester tester, {JobState state = JobState.finished}) async {
      repo.jobs.add(_job(JobState.running));
      container.read(startedJobsProvider.notifier).add('7', 'Scan library');
      await tester.pump();
      await poll(tester);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      addTearDown(() => tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed));
      repo.jobs
        ..clear()
        ..add(_job(state));
      await poll(tester);
    }

    testWidgets('a job ending in the background posts a discreet notification', (tester) async {
      await pumpListener(tester);
      await finishInBackground(tester);

      expect(service.shown, hasLength(1));
      final notification = service.shown.single;
      expect(notification.title, 'StashTube');
      expect(notification.body, 'A task has finished');
      expect(notification.discreet, isTrue);
      expect(notification.payload, NotificationPayload.serverTasks);
      expect(container.read(startedJobsProvider), isEmpty);

      // Not reported a second time in the app.
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await poll(tester);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('without discretion it names the task and the server', (tester) async {
      await pumpListener(tester, discreet: false);
      await finishInBackground(tester, state: JobState.failed);

      final notification = service.shown.single;
      expect(notification.title, 'Failed: Scan library');
      expect(notification.body, container.read(serverProfilesProvider).active?.name);
      expect(notification.body, isNotNull);
      expect(notification.discreet, isFalse);
    });

    testWidgets('while switched off, nothing is posted and the app reports it on return', (tester) async {
      await pump(tester, const JobFinishedListener(child: Scaffold(body: Text('Home'))));
      await finishInBackground(tester);
      expect(service.shown, isEmpty);
      expect(container.read(startedJobsProvider), isNotEmpty);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await poll(tester);
      expect(find.text('Finished: Scan library'), findsOneWidget);
    });

    testWidgets('in the app it shows a snack bar, no notification', (tester) async {
      await pumpListener(tester);
      repo.jobs.add(_job(JobState.finished));
      container.read(startedJobsProvider.notifier).add('7', 'Scan library');
      await tester.pump();
      await poll(tester);
      expect(find.text('Finished: Scan library'), findsOneWidget);
      expect(service.shown, isEmpty);
    });

    testWidgets('tapping the notification opens the server tasks', (tester) async {
      await pumpListener(tester);
      expect(find.byType(ServerTasksPage), findsNothing);
      service.tapController.add(NotificationPayload.serverTasks);
      await settle(tester);
      expect(find.byType(ServerTasksPage), findsOneWidget);
    });

    testWidgets('a notification that launched the app opens the server tasks', (tester) async {
      service.launch = NotificationPayload.serverTasks;
      await pumpListener(tester);
      await settle(tester);
      expect(find.byType(ServerTasksPage), findsOneWidget);
    });
  });
}
