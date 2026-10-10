import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/secret_store.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/features/security/app_lock.dart';
import 'package:stash_app_mobile/features/security/app_lock_gate.dart';

class FakeBiometrics implements BiometricAuth {
  FakeBiometrics({this.succeed = true});

  final bool succeed;
  int calls = 0;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<bool> authenticate(String reason) async {
    calls++;
    return succeed;
  }
}

void main() {
  late SharedPreferences prefs;
  late MemorySecretStore secrets;
  late FakeBiometrics biometrics;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    secrets = MemorySecretStore();
    biometrics = FakeBiometrics();
  });

  /// A container on the same device storage, as after restarting the app.
  ProviderContainer container() {
    final c = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      secretStoreProvider.overrideWithValue(secrets),
      biometricAuthProvider.overrideWithValue(biometrics),
    ]);
    addTearDown(c.dispose);
    return c;
  }

  test('PIN hashes depend on the salt and never equal the PIN', () {
    expect(hashPin('1234', 'a'), hashPin('1234', 'a'));
    expect(hashPin('1234', 'a'), isNot(hashPin('1234', 'b')));
    expect(hashPin('1234', 'a'), isNot(contains('1234')));
  });

  test('enable stores only a salted hash; verify and disable', () async {
    final c = container();
    final settings = c.read(appLockSettingsProvider.notifier);
    await settings.enable('2580');
    expect(c.read(appLockSettingsProvider).enabled, isTrue);
    expect(prefs.getKeys().map(prefs.get), isNot(contains('2580')));
    expect(settings.verify('2580'), isTrue);
    expect(settings.verify('0000'), isFalse);

    await settings.disable();
    expect(c.read(appLockSettingsProvider).enabled, isFalse);
    expect(settings.verify('2580'), isFalse);
  });

  test('the PIN hash is kept in the secret store, as one value', () async {
    final c = container();
    await c.read(appLockSettingsProvider.notifier).enable('2580');
    expect(secrets.read('lock_pin'), matches(RegExp(r'^[^:]+:[0-9a-f]{64}$')));
    expect(prefs.getKeys().where((k) => k.startsWith('lock_pin_') && k != 'lock_pin_length'), isEmpty);
    expect(container().read(appLockSettingsProvider.notifier).verify('2580'), isTrue, reason: 'after a restart');
  });

  test('a PIN of an older version moves out of SharedPreferences', () async {
    SharedPreferences.setMockInitialValues({
      'lock_enabled': true,
      'lock_pin_salt': 'salt',
      'lock_pin_hash': hashPin('1234', 'salt'),
    });
    prefs = await SharedPreferences.getInstance();
    final c = container();
    expect(c.read(appLockSettingsProvider).enabled, isTrue);
    expect(c.read(appLockSettingsProvider.notifier).verify('1234'), isTrue);
    await pumpEventQueue();
    expect(prefs.getString('lock_pin_hash'), isNull);
    expect(secrets.read('lock_pin'), 'salt:${hashPin('1234', 'salt')}');
    expect(container().read(appLockSettingsProvider.notifier).verify('1234'), isTrue);
  });

  test('wrong PINs block the PIN for a growing time, across restarts', () async {
    var c = container();
    await c.read(appLockSettingsProvider.notifier).enable('1234');
    var now = DateTime(2026, 1, 1, 12);
    var throttle = c.read(pinThrottleProvider.notifier)..now = () => now;
    final settings = c.read(appLockSettingsProvider.notifier);

    for (var i = 0; i < PinThrottle.freeAttempts - 1; i++) {
      expect(settings.verify('0000'), isFalse);
    }
    expect(throttle.remaining(), Duration.zero, reason: 'a few mistakes are free');
    expect(settings.verify('0000'), isFalse);
    expect(throttle.remaining(), const Duration(seconds: 30));
    expect(settings.verify('1234'), isFalse, reason: 'even the right PIN has to wait');

    // Restarting the app doesn't help.
    c = container();
    throttle = c.read(pinThrottleProvider.notifier)..now = () => now;
    expect(throttle.remaining(), const Duration(seconds: 30));

    now = now.add(const Duration(seconds: 31));
    expect(throttle.remaining(), Duration.zero);
    expect(c.read(appLockSettingsProvider.notifier).verify('0000'), isFalse);
    expect(throttle.remaining(), const Duration(minutes: 1), reason: 'the next mistake waits longer');

    // Setting the clock back doesn't stretch the wait beyond the delay.
    now = now.subtract(const Duration(days: 1));
    expect(throttle.remaining(), const Duration(minutes: 1));

    now = now.add(const Duration(days: 2));
    expect(c.read(appLockSettingsProvider.notifier).verify('1234'), isTrue);
    expect(c.read(pinThrottleProvider).failures, 0, reason: 'a successful unlock starts over');
    expect(prefs.getInt('lock_failed_attempts'), isNull);
  });

  test('locks when the clock was set back while in the background', () async {
    await container().read(appLockSettingsProvider.notifier).enable('1234');
    final c = container();
    await c.read(appLockSettingsProvider.notifier).setLockAfter(const Duration(minutes: 5));
    final lock = c.read(appLockedProvider.notifier);
    var now = DateTime(2026, 1, 1, 12);
    lock.now = () => now;
    lock.unlock();

    lock.appHidden();
    now = now.subtract(const Duration(hours: 1));
    lock.appShown();
    expect(c.read(appLockedProvider), isTrue);
  });

  test('locks at start and after the background delay', () async {
    await container().read(appLockSettingsProvider.notifier).enable('1234');
    final c = container();
    expect(c.read(appLockedProvider), isTrue, reason: 'locked when the app starts');

    final lock = c.read(appLockedProvider.notifier);
    var now = DateTime(2026, 1, 1, 12);
    lock.now = () => now;
    lock.unlock();
    await c.read(appLockSettingsProvider.notifier).setLockAfter(const Duration(minutes: 1));

    lock.appHidden();
    now = now.add(const Duration(seconds: 30));
    lock.appShown();
    expect(c.read(appLockedProvider), isFalse, reason: 'back within the grace period');

    lock.appHidden();
    now = now.add(const Duration(minutes: 2));
    lock.appShown();
    expect(c.read(appLockedProvider), isTrue);
  });

  test('never locks when the lock is off', () {
    final c = container();
    expect(c.read(appLockedProvider), isFalse);
    c.read(appLockedProvider.notifier)
      ..appHidden()
      ..appShown();
    expect(c.read(appLockedProvider), isFalse);
  });

  Future<ProviderContainer> pumpGate(WidgetTester tester) async {
    final c = container();
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        builder: (context, child) => AppLockGate(child: child!),
        home: const Scaffold(body: TextField(autofocus: true, decoration: InputDecoration(labelText: 'secret content'))),
      ),
    ));
    await tester.pumpAndSettle();
    return c;
  }

  Future<void> enterPin(WidgetTester tester, String pin) async {
    for (final digit in pin.split('')) {
      await tester.tap(find.descendant(of: find.byType(LockScreen), matching: find.text(digit)).first);
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  testWidgets('lock screen: wrong PIN stays locked, right PIN unlocks', (tester) async {
    await tester.runAsync(() => container().read(appLockSettingsProvider.notifier).enable('1234'));
    final c = await pumpGate(tester);
    expect(find.byType(LockScreen), findsOneWidget);

    await enterPin(tester, '9999');
    expect(c.read(appLockedProvider), isTrue);

    await enterPin(tester, '1234');
    expect(c.read(appLockedProvider), isFalse);
    expect(find.byType(LockScreen), findsNothing);
    expect(find.text('secret content'), findsOneWidget);
  });

  testWidgets('while locked, the app behind takes no focus, semantics or back', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.runAsync(() => container().read(appLockSettingsProvider.notifier).enable('1234'));
    final c = await pumpGate(tester);
    expect(find.semantics.byLabel('secret content'), findsNothing, reason: 'screen readers must not read it');
    expect(tester.testTextInput.isVisible, isFalse, reason: 'no keyboard focus behind the lock');
    expect(lockBackGuard.locked, isTrue);
    expect(await lockBackGuard.didPopRoute(), isTrue, reason: 'back leaves the app instead of popping pages');

    await enterPin(tester, '1234');
    expect(c.read(appLockedProvider), isFalse);
    expect(find.semantics.byLabel('secret content'), findsOneWidget);
    expect(lockBackGuard.locked, isFalse);
    expect(await lockBackGuard.didPopRoute(), isFalse);
    semantics.dispose();
  });

  testWidgets('too many wrong PINs show how long to wait instead of the PIN pad', (tester) async {
    await tester.runAsync(() => container().read(appLockSettingsProvider.notifier).enable('1234'));
    final c = await pumpGate(tester);
    var now = DateTime(2026, 1, 1, 12);
    c.read(pinThrottleProvider.notifier).now = () => now;

    for (var i = 0; i < PinThrottle.freeAttempts; i++) {
      await enterPin(tester, '9999');
    }
    expect(find.text('Too many wrong PINs.'), findsOneWidget);
    expect(find.text('Try again in 0:30.'), findsOneWidget);
    expect(find.descendant(of: find.byType(LockScreen), matching: find.text('1')), findsNothing,
        reason: 'no PIN pad to keep guessing on');

    now = now.add(const Duration(seconds: 31));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    await enterPin(tester, '1234');
    expect(c.read(appLockedProvider), isFalse);
  });

  testWidgets('biometric unlock starts automatically when enabled', (tester) async {
    await tester.runAsync(() async {
      final c = container();
      await c.read(appLockSettingsProvider.notifier).enable('1234');
      await c.read(appLockSettingsProvider.notifier).setBiometrics(true);
    });
    final c = await pumpGate(tester);
    expect(biometrics.calls, 1);
    expect(c.read(appLockedProvider), isFalse);
  });

  testWidgets('app switcher cover appears while inactive when enabled', (tester) async {
    await tester.runAsync(() => container().read(appLockSettingsProvider.notifier).setHideInSwitcher(true));
    await pumpGate(tester);
    expect(find.byType(PrivacyCover), findsNothing);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.byType(PrivacyCover), findsOneWidget);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(find.byType(PrivacyCover), findsNothing);
  });

  test('without a delay it locks as the app is hidden', () async {
    await container().read(appLockSettingsProvider.notifier).enable('1234');
    final c = container();
    final lock = c.read(appLockedProvider.notifier)..unlock();
    lock.appHidden();
    expect(c.read(appLockedProvider), isTrue, reason: 'locked before the app switcher or the way back shows it');
  });

  testWidgets('with the lock on, the cover shows while inactive', (tester) async {
    await tester.runAsync(() => container().read(appLockSettingsProvider.notifier).enable('1234'));
    final c = await pumpGate(tester);
    c.read(appLockedProvider.notifier).unlock();
    await tester.pump();

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.byType(PrivacyCover), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(find.byType(PrivacyCover), findsNothing);
  });

  testWidgets('biometrics wait for the foreground and are not asked twice in a row', (tester) async {
    biometrics = FakeBiometrics(succeed: false);
    await tester.runAsync(() async {
      final c = container();
      await c.read(appLockSettingsProvider.notifier).enable('1234');
      await c.read(appLockSettingsProvider.notifier).setBiometrics(true);
    });
    final c = await pumpGate(tester);
    expect(biometrics.calls, 1, reason: 'asked at start');

    // Its own prompt makes the app inactive; cancelling it keeps the PIN pad.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(biometrics.calls, 1);

    // Back from the background: asked again, but only once in the foreground.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(biometrics.calls, 1, reason: 'not while still inactive');
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(biometrics.calls, 2);
    expect(c.read(appLockedProvider), isTrue);
  });

  testWidgets('PIN prompts cover the whole app, also above a nested navigator', (tester) async {
    await tester.runAsync(() => container().read(appLockSettingsProvider.notifier).enable('1234'));
    final c = container();
    c.read(appLockedProvider.notifier).unlock();
    bool? confirmed;
    String? created;
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const Text('secret content'),
              Expanded(
                // Like the settings sheet's own navigator.
                child: Navigator(
                  onGenerateRoute: (_) => MaterialPageRoute<void>(
                    builder: (context) => Consumer(
                      builder: (context, ref, _) => Column(
                        children: [
                          TextButton(
                            onPressed: () async => confirmed = await confirmPin(context, ref),
                            child: const Text('confirm'),
                          ),
                          TextButton(
                            onPressed: () async => created = await showCreatePin(context),
                            child: const Text('create'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));

    Future<void> digits(String pin) async {
      for (final digit in pin.split('')) {
        await tester.tap(find.descendant(of: find.byType(ScreenLock), matching: find.text(digit)).first);
        await tester.pump();
      }
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('confirm'));
    await tester.pumpAndSettle();
    expect(find.text('secret content'), findsNothing, reason: 'the app is covered, not only the inner navigator');
    await digits('1234');
    expect(confirmed, isTrue);
    expect(find.text('secret content'), findsOneWidget);

    await tester.tap(find.text('create'));
    await tester.pumpAndSettle();
    await digits('2580');
    await digits('2580');
    expect(created, '2580');
  });

  test('the app is always hidden in the switcher while the lock is on', () {
    expect(const AppLockSettings().hidesApp, isFalse);
    expect(const AppLockSettings(hideInSwitcher: true).hidesApp, isTrue);
    expect(const AppLockSettings(enabled: true).hidesApp, isTrue);
  });
}
