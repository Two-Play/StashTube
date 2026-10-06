import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'cast_media.dart';
import 'cast_service.dart';

/// AirPlay on iOS (4.21), through the `stash/airplay` channels of the app
/// (`AirPlayController` in `ios/Runner`).
///
/// The device is chosen in the system's route picker. Once an AirPlay
/// route is active, [load] plays the media in a native `AVPlayer` with
/// external playback, so the video runs on the TV; play/pause/seek control
/// it. The connection counts as active while the route is AirPlay and the
/// app hasn't stopped it ([disconnect]).
class AirPlayCastService implements CastService {
  AirPlayCastService._();

  static CastService create() {
    if (kIsWeb || !Platform.isIOS) return const UnsupportedCastService();
    return AirPlayCastService._();
  }

  static const _methods = MethodChannel('stash/airplay');
  static const _events = EventChannel('stash/airplay/events');

  /// Native state, shared by [connection] and [playback].
  late final Stream<Map<Object?, Object?>> _state =
      _events.receiveBroadcastStream().map((event) => (event as Map?) ?? const {}).asBroadcastStream();

  @override
  bool get isSupported => true;

  @override
  bool get supportsAirPlay => true;

  @override
  Future<void> showAirPlayPicker() async {
    final opened = await _methods.invokeMethod<bool>('showPicker');
    if (opened != true) debugPrint('AirPlay picker could not be opened');
  }

  /// AirPlay devices aren't listed by the app; see [showAirPlayPicker].
  @override
  Stream<List<CastTarget>> get devices => Stream.value(const []);

  @override
  Stream<CastConnection?> get connection => _state.map((state) {
        final route = state['route'] as String?;
        return route != null && state['engaged'] == true
            ? CastConnection(deviceName: route, kind: CastKind.airPlay)
            : null;
      }).distinct((a, b) => a?.deviceName == b?.deviceName);

  @override
  Stream<CastPlayback> get playback => _state.map((state) => CastPlayback(
        playing: state['playing'] == true,
        loading: state['loading'] == true,
        position: Duration(milliseconds: (state['positionMs'] as num?)?.toInt() ?? 0),
      ));

  @override
  Future<void> connect(CastTarget target) => showAirPlayPicker();

  /// Stops playing on the TV and opens the picker, so the user can switch
  /// the route back to the phone.
  @override
  Future<void> disconnect() async {
    await _methods.invokeMethod<void>('stop');
    await showAirPlayPicker();
  }

  @override
  Future<void> load(CastMedia media) => _methods.invokeMethod<void>('load', {
        'url': media.url,
        'title': media.title,
        'startMs': media.start.inMilliseconds,
      });

  @override
  Future<void> play() => _methods.invokeMethod<void>('play');

  @override
  Future<void> pause() => _methods.invokeMethod<void>('pause');

  @override
  Future<void> seek(Duration position) => _methods.invokeMethod<void>('seek', position.inMilliseconds);
}

/// Google Cast and AirPlay as one [CastService]: lists the Cast devices,
/// offers AirPlay where available, and sends the commands to whichever is
/// connected.
class CombinedCastService implements CastService {
  CombinedCastService(this.googleCast, this.airPlay);

  final CastService googleCast;
  final CastService airPlay;

  CastConnection? _airPlayConnection;

  /// Commands go to AirPlay while it is connected, else to Google Cast.
  CastService get _active => _airPlayConnection != null ? airPlay : googleCast;

  @override
  bool get isSupported => googleCast.isSupported || airPlay.isSupported;

  @override
  bool get supportsAirPlay => airPlay.supportsAirPlay;

  @override
  Future<void> showAirPlayPicker() => airPlay.showAirPlayPicker();

  @override
  Stream<List<CastTarget>> get devices => googleCast.devices;

  @override
  late final Stream<CastConnection?> connection = _combine<CastConnection?>(
    googleCast.connection,
    airPlay.connection,
    (google, airPlay) {
      _airPlayConnection = airPlay;
      return airPlay ?? google;
    },
  ).distinct((a, b) => a?.deviceName == b?.deviceName && a?.kind == b?.kind).asBroadcastStream();

  /// The connected service's playback.
  @override
  Stream<CastPlayback> get playback => _merge(
        googleCast.playback.where((_) => _airPlayConnection == null),
        airPlay.playback.where((_) => _airPlayConnection != null),
      );

  @override
  Future<void> connect(CastTarget target) => googleCast.connect(target);

  @override
  Future<void> disconnect() => _active.disconnect();

  @override
  Future<void> load(CastMedia media) => _active.load(media);

  @override
  Future<void> play() => _active.play();

  @override
  Future<void> pause() => _active.pause();

  @override
  Future<void> seek(Duration position) => _active.seek(position);
}

/// Emits [combine] of the latest values of [a] and [b] (each starting as null).
Stream<R> _combine<R>(Stream<CastConnection?> a, Stream<CastConnection?> b, R Function(CastConnection?, CastConnection?) combine) {
  late final StreamController<R> controller;
  final subscriptions = <StreamSubscription<CastConnection?>>[];
  CastConnection? latestA;
  CastConnection? latestB;
  controller = StreamController<R>(
    onListen: () {
      subscriptions
        ..add(a.listen((v) => controller.add(combine(latestA = v, latestB)), onError: controller.addError))
        ..add(b.listen((v) => controller.add(combine(latestA, latestB = v)), onError: controller.addError));
    },
    onCancel: () async {
      for (final s in subscriptions) {
        await s.cancel();
      }
    },
  );
  return controller.stream;
}

/// Events of both streams.
Stream<T> _merge<T>(Stream<T> a, Stream<T> b) {
  late final StreamController<T> controller;
  final subscriptions = <StreamSubscription<T>>[];
  controller = StreamController<T>(
    onListen: () {
      subscriptions
        ..add(a.listen(controller.add, onError: controller.addError))
        ..add(b.listen(controller.add, onError: controller.addError));
    },
    onCancel: () async {
      for (final s in subscriptions) {
        await s.cancel();
      }
    },
  );
  return controller.stream;
}
