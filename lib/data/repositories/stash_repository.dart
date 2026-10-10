import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

import '../../core/api/documents/galleries.graphql.dart';
import '../../core/api/documents/groups.graphql.dart';
import '../../core/api/documents/images.graphql.dart';
import '../../core/api/documents/performers.graphql.dart';
import '../../core/api/documents/refs.graphql.dart';
import '../../core/api/documents/scenes.graphql.dart';
import '../../core/api/documents/studios.graphql.dart';
import '../../core/api/documents/system.graphql.dart';
import '../../core/api/documents/tags.graphql.dart';
import '../../core/api/stash_schema.graphql.dart';
import '../../core/config/server_config.dart';
import '../../features/player/playback_tracker.dart';
import '../models/gallery.dart';
import '../models/group.dart';
import '../models/image_item.dart';
import '../models/json.dart';
import '../models/list_queries.dart';
import '../models/marker.dart';
import '../models/page_result.dart';
import '../models/performer.dart';
import '../models/scene.dart';
import '../models/saved_filter.dart';
import '../models/scene_details.dart';
import '../models/scrub_thumbnails.dart';
import '../models/stats.dart';
import '../models/studio.dart';
import '../models/tag.dart';
import 'stash_session.dart';

/// What went wrong, so the UI can show the error in the user's language
/// (`errorText`); [StashApiException.message] stays English for logs.
enum StashErrorKind {
  /// The server's own error text, shown as is.
  server,
  unreachable,
  unauthorized,
  invalidCredentials,
  notReady,
  notFound,
  notSaved,
}

class StashApiException implements Exception {
  const StashApiException(this.message, {this.isNetworkError = false, this.kind = StashErrorKind.server, this.detail});

  final String message;
  final StashErrorKind kind;

  /// Extra information for the localized text, e.g. the network error.
  final String? detail;

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

GraphQLClient createGraphQLClient(ServerConfig config, {http.Client? httpClient, StashSessionCookie? session}) =>
    GraphQLClient(
      link: HttpLink(
        config.graphqlEndpoint,
        defaultHeaders: {...config.authHeaders, if (session != null) 'Cookie': session.header},
        httpClient: httpClient,
      ),
      // Lists are paginated and refreshed manually, so no normalized caching.
      cache: GraphQLCache(),
      defaultPolicies: DefaultPolicies(query: Policies(fetch: FetchPolicy.networkOnly)),
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

  /// Checks that [config] points to a reachable, set-up Stash server and,
  /// with a login, that it signs in.
  static Future<void> verifyServer(ServerConfig config) async {
    StashSessionCookie? session;
    if (config.usesSession) {
      final client = http.Client();
      try {
        session = await stashLogin(client, config);
      } finally {
        client.close();
      }
    }
    final repo = StashRepository(createGraphQLClient(config, session: session));
    final data = await repo._query(Options$Query$SystemStatus());
    final status = toJson$Enum$SystemStatusEnum(data.systemStatus.status);
    if (status != 'OK') {
      throw StashApiException(
        'Server is reachable but not ready (status: $status).',
        kind: StashErrorKind.notReady,
        detail: status,
      );
    }
  }

  Future<String?> serverVersion() async => (await _query(Options$Query$Version())).version.version;

  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = defaultPageSize}) async {
    final data = await _query(
      Options$Query$FindScenes(
        variables: Variables$Query$FindScenes(
          filter: _findFilter(
            search: query.search,
            page: page,
            perPage: perPage,
            sort: query.sortField,
            direction: query.direction,
          ),
          scene_filter: _input(query.toSceneFilter(), Input$SceneFilterType.fromJson, (i) => i.toJson()),
        ),
      ),
    );
    final result = data.findScenes;
    return PageResult(
      items: [
        for (final s in result.scenes)
          if (s.id != query.excludeSceneId) Scene.fromFields(s),
      ],
      totalCount: result.count,
    );
  }

  Future<PageResult<Performer>> findPerformers(
    PerformerQuery query, {
    int page = 1,
    int perPage = defaultPageSize,
  }) async {
    final data = await _query(
      Options$Query$FindPerformers(
        variables: Variables$Query$FindPerformers(
          filter: _findFilter(
            search: query.search,
            page: page,
            perPage: perPage,
            sort: query.sortField,
            direction: query.direction,
          ),
          performer_filter: _input(query.toPerformerFilter(), Input$PerformerFilterType.fromJson, (i) => i.toJson()),
        ),
      ),
    );
    final result = data.findPerformers;
    return PageResult(items: [for (final p in result.performers) Performer.fromFields(p)], totalCount: result.count);
  }

  Future<Performer> findPerformer(String id) async {
    final data = await _query(Options$Query$FindPerformer(variables: Variables$Query$FindPerformer(id: id)));
    final performer = data.findPerformer;
    if (performer == null) throw const StashApiException('Performer not found.', kind: StashErrorKind.notFound);
    return Performer.fromFields(performer, details: performer.details);
  }

  /// Scene markers of all scenes, for the markers page.
  Future<PageResult<Marker>> findMarkers(MarkerQuery query, {int page = 1, int perPage = defaultPageSize}) async {
    final data = await _query(
      Options$Query$FindSceneMarkers(
        variables: Variables$Query$FindSceneMarkers(
          filter: _findFilter(
            search: query.search,
            page: page,
            perPage: perPage,
            sort: query.sortField,
            direction: query.direction,
          ),
        ),
      ),
    );
    final result = data.findSceneMarkers;
    return PageResult(items: [for (final m in result.scene_markers) Marker.fromGraphql(m)], totalCount: result.count);
  }

  Future<PageResult<Studio>> findStudios(StudioQuery query, {int page = 1, int perPage = defaultPageSize}) async {
    final data = await _query(
      Options$Query$FindStudios(
        variables: Variables$Query$FindStudios(
          filter: _findFilter(search: query.search, page: page, perPage: perPage, sort: 'name', direction: 'ASC'),
        ),
      ),
    );
    final result = data.findStudios;
    return PageResult(items: [for (final s in result.studios) Studio.fromFields(s)], totalCount: result.count);
  }

  Future<Studio> findStudio(String id) async {
    final data = await _query(Options$Query$FindStudio(variables: Variables$Query$FindStudio(id: id)));
    final studio = data.findStudio;
    if (studio == null) throw const StashApiException('Studio not found.', kind: StashErrorKind.notFound);
    return Studio.fromFields(studio);
  }

  @override
  Future<void> saveActivity(String sceneId, {required double resumeTime, required double playDuration}) => _mutate(
    Options$Mutation$SceneSaveActivity(
      variables: Variables$Mutation$SceneSaveActivity(id: sceneId, resume_time: resumeTime, playDuration: playDuration),
    ),
  );

  @override
  Future<void> addPlay(String sceneId) =>
      _mutate(Options$Mutation$SceneAddPlay(variables: Variables$Mutation$SceneAddPlay(id: sceneId)));

  Future<PageResult<ImageItem>> findImages(ImageQuery query, {int page = 1, int perPage = defaultPageSize}) async {
    final data = await _query(
      Options$Query$FindImages(
        variables: Variables$Query$FindImages(
          filter: _findFilter(
            search: query.search,
            page: page,
            perPage: perPage,
            sort: query.sortField,
            direction: query.direction,
          ),
          image_filter: _input(query.toImageFilter(), Input$ImageFilterType.fromJson, (i) => i.toJson()),
        ),
      ),
    );
    final result = data.findImages;
    return PageResult(items: [for (final i in result.images) ImageItem.fromGraphql(i)], totalCount: result.count);
  }

  Future<PageResult<Gallery>> findGalleries(GalleryQuery query, {int page = 1, int perPage = defaultPageSize}) async {
    final data = await _query(
      Options$Query$FindGalleries(
        variables: Variables$Query$FindGalleries(
          filter: _findFilter(
            search: query.search,
            page: page,
            perPage: perPage,
            sort: query.sortField,
            direction: query.direction,
          ),
        ),
      ),
    );
    final result = data.findGalleries;
    return PageResult(items: [for (final g in result.galleries) Gallery.fromFields(g)], totalCount: result.count);
  }

  Future<Gallery> findGallery(String id) async {
    final data = await _query(Options$Query$FindGallery(variables: Variables$Query$FindGallery(id: id)));
    final gallery = data.findGallery;
    if (gallery == null) throw const StashApiException('Gallery not found.', kind: StashErrorKind.notFound);
    return Gallery.fromFields(gallery);
  }

  /// Tags; without a search only tags that have scenes.
  Future<PageResult<Tag>> findTags(TagQuery query, {int page = 1, int perPage = defaultPageSize}) async {
    final data = await _query(
      Options$Query$FindTags(
        variables: Variables$Query$FindTags(
          filter: _findFilter(
            search: query.search,
            page: page,
            perPage: perPage,
            sort: query.sort.field,
            direction: query.direction,
          ),
          tag_filter: (query.search == null || query.search!.isEmpty)
              ? Input$TagFilterType(
                  scene_count: Input$IntCriterionInput(value: 0, modifier: Enum$CriterionModifier.GREATER_THAN),
                )
              : null,
        ),
      ),
    );
    final result = data.findTags;
    return PageResult(items: [for (final t in result.tags) Tag.fromFields(t)], totalCount: result.count);
  }

  Future<Tag> findTag(String id) async {
    final data = await _query(Options$Query$FindTag(variables: Variables$Query$FindTag(id: id)));
    final tag = data.findTag;
    if (tag == null) throw const StashApiException('Tag not found.', kind: StashErrorKind.notFound);
    return Tag.fromFields(tag, description: tag.description);
  }

  /// Scene filters saved in Stash's web UI; empty on servers that don't
  /// support them in this form.
  Future<List<SavedFilter>> savedSceneFilters() async {
    try {
      final data = await _query(Options$Query$SavedSceneFilters());
      return [for (final f in data.findSavedFilters) SavedFilter.fromGraphql(f)];
    } on StashApiException catch (e) {
      if (e.isNetworkError) rethrow;
      return const [];
    }
  }

  /// Scenes by id, in the order of [ids] (unknown ids are skipped).
  Future<List<Scene>> findScenesByIds(List<String> ids) async {
    if (ids.isEmpty) return const [];
    final data = await _query(Options$Query$FindScenesByIds(variables: Variables$Query$FindScenesByIds(ids: ids)));
    final byId = {for (final s in data.findScenes.scenes) s.id: Scene.fromFields(s)};
    return [for (final id in ids) ?byId[id]];
  }

  Future<PageResult<Group>> findGroups(GroupQuery query, {int page = 1, int perPage = defaultPageSize}) async {
    final data = await _query(
      Options$Query$FindGroups(
        variables: Variables$Query$FindGroups(
          filter: _findFilter(search: query.search, page: page, perPage: perPage, sort: 'name', direction: 'ASC'),
        ),
      ),
    );
    final result = data.findGroups;
    return PageResult(items: [for (final g in result.groups) Group.fromFields(g)], totalCount: result.count);
  }

  Future<Group> findGroup(String id) async {
    final data = await _query(Options$Query$FindGroup(variables: Variables$Query$FindGroup(id: id)));
    final group = data.findGroup;
    if (group == null) throw const StashApiException('Group not found.', kind: StashErrorKind.notFound);
    return Group.fromFields(group, synopsis: group.synopsis);
  }

  Future<LibraryStats> libraryStats() async => LibraryStats.fromGraphql((await _query(Options$Query$Stats())).stats);

  /// Null when the server doesn't support activity stats (older Stash).
  Future<ActivityStats?> activityStats() async {
    try {
      return ActivityStats.fromGraphql((await _query(Options$Query$ActivityStats())).stats);
    } on StashApiException catch (e) {
      if (e.isNetworkError) rethrow;
      return null;
    }
  }

  Future<SceneDetails> findSceneDetails(String sceneId) async {
    final data = await _query(Options$Query$FindSceneDetails(variables: Variables$Query$FindSceneDetails(id: sceneId)));
    final scene = data.findScene;
    if (scene == null) throw const StashApiException('Scene not found.', kind: StashErrorKind.notFound);
    return SceneDetails.fromGraphql(scene);
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
  Future<void> setSceneRating(String sceneId, int? rating100) => _mutate(
    Options$Mutation$SceneSetRating(
      variables: Variables$Mutation$SceneSetRating(id: sceneId, rating100: rating100),
    ),
  );

  // Updates: [changes] holds only the fields to change, in the GraphQL input
  // shape (e.g. {'title': 'x', 'studio_id': '3'}); the id is added here.

  Future<Scene> updateScene(String id, Map<String, dynamic> changes) async {
    final data = await _mutate(
      Options$Mutation$SceneEdit(
        variables: Variables$Mutation$SceneEdit(
          input: _updateInput(id, changes, Input$SceneUpdateInput.fromJson, (i) => i.toJson()),
        ),
      ),
    );
    return Scene.fromFields(data.sceneUpdate ?? _notSaved());
  }

  Future<Performer> updatePerformer(String id, Map<String, dynamic> changes) async {
    final data = await _mutate(
      Options$Mutation$PerformerEdit(
        variables: Variables$Mutation$PerformerEdit(
          input: _updateInput(id, changes, Input$PerformerUpdateInput.fromJson, (i) => i.toJson()),
        ),
      ),
    );
    final performer = data.performerUpdate ?? _notSaved();
    return Performer.fromFields(performer, details: performer.details);
  }

  Future<Studio> updateStudio(String id, Map<String, dynamic> changes) async {
    final data = await _mutate(
      Options$Mutation$StudioEdit(
        variables: Variables$Mutation$StudioEdit(
          input: _updateInput(id, changes, Input$StudioUpdateInput.fromJson, (i) => i.toJson()),
        ),
      ),
    );
    return Studio.fromFields(data.studioUpdate ?? _notSaved());
  }

  Future<Tag> updateTag(String id, Map<String, dynamic> changes) async {
    final data = await _mutate(
      Options$Mutation$TagEdit(
        variables: Variables$Mutation$TagEdit(
          input: _updateInput(id, changes, Input$TagUpdateInput.fromJson, (i) => i.toJson()),
        ),
      ),
    );
    final tag = data.tagUpdate ?? _notSaved();
    return Tag.fromFields(tag, description: tag.description);
  }

  Future<Gallery> updateGallery(String id, Map<String, dynamic> changes) async {
    final data = await _mutate(
      Options$Mutation$GalleryEdit(
        variables: Variables$Mutation$GalleryEdit(
          input: _updateInput(id, changes, Input$GalleryUpdateInput.fromJson, (i) => i.toJson()),
        ),
      ),
    );
    return Gallery.fromFields(data.galleryUpdate ?? _notSaved());
  }

  static Never _notSaved() => throw const StashApiException('Nothing was saved.', kind: StashErrorKind.notSaved);

  Future<List<String>?> sceneUrls(String id) => _urls(
    () async => (await _query(Options$Query$SceneUrls(variables: Variables$Query$SceneUrls(id: id)))).findScene?.urls,
  );

  Future<List<String>?> performerUrls(String id) => _urls(
    () async => (await _query(
      Options$Query$PerformerUrls(variables: Variables$Query$PerformerUrls(id: id)),
    )).findPerformer?.urls,
  );

  Future<List<String>?> galleryUrls(String id) => _urls(
    () async =>
        (await _query(Options$Query$GalleryUrls(variables: Variables$Query$GalleryUrls(id: id)))).findGallery?.urls,
  );

  /// Null when the server doesn't support URL lists for this kind.
  Future<List<String>?> _urls(Future<List<String>?> Function() load) async {
    try {
      return await load() ?? const [];
    } on StashApiException catch (e) {
      if (e.isNetworkError) rethrow;
      return null;
    }
  }

  Future<Tag> createTag(String name) async {
    final data = await _mutate(Options$Mutation$TagCreate(variables: Variables$Mutation$TagCreate(name: name)));
    final tag = data.tagCreate;
    if (tag == null) throw const StashApiException('Tag was not created.', kind: StashErrorKind.notSaved);
    return Tag.fromFields(tag);
  }

  /// Replaces the scene's tags; returns them as saved by the server.
  Future<List<Tag>> setSceneTags(String sceneId, List<String> tagIds) async {
    final data = await _mutate(
      Options$Mutation$SceneSetTags(
        variables: Variables$Mutation$SceneSetTags(id: sceneId, tag_ids: tagIds),
      ),
    );
    return [for (final t in data.sceneUpdate?.tags ?? const <Fragment$TagRef>[]) Tag.fromRef(t)];
  }

  /// Increments the O-counter; returns the new count.
  Future<int> addSceneO(String sceneId) async =>
      (await _mutate(Options$Mutation$SceneAddO(variables: Variables$Mutation$SceneAddO(id: sceneId)))).sceneAddO.count;

  /// Removes the latest O; returns the new count.
  Future<int> removeSceneO(String sceneId) async => (await _mutate(
    Options$Mutation$SceneDeleteO(variables: Variables$Mutation$SceneDeleteO(id: sceneId)),
  )).sceneDeleteO.count;

  Future<SceneMarker> createMarker({
    required String sceneId,
    required double seconds,
    required String primaryTagId,
    String title = '',
  }) async {
    final data = await _mutate(
      Options$Mutation$SceneMarkerCreate(
        variables: Variables$Mutation$SceneMarkerCreate(
          input: Input$SceneMarkerCreateInput(
            scene_id: sceneId,
            seconds: seconds,
            primary_tag_id: primaryTagId,
            title: title,
          ),
        ),
      ),
    );
    final marker = data.sceneMarkerCreate;
    if (marker == null) throw const StashApiException('Marker was not created.', kind: StashErrorKind.notSaved);
    return SceneMarker.fromFields(marker);
  }

  Future<void> setPerformerFavorite(String performerId, bool favorite) => _mutate(
    Options$Mutation$PerformerSetFavorite(
      variables: Variables$Mutation$PerformerSetFavorite(id: performerId, favorite: favorite),
    ),
  );

  static Input$FindFilterType _findFilter({
    String? search,
    required int page,
    required int perPage,
    required String sort,
    required String direction,
  }) => Input$FindFilterType(
    q: search == null || search.isEmpty ? null : search,
    page: page,
    per_page: perPage,
    sort: sort,
    direction: fromJson$Enum$SortDirectionEnum(direction),
  );

  static T _updateInput<T>(
    String id,
    Map<String, dynamic> changes,
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic> Function(T) toJson,
  ) => _input({'id': id, ...changes}, fromJson, toJson)!;

  /// Turns a filter or update built as a map (the app's queries and forms
  /// build them that way) into its generated input type. The generated
  /// parser ignores keys the schema doesn't have; in debug builds and tests
  /// such a key fails here instead of silently going missing.
  static T? _input<T>(
    Map<String, dynamic>? map,
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic> Function(T) toJson,
  ) {
    if (map == null) return null;
    assert(fitsInput(map, fromJson, toJson), 'Not in the Stash schema: $map');
    return fromJson(map);
  }

  Future<T> _query<T>(QueryOptions<T> options) => _run(() => _client.query(options));

  Future<T> _mutate<T>(MutationOptions<T> options) => _run(() => _client.mutate(options));

  Future<T> _run<T>(Future<QueryResult<T>> Function() request) async {
    final QueryResult<T> result;
    try {
      result = await request();
    } catch (e) {
      throw StashApiException('$e', isNetworkError: true, kind: StashErrorKind.unreachable, detail: '$e');
    }

    final exception = result.exception;
    if (exception != null) {
      final link = exception.linkException;
      if (link is HttpLinkServerException) {
        // Stash answers invalid queries (e.g. fields unknown to older
        // versions) with HTTP 422 plus GraphQL errors: not a network problem.
        final errors = link.parsedResponse?.errors ?? const [];
        if (errors.isNotEmpty) throw StashApiException(errors.map((e) => e.message).join('\n'));
      }
      // Without a valid API key Stash answers 401 with an empty body, which
      // the link fails to parse (HttpLinkParserException).
      final status = switch (link) {
        HttpLinkServerException(:final response) || HttpLinkParserException(:final response) => response.statusCode,
        _ => null,
      };
      if (status == 401 || status == 403) {
        throw const StashApiException('Not authorized – check the API key.', kind: StashErrorKind.unauthorized);
      }
      if (link is HttpLinkParserException && status != null && status >= 300) {
        // Not a Stash answer (wrong address, a proxy's error page): retrying
        // only helps when the server side is failing.
        throw StashApiException(
          'The server answered with HTTP $status.',
          isNetworkError: status >= 500,
          kind: StashErrorKind.unreachable,
          detail: 'HTTP $status',
        );
      }
      if (link != null) {
        final cause = link.originalException ?? link;
        throw StashApiException(
          'Could not reach the server: $cause',
          isNetworkError: true,
          kind: StashErrorKind.unreachable,
          detail: '$cause',
        );
      }
      throw StashApiException(exception.graphqlErrors.map((e) => e.message).join('\n'));
    }
    try {
      return result.parsedData ?? (throw const StashApiException('The server sent no data.'));
    } on StashApiException {
      rethrow;
    } catch (e) {
      // A response that doesn't match the generated types: another schema.
      throw StashApiException('Unexpected response from the server: $e');
    }
  }
}

final graphQLClientProvider = Provider<GraphQLClient>((ref) {
  final config = ref.watch(serverConfigProvider);
  if (config == null) throw StateError('No server configured');
  return createGraphQLClient(config, httpClient: ref.watch(stashHttpClientProvider));
});

// Not on authHeadersProvider: a renewed session cookie must not rebuild the
// repository and everything loaded through it; the client adds the cookie.
final stashRepositoryProvider = Provider<StashRepository>(
  (ref) => StashRepository(
    ref.watch(graphQLClientProvider),
    authHeaders: ref.watch(serverConfigProvider)?.authHeaders ?? const {},
    httpClient: ref.watch(stashHttpClientProvider),
  ),
);
