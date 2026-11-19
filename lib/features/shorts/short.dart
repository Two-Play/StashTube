import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../../core/utils/picture_fit.dart';

import '../../data/models/image_item.dart';
import '../../data/models/marker.dart';
import '../../data/models/scene.dart';

/// One page of the shorts: a whole short video, or a scene marker played
/// from its scene's stream (original resolution) between [start] and [end].
@immutable
class Short {
  const Short.video(this.scene)
      : marker = null,
        image = null;

  Short.marker(Marker this.marker)
      : scene = marker.scene,
        image = null;

  /// A video file shown as an image (a gallery's clip, #64). [scene] only
  /// stands in for display (title, thumbnail, file, performers): it is no
  /// Stash scene, so the scene actions (rating, O-counter, plays, watch
  /// later, full video) don't apply ([isImage]).
  Short.image(ImageItem this.image)
      : marker = null,
        scene = Scene(
          id: 'image:${image.id}',
          title: image.title,
          duration: image.videoDuration ?? 0,
          width: image.width,
          height: image.height,
          screenshotUrl: image.thumbnailUrl,
          streamUrl: image.imageUrl,
          studio: image.studio,
          performers: image.performers,
        );

  /// Length of a marker clip without an end time; Stash's marker previews
  /// are as long.
  static const markerClipSeconds = 20.0;

  final Scene scene;
  final Marker? marker;
  final ImageItem? image;

  bool get isMarker => marker != null;

  bool get isImage => image != null;

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

  /// What the player opens: the scene's stream for a whole video; for a
  /// marker an mpv EDL of only its clip (`edl://%<length>%<url>,start=…,length=…`),
  /// which mpv plays and loops as a file of its own (position 0
  /// to the clip's length). An A-B loop inside the whole scene kept leaving
  /// the clip (scene ends, seeks, the loop surviving the next file).
  String? get playbackUrl {
    final url = scene.streamUrl;
    if (url == null || marker == null) return url;
    String seconds(Duration d) => (d.inMilliseconds / 1000).toStringAsFixed(3);
    return 'edl://%${utf8.encode(url).length}%$url,start=${seconds(start!)},length=${seconds(end! - start!)}';
  }

  /// See [pictureFit].
  static BoxFit fitFor(double? aspect, double boxAspect) => pictureFit(aspect, boxAspect);

  /// The scene's width / height, null when Stash doesn't know it.
  double? get aspect => scene.aspect;

  static Duration _duration(double seconds) => Duration(milliseconds: (seconds * 1000).round());

  @override
  bool operator ==(Object other) => other is Short && other.key == key;

  @override
  int get hashCode => key.hashCode;
}
