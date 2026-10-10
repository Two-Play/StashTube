import 'cast_media.dart';

class CastTarget {
  const CastTarget({required this.id, required this.name, this.model});

  final String id;
  final String name;
  final String? model;
}

enum CastKind { googleCast, airPlay }

/// The cast device currently connected, if any.
class CastConnection {
  const CastConnection({required this.deviceName, this.kind = CastKind.googleCast});

  final String deviceName;
  final CastKind kind;
}

class CastPlayback {
  const CastPlayback({this.playing = false, this.position = Duration.zero, this.loading = false});

  final bool playing;
  final bool loading;
  final Duration position;
}

/// Chromecast access, behind an interface so the app logic can be tested
/// without the native SDK.
abstract interface class CastService {
  bool get isSupported;

  /// Whether AirPlay can be offered (iOS); its devices are picked in the
  /// system's route picker, see [showAirPlayPicker].
  bool get supportsAirPlay;

  /// Opens the system's AirPlay picker.
  Future<void> showAirPlayPicker();

  /// Devices on the network; discovery runs while this is listened to.
  Stream<List<CastTarget>> get devices;
  Stream<CastConnection?> get connection;
  Stream<CastPlayback> get playback;

  Future<void> connect(CastTarget target);
  Future<void> disconnect();
  Future<void> load(CastMedia media);
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration position);
}

/// For platforms without Google Cast (desktop, tests, the F-Droid build).
class UnsupportedCastService implements CastService {
  const UnsupportedCastService();

  @override
  bool get isSupported => false;
  @override
  bool get supportsAirPlay => false;
  @override
  Future<void> showAirPlayPicker() async {}
  @override
  Stream<List<CastTarget>> get devices => Stream.value(const []);
  @override
  Stream<CastConnection?> get connection => Stream.value(null);
  @override
  Stream<CastPlayback> get playback => const Stream.empty();
  @override
  Future<void> connect(CastTarget target) async {}
  @override
  Future<void> disconnect() async {}
  @override
  Future<void> load(CastMedia media) async {}
  @override
  Future<void> play() async {}
  @override
  Future<void> pause() async {}
  @override
  Future<void> seek(Duration position) async {}
}
