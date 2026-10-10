import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';

StashRepository _repoFailingWith(LinkException exception) => StashRepository(GraphQLClient(
      cache: GraphQLCache(),
      link: Link.function((request, [forward]) => Stream.error(exception)),
    ));

/// A repository whose server answers every request with [response], going
/// through the real HTTP link (which is what turns it into exceptions).
StashRepository _repoAnswering(http.Response response) => StashRepository(GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink('http://stash.test/graphql', httpClient: MockClient((_) async => response)),
    ));

void main() {
  test('an error page names its HTTP status; only server-side failures are retried', () async {
    await expectLater(
      _repoAnswering(http.Response('<html>Not found</html>', 404)).libraryStats(),
      throwsA(isA<StashApiException>()
          .having((e) => e.detail, 'detail', 'HTTP 404')
          .having((e) => e.isNetworkError, 'isNetworkError', isFalse)),
    );
    await expectLater(
      _repoAnswering(http.Response('<html>Bad gateway</html>', 502)).libraryStats(),
      throwsA(isA<StashApiException>()
          .having((e) => e.detail, 'detail', 'HTTP 502')
          .having((e) => e.isNetworkError, 'isNetworkError', isTrue)),
    );
  });

  test('HTTP 422 with GraphQL errors is a query error, not a network error', () async {
    final repo = _repoFailingWith(HttpLinkServerException(
      response: http.Response('{}', 422),
      parsedResponse: const Response(
        errors: [GraphQLError(message: 'Cannot query field "total_o_count" on type "StatsResultType".')],
        response: {},
      ),
    ));

    await expectLater(
      repo.libraryStats(),
      throwsA(isA<StashApiException>()
          .having((e) => e.isNetworkError, 'isNetworkError', isFalse)
          .having((e) => e.message, 'message', contains('total_o_count'))),
    );
    expect(await repo.activityStats(), isNull, reason: 'older servers just lack activity stats');
  });

  test('HTTP 401 asks to check the API key', () async {
    final repo = _repoFailingWith(HttpLinkServerException(
      response: http.Response('', 401),
      parsedResponse: const Response(response: {}),
    ));
    await expectLater(
      repo.libraryStats(),
      throwsA(isA<StashApiException>().having((e) => e.message, 'message', contains('API key'))),
    );
  });

  test('HTTP 401 with an empty body (missing API key) asks to check the API key', () async {
    final repo = _repoFailingWith(HttpLinkParserException(
      originalException: const FormatException('Unexpected end of input'),
      originalStackTrace: null,
      response: http.Response('', 401),
    ));
    await expectLater(
      repo.libraryStats(),
      throwsA(isA<StashApiException>()
          .having((e) => e.kind, 'kind', StashErrorKind.unauthorized)
          .having((e) => e.isNetworkError, 'isNetworkError', isFalse)),
    );
  });

  test('unreachable server stays a network error', () async {
    final repo = _repoFailingWith(ServerException(originalException: Exception('connection refused')));
    await expectLater(
      repo.activityStats(),
      throwsA(isA<StashApiException>().having((e) => e.isNetworkError, 'isNetworkError', isTrue)),
    );
  });

  test('retry policy: only network errors, at most 3 times with backoff', () {
    const network = StashApiException('offline', isNetworkError: true);
    expect(stashRetry(0, network), const Duration(milliseconds: 500));
    expect(stashRetry(2, network), const Duration(milliseconds: 2000));
    expect(stashRetry(3, network), isNull);
    expect(stashRetry(0, const StashApiException('Not authorized')), isNull);
    expect(stashRetry(0, StateError('bug')), isNull);
  });
}
