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
    'files': [
      {
        'path': r'D:\videos\holiday.mp4',
        'size': 1288490189,
        'format': 'mp4',
        'width': 2560,
        'height': 1440,
        'duration': 12.5,
        'video_codec': 'h264',
        'audio_codec': '',
        'frame_rate': 29.97,
        'bit_rate': 8500000,
        'mod_time': '2024-03-01T10:00:00Z',
      },
      {'path': ''},
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

  test('parses files, dropping empty values', () {
    final file = details.files.single;
    expect(file.name, 'holiday.mp4');
    expect(file.size, 1288490189);
    expect(file.height, 1440);
    expect(file.videoCodec, 'h264');
    expect(file.audioCodec, isNull);
    expect(file.frameRate, 29.97);
    expect(file.bitRate, 8500000);
    expect(file.modified, DateTime.utc(2024, 3, 1, 10));
  });

  group('preferred stream', () {
    SceneStream hls(String resolution, String label) => SceneStream(
          url: 'http://s/stream.m3u8?resolution=$resolution',
          label: label,
          mimeType: 'application/vnd.apple.mpegurl',
        );
    final streams = [
      const SceneStream(url: 'http://s/stream', label: 'Direct stream', mimeType: 'video/mp4'),
      hls('FULL_HD', 'HLS Full HD (1080p)'),
      hls('STANDARD_HD', 'HLS Standard HD (720p)'),
      hls('LOW', 'HLS Low (240p)'),
      const SceneStream(url: 'http://s/stream.mp4?resolution=STANDARD_HD', label: 'MP4 Standard HD (720p)', mimeType: 'video/mp4'),
    ];

    test('reads the height from the URL, else the label', () {
      expect(streams[1].height, 1080);
      expect(streams[0].height, isNull);
      expect(const SceneStream(url: 'http://s/x', label: 'WEBM 480p').height, 480);
      expect(streams[1].format, 'HLS');
    });

    test('exact label, else the same format at that height, else lower', () {
      expect(pickPreferredStream(streams, 'HLS Low (240p)'), streams[3]);
      expect(pickPreferredStream(streams, 'HLS 720p'), streams[2], reason: 'chosen in the settings');
      expect(pickPreferredStream(streams, 'MP4 720p'), streams[4]);
      expect(pickPreferredStream(streams, 'HLS 480p'), streams[3]);
    });

    test('plays the original when it is no larger than preferred', () {
      final small = [streams[0], streams[3]]; // a 240p video: only a 240p transcode
      expect(pickPreferredStream(small, 'HLS 720p'), isNull);
      expect(pickPreferredStream(streams, 'HLS 2160p'), isNull);
      expect(pickPreferredStream(streams, 'DASH 720p'), isNull, reason: 'format not offered');
    });
  });
}
