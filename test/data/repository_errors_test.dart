import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';

StashRepository _repoFailingWith(LinkException exception) => StashRepository(GraphQLClient(
      cache: GraphQLCache(),
      link: Link.function((request, [forward]) => Stream.error(exception)),
    ));

void main() {
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

  test('unreachable server stays a network error', () async {
    final repo = _repoFailingWith(ServerException(originalException: Exception('connection refused')));
    await expectLater(
      repo.activityStats(),
      throwsA(isA<StashApiException>().having((e) => e.isNetworkError, 'isNetworkError', isTrue)),
    );
  });
}
