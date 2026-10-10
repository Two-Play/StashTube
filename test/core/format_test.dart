import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/core/utils/format.dart';
import 'package:stash_app_mobile/l10n/l10n.dart';

void main() {
  test('formatDuration', () {
    expect(formatDuration(0), '0:00');
    expect(formatDuration(65), '1:05');
    expect(formatDuration(3723.4), '1:02:03');
    expect(formatDuration(double.nan), '0:00');
  });

  test('formatTimeAgo', () {
    final now = DateTime(2024, 6, 1);
    final l = lookupAppLocalizations(const Locale('en'));
    expect(formatTimeAgo(l, now.subtract(const Duration(days: 1)), now), '1 day ago');
    expect(formatTimeAgo(l, now.subtract(const Duration(days: 14)), now), '2 weeks ago');
    expect(formatTimeAgo(l, now.subtract(const Duration(days: 800)), now), '2 years ago');

    final de = lookupAppLocalizations(const Locale('de'));
    expect(formatTimeAgo(de, now.subtract(const Duration(days: 1)), now), 'vor 1 Tag');
    expect(formatTimeAgo(de, now.subtract(const Duration(days: 800)), now), 'vor 2 Jahren');
  });

  test('resolutionLabel', () {
    expect(resolutionLabel(2160), '4K');
    expect(resolutionLabel(1080), '1080p');
    expect(resolutionLabel(360), '360p');
    expect(resolutionLabel(null), isNull);
  });

  group('ServerConfig.normalizeUrl', () {
    test('adds a scheme and strips trailing slashes and /graphql', () {
      expect(ServerConfig.normalizeUrl('192.168.1.5:9999'), 'http://192.168.1.5:9999');
      expect(ServerConfig.normalizeUrl('https://stash.local/'), 'https://stash.local');
      expect(ServerConfig.normalizeUrl(' http://stash:9999/graphql '), 'http://stash:9999');
    });

    test('drops query and fragment, keeps sub-paths and credentials', () {
      expect(ServerConfig.normalizeUrl('https://host/?x=1#top'), 'https://host');
      expect(ServerConfig.normalizeUrl('https://host/stash/graphql?x=1'), 'https://host/stash');
      expect(ServerConfig.normalizeUrl('https://user:pw@host:8443/stash/'), 'https://user:pw@host:8443/stash');
    });

    test('knows local hosts and warns about plain HTTP over the internet', () {
      for (final host in ['localhost', 'nas', 'stash.lan', 'nas.tail1234.ts.net', '127.0.0.1', '172.20.1.1',
          '192.168.0.9', '100.101.102.103', '::1', 'fd12::1', 'fe80::1']) {
        expect(ServerConfig.isLocalHost(host), isTrue, reason: host);
      }
      for (final host in ['example.com', '8.8.8.8', '172.32.0.1', '100.128.0.1', '2001:db8::1']) {
        expect(ServerConfig.isLocalHost(host), isFalse, reason: host);
      }
      expect(const ServerConfig(baseUrl: 'http://stash.example.com').isUnencryptedOverInternet, isTrue);
      expect(const ServerConfig(baseUrl: 'https://stash.example.com').isUnencryptedOverInternet, isFalse);
      expect(const ServerConfig(baseUrl: 'http://192.168.1.5:9999').isUnencryptedOverInternet, isFalse);
      expect(const ServerConfig(baseUrl: 'http://[fd12::1]:9999').isUnencryptedOverInternet, isFalse);
    });

    test('rejects invalid input', () {
      expect(ServerConfig.normalizeUrl(''), isNull);
      expect(ServerConfig.normalizeUrl('ftp://host'), isNull);
      expect(ServerConfig.normalizeUrl('http://'), isNull);
    });

    test('auth headers only with an API key', () {
      expect(const ServerConfig(baseUrl: 'http://a').authHeaders, isEmpty);
      expect(const ServerConfig(baseUrl: 'http://a', apiKey: 'k').authHeaders, {'ApiKey': 'k'});
    });
  });
}
