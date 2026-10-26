import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/pip/pip.dart';
import 'sliver_columns.dart';

/// Which ways the app may turn. On phones only the open player turns (for
/// a wide video, so that turning the phone enters fullscreen); lists,
/// pages and the shorts stay portrait. Tablets turn everywhere.
///
/// The player's fullscreen and its portrait lock after leaving fullscreen
/// sideways set their own orientations as an [override].
abstract final class AppOrientation {
  static bool _phone = false;
  static bool _playerTurns = false;
  static List<DeviceOrientation>? _override;
  static List<DeviceOrientation>? _applied;

  /// The orientations the policy allows; empty means all.
  @visibleForTesting
  static List<DeviceOrientation> get allowed =>
      _override ?? (_phone && !_playerTurns ? const [DeviceOrientation.portraitUp] : const []);

  /// Whether the window is a phone's (its shortest side below
  /// [kWideLayoutBreakpoint]).
  static Future<void> setPhone(bool phone) {
    _phone = phone;
    return _apply();
  }

  /// Whether the open player may turn (a wide video in the expanded panel).
  static Future<void> setPlayerTurns(bool turns) {
    _playerTurns = turns;
    return _apply();
  }

  /// Orientations that win over the policy, e.g. landscape in fullscreen;
  /// null goes back to it.
  static Future<void> setOverride(List<DeviceOrientation>? orientations) {
    _override = orientations;
    return _apply();
  }

  @visibleForTesting
  static void reset() {
    _phone = false;
    _playerTurns = false;
    _override = null;
    _applied = null;
  }

  static Future<void> _apply() async {
    final orientations = allowed;
    if (listEquals(orientations, _applied)) return;
    _applied = orientations;
    if (!Platform.isAndroid && !Platform.isIOS) return;
    await SystemChrome.setPreferredOrientations(orientations);
  }
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
