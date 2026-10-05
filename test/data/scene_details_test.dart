import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';

void main() {
  final details = SceneDetails.fromJson({
    'id': '1',
    'sceneStreams': [
      {'url': 'http://s/stream', 'mime_type': 'video/mp4', 'label': 'Direct stream'},
      {'url': 'http://s/stream.m3u8?resolution=STANDARD_HD', 'mime_type': 'application/vnd.apple.mpegurl', 'label': 'HLS Standard HD (720p)'},
      {'url': 'http://s/stream.mp4?resolution=STANDARD', 'mime_type': 'video/mp4', 'label': 'MP4 Standard (480p)'},
      {'url': '', 'label': 'broken'},
    ],
    'scene_markers': [
      {'id': 'b', 'title': '', 'seconds': 300, 'primary_tag': {'name': 'Ending'}},
      {'id': 'a', 'title': 'Intro', 'seconds': 0},
      {'id': 'c', 'title': 'Middle', 'seconds': 120.5},
    ],
  });

  test('parses streams and drops entries without URL', () {
    expect(details.streams.map((s) => s.label), ['Direct stream', 'HLS Standard HD (720p)', 'MP4 Standard (480p)']);
    expect(details.streams[0].isDirect, isTrue);
    expect(details.streams[1].isHls, isTrue);
    expect(details.streams[2].isHls, isFalse);
  });

  test('sorts markers and falls back to the primary tag as title', () {
    expect(details.markers.map((m) => m.title), ['Intro', 'Middle', 'Ending']);
    expect(details.markers.last.seconds, 300);
  });

  test('markerAt finds the chapter containing a position', () {
    expect(details.markerAt(0)?.title, 'Intro');
    expect(details.markerAt(119)?.title, 'Intro');
    expect(details.markerAt(120.5)?.title, 'Middle');
    expect(details.markerAt(9999)?.title, 'Ending');
    expect(const SceneDetails().markerAt(10), isNull);
  });
}
