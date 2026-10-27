import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// How the phone is held: upright, or turned sideways with its top to the
/// left (counterclockwise) or to the right (clockwise).
enum HeldOrientation {
  portrait,
  turnedLeft,
  turnedRight;

  bool get isLandscape => this != portrait;

  /// The angle (clockwise, as [Transform.rotate] takes it) that shows a
  /// picture upright on a portrait screen held this way.
  double get uprightAngle => switch (this) {
        portrait => 0,
        turnedLeft => math.pi / 2,
        turnedRight => -math.pi / 2,
      };
}

/// Reports turns of the phone while listened to (`stash/device_orientation`:
/// Android's OrientationEventListener, iOS' UIDevice orientation). The app
/// itself stays portrait on phones ([AppOrientation]), so the player learns
/// from here that the phone was turned, morphs its video into the turned
/// fullscreen and only then turns the screen. The system's rotation lock
/// wins: while it is on, no turn to landscape is reported. Lying flat
/// reports nothing.
final heldOrientationProvider = Provider<Stream<HeldOrientation>>((ref) {
  if (!Platform.isAndroid && !Platform.isIOS) return const Stream.empty();
  return const EventChannel('stash/device_orientation')
      .receiveBroadcastStream()
      .map(
        (event) => switch (event) {
          'turnedLeft' => HeldOrientation.turnedLeft,
          'turnedRight' => HeldOrientation.turnedRight,
          _ => HeldOrientation.portrait,
        },
      )
      // A device without a sensor (or an old plugin binary): no turns.
      .handleError((Object _) {});
});
