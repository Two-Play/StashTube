import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/connection_status.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/data/repositories/stash_session.dart';

/// How the fake server answers the next request.
enum _Answer { ok, offline, serverError }

void main() {
  late _Answer answer;
  late ProviderContainer c;

  setUp(() async {
    answer = _Answer.ok;
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    c = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      stashHttpClientProvider.overrideWithValue(MockClient((_) async => http.Response('', 500))),
      graphQLClientProvider.overrideWith((ref) {
        ref.watch(serverConfigProvider);
        return GraphQLClient(
          cache: GraphQLCache(),
          link: Link.function((request, [forward]) => switch (answer) {
                _Answer.ok => Stream.value(const Response(data: {
                    '__typename': 'Query',
                    'version': {'__typename': 'Version', 'version': 'v0.31.1'},
                  }, response: {})),
                _Answer.offline => Stream.error(const ServerException(originalException: 'Connection refused')),
                _Answer.serverError => Stream.value(const Response(
                    errors: [GraphQLError(message: 'Cannot query field "version"')],
                    response: {},
                  )),
              }),
        );
      }),
    ]);
    await c.read(serverProfilesProvider.notifier).add(const ServerConfig(baseUrl: 'http://a'));
  });
  tearDown(() => c.dispose());

  Future<void> call() async {
    try {
      await c.read(stashRepositoryProvider).serverVersion();
    } on StashApiException {
      // The status is what matters here.
    }
  }

  test('a network error makes the server unreachable, a successful call reachable again', () async {
    expect(c.read(connectionStatusProvider), ServerReachability.unknown);

    answer = _Answer.offline;
    await call();
    expect(c.read(connectionStatusProvider), ServerReachability.unreachable);

    answer = _Answer.ok;
    await call();
    expect(c.read(connectionStatusProvider), ServerReachability.reachable);
  });

  test('server errors leave the status alone', () async {
    answer = _Answer.serverError;
    await call();
    expect(c.read(connectionStatusProvider), ServerReachability.unknown);

    answer = _Answer.offline;
    await call();
    answer = _Answer.serverError;
    await call();
    expect(c.read(connectionStatusProvider), ServerReachability.unreachable);
  });

  test('switching servers starts over', () async {
    final sub = c.listen(connectionStatusProvider, (_, _) {});
    addTearDown(sub.close);
    answer = _Answer.offline;
    await call();
    expect(sub.read(), ServerReachability.unreachable);

    await c.read(serverProfilesProvider.notifier).add(const ServerConfig(baseUrl: 'http://b'));
    expect(sub.read(), ServerReachability.unknown);
  });

  test('a repository replaced by a server switch reports nothing', () async {
    final sub = c.listen(connectionStatusProvider, (_, _) {});
    addTearDown(sub.close);
    final oldRepo = c.read(stashRepositoryProvider);
    await c.read(serverProfilesProvider.notifier).add(const ServerConfig(baseUrl: 'http://b'));

    answer = _Answer.offline;
    await expectLater(oldRepo.serverVersion(), throwsA(isA<StashApiException>()));
    expect(sub.read(), ServerReachability.unknown);
  });
}
