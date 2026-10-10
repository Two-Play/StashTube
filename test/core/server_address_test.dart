import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/auth/login_page.dart';

void main() {
  group('addresses to try', () {
    test('without a port, also Stash\'s 9999: first for http, second for https', () {
      expect(ServerConfig.candidateUrls('192.168.1.10'), ['http://192.168.1.10:9999', 'http://192.168.1.10']);
      expect(ServerConfig.candidateUrls('https://stash.example.com/'),
          ['https://stash.example.com', 'https://stash.example.com:9999']);
    });

    test('an explicit port is used as given', () {
      expect(ServerConfig.candidateUrls('http://nas:8080/graphql'), ['http://nas:8080']);
      expect(ServerConfig.candidateUrls('nas:9999'), ['http://nas:9999']);
    });

    test('nothing to try for an unusable address', () {
      expect(ServerConfig.candidateUrls('  '), isEmpty);
      expect(ServerConfig.candidateUrls('ftp://nas'), isEmpty);
    });
  });

  group('finding the server', () {
    final candidates = [
      for (final url in ServerConfig.candidateUrls('192.168.1.10')) ServerConfig(baseUrl: url),
    ];

    test('takes the first address that answers', () async {
      final tried = <String>[];
      final found = await findServer(candidates, verify: (config) async {
        tried.add(config.baseUrl);
        if (config.baseUrl.endsWith(':9999')) throw const StashApiException('refused', isNetworkError: true);
      });
      expect(found.baseUrl, 'http://192.168.1.10');
      expect(tried, ['http://192.168.1.10:9999', 'http://192.168.1.10']);
    });

    test('a server\'s answer (e.g. a wrong API key) wins over not connecting', () async {
      await expectLater(
        findServer(candidates, verify: (config) async {
          if (config.baseUrl.endsWith(':9999')) {
            throw const StashApiException('check the API key', kind: StashErrorKind.unauthorized);
          }
          throw const StashApiException('refused', isNetworkError: true);
        }),
        throwsA(isA<StashApiException>().having((e) => e.kind, 'kind', StashErrorKind.unauthorized)),
      );
    });
  });
}
