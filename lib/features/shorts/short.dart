import 'package:flutter/foundation.dart';

import '../../data/models/marker.dart';
import '../../data/models/scene.dart';

/// One page of the shorts: a whole short video, or a scene marker played
/// from its scene's stream (original resolution) between [start] and [end].
@immutable
class Short {
  const Short.video(this.scene) : marker = null;

  Short.marker(Marker this.marker) : scene = marker.scene;

  /// Length of a marker clip without an end time; Stash's marker previews
  /// are as long.
  static const markerClipSeconds = 20.0;

  final Scene scene;
  final Marker? marker;

  bool get isMarker => marker != null;

  /// Unique in a feed: a scene can be a short and have markers in it.
  String get key => marker == null ? scene.id : 'marker:${marker!.id}';

  /// Where playback starts and loops back to; null for a whole video.
  Duration? get start => marker == null ? null : _duration(marker!.seconds);

  /// Where a marker clip loops; null for a whole video.
  Duration? get end {
    final marker = this.marker;
    if (marker == null) return null;
    var seconds = marker.endSeconds ?? marker.seconds + markerClipSeconds;
    if (scene.duration > 0 && seconds > scene.duration) seconds = scene.duration;
    return _duration(seconds);
  }

  /// The clip's or the video's length in seconds.
  double get duration => marker == null ? scene.duration : (end! - start!).inMilliseconds / 1000;

  String get title => marker?.title ?? scene.title;

  /// How far playback may stray from a marker's clip before
  /// [correctionFor] brings it back: the A-B loop jumps back a moment after
  /// the end.
  static const clipTolerance = Duration(seconds: 1);

  /// Where a marker short's player has to go when it is at [position]: the
  /// clip's start once the position left the clip (e.g. the scene ended
  /// and looped to 0); null while inside, and always for a whole video.
  Duration? correctionFor(Duration position) {
    final start = this.start;
    final end = this.end;
    if (start == null || end == null) return null;
    return position >= start - clipTolerance && position <= end + clipTolerance ? null : start;
  }

  static Duration _duration(double seconds) => Duration(milliseconds: (seconds * 1000).round());

  @override
  bool operator ==(Object other) => other is Short && other.key == key;

  @override
  int get hashCode => key.hashCode;
}
