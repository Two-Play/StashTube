import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/api/queries.dart';
import '../../core/config/server_config.dart';
import '../../features/player/playback_tracker.dart';
import '../models/json.dart';
import '../models/list_queries.dart';
import '../models/page_result.dart';
import '../models/performer.dart';
import '../models/scene.dart';
import '../models/studio.dart';

class StashApiException implements Exception {
  const StashApiException(this.message, {this.isNetworkError = false});

  final String message;

  /// True when the server could not be reached (wrong URL, offline, ...),
  /// as opposed to the server rejecting the query.
  final bool isNetworkError;

  @override
  String toString() => message;
}

GraphQLClient createGraphQLClient(ServerConfig config) => GraphQLClient(
      link: HttpLink(config.graphqlEndpoint, defaultHeaders: config.authHeaders),
      // Lists are paginated and refreshed manually, so no normalized caching.
      cache: GraphQLCache(),
      defaultPolicies: DefaultPolicies(
        query: Policies(fetch: FetchPolicy.networkOnly),
      ),
    );

/// All access to the Stash GraphQL API goes through this class.
class StashRepository implements PlaybackActivityApi {
  StashRepository(this._client);

  final GraphQLClient _client;

  static const defaultPageSize = 24;

  /// Checks that [config] points to a reachable, set-up Stash server.
  static Future<void> verifyServer(ServerConfig config) async {
    final repo = StashRepository(createGraphQLClient(config));
    final data = await repo._query(StashQueries.systemStatus);
    final status = readObject(data, 'systemStatus')?['status'];
    if (status != 'OK') {
      throw StashApiException('Server is reachable but not ready (status: $status).');
    }
  }

  Future<String?> serverVersion() async {
    final data = await _query(StashQueries.version);
    return readObject(data, 'version')?['version'] as String?;
  }

  Future<PageResult<Scene>> findScenes(
    SceneQuery query, {
    int page = 1,
    int perPage = defaultPageSize,
  }) async {
    final data = await _query(StashQueries.findScenes, {
      'filter': _findFilter(
        search: query.search,
        page: page,
        perPage: perPage,
        sort: query.sortField,
        direction: query.direction,
      ),
      'scene_filter': query.toSceneFilter(),
    });
    final result = readObject(data, 'findScenes') ?? const {};
    final scenes = readList(result, 'scenes')
        .map(Scene.fromJson)
        .where((s) => s.id != query.excludeSceneId)
        .toList();
    return PageResult(items: scenes, totalCount: readInt(result, 'count'));
  }

  Future<PageResult<Performer>> findPerformers(
    PerformerQuery query, {
    int page = 1,
    int perPage = defaultPageSize,
  }) async {
    final data = await _query(StashQueries.findPerformers, {
      'filter': _findFilter(
        search: query.search,
        page: page,
        perPage: perPage,
        sort: query.sortField,
        direction: query.direction,
      ),
      'performer_filter': query.toPerformerFilter(),
    });
    final result = readObject(data, 'findPerformers') ?? const {};
    return PageResult(
      items: readList(result, 'performers').map(Performer.fromJson).toList(),
      totalCount: readInt(result, 'count'),
    );
  }

  Future<Performer> findPerformer(String id) async {
    final data = await _query(StashQueries.findPerformer, {'id': id});
    final json = readObject(data, 'findPerformer');
    if (json == null) throw const StashApiException('Performer not found.');
    return Performer.fromJson(json);
  }

  Future<PageResult<Studio>> findStudios(
    StudioQuery query, {
    int page = 1,
    int perPage = defaultPageSize,
  }) async {
    final data = await _query(StashQueries.findStudios, {
      'filter': _findFilter(
        search: query.search,
        page: page,
        perPage: perPage,
        sort: 'name',
        direction: 'ASC',
      ),
    });
    final result = readObject(data, 'findStudios') ?? const {};
    return PageResult(
      items: readList(result, 'studios').map(Studio.fromJson).toList(),
      totalCount: readInt(result, 'count'),
    );
  }

  Future<Studio> findStudio(String id) async {
    final data = await _query(StashQueries.findStudio, {'id': id});
    final json = readObject(data, 'findStudio');
    if (json == null) throw const StashApiException('Studio not found.');
    return Studio.fromJson(json);
  }

  @override
  Future<void> saveActivity(String sceneId, {required double resumeTime, required double playDuration}) =>
      _mutate(StashQueries.sceneSaveActivity, {
        'id': sceneId,
        'resume_time': resumeTime,
        'playDuration': playDuration,
      });

  @override
  Future<void> addPlay(String sceneId) => _mutate(StashQueries.sceneAddPlay, {'id': sceneId});

  Future<void> setPerformerFavorite(String performerId, bool favorite) =>
      _mutate(StashQueries.performerSetFavorite, {'id': performerId, 'favorite': favorite});

  static Map<String, dynamic> _findFilter({
    String? search,
    required int page,
    required int perPage,
    required String sort,
    required String direction,
  }) =>
      {
        if (search != null && search.isNotEmpty) 'q': search,
        'page': page,
        'per_page': perPage,
        'sort': sort,
        'direction': direction,
      };

  Future<Json> _query(String document, [Map<String, dynamic> variables = const {}]) =>
      _run(() => _client.query(QueryOptions(document: gql(document), variables: variables)));

  Future<Json> _mutate(String document, Map<String, dynamic> variables) =>
      _run(() => _client.mutate(MutationOptions(document: gql(document), variables: variables)));

  Future<Json> _run(Future<QueryResult> Function() request) async {
    final QueryResult result;
    try {
      result = await request();
    } catch (e) {
      throw StashApiException(e.toString(), isNetworkError: true);
    }

    final exception = result.exception;
    if (exception != null) {
      final link = exception.linkException;
      if (link != null) {
        final cause = link.originalException ?? link;
        throw StashApiException('Could not reach the server: $cause', isNetworkError: true);
      }
      throw StashApiException(
        exception.graphqlErrors.map((e) => e.message).join('\n'),
      );
    }
    return result.data ?? const {};
  }
}

final graphQLClientProvider = Provider<GraphQLClient>((ref) {
  final config = ref.watch(serverConfigProvider);
  if (config == null) throw StateError('No server configured');
  return createGraphQLClient(config);
});

final stashRepositoryProvider = Provider<StashRepository>(
  (ref) => StashRepository(ref.watch(graphQLClientProvider)),
);
