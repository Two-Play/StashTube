import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';

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

/// For platforms without Google Cast (desktop, tests).
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

/// Google Cast SDK via `flutter_chrome_cast`, using the Default Media Receiver.
class GoogleCastService implements CastService {
  GoogleCastService._();

  static CastService create() {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return const UnsupportedCastService();
    final service = GoogleCastService._();
    service._init();
    return service;
  }

  final _devicesById = <String, GoogleCastDevice>{};

  void _init() {
    const appId = GoogleCastDiscoveryCriteria.kDefaultApplicationId;
    final GoogleCastOptions options = Platform.isIOS
        ? IOSGoogleCastOptions(GoogleCastDiscoveryCriteriaInitialize.initWithApplicationID(appId))
        : GoogleCastOptionsAndroid(appId: appId);
    GoogleCastContext.instance.setSharedInstanceWithOptions(options);
  }

  @override
  bool get isSupported => true;

  @override
  bool get supportsAirPlay => false;

  @override
  Future<void> showAirPlayPicker() async {}

  @override
  Stream<List<CastTarget>> get devices {
    late final StreamController<List<CastTarget>> controller;
    StreamSubscription<List<GoogleCastDevice>>? sub;
    controller = StreamController<List<CastTarget>>(
      onListen: () {
        GoogleCastDiscoveryManager.instance.startDiscovery();
        sub = GoogleCastDiscoveryManager.instance.devicesStream.listen((devices) {
          for (final d in devices) {
            _devicesById[d.deviceID] = d;
          }
          controller.add([
            for (final d in devices) CastTarget(id: d.deviceID, name: d.friendlyName, model: d.modelName),
          ]);
        });
      },
      onCancel: () async {
        await sub?.cancel();
        GoogleCastDiscoveryManager.instance.stopDiscovery();
      },
    );
    return controller.stream;
  }

  @override
  Stream<CastConnection?> get connection => GoogleCastSessionManager.instance.currentSessionStream.map((session) {
        final connected = session != null && session.connectionState == GoogleCastConnectState.connected;
        return connected ? CastConnection(deviceName: session.device?.friendlyName ?? 'Cast device') : null;
      });

  /// Emits on every status change and on the device's position updates, so
  /// the position keeps moving while it plays.
  @override
  Stream<CastPlayback> get playback {
    final client = GoogleCastRemoteMediaClient.instance;
    late final StreamController<CastPlayback> controller;
    final subscriptions = <StreamSubscription<Object?>>[];
    void emit() {
      final state = client.mediaStatus?.playerState;
      controller.add(CastPlayback(
        playing: state == CastMediaPlayerState.playing,
        loading: state == CastMediaPlayerState.buffering || state == CastMediaPlayerState.loading,
        position: client.playerPosition,
      ));
    }

    controller = StreamController<CastPlayback>(
      onListen: () => subscriptions.addAll([
        client.mediaStatusStream.listen((_) => emit()),
        client.playerPositionStream.listen((_) => emit()),
      ]),
      onCancel: () async {
        for (final s in subscriptions) {
          await s.cancel();
        }
      },
    );
    return controller.stream;
  }

  @override
  Future<void> connect(CastTarget target) async {
    final device = _devicesById[target.id];
    if (device == null) throw StateError('Cast device ${target.name} is no longer available');
    await GoogleCastSessionManager.instance.startSessionWithDevice(device);
  }

  @override
  Future<void> disconnect() => GoogleCastSessionManager.instance.endSessionAndStopCasting();

  @override
  Future<void> load(CastMedia media) {
    final image = media.imageUrl;
    final metadata = GoogleCastMovieMediaMetadata(
      title: media.title,
      subtitle: media.subtitle,
      images: image == null ? null : [GoogleCastImage(url: Uri.parse(image), width: 1280, height: 720)],
    );
    final GoogleCastMediaInformation info = Platform.isIOS
        ? GoogleCastMediaInformationIOS(
            contentId: media.url,
            contentUrl: Uri.parse(media.url),
            streamType: CastMediaStreamType.buffered,
            contentType: media.contentType,
            metadata: metadata,
          )
        : GoogleCastMediaInformationAndroid(
            contentId: media.url,
            contentUrl: Uri.parse(media.url),
            streamType: CastMediaStreamType.buffered,
            contentType: media.contentType,
            metadata: metadata,
          );
    return GoogleCastRemoteMediaClient.instance.loadMedia(info, autoPlay: true, playPosition: media.start);
  }

  @override
  Future<void> play() => GoogleCastRemoteMediaClient.instance.play();

  @override
  Future<void> pause() => GoogleCastRemoteMediaClient.instance.pause();

  @override
  Future<void> seek(Duration position) =>
      GoogleCastRemoteMediaClient.instance.seek(GoogleCastMediaSeekOption(position: position));
}
