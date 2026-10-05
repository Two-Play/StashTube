import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

import '../../core/api/queries.dart';
import '../../core/config/server_config.dart';
import '../../features/player/playback_tracker.dart';
import '../models/gallery.dart';
import '../models/group.dart';
import '../models/image_item.dart';
import '../models/json.dart';
import '../models/list_queries.dart';
import '../models/page_result.dart';
import '../models/performer.dart';
import '../models/scene.dart';
import '../models/saved_filter.dart';
import '../models/scene_details.dart';
import '../models/scrub_thumbnails.dart';
import '../models/stats.dart';
import '../models/studio.dart';
import '../models/tag.dart';

class StashApiException implements Exception {
  const StashApiException(this.message, {this.isNetworkError = false});

  final String message;

  /// True when the server could not be reached (wrong URL, offline, ...),
  /// as opposed to the server rejecting the query.
  final bool isNetworkError;

  @override
  String toString() => message;
}

/// Retry policy for failed providers (Riverpod 3 retries by default, up to
/// 10 times). Only retry when the server was unreachable, a few times with
/// backoff; errors the server reports (bad query, wrong API key) are shown
/// right away instead of hammering the server.
Duration? stashRetry(int retryCount, Object error) {
  if (retryCount >= 3) return null;
  if (error is! StashApiException || !error.isNetworkError) return null;
  return Duration(milliseconds: 500 * (1 << retryCount));
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
  StashRepository(this._client, {this._authHeaders = const {}, http.Client? httpClient})
      : _http = httpClient ?? http.Client();

  final GraphQLClient _client;
  final Map<String, String> _authHeaders;

  /// For non-GraphQL server files such as the sprite VTT.
  final http.Client _http;

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

  Future<PageResult<ImageItem>> findImages(
    ImageQuery query, {
    int page = 1,
    int perPage = defaultPageSize,
  }) async {
    final data = await _query(StashQueries.findImages, {
      'filter': _findFilter(page: page, perPage: perPage, sort: query.sortField, direction: query.direction),
      'image_filter': query.toImageFilter(),
    });
    final result = readObject(data, 'findImages') ?? const {};
    return PageResult(
      items: readList(result, 'images').map(ImageItem.fromJson).toList(),
      totalCount: readInt(result, 'count'),
    );
  }

  Future<PageResult<Gallery>> findGalleries(
    GalleryQuery query, {
    int page = 1,
    int perPage = defaultPageSize,
  }) async {
    final data = await _query(StashQueries.findGalleries, {
      'filter': _findFilter(page: page, perPage: perPage, sort: query.sortField, direction: query.direction),
    });
    final result = readObject(data, 'findGalleries') ?? const {};
    return PageResult(
      items: readList(result, 'galleries').map(Gallery.fromJson).toList(),
      totalCount: readInt(result, 'count'),
    );
  }

  Future<Gallery> findGallery(String id) async {
    final data = await _query(StashQueries.findGallery, {'id': id});
    final json = readObject(data, 'findGallery');
    if (json == null) throw const StashApiException('Gallery not found.');
    return Gallery.fromJson(json);
  }

  /// Tags; without a search only tags that have scenes.
  Future<PageResult<Tag>> findTags(
    TagQuery query, {
    int page = 1,
    int perPage = defaultPageSize,
  }) async {
    final data = await _query(StashQueries.findTags, {
      'filter': _findFilter(
        search: query.search,
        page: page,
        perPage: perPage,
        sort: query.sort.field,
        direction: query.direction,
      ),
      'tag_filter': (query.search == null || query.search!.isEmpty)
          ? {'scene_count': {'value': 0, 'modifier': 'GREATER_THAN'}}
          : null,
    });
    final result = readObject(data, 'findTags') ?? const {};
    return PageResult(
      items: readList(result, 'tags').map(Tag.fromJson).toList(),
      totalCount: readInt(result, 'count'),
    );
  }

  Future<Tag> findTag(String id) async {
    final data = await _query(StashQueries.findTag, {'id': id});
    final json = readObject(data, 'findTag');
    if (json == null) throw const StashApiException('Tag not found.');
    return Tag.fromJson(json);
  }

  /// Scene filters saved in Stash's web UI; empty on servers that don't
  /// support them in this form.
  Future<List<SavedFilter>> savedSceneFilters() async {
    try {
      final data = await _query(StashQueries.savedSceneFilters);
      final list = data['findSavedFilters'];
      if (list is! List) return const [];
      return [for (final f in list.whereType<Map>()) SavedFilter.fromJson(Map<String, dynamic>.from(f))];
    } on StashApiException catch (e) {
      if (e.isNetworkError) rethrow;
      return const [];
    }
  }

  /// Scenes by id, in the order of [ids] (unknown ids are skipped).
  Future<List<Scene>> findScenesByIds(List<String> ids) async {
    if (ids.isEmpty) return const [];
    final data = await _query(StashQueries.findScenesByIds, {'ids': ids});
    final byId = {
      for (final s in readList(readObject(data, 'findScenes') ?? const {}, 'scenes').map(Scene.fromJson)) s.id: s,
    };
    return [for (final id in ids) if (byId[id] case final scene?) scene];
  }

  Future<PageResult<Group>> findGroups(GroupQuery query, {int page = 1, int perPage = defaultPageSize}) async {
    final data = await _query(StashQueries.findGroups, {
      'filter': _findFilter(search: query.search, page: page, perPage: perPage, sort: 'name', direction: 'ASC'),
    });
    final result = readObject(data, 'findGroups') ?? const {};
    return PageResult(
      items: readList(result, 'groups').map(Group.fromJson).toList(),
      totalCount: readInt(result, 'count'),
    );
  }

  Future<Group> findGroup(String id) async {
    final data = await _query(StashQueries.findGroup, {'id': id});
    final json = readObject(data, 'findGroup');
    if (json == null) throw const StashApiException('Group not found.');
    return Group.fromJson(json);
  }

  Future<LibraryStats> libraryStats() async {
    final data = await _query(StashQueries.stats);
    return LibraryStats.fromJson(readObject(data, 'stats') ?? const {});
  }

  /// Null when the server doesn't support activity stats (older Stash).
  Future<ActivityStats?> activityStats() async {
    try {
      final data = await _query(StashQueries.activityStats);
      return ActivityStats.fromJson(readObject(data, 'stats') ?? const {});
    } on StashApiException catch (e) {
      if (e.isNetworkError) rethrow;
      return null;
    }
  }

  Future<SceneDetails> findSceneDetails(String sceneId) async {
    final data = await _query(StashQueries.findSceneDetails, {'id': sceneId});
    final json = readObject(data, 'findScene');
    if (json == null) throw const StashApiException('Scene not found.');
    return SceneDetails.fromJson(json);
  }

  /// Seek preview thumbnails of a scene; null if Stash hasn't generated
  /// sprites for it or they can't be loaded (previews are optional).
  Future<ScrubThumbnails?> scrubThumbnails(SceneDetails details) async {
    final vttUrl = details.vttUrl;
    if (vttUrl == null) return null;
    try {
      final response = await _http.get(Uri.parse(vttUrl), headers: _authHeaders);
      if (response.statusCode != 200) return null;
      return ScrubThumbnails.parse(response.body, spriteUrl: details.spriteUrl, vttUrl: vttUrl);
    } catch (_) {
      return null;
    }
  }

  /// [rating100] null removes the rating.
  Future<void> setSceneRating(String sceneId, int? rating100) =>
      _mutate(StashQueries.sceneSetRating, {'id': sceneId, 'rating100': rating100});

  // Updates: [changes] holds only the fields to change, in the GraphQL input
  // shape (e.g. {'title': 'x', 'studio_id': '3'}); the id is added here.

  Future<Scene> updateScene(String id, Map<String, dynamic> changes) =>
      _update(StashQueries.sceneUpdate, 'sceneUpdate', id, changes, Scene.fromJson);

  Future<Performer> updatePerformer(String id, Map<String, dynamic> changes) =>
      _update(StashQueries.performerUpdate, 'performerUpdate', id, changes, Performer.fromJson);

  Future<Studio> updateStudio(String id, Map<String, dynamic> changes) =>
      _update(StashQueries.studioUpdate, 'studioUpdate', id, changes, Studio.fromJson);

  Future<Tag> updateTag(String id, Map<String, dynamic> changes) =>
      _update(StashQueries.tagUpdate, 'tagUpdate', id, changes, Tag.fromJson);

  Future<Gallery> updateGallery(String id, Map<String, dynamic> changes) =>
      _update(StashQueries.galleryUpdate, 'galleryUpdate', id, changes, Gallery.fromJson);

  Future<List<String>?> sceneUrls(String id) => _urls(StashQueries.sceneUrls, 'findScene', id);
  Future<List<String>?> performerUrls(String id) => _urls(StashQueries.performerUrls, 'findPerformer', id);
  Future<List<String>?> galleryUrls(String id) => _urls(StashQueries.galleryUrls, 'findGallery', id);

  /// Null when the server doesn't support URL lists for this kind.
  Future<List<String>?> _urls(String document, String field, String id) async {
    try {
      final data = await _query(document, {'id': id});
      final list = readObject(data, field)?['urls'];
      return list is List ? [for (final u in list) u.toString()] : const [];
    } on StashApiException catch (e) {
      if (e.isNetworkError) rethrow;
      return null;
    }
  }

  Future<T> _update<T>(
    String document,
    String field,
    String id,
    Map<String, dynamic> changes,
    T Function(Json) parse,
  ) async {
    final data = await _mutate(document, {
      'input': {'id': id, ...changes},
    });
    final json = readObject(data, field);
    if (json == null) throw const StashApiException('Nothing was saved.');
    return parse(json);
  }

  Future<Tag> createTag(String name) async {
    final data = await _mutate(StashQueries.tagCreate, {'name': name});
    final json = readObject(data, 'tagCreate');
    if (json == null) throw const StashApiException('Tag was not created.');
    return Tag.fromJson(json);
  }

  /// Replaces the scene's tags; returns them as saved by the server.
  Future<List<Tag>> setSceneTags(String sceneId, List<String> tagIds) async {
    final data = await _mutate(StashQueries.sceneSetTags, {'id': sceneId, 'tag_ids': tagIds});
    return readList(readObject(data, 'sceneUpdate') ?? const {}, 'tags').map(Tag.fromJson).toList();
  }

  /// Increments the O-counter; returns the new count.
  Future<int> addSceneO(String sceneId) async {
    final data = await _mutate(StashQueries.sceneAddO, {'id': sceneId});
    return readInt(readObject(data, 'sceneAddO') ?? const {}, 'count');
  }

  /// Removes the latest O; returns the new count.
  Future<int> removeSceneO(String sceneId) async {
    final data = await _mutate(StashQueries.sceneDeleteO, {'id': sceneId});
    return readInt(readObject(data, 'sceneDeleteO') ?? const {}, 'count');
  }

  Future<SceneMarker> createMarker({
    required String sceneId,
    required double seconds,
    required String primaryTagId,
    String title = '',
  }) async {
    final data = await _mutate(StashQueries.sceneMarkerCreate, {
      'input': {'scene_id': sceneId, 'seconds': seconds, 'primary_tag_id': primaryTagId, 'title': title},
    });
    final json = readObject(data, 'sceneMarkerCreate');
    if (json == null) throw const StashApiException('Marker was not created.');
    return SceneMarker.fromJson(json);
  }

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
      if (link is HttpLinkServerException) {
        // Stash answers invalid queries (e.g. fields unknown to older
        // versions) with HTTP 422 plus GraphQL errors: not a network problem.
        final errors = link.parsedResponse?.errors ?? const [];
        if (errors.isNotEmpty) throw StashApiException(errors.map((e) => e.message).join('\n'));
        if (link.response.statusCode == 401 || link.response.statusCode == 403) {
          throw const StashApiException('Not authorized – check the API key.');
        }
      }
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

final stashRepositoryProvider = Provider<StashRepository>((ref) {
  final httpClient = http.Client();
  ref.onDispose(httpClient.close);
  return StashRepository(
    ref.watch(graphQLClientProvider),
    authHeaders: ref.watch(authHeadersProvider),
    httpClient: httpClient,
  );
});
