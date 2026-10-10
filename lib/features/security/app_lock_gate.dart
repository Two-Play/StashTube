import '../../core/config/haptics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '../pip/pip.dart';
import 'app_lock.dart';
import '../../l10n/l10n.dart';

/// Sits above every page and dialog (MaterialApp.builder): shows the lock
/// screen while locked (11.1) and covers the app while it is inactive, when
/// the lock is on or the app switcher should not show it (11.2).
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
      onResume: () {
        setState(() => _inactive = false);
        // The native cover (iOS) goes once this frame, with the lock screen
        // if locked, is drawn.
        WidgetsBinding.instance.endOfFrame.then((_) => SecureWindow.uncover());
      },
      onHide: () => ref.read(appLockedProvider.notifier).appHidden(),
      onShow: () => ref.read(appLockedProvider.notifier).appShown(),
    );
    SecureWindow.set(ref.read(appLockSettingsProvider).hidesApp);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appLockSettingsProvider.select((s) => s.hidesApp), (_, hide) => SecureWindow.set(hide));
    final locked = ref.watch(appLockedProvider);
    final settings = ref.watch(appLockSettingsProvider);
    // Android's picture-in-picture window is inactive too, but shows the video.
    final cover = !locked &&
        _inactive &&
        settings.hidesApp &&
        !ref.watch(pipProvider);

    return Stack(
      children: [
        // Keeps the app's state while covered, but no taps reach it.
        IgnorePointer(ignoring: locked, child: widget.child),
        if (locked) const Positioned.fill(child: LockScreen()),
        if (cover) const Positioned.fill(child: PrivacyCover()),
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
///
/// Face ID / fingerprint is asked for once the app is in the foreground:
/// asked while iOS still has the app inactive (just back from the
/// background), the system cancels it. It is asked again after the app was
/// in the background, but not after its own prompt (which makes the app
/// inactive too), so cancelling it leaves the PIN pad.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  late final AppLifecycleListener _lifecycle;
  bool _askBiometrics = true;
  bool _asking = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onHide: () => _askBiometrics = true,
      onResume: _maybeAskBiometrics,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAskBiometrics());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _maybeAskBiometrics() {
    if (!mounted || !_askBiometrics || !ref.read(appLockSettingsProvider).biometrics) return;
    final state = WidgetsBinding.instance.lifecycleState;
    if (state != null && state != AppLifecycleState.resumed) return;
    _askBiometrics = false;
    _biometric();
  }

  Future<void> _biometric() async {
    if (_asking) return;
    _asking = true;
    try {
      final ok = await ref.read(biometricAuthProvider).authenticate(context.l10n.unlockReason);
      if (ok && mounted) ref.read(appLockedProvider.notifier).unlock();
    } finally {
      _asking = false;
    }
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
              onUnlocked: () {
                Haptics.medium();
                ref.read(appLockedProvider.notifier).unlock();
              },
              onError: (_) => Haptics.error(),
              title: Text(context.l10n.enterPin),
              useBlur: false,
              customizedButtonChild: settings.biometrics ? const Icon(Icons.fingerprint) : null,
              customizedButtonTap: settings.biometrics ? _biometric : null,
            ),
          ),
        ),
      ],
    );
  }
}

/// Asks for a new PIN twice; returns it, or null if cancelled. Covers the
/// whole app like the lock screen, also above the settings sheet.
Future<String?> showCreatePin(BuildContext context) {
  final l = context.l10n;
  return Navigator.of(context, rootNavigator: true).push<String>(_PinRoute(
    builder: (context) => ScreenLock.create(
      title: Text(l.choosePin),
      confirmTitle: Text(l.repeatPin),
      useBlur: false,
      onConfirmed: (pin) => Navigator.of(context).pop(pin),
      onCancelled: () => Navigator.of(context).pop(),
    ),
  ));
}

/// Asks for the current PIN before a setting that needs it (turning the
/// lock off, a new PIN); returns whether it was entered correctly. Covers
/// the whole app like the lock screen.
Future<bool> confirmPin(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final ok = await Navigator.of(context, rootNavigator: true).push<bool>(_PinRoute(
    builder: (context) => ScreenLock(
      title: Text(l.enterYourPin),
      correctString: '0' * ref.read(appLockSettingsProvider).pinLength,
      onValidate: (input) async => ref.read(appLockSettingsProvider.notifier).verify(input),
      useBlur: false,
      onError: (_) => Haptics.error(),
      onUnlocked: () => Navigator.of(context).pop(true),
      onCancelled: () => Navigator.of(context).pop(false),
    ),
  ));
  return ok ?? false;
}

/// Full screen and opaque, so nothing of the app shows behind the PIN pad.
class _PinRoute<T> extends MaterialPageRoute<T> {
  _PinRoute({required WidgetBuilder builder})
      : super(fullscreenDialog: true, builder: (context) => Material(child: builder(context)));
}
