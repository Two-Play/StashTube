import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stash_app_mobile/core/network/origin_guard.dart';

void main() {
  group('sameOrigin', () {
    test('compares scheme, host and port, with default ports', () {
      final server = Uri.parse('https://Stash.example');
      expect(sameOrigin(Uri.parse('https://stash.example:443/x'), server), isTrue);
      expect(sameOrigin(Uri.parse('http://stash.example/x'), server), isFalse);
      expect(sameOrigin(Uri.parse('https://stash.example:8443/x'), server), isFalse);
      expect(sameOrigin(Uri.parse('https://evil.example/x'), server), isFalse);
      expect(sameOrigin(Uri.parse('https://stash.example.evil/x'), server), isFalse);
    });
  });

  group('AuthHeaders', () {
    final auth = AuthHeaders(Uri.parse('http://s:9999'), const {'ApiKey': 'k'});

    test('only for URLs on the server', () {
      expect(auth.forUrl('http://s:9999/scene/1/screenshot'), {'ApiKey': 'k'});
      expect(auth.forUrl('http://cdn.example/image.jpg'), isEmpty);
      expect(auth.forUrl('http://s/image.jpg'), isEmpty, reason: 'another port');
      expect(auth.forUrl('not a url ::'), isEmpty);
      expect(AuthHeaders.none.forUrl('http://s:9999/x'), isEmpty);
    });

    test("an EDL clip counts by the stream's URL inside", () {
      String edl(String url) => 'edl://%${url.length}%$url,start=1.000,length=2.000';
      expect(auth.forUrl(edl('http://s:9999/scene/1/stream')), {'ApiKey': 'k'});
      expect(auth.forUrl(edl('http://evil/stream')), isEmpty);
      expect(fetchedUri('edl://%99%http://s'), isNull);
    });
  });

  group('OriginGuardClient', () {
    test('drops credentials of a request to another origin', () async {
      final sent = <Uri, Map<String, String>>{};
      final client = OriginGuardClient(
        MockClient((r) async {
          sent[r.url] = r.headers;
          return http.Response('', 200);
        }),
        origin: Uri.parse('http://s'),
      );
      await client.get(Uri.parse('http://s/a'), headers: {'ApiKey': 'k', 'Cookie': 'session=1', 'X': 'y'});
      await client.get(Uri.parse('http://other/a'), headers: {'ApiKey': 'k', 'Cookie': 'session=1', 'X': 'y'});
      expect(sent[Uri.parse('http://s/a')], containsPair('ApiKey', 'k'));
      expect(sent[Uri.parse('http://other/a')], {'X': 'y'});
    });

    test('follows redirects, without credentials once they leave the origin', () async {
      final sent = <String, Map<String, String>>{};
      final client = OriginGuardClient(MockClient((r) async {
        sent[r.url.toString()] = r.headers;
        return switch (r.url.path) {
          '/start' => http.Response('', 302, headers: {'location': '/moved'}),
          '/moved' => http.Response('', 301, headers: {'location': 'https://evil.example/steal'}),
          _ => http.Response('done', 200),
        };
      }));
      final response = await client.get(Uri.parse('http://s/start'), headers: {'ApiKey': 'k'});
      expect(response.body, 'done');
      expect(sent['http://s/moved'], containsPair('ApiKey', 'k'), reason: 'same origin');
      expect(sent['https://evil.example/steal'], isNot(contains('ApiKey')));
    });

    test('a 303 after a POST continues as GET; 307 keeps method and body', () async {
      final seen = <String>[];
      final client = OriginGuardClient(MockClient((r) async {
        seen.add('${r.method} ${r.url.path} ${r.body}');
        return switch (r.url.path) {
          '/see-other' => http.Response('', 303, headers: {'location': '/result'}),
          '/temporary' => http.Response('', 307, headers: {'location': '/result'}),
          _ => http.Response('', 200),
        };
      }));
      await client.post(Uri.parse('http://s/see-other'), body: 'q');
      await client.post(Uri.parse('http://s/temporary'), body: 'q');
      expect(seen, ['POST /see-other q', 'GET /result ', 'POST /temporary q', 'POST /result q']);
    });

    test('stops after maxRedirects', () async {
      final client = OriginGuardClient(MockClient((r) async => http.Response('', 302, headers: {'location': '/again'})));
      final request = http.Request('GET', Uri.parse('http://s/loop'))..maxRedirects = 3;
      await expectLater(client.send(request), throwsA(isA<http.ClientException>()));
    });

    test('returns the redirect itself when the request asks not to follow', () async {
      final client = OriginGuardClient(MockClient((r) async => http.Response('', 302, headers: {'location': '/x'})));
      final request = http.Request('POST', Uri.parse('http://s/login'))..followRedirects = false;
      expect((await client.send(request)).statusCode, 302);
    });
  });
}
