import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/secret_store.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/features/security/app_lock.dart';
import 'package:stash_app_mobile/features/security/app_lock_gate.dart';
import 'package:stash_app_mobile/features/security/pin_hash.dart';

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

  test('legacy PIN hashes depend on the salt and never equal the PIN', () {
    expect(legacyHashPin('1234', 'a'), legacyHashPin('1234', 'a'));
    expect(legacyHashPin('1234', 'a'), isNot(legacyHashPin('1234', 'b')));
    expect(legacyHashPin('1234', 'a'), isNot(contains('1234')));
  });

  test('PBKDF2-HMAC-SHA256 matches the RFC 7914 test vector', () {
    String hex(List<int> b) => b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
    expect(hex(pbkdf2Sha256('passwd'.codeUnits, 'salt'.codeUnits, 1)),
        '55ac046e56e3089fec1691c22544b605f94185216dde0465e68b9d57c20dacbc');
  });

  test('a stored PIN round-trips and only matches its PIN', () async {
    final stored = await StoredPin.create('2580');
    expect(stored.isLegacy, isFalse);
    final parsed = StoredPin.parse(stored.encode())!;
    expect(parsed.rounds, StoredPin.iterations);
    expect(await parsed.matches('2580'), isTrue);
    expect(await parsed.matches('2581'), isFalse);
    expect(StoredPin.parse('pbkdf2-sha256\$x\$s\$h'), isNull);
    expect(StoredPin.parse('garbage'), isNull);
    expect(StoredPin.parse('salt:${legacyHashPin('1', 'salt')}')!.isLegacy, isTrue);
  });

  test('enable stores only a salted hash; verify and disable', () async {
    final c = container();
    final settings = c.read(appLockSettingsProvider.notifier);
    await settings.enable('2580');
    expect(c.read(appLockSettingsProvider).enabled, isTrue);
    expect(prefs.getKeys().map(prefs.get), isNot(contains('2580')));
    expect(await settings.verify('2580'), isTrue);
    expect(await settings.verify('0000'), isFalse);

    await settings.disable();
    expect(c.read(appLockSettingsProvider).enabled, isFalse);
    expect(await settings.verify('2580'), isFalse);
  });

  test('the PIN hash is kept in the secret store, as one PBKDF2 value', () async {
    final c = container();
    await c.read(appLockSettingsProvider.notifier).enable('2580');
    expect(secrets.read('lock_pin'), matches(RegExp(r'^pbkdf2-sha256\$\d+\$[^$]+\$[^$]+$')));
    expect(prefs.getKeys().where((k) => k.startsWith('lock_pin_') && k != 'lock_pin_length'), isEmpty);
    expect(await container().read(appLockSettingsProvider.notifier).verify('2580'), isTrue, reason: 'after a restart');
  });

  test('a PIN of an older version moves out of SharedPreferences and is upgraded', () async {
    SharedPreferences.setMockInitialValues({
      'lock_enabled': true,
      'lock_pin_salt': 'salt',
      'lock_pin_hash': legacyHashPin('1234', 'salt'),
    });
    prefs = await SharedPreferences.getInstance();
    final c = container();
    expect(c.read(appLockSettingsProvider).enabled, isTrue);
    await pumpEventQueue();
    expect(prefs.getString('lock_pin_hash'), isNull);
    expect(secrets.read('lock_pin'), 'salt:${legacyHashPin('1234', 'salt')}', reason: 'moved as it was');
    expect(await c.read(appLockSettingsProvider.notifier).verify('1234'), isTrue);
    expect(secrets.read('lock_pin'), startsWith('pbkdf2-sha256\$'), reason: 'upgraded after the right PIN');
    expect(await container().read(appLockSettingsProvider.notifier).verify('1234'), isTrue);
  });

  test('a legacy SHA-256 PIN stays until the right PIN, then becomes PBKDF2', () async {
    secrets.values['lock_pin'] = 'salt:${legacyHashPin('1234', 'salt')}';
    await prefs.setBool('lock_enabled', true);
    final settings = container().read(appLockSettingsProvider.notifier);
    expect(await settings.verify('0000'), isFalse);
    expect(secrets.read('lock_pin'), startsWith('salt:'), reason: 'a wrong PIN changes nothing');
    expect(await settings.verify('1234'), isTrue);
    expect(StoredPin.parse(secrets.read('lock_pin'))!.isLegacy, isFalse);
    expect(await container().read(appLockSettingsProvider.notifier).verify('1234'), isTrue);
    expect(await container().read(appLockSettingsProvider.notifier).verify('0000'), isFalse);
  });

  test('a lock whose PIN is lost stays on and locked', () async {
    await prefs.setBool('lock_enabled', true);
    final c = container();
    final settings = c.read(appLockSettingsProvider);
    expect(settings.enabled, isTrue, reason: 'an unreadable secure storage must not open the app');
    expect(settings.pinLost, isTrue);
    expect(c.read(appLockedProvider), isTrue);
    expect(await c.read(appLockSettingsProvider.notifier).verify('1234'), isFalse);

    await c.read(appLockSettingsProvider.notifier).enable('4321');
    expect(c.read(appLockSettingsProvider).pinLost, isFalse);
    expect(await c.read(appLockSettingsProvider.notifier).verify('4321'), isTrue);
  });

  test('resetting the app removes everything and turns the lock off', () async {
    await prefs.setBool('lock_enabled', true);
    await prefs.setString('server_profiles', '[{"id":"1","name":"s","url":"http://s"}]');
    await prefs.setString('active_server', '1');
    secrets.values['api_key:1'] = 'k';
    final c = container();
    expect(c.read(serverProfilesProvider).profiles, hasLength(1));
    await c.read(appLockSettingsProvider.notifier).resetApp();
    expect(prefs.getKeys(), isEmpty);
    expect(secrets.values, isEmpty);
    expect(c.read(appLockSettingsProvider).enabled, isFalse);
    expect(c.read(appLockedProvider), isFalse);
    expect(c.read(serverProfilesProvider).profiles, isEmpty);
  });

  test('wrong PINs block the PIN for a growing time, across restarts', () async {
    var c = container();
    await c.read(appLockSettingsProvider.notifier).enable('1234');
    var now = DateTime(2026, 1, 1, 12);
    var throttle = c.read(pinThrottleProvider.notifier)..now = () => now;
    final settings = c.read(appLockSettingsProvider.notifier);

    for (var i = 0; i < PinThrottle.freeAttempts - 1; i++) {
      expect(await settings.verify('0000'), isFalse);
    }
    expect(throttle.remaining(), Duration.zero, reason: 'a few mistakes are free');
    expect(await settings.verify('0000'), isFalse);
    expect(throttle.remaining(), const Duration(seconds: 30));
    expect(await settings.verify('1234'), isFalse, reason: 'even the right PIN has to wait');

    // Restarting the app doesn't help.
    c = container();
    throttle = c.read(pinThrottleProvider.notifier)..now = () => now;
    expect(throttle.remaining(), const Duration(seconds: 30));

    now = now.add(const Duration(seconds: 31));
    expect(throttle.remaining(), Duration.zero);
    expect(await c.read(appLockSettingsProvider.notifier).verify('0000'), isFalse);
    expect(throttle.remaining(), const Duration(minutes: 1), reason: 'the next mistake waits longer');

    // Setting the clock back doesn't stretch the wait beyond the delay.
    now = now.subtract(const Duration(days: 1));
    expect(throttle.remaining(), const Duration(minutes: 1));

    now = now.add(const Duration(days: 2));
    expect(await c.read(appLockSettingsProvider.notifier).verify('1234'), isTrue);
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

  testWidgets('a lost PIN keeps the app locked; resetting it starts over', (tester) async {
    await prefs.setBool('lock_enabled', true);
    await prefs.setString('server_profiles', '[{"id":"1","name":"s","url":"http://s"}]');
    final c = await pumpGate(tester);
    expect(c.read(appLockedProvider), isTrue);
    expect(find.text('The PIN is no longer on this device'), findsOneWidget);
    expect(find.descendant(of: find.byType(LockScreen), matching: find.text('1')), findsNothing,
        reason: 'no PIN pad: there is no PIN to check');

    await tester.tap(find.text('Reset app'));
    await tester.pumpAndSettle();
    expect(find.text('Reset StashTube?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('The PIN is no longer on this device'), findsOneWidget);

    await tester.tap(find.text('Reset app'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Reset app'));
    await tester.pumpAndSettle();
    expect(c.read(appLockedProvider), isFalse);
    expect(find.byType(LockScreen), findsNothing);
    expect(prefs.getKeys(), isEmpty);
    expect(c.read(serverProfilesProvider).profiles, isEmpty);
  });

  testWidgets('a lost PIN with biometrics: unlocking asks for a new PIN first', (tester) async {
    await prefs.setBool('lock_enabled', true);
    await prefs.setBool('lock_biometrics', true);
    final c = await pumpGate(tester);
    expect(biometrics.calls, 1);
    expect(c.read(appLockedProvider), isTrue, reason: 'not open without a PIN for next time');
    expect(find.text('Choose a new PIN'), findsOneWidget);

    await enterPin(tester, '2468');
    await enterPin(tester, '2468');
    expect(c.read(appLockedProvider), isFalse);
    expect(c.read(appLockSettingsProvider).pinLost, isFalse);
    expect(await tester.runAsync(() => c.read(appLockSettingsProvider.notifier).verify('2468')), isTrue);
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

  /// A button that asks [confirmPin] and hands its answer to [onResult].
  Future<void> pumpConfirm(WidgetTester tester, ProviderContainer c, void Function(bool) onResult) =>
      tester.pumpWidget(UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) => TextButton(
                onPressed: () async => onResult(await confirmPin(context, ref)),
                child: const Text('confirm'),
              ),
            ),
          ),
        ),
      ));

  testWidgets('with biometrics on, Face ID or the fingerprint confirm instead of the PIN', (tester) async {
    await tester.runAsync(() async {
      final c = container();
      await c.read(appLockSettingsProvider.notifier).enable('1234');
      await c.read(appLockSettingsProvider.notifier).setBiometrics(true);
    });
    final c = container();
    c.read(appLockedProvider.notifier).unlock();
    bool? confirmed;
    await pumpConfirm(tester, c, (ok) => confirmed = ok);

    await tester.tap(find.text('confirm'));
    await tester.pumpAndSettle();
    expect(biometrics.calls, 0, reason: 'not asked unprompted: the PIN pad comes first');
    await tester.tap(find.byIcon(Icons.fingerprint));
    await tester.pumpAndSettle();
    expect(biometrics.calls, 1);
    expect(confirmed, isTrue, reason: 'a forgotten PIN can still be changed');

    // While wrong PINs block the pad, biometrics are asked right away.
    for (var i = 0; i < PinThrottle.freeAttempts; i++) {
      c.read(pinThrottleProvider.notifier).recordFailure();
    }
    confirmed = null;
    await tester.tap(find.text('confirm'));
    await tester.pumpAndSettle();
    expect(biometrics.calls, 2);
    expect(confirmed, isTrue);
    expect(c.read(pinThrottleProvider).failures, 0);
  });

  testWidgets('without biometrics, the PIN pad has no fingerprint button', (tester) async {
    await tester.runAsync(() => container().read(appLockSettingsProvider.notifier).enable('1234'));
    final c = container();
    await pumpConfirm(tester, c, (_) {});
    await tester.tap(find.text('confirm'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.fingerprint), findsNothing);
  });

  test('the app is always hidden in the switcher while the lock is on', () {
    expect(const AppLockSettings().hidesApp, isFalse);
    expect(const AppLockSettings(hideInSwitcher: true).hidesApp, isTrue);
    expect(const AppLockSettings(enabled: true).hidesApp, isTrue);
  });
}
