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
