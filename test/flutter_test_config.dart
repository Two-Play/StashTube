import 'dart:async';

import 'package:stash_app_mobile/features/security/pin_hash.dart';

/// Runs before every test file: PIN hashes with few rounds, computed on the
/// test's own isolate, so tests that enter PINs stay fast and work in fake
/// async zones.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  StoredPin.iterations = 1000;
  await testMain();
}
