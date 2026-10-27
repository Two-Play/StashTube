import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/pip/pip.dart';
import 'sliver_columns.dart';

/// Which ways the app may turn. Phones stay portrait (4.28): the player
/// learns from [heldOrientationProvider] that the phone was turned and then
/// turns only its fullscreen, under a black curtain. Tablets turn
/// everywhere.
///
/// The player's fullscreen sets its own orientations as an [turnTo]
/// override.
abstract final class AppOrientation {
  static bool _phone = false;
  static List<DeviceOrientation>? _override;
  static List<DeviceOrientation>? _applied;

  /// The orientations allowed now; empty means all.
  @visibleForTesting
  static List<DeviceOrientation> get allowed =>
      _override ?? (_phone ? const [DeviceOrientation.portraitUp] : const []);

  /// Whether the window is a phone's (its shortest side below
  /// [kWideLayoutBreakpoint]).
  static Future<void> setPhone(bool phone) {
    _phone = phone;
    return _apply();
  }

  /// Sets [orientations] in place of the policy (null goes back to it) and
  /// waits until the window has turned to fit them, so a curtain over the
  /// turn can go.
  static Future<void> turnTo(List<DeviceOrientation>? orientations) async {
    _override = orientations;
    await _apply();
    await _untilFits(allowed);
  }

  @visibleForTesting
  static void reset() {
    _phone = false;
    _override = null;
    _applied = null;
  }

  static bool get _mobile => Platform.isAndroid || Platform.isIOS;

  static Future<void> _apply() async {
    final orientations = allowed;
    if (listEquals(orientations, _applied)) return;
    _applied = orientations;
    if (!_mobile) return;
    await SystemChrome.setPreferredOrientations(orientations);
  }

  /// Waits (at most a second) until the window's shape fits [orientations].
  static Future<void> _untilFits(List<DeviceOrientation> orientations) async {
    if (!_mobile || orientations.isEmpty) return;
    bool fits() {
      final view = PlatformDispatcher.instance.views.firstOrNull;
      if (view == null) return true;
      final landscape = view.physicalSize.width > view.physicalSize.height;
      return orientations.any(
        (o) => (o == DeviceOrientation.landscapeLeft || o == DeviceOrientation.landscapeRight) == landscape,
      );
    }

    if (fits()) return;
    final turned = Completer<void>();
    final observer = _MetricsObserver(() {
      if (fits() && !turned.isCompleted) turned.complete();
    });
    WidgetsBinding.instance.addObserver(observer);
    try {
      await turned.future.timeout(const Duration(seconds: 1), onTimeout: () {});
    } finally {
      WidgetsBinding.instance.removeObserver(observer);
    }
    // Two frames in the new shape and a moment for the video surface to
    // follow before what covers the turn goes (a fixed 200 ms felt slow).
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}

class _MetricsObserver with WidgetsBindingObserver {
  _MetricsObserver(this.onChange);

  final VoidCallback onChange;

  @override
  void didChangeMetrics() => onChange();
}

/// Tells [AppOrientation] whether the app runs on a phone, from the window's
/// size (not while it is Android's small picture-in-picture window).
class AppOrientationScope extends ConsumerWidget {
  const AppOrientationScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    if (shortest > 0 && !ref.watch(pipProvider)) AppOrientation.setPhone(shortest < kWideLayoutBreakpoint);
    return child;
  }
}
