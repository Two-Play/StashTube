import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Android accepts picture-in-picture aspect ratios between 1:2.39 and
/// 2.39:1; a bit inside, so rounding never crosses the limit.
const pipMinAspect = 0.42;
const pipMaxAspect = 2.38;

/// [aspect] within what Android's picture-in-picture accepts; 16:9 when
/// unknown.
double clampPipAspect(double? aspect) =>
    aspect == null || !aspect.isFinite || aspect <= 0 ? 16 / 9 : aspect.clamp(pipMinAspect, pipMaxAspect);

/// The part of [box] (logical pixels) that a video of [aspect] fills,
/// centered as `BoxFit.contain` places it, in physical pixels for Android's
/// `setSourceRectHint`. Null for an empty box.
Rect? pipSourceRect(Rect box, double aspect, double pixelRatio) {
  if (box.width <= 1 || box.height <= 1 || aspect <= 0) return null;
  final fitted = box.width / box.height > aspect
      ? Size(box.height * aspect, box.height)
      : Size(box.width, box.width / aspect);
  final rect = Rect.fromCenter(center: box.center, width: fitted.width, height: fitted.height);
  return Rect.fromLTRB(
    (rect.left * pixelRatio).roundToDouble(),
    (rect.top * pixelRatio).roundToDouble(),
    (rect.right * pixelRatio).roundToDouble(),
    (rect.bottom * pixelRatio).roundToDouble(),
  );
}

/// Something the platform's picture-in-picture reported.
sealed class PipEvent {
  const PipEvent();
}

/// The app's own window entered or left picture-in-picture (Android).
class PipModeChanged extends PipEvent {
  const PipModeChanged(this.active);

  final bool active;
}

/// The native player's picture-in-picture ended (iOS), at [position].
/// [playing]: it was still playing, e.g. the user tapped "back to the app".
class PipStopped extends PipEvent {
  const PipStopped({required this.position, required this.playing});

  final Duration position;
  final bool playing;
}

/// Picture-in-picture (4.12). Android shrinks the app's own window, and the
/// app shows only the video in it. iOS can't show mpv's video in
/// picture-in-picture, so a native AVPlayer takes over the stream there,
/// like AirPlay. An interface so tests can use a fake.
abstract class PipService {
  /// Whether this platform has picture-in-picture at all.
  bool get isSupported;

  /// Whether leaving the app can enter it by itself (Android).
  bool get canAutoEnter;

  Stream<PipEvent> get events;

  /// Android: enter picture-in-picture when the user leaves the app, in a
  /// window of [aspect] (width / height). Sent again whenever the video's
  /// size becomes known or changes, also while in picture-in-picture.
  Future<void> setAutoEnter({required bool enabled, required double aspect});

  /// Android: shrinks the app's window to the video, a window of [aspect].
  /// [from] is the video's place on screen in logical pixels, which the
  /// window shrinks out of.
  Future<bool> enter({required double aspect, Rect? from});

  /// iOS: plays [url] natively from [start] in picture-in-picture, growing
  /// out of [from] (the video's place on screen, in logical pixels). [aspect]
  /// is the video's width / height as far as the app knows it, so the
  /// window doesn't start in the wrong shape.
  Future<bool> startNative({
    required String url,
    required Map<String, String> headers,
    required Duration start,
    required Rect from,
    double? aspect,
  });

  /// iOS: ends the native picture-in-picture.
  Future<void> stopNative();

  /// The platform's service, or [UnsupportedPipService] elsewhere (tests,
  /// desktop).
  static PipService create() {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return const UnsupportedPipService();
    return ChannelPipService(native: Platform.isIOS);
  }
}

class UnsupportedPipService implements PipService {
  const UnsupportedPipService();

  @override
  bool get isSupported => false;

  @override
  bool get canAutoEnter => false;

  @override
  Stream<PipEvent> get events => const Stream.empty();

  @override
  Future<void> setAutoEnter({required bool enabled, required double aspect}) async {}

  @override
  Future<bool> enter({required double aspect, Rect? from}) async => false;

  @override
  Future<bool> startNative({
    required String url,
    required Map<String, String> headers,
    required Duration start,
    required Rect from,
    double? aspect,
  }) async =>
      false;

  @override
  Future<void> stopNative() async {}
}

/// The `stash/pip` channel of `MainActivity` (Android) and
/// `PictureInPictureController` in `AppDelegate.swift` (iOS).
class ChannelPipService implements PipService {
  ChannelPipService({required this.native, this.channel = const MethodChannel('stash/pip'), this.pixelRatio}) {
    channel.setMethodCallHandler((call) async {
      final args = call.arguments;
      switch (call.method) {
        case 'pipChanged':
          _events.add(PipModeChanged(args == true));
        case 'pipStopped':
          final map = (args as Map).cast<String, Object?>();
          _events.add(PipStopped(
            position: Duration(milliseconds: (map['positionMs'] as num?)?.toInt() ?? 0),
            playing: map['playing'] == true,
          ));
      }
    });
  }

  /// iOS: the native player plays in picture-in-picture.
  final bool native;

  /// `stash/pip`; another in tests.
  final MethodChannel channel;

  /// Physical pixels per logical pixel, for Android's source rect hint; the
  /// first view's when null. Set in tests.
  final double? pixelRatio;
  final _events = StreamController<PipEvent>.broadcast();

  @override
  bool get isSupported => true;

  @override
  bool get canAutoEnter => !native;

  @override
  Stream<PipEvent> get events => _events.stream;

  @override
  Future<void> setAutoEnter({required bool enabled, required double aspect}) async {
    if (native) return;
    await _invoke<void>('setAutoEnter', {'enabled': enabled, 'aspect': aspect});
  }

  @override
  Future<bool> enter({required double aspect, Rect? from}) async {
    if (native) return false;
    final hint = from == null ? null : pipSourceRect(from, aspect, _pixelRatio);
    return await _invoke<bool>('enter', {
          'aspect': aspect,
          if (hint != null) 'rect': [hint.left, hint.top, hint.width, hint.height],
        }) ==
        true;
  }

  double get _pixelRatio {
    if (pixelRatio != null) return pixelRatio!;
    final views = WidgetsBinding.instance.platformDispatcher.views;
    return views.isEmpty ? 1 : views.first.devicePixelRatio;
  }

  @override
  Future<bool> startNative({
    required String url,
    required Map<String, String> headers,
    required Duration start,
    required Rect from,
    double? aspect,
  }) async =>
      native &&
      await _invoke<bool>('start', {
            'url': url,
            'headers': headers,
            'startMs': start.inMilliseconds,
            'rect': [from.left, from.top, from.width, from.height],
            'aspect': ?aspect,
          }) ==
          true;

  @override
  Future<void> stopNative() async {
    if (native) await _invoke<void>('stop');
  }

  Future<T?> _invoke<T>(String method, [Object? arguments]) async {
    try {
      return await channel.invokeMethod<T>(method, arguments);
    } on PlatformException catch (e) {
      debugPrint('Picture-in-picture: $method failed: ${e.message}');
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}
