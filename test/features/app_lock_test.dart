import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late FakeBiometrics biometrics;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    biometrics = FakeBiometrics();
  });

  ProviderContainer container() {
    final c = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
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
        home: const Scaffold(body: Text('secret content')),
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
}
