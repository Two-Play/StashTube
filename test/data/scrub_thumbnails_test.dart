import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/models/scrub_thumbnails.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';

const _vtt = '''WEBVTT

00:00:00.000 --> 00:00:05.000
abc_sprite.jpg#xywh=0,0,160,90

00:00:05.000 --> 00:00:10.000
abc_sprite.jpg#xywh=160,0,160,90

01:00:10.000 --> 01:00:15.500
abc_sprite.jpg#xywh=320,90,160,90
''';

void main() {
  group('ScrubThumbnails.parse', () {
    test('skips cues with an empty region', () {
      const vtt = 'WEBVTT\n\n00:00.000 --> 00:05.000\ns.jpg#xywh=0,0,0,90\n\n00:05.000 --> 00:10.000\ns.jpg#xywh=0,0,160,90\n';
      final t = ScrubThumbnails.parse(vtt, spriteUrl: 'http://s/sprite', vttUrl: 'http://s/vtt')!;
      expect(t.cues.single.start, 5);
      expect(ScrubThumbnails.parse('WEBVTT\n\n00:00.000 --> 00:05.000\ns.jpg#xywh=0,0,160,0\n', vttUrl: 'http://s/vtt'), isNull);
    });

    test('reads cues and prefers the sprite URL from the API', () {
      final t = ScrubThumbnails.parse(_vtt, spriteUrl: 'http://s/sprite', vttUrl: 'http://s/scene/1/vtt/thumbs')!;
      expect(t.spriteUrl, 'http://s/sprite');
      expect(t.cues, hasLength(3));
      expect(t.cues[1].x, 160);
      expect(t.cues[2].start, 3610);
      expect(t.cues[2].end, 3615.5);
      expect(t.cues[2].y, 90);
    });

    test('resolves the sprite file next to the VTT when no sprite URL is known', () {
      final t = ScrubThumbnails.parse(_vtt, vttUrl: 'http://s/scene/1/abc_thumbs.vtt')!;
      expect(t.spriteUrl, 'http://s/scene/1/abc_sprite.jpg');
    });

    test('handles CRLF, MM:SS timestamps and junk', () {
      const vtt = 'WEBVTT\r\n\r\n00:05.000 --> 00:10.000\r\nx.jpg#xywh=1,2,3,4\r\n\r\nnot a cue\r\n';
      final t = ScrubThumbnails.parse(vtt, spriteUrl: 'u', vttUrl: 'http://s/v')!;
      expect(t.cues.single.start, 5);
      expect(t.cues.single.height, 4);
      expect(ScrubThumbnails.parse('WEBVTT\n', spriteUrl: 'u', vttUrl: 'http://s/v'), isNull);
    });

    test('cueAt picks the frame for a position', () {
      final t = ScrubThumbnails.parse(_vtt, spriteUrl: 'u', vttUrl: 'http://s/v')!;
      expect(t.cueAt(0).x, 0);
      expect(t.cueAt(4.9).x, 0);
      expect(t.cueAt(5).x, 160);
      expect(t.cueAt(600).x, 160);
      expect(t.cueAt(99999).x, 320);
      expect(t.cueAt(-1).x, 0);
    });
  });

  group('StashRepository.scrubThumbnails', () {
    StashRepository repo(MockClient client) => StashRepository(
          GraphQLClient(cache: GraphQLCache(), link: HttpLink('http://s/graphql')),
          authHeaders: const {'ApiKey': 'secret'},
          httpClient: client,
        );

    test('loads the VTT with the API key', () async {
      Map<String, String>? sentHeaders;
      final r = repo(MockClient((request) async {
        sentHeaders = request.headers;
        return http.Response(_vtt, 200);
      }));
      final t = await r.scrubThumbnails(const SceneDetails(vttUrl: 'http://s/vtt', spriteUrl: 'http://s/sprite'));
      expect(t?.cues, hasLength(3));
      expect(sentHeaders?['ApiKey'], 'secret');
    });

    test('previews are optional: missing or failing VTT gives null', () async {
      final notFound = repo(MockClient((_) async => http.Response('', 404)));
      expect(await notFound.scrubThumbnails(const SceneDetails(vttUrl: 'http://s/vtt')), isNull);
      expect(await notFound.scrubThumbnails(const SceneDetails()), isNull);

      final offline = repo(MockClient((_) async => throw http.ClientException('offline')));
      expect(await offline.scrubThumbnails(const SceneDetails(vttUrl: 'http://s/vtt')), isNull);
    });
  });
}
