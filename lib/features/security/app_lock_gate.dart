import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '../pip/pip.dart';
import 'app_lock.dart';
import '../../l10n/l10n.dart';

/// Sits above every page and dialog (MaterialApp.builder): shows the lock
/// screen while locked (11.1) and covers the app while it is inactive or in
/// the app switcher when that is enabled (11.2).
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> {
  late final AppLifecycleListener _lifecycle;
  bool _inactive = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onInactive: () => setState(() => _inactive = true),
      onResume: () => setState(() => _inactive = false),
      onHide: () => ref.read(appLockedProvider.notifier).appHidden(),
      onShow: () => ref.read(appLockedProvider.notifier).appShown(),
    );
    SecureWindow.set(ref.read(appLockSettingsProvider).hideInSwitcher);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appLockSettingsProvider.select((s) => s.hideInSwitcher), (_, hide) => SecureWindow.set(hide));
    final locked = ref.watch(appLockedProvider);
    final hide = ref.watch(appLockSettingsProvider.select((s) => s.hideInSwitcher));

    return Stack(
      children: [
        // Keeps the app's state while covered, but no taps reach it.
        IgnorePointer(ignoring: locked, child: widget.child),
        if (locked) const Positioned.fill(child: LockScreen()),
        // Android's picture-in-picture window is inactive too, but shows the video.
        if (!locked && hide && _inactive && !ref.watch(pipProvider)) const Positioned.fill(child: PrivacyCover()),
      ],
    );
  }
}

/// Plain cover with the app's mark, shown in the app switcher.
class PrivacyCover extends StatelessWidget {
  const PrivacyCover({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.surface,
      child: Center(child: Icon(Icons.lock_outline, size: 56, color: colors.onSurfaceVariant)),
    );
  }
}

/// PIN pad with optional biometric unlock.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  Future<void> _biometric() async {
    final ok = await ref.read(biometricAuthProvider).authenticate(context.l10n.unlockReason);
    if (ok && mounted) ref.read(appLockedProvider.notifier).unlock();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appLockSettingsProvider);
    // Above the Navigator there is no Overlay, which the PIN pad needs.
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => Material(
            child: ScreenLock(
              // Only used for the number of digits: the PIN is checked
              // against its stored hash in onValidate.
              correctString: '0' * settings.pinLength,
              onValidate: (input) async => ref.read(appLockSettingsProvider.notifier).verify(input),
              onUnlocked: () => ref.read(appLockedProvider.notifier).unlock(),
              title: Text(context.l10n.enterPin),
              useBlur: false,
              onOpened: settings.biometrics ? _biometric : null,
              customizedButtonChild: settings.biometrics ? const Icon(Icons.fingerprint) : null,
              customizedButtonTap: settings.biometrics ? _biometric : null,
            ),
          ),
        ),
      ],
    );
  }
}

/// Asks for a new PIN twice; returns it, or null if cancelled.
Future<String?> showCreatePin(BuildContext context) async {
  String? pin;
  await screenLockCreate(
    context: context,
    title: Text(context.l10n.choosePin),
    confirmTitle: Text(context.l10n.repeatPin),
    canCancel: true,
    onConfirmed: (value) {
      pin = value;
      Navigator.pop(context);
    },
  );
  return pin;
}

/// Asks for the current PIN; returns whether it was entered correctly.
Future<bool> confirmPin(BuildContext context, WidgetRef ref) async {
  var ok = false;
  await screenLock(
    context: context,
    title: Text(context.l10n.enterYourPin),
    correctString: '0' * ref.read(appLockSettingsProvider).pinLength,
    onValidate: (input) async => ref.read(appLockSettingsProvider.notifier).verify(input),
    canCancel: true,
    onUnlocked: () {
      ok = true;
      Navigator.pop(context);
    },
  );
  return ok;
}
