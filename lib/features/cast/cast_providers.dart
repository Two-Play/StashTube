import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'airplay_service.dart';
import 'cast_service.dart';
import 'google_cast_service.dart';

/// Google Cast and, on iOS, AirPlay. Overridden in tests with a fake.
final castServiceProvider = Provider<CastService>(
  (ref) => CombinedCastService(GoogleCastService.create(), AirPlayCastService.create()),
);

/// The connected cast device, or null when not casting.
final castConnectionProvider = StreamProvider<CastConnection?>(
  (ref) => ref.watch(castServiceProvider).connection,
);

final castPlaybackProvider = StreamProvider<CastPlayback>(
  (ref) => ref.watch(castServiceProvider).playback,
);

/// Whether playback currently happens on a cast device.
final isCastingProvider = Provider<bool>((ref) => ref.watch(castConnectionProvider).value != null);

/// A scene that couldn't be played on the cast device; the player shows it
/// in a snack bar. Each failure is a new object, so the same error twice is
/// reported twice.
class CastFailure {
  CastFailure(this.error, this.deviceName);

  final Object error;
  final String? deviceName;
}

class CastFailureNotifier extends Notifier<CastFailure?> {
  @override
  CastFailure? build() => null;

  void report(Object error, String? deviceName) => state = CastFailure(error, deviceName);
}

final castFailureProvider = NotifierProvider<CastFailureNotifier, CastFailure?>(CastFailureNotifier.new);
