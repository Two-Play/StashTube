import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cast_service.dart';

/// Overridden in tests with a fake.
final castServiceProvider = Provider<CastService>((ref) => GoogleCastService.create());

/// The connected cast device, or null when not casting.
final castConnectionProvider = StreamProvider<CastConnection?>(
  (ref) => ref.watch(castServiceProvider).connection,
);

final castPlaybackProvider = StreamProvider<CastPlayback>(
  (ref) => ref.watch(castServiceProvider).playback,
);

/// Whether playback currently happens on a cast device.
final isCastingProvider = Provider<bool>((ref) => ref.watch(castConnectionProvider).value != null);
