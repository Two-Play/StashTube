import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/haptics.dart';
import '../../core/config/server_config.dart';
import '../../core/config/theme.dart';
import '../../l10n/l10n.dart';

/// Whether the player's gesture tips (CTRL-2) were dismissed; once per
/// install, for all servers. "Show gesture tips again" in the playback
/// settings resets it.
class GestureTipsSeenNotifier extends Notifier<bool> {
  static const _key = 'gesture_tips_seen';

  @override
  bool build() {
    final SharedPreferences prefs;
    try {
      prefs = ref.watch(sharedPreferencesProvider);
    } catch (_) {
      // Tests of single widgets don't provide preferences: no tips there.
      return true;
    }
    return prefs.getBool(_key) ?? false;
  }

  Future<void> dismiss() => _set(true);

  Future<void> reset() => _set(false);

  Future<void> _set(bool seen) async {
    state = seen;
    await ref.read(sharedPreferencesProvider).setBool(_key, seen);
  }
}

final gestureTipsSeenProvider = NotifierProvider<GestureTipsSeenNotifier, bool>(GestureTipsSeenNotifier.new);

/// Coach marks over the video the first time the player's controls show:
/// the gestures that have no button (double tap, hold, pinch, swipe down).
/// Tapping anywhere or "Got it" calls [onDismiss].
class GestureTipsOverlay extends StatelessWidget {
  const GestureTipsOverlay({super.key, required this.onDismiss, required this.seekSeconds});

  final VoidCallback onDismiss;
  final int seekSeconds;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    const onVideo = Colors.white;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    Widget tip(IconData icon, String label) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.xs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: onVideo, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Flexible(child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: onVideo))),
            ],
          ),
        );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: reduceMotion ? 1 : 0, end: 1),
      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 250),
      builder: (context, opacity, child) => Opacity(opacity: opacity, child: child),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onDismiss,
        // Swallow drags too, so the tips don't move the panel underneath.
        onVerticalDragStart: (_) {},
        child: ColoredBox(
          color: AppColors.of(context).videoScrim,
          // Scaled down rather than overflowing the small player at large
          // text sizes (like the playback error).
          child: LayoutBuilder(
            builder: (context, constraints) => FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: constraints.maxWidth,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Semantics(
                        liveRegion: true,
                        header: true,
                        child: Text(
                          l.gestureTipsTitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleSmall?.copyWith(color: onVideo),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          tip(Icons.touch_app_outlined, l.gestureTipDoubleTap(seekSeconds)),
                          tip(Icons.fast_forward_outlined, l.gestureTipHold),
                          tip(Icons.pinch_outlined, l.gestureTipPinch),
                          tip(Icons.swipe_down_outlined, l.gestureTipSwipeDown),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s),
                      FilledButton(
                        onPressed: () {
                          Haptics.light();
                          onDismiss();
                        },
                        child: Text(l.gestureTipsDone),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
