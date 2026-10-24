import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/data/repositories/stash_session.dart';
import 'package:stash_app_mobile/l10n/l10n.dart';

/// What dart:io reports on iOS when the Local Network permission is denied.
const _noRoute = 'SocketException: No route to host (OS Error: No route to host, errno = 65), '
    'address = 192.168.1.20, port = 51234';

StashRepository _repoFailing(String url, Object error) => StashRepository(GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(url, httpClient: MockClient((_) async => throw error)),
    ));

void main() {
  group('isLocalNetworkDenied (ONB-2)', () {
    test('a LAN host on iOS with "No route to host" / errno 65', () {
      expect(isLocalNetworkDenied(_noRoute, platform: TargetPlatform.iOS), isTrue, reason: 'host from the text');
      expect(isLocalNetworkDenied('Connection failed (OS Error: errno = 65)', host: '10.0.0.5', platform: TargetPlatform.iOS),
          isTrue);
      expect(isLocalNetworkDenied('Local network prohibited', host: 'nas.local', platform: TargetPlatform.iOS), isTrue);
      expect(
        isLocalNetworkDenied('ClientException with SocketException: No route to host, uri=http://192.168.0.2:9999/graphql',
            platform: TargetPlatform.iOS),
        isTrue,
      );
    });

    test('not on Android, not for other errors, public hosts, loopback or VPN addresses', () {
      expect(isLocalNetworkDenied(_noRoute, platform: TargetPlatform.android), isFalse);
      expect(isLocalNetworkDenied('Connection refused (errno = 61)', host: '192.168.1.20', platform: TargetPlatform.iOS),
          isFalse);
      expect(isLocalNetworkDenied('No route to host', host: 'stash.example.com', platform: TargetPlatform.iOS), isFalse);
      expect(isLocalNetworkDenied('No route to host', host: '127.0.0.1', platform: TargetPlatform.iOS), isFalse);
      expect(isLocalNetworkDenied('No route to host', host: '100.101.102.103', platform: TargetPlatform.iOS), isFalse,
          reason: 'Tailscale');
      expect(isLocalNetworkDenied('No route to host', host: 'box.tail1234.ts.net', platform: TargetPlatform.iOS),
          isFalse);
      expect(isLocalNetworkDenied('No route to host', platform: TargetPlatform.iOS), isFalse, reason: 'host unknown');
    });
  });

  group('on iOS', () {
    setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.iOS);
    tearDown(() => debugDefaultTargetPlatformOverride = null);

    test('the repository reports a blocked LAN server as such, still a network error', () async {
      await expectLater(
        _repoFailing('http://192.168.1.20:9999/graphql', const SocketException('No route to host',
            osError: OSError('No route to host', 65))).libraryStats(),
        throwsA(isA<StashApiException>()
            .having((e) => e.kind, 'kind', StashErrorKind.localNetworkDenied)
            .having((e) => e.isNetworkError, 'isNetworkError', isTrue)),
      );
      await expectLater(
        _repoFailing('https://stash.example.com/graphql', const SocketException('No route to host',
            osError: OSError('No route to host', 65))).libraryStats(),
        throwsA(isA<StashApiException>().having((e) => e.kind, 'kind', StashErrorKind.unreachable)),
      );
    });

    test('signing in with a password reports it too', () async {
      final client = MockClient((_) async => throw http.ClientException('No route to host (errno = 65)'));
      await expectLater(
        stashLogin(client, const ServerConfig(baseUrl: 'http://192.168.1.20:9999', username: 'a', password: 'b')),
        throwsA(isA<StashApiException>().having((e) => e.kind, 'kind', StashErrorKind.localNetworkDenied)),
      );
    });
  });

  test('the message tells where to allow it', () {
    final l = lookupAppLocalizations(const Locale('en'));
    const error = StashApiException('x', isNetworkError: true, kind: StashErrorKind.localNetworkDenied);
    expect(errorText(l, error), contains('Settings → Privacy & Security → Local Network → StashTube'));
    expect(errorText(lookupAppLocalizations(const Locale('de')), error), contains('Lokales Netzwerk'));
  });
}
