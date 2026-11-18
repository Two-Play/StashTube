import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '../../core/config/haptics.dart';
import '../../core/utils/format.dart';
import '../pip/pip.dart';
import 'app_lock.dart';
import '../../l10n/l10n.dart';

/// Keeps Android's back button (and back gesture) away from the pages
/// behind the lock screen: while locked, back leaves the app instead.
///
/// Registered in `main()` before `runApp`, so it is asked before the app's
/// navigators; [AppLockGate] tells it whether the app is locked.
class LockBackGuard with WidgetsBindingObserver {
  bool locked = false;

  @override
  Future<bool> didPopRoute() async {
    if (!locked) return false;
    unawaited(SystemNavigator.pop());
    return true;
  }

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) => locked;

  @override
  void handleCommitBackGesture() => SystemNavigator.pop();
}

final lockBackGuard = LockBackGuard();

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
    lockBackGuard.locked = ref.read(appLockedProvider);
  }

  @override
  void dispose() {
    lockBackGuard.locked = false;
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appLockSettingsProvider.select((s) => s.hidesApp), (_, hide) => SecureWindow.set(hide));
    ref.listen(appLockedProvider, (_, locked) => lockBackGuard.locked = locked);
    final locked = ref.watch(appLockedProvider);
    final settings = ref.watch(appLockSettingsProvider);
    // Android's picture-in-picture window is inactive too, but shows the video.
    final cover = !locked &&
        _inactive &&
        settings.hidesApp &&
        !ref.watch(pipProvider);

    return Stack(
      children: [
        // Keeps the app's state while covered, but nothing reaches it: no
        // taps, no keyboard focus, and screen readers don't read it out.
        ExcludeFocus(
          excluding: locked,
          child: ExcludeSemantics(
            excluding: locked,
            child: IgnorePointer(ignoring: locked, child: widget.child),
          ),
        ),
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

/// PIN pad with optional biometric unlock; after too many wrong PINs it
/// shows how long to wait instead.
class LockScreen extends StatelessWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Above the Navigator there is no Overlay, which the PIN pad needs. The
    // entry is only built once, so its content watches the providers itself.
    return Overlay(
      initialEntries: [OverlayEntry(builder: (_) => const Material(child: _LockScreenBody()))],
    );
  }
}

/// Face ID / fingerprint is asked for once the app is in the foreground:
/// asked while iOS still has the app inactive (just back from the
/// background), the system cancels it. It is asked again after the app was
/// in the background, but not after its own prompt (which makes the app
/// inactive too), so cancelling it leaves the PIN pad.
class _LockScreenBody extends ConsumerStatefulWidget {
  const _LockScreenBody();

  @override
  ConsumerState<_LockScreenBody> createState() => _LockScreenBodyState();
}

class _LockScreenBodyState extends ConsumerState<_LockScreenBody> {
  late final AppLifecycleListener _lifecycle;
  bool _askBiometrics = true;
  bool _asking = false;

  /// After biometrics while the PIN is lost: a new PIN is being chosen.
  bool _choosingPin = false;

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
      if (!ok || !mounted) return;
      ref.read(pinThrottleProvider.notifier).reset();
      // Without a PIN the lock would be useless after unlocking: a new one first.
      if (ref.read(appLockSettingsProvider).pinLost) {
        setState(() => _choosingPin = true);
        return;
      }
      ref.read(appLockedProvider.notifier).unlock();
    } finally {
      _asking = false;
    }
  }

  Future<void> _setNewPin(String pin) async {
    await ref.read(appLockSettingsProvider.notifier).enable(pin);
    if (!mounted) return;
    Haptics.medium();
    _choosingPin = false;
    ref.read(appLockedProvider.notifier).unlock();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appLockSettingsProvider);
    if (settings.pinLost) {
      if (_choosingPin) {
        return ScreenLock.create(
          title: Text(context.l10n.chooseNewPin),
          confirmTitle: Text(context.l10n.repeatPin),
          useBlur: false,
          onConfirmed: _setNewPin,
          onCancelled: () => setState(() => _choosingPin = false),
        );
      }
      return PinLostView(
        onBiometric: settings.biometrics ? _biometric : null,
        onReset: () => ref.read(appLockSettingsProvider.notifier).resetApp(),
      );
    }
    ref.watch(pinThrottleProvider);
    final throttle = ref.read(pinThrottleProvider.notifier);

    if (throttle.remaining() > Duration.zero) {
      return PinBlockedView(
        remaining: throttle.remaining,
        onExpired: () => setState(() {}),
        onBiometric: settings.biometrics ? _biometric : null,
      );
    }
    return ScreenLock(
      // Only used for the number of digits: the PIN is checked against its
      // stored hash in onValidate.
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
    );
  }
}

/// Shown instead of the PIN pad after too many wrong PINs, with the time
/// left until the next try.
class PinBlockedView extends StatefulWidget {
  const PinBlockedView({super.key, required this.remaining, required this.onExpired, this.onBiometric});

  final Duration Function() remaining;

  /// Called once the wait is over.
  final VoidCallback onExpired;
  final VoidCallback? onBiometric;

  @override
  State<PinBlockedView> createState() => _PinBlockedViewState();
}

class _PinBlockedViewState extends State<PinBlockedView> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (widget.remaining() <= Duration.zero) {
        widget.onExpired();
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_clock_outlined, size: 56, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(l.pinTooManyAttempts, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              l.pinTryAgainIn(formatDuration(widget.remaining().inMilliseconds / 1000)),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            if (widget.onBiometric != null) ...[
              const SizedBox(height: 24),
              IconButton.filledTonal(
                iconSize: 32,
                tooltip: l.unlockBiometric,
                icon: const Icon(Icons.fingerprint),
                onPressed: widget.onBiometric,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shown instead of the PIN pad when the lock is on but its PIN can't be
/// read ([AppLockSettings.pinLost]): biometrics lead to a new PIN; without
/// them, the only way in is resetting the app, asked once more inline (the
/// lock screen sits above the navigator, so no dialog).
class PinLostView extends StatefulWidget {
  const PinLostView({super.key, required this.onReset, this.onBiometric});

  final VoidCallback? onBiometric;
  final Future<void> Function() onReset;

  @override
  State<PinLostView> createState() => _PinLostViewState();
}

class _PinLostViewState extends State<PinLostView> {
  bool _confirming = false;
  bool _resetting = false;

  Future<void> _reset() async {
    setState(() => _resetting = true);
    try {
      await widget.onReset();
    } finally {
      if (mounted) setState(() => _resetting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final muted = theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final biometric = widget.onBiometric;
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _confirming
                ? [
                    Icon(Icons.restart_alt, size: 56, color: theme.colorScheme.error),
                    const SizedBox(height: 16),
                    Text(l.resetAppTitle, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(l.resetAppBody, textAlign: TextAlign.center, style: muted),
                    const SizedBox(height: 24),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        OutlinedButton(
                          onPressed: _resetting ? null : () => setState(() => _confirming = false),
                          child: Text(l.cancel),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: theme.colorScheme.onError,
                          ),
                          onPressed: _resetting ? null : _reset,
                          child: Text(l.resetApp),
                        ),
                      ],
                    ),
                  ]
                : [
                    Icon(Icons.lock_reset, size: 56, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text(l.pinLostTitle, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(l.pinLostBody, textAlign: TextAlign.center, style: muted),
                    if (biometric != null) ...[
                      const SizedBox(height: 8),
                      Text(l.pinLostBiometricHint, textAlign: TextAlign.center, style: muted),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        icon: const Icon(Icons.fingerprint),
                        label: Text(l.unlockBiometric),
                        onPressed: biometric,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(l.pinLostResetHint, textAlign: TextAlign.center, style: muted),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => setState(() => _confirming = true),
                      child: Text(l.resetApp),
                    ),
                  ],
          ),
        ),
      ),
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
///
/// Wrong entries count like on the lock screen; while the PIN is blocked,
/// this only says how long to wait.
Future<bool> confirmPin(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final throttle = ref.read(pinThrottleProvider.notifier);
  final settings = ref.read(appLockSettingsProvider.notifier);
  final messenger = ScaffoldMessenger.of(context);

  bool showBlocked() {
    final remaining = throttle.remaining();
    if (remaining <= Duration.zero) return false;
    messenger.showSnackBar(SnackBar(
      content: Text('${l.pinTooManyAttempts} ${l.pinTryAgainIn(formatDuration(remaining.inMilliseconds / 1000))}'),
    ));
    return true;
  }

  if (showBlocked()) return false;
  final ok = await Navigator.of(context, rootNavigator: true).push<bool>(_PinRoute(
    builder: (context) => ScreenLock(
      title: Text(l.enterYourPin),
      correctString: '0' * ref.read(appLockSettingsProvider).pinLength,
      onValidate: (input) async => settings.verify(input),
      useBlur: false,
      onError: (_) {
        Haptics.error();
        if (showBlocked()) Navigator.of(context).pop(false);
      },
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
