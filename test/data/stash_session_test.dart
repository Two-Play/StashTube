import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/data/repositories/stash_session.dart';

const _login = ServerConfig(baseUrl: 'http://s', username: 'me', password: 'pw');

/// A Stash server that accepts "me"/"pw" and numbers its sessions.
class _FakeStash {
  var logins = 0;
  final graphqlCookies = <String?>[];
  String? validSession;

  late final client = MockClient((request) async {
    if (request.url.path == '/login') {
      if (request.bodyFields['username'] != 'me' || request.bodyFields['password'] != 'pw') {
        return http.Response('<html>login</html>', 200);
      }
      logins++;
      validSession = 's$logins';
      return http.Response('', 302, headers: {
        'location': '/',
        'set-cookie': 'session=$validSession; Path=/; Max-Age=3600; HttpOnly',
      });
    }
    final cookie = request.headers['Cookie'];
    graphqlCookies.add(cookie);
    if (cookie != 'session=$validSession') return http.Response('', 401);
    return http.Response(jsonEncode({'data': {'ok': true}, 'echo': request.body}), 200);
  });
}

void main() {
  test('reads the session cookie and its lifetime from Set-Cookie', () {
    final now = DateTime(2026, 1, 1, 12);
    final cookie = parseSessionCookie(
      'other=1; Path=/, session=abc123; Path=/; Expires=Wed, 01 Jan 2026 13:00:00 GMT; Max-Age=3600, x=2; Max-Age=5',
      now: () => now,
    )!;
    expect(cookie.value, 'abc123');
    expect(cookie.expires, now.add(const Duration(hours: 1)));
    expect(parseSessionCookie('session=a')!.expires, isNull);
    expect(parseSessionCookie('mysession=a; Path=/'), isNull);
    expect(parseSessionCookie(''), isNull);
  });

  test('signs in like the login page and rejects a wrong password', () async {
    final stash = _FakeStash();
    final cookie = await stashLogin(stash.client, _login);
    expect(cookie.header, 'session=s1');

    await expectLater(
      stashLogin(stash.client, const ServerConfig(baseUrl: 'http://s', username: 'me', password: 'nope')),
      throwsA(isA<StashApiException>().having((e) => e.kind, 'kind', StashErrorKind.invalidCredentials)),
    );
  });

  test('a login is only used without an API key', () {
    expect(_login.usesSession, isTrue);
    expect(const ServerConfig(baseUrl: 'http://s', apiKey: 'k', username: 'me', password: 'pw').usesSession, isFalse);
    expect(const ServerConfig(baseUrl: 'http://s', username: 'me').usesSession, isFalse);
  });

  group('session', () {
    late _FakeStash stash;
    late ProviderContainer container;
    var now = DateTime(2026, 1, 1, 12);

    setUp(() {
      stash = _FakeStash();
      now = DateTime(2026, 1, 1, 12);
      container = ProviderContainer(overrides: [serverConfigProvider.overrideWithValue(_login)]);
      addTearDown(container.dispose);
      container.read(stashSessionProvider.notifier)
        ..createClient = (() => stash.client)
        ..now = (() => now);
    });

    StashSessionClient client() => StashSessionClient(
          stash.client,
          ensure: () => container.read(stashSessionProvider.notifier).ensure(),
          renew: () => container.read(stashSessionProvider.notifier).renew(),
        );

    test('signs in before the first request and sends the cookie', () async {
      final response = await client().post(Uri.parse('http://s/graphql'), body: '{"query":"q"}');
      expect(response.statusCode, 200);
      expect(stash.graphqlCookies, ['session=s1']);
      expect(container.read(authHeadersProvider), {'Cookie': 'session=s1'}, reason: 'for images and streams');
    });

    test('signs in again when the server rejects the cookie, repeating the request', () async {
      await client().get(Uri.parse('http://s/graphql'));
      stash.validSession = 'expired-on-server';

      final response = await client().post(Uri.parse('http://s/graphql'), body: '{"query":"q"}');
      expect(response.statusCode, 200);
      expect(jsonDecode(response.body)['echo'], '{"query":"q"}', reason: 'the body is sent again');
      expect(stash.logins, 2);
      expect(stash.graphqlCookies.last, 'session=s2');
    });

    test('renews the session shortly before it expires', () async {
      await client().get(Uri.parse('http://s/graphql'));
      now = now.add(const Duration(minutes: 49));
      await client().get(Uri.parse('http://s/graphql'));
      expect(stash.logins, 1);

      now = now.add(const Duration(minutes: 2)); // 9 minutes left
      await client().get(Uri.parse('http://s/graphql'));
      expect(stash.logins, 2);
    });

    test('parallel requests share one login', () async {
      await Future.wait([for (var i = 0; i < 3; i++) client().get(Uri.parse('http://s/graphql'))]);
      expect(stash.logins, 1);
    });
  });
}
