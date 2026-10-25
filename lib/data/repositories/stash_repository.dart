import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

import '../../core/api/documents/galleries.graphql.dart';
import '../../core/api/documents/groups.graphql.dart';
import '../../core/api/documents/images.graphql.dart';
import '../../core/api/documents/markers.graphql.dart';
import '../../core/api/documents/performers.graphql.dart';
import '../../core/api/documents/refs.graphql.dart';
import '../../core/api/documents/scenes.graphql.dart';
import '../../core/api/documents/studios.graphql.dart';
import '../../core/api/documents/system.graphql.dart';
import '../../core/api/documents/watch_stats.graphql.dart';
import '../../core/api/documents/tags.graphql.dart';
import '../../core/api/documents/tasks.graphql.dart';
import '../../core/api/stash_schema.graphql.dart';
import '../../core/config/server_config.dart';
import '../../features/player/playback_tracker.dart';
import '../connection_status.dart';
import '../models/gallery.dart';
import '../models/group.dart';
import '../models/image_details.dart';
import '../models/image_item.dart';
import '../models/json.dart';
import '../models/list_queries.dart';
import '../models/marker.dart';
import '../models/page_result.dart';
import '../models/performer.dart';
import '../models/performer_profile.dart';
import '../models/scene.dart';
import '../models/saved_filter.dart';
import '../models/scene_details.dart';
import '../models/scrub_thumbnails.dart';
import '../models/server_task.dart';
import '../models/stats.dart';
import '../models/studio.dart';
import '../models/tag.dart';
import '../models/watch_history.dart';
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

  /// iOS refused the connection into the local network: the user denied
  /// StashTube's "Local Network" permission.
  localNetworkDenied,
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

/// The exception for a server that couldn't be reached because of [cause];
/// [host] is the server's host when known (else read from the error text).
/// On iOS a denied "Local Network" permission makes connections into the
/// LAN fail like an unreachable host; that gets its own
/// [StashErrorKind.localNetworkDenied], so the user learns what to switch on.
StashApiException unreachableException(Object cause, {String? host, String prefix = 'Could not reach the server: '}) =>
    StashApiException(
      '$prefix$cause',
      isNetworkError: true,
      kind: isLocalNetworkDenied('$cause', host: host) ? StashErrorKind.localNetworkDenied : StashErrorKind.unreachable,
      detail: '$cause',
    );

/// Whether [error] (a network error's text) looks like iOS blocking the
/// connection to [host] for lack of the local network permission: a host in
/// the LAN (not loopback, not a VPN address such as Tailscale's) and
/// "No route to host" (errno 65) or "Local network prohibited".
bool isLocalNetworkDenied(String error, {String? host, TargetPlatform? platform}) {
  if ((platform ?? defaultTargetPlatform) != TargetPlatform.iOS) return false;
  final h = (host ?? _hostIn(error))?.toLowerCase();
  if (h == null || !ServerConfig.isLocalHost(h) || _isLoopbackOrVpn(h)) return false;
  return RegExp(r'errno\s*=\s*65\b|no route to host|local network prohibited', caseSensitive: false).hasMatch(error);
}

/// The host in a socket or client error's text (`uri=http://host:9999/…`
/// or `address = host`).
String? _hostIn(String error) {
  final uri = RegExp(r'uri=(\S+)').firstMatch(error);
  if (uri != null) {
    final host = Uri.tryParse(uri.group(1)!.replaceAll(RegExp(r'[,)]+$'), ''))?.host;
    if (host != null && host.isNotEmpty) return host;
  }
  return RegExp(r'address = ([^\s,]+)').firstMatch(error)?.group(1);
}

bool _isLoopbackOrVpn(String host) {
  if (host == 'localhost' || host.endsWith('.localhost') || host.endsWith('.ts.net')) return true;
  try {
    final ip = Uri.parseIPv4Address(host);
    return ip[0] == 127 || (ip[0] == 100 && ip[1] >= 64 && ip[1] <= 127);
  } on FormatException {
    return host == '::1' || host == '[::1]';
  }
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

/// A scene's place in a group: the group and the scene's position in it.
typedef SceneGroupEntry = ({String groupId, int? sceneIndex});

/// All access to the Stash GraphQL API goes through this class.
class StashRepository implements PlaybackActivityApi {
  StashRepository(this._client, {this._authHeaders = const {}, http.Client? httpClient, this._onReachability})
    : _http = httpClient ?? http.Client();

  final GraphQLClient _client;

  /// Told after every call whether the server answered (true) or couldn't be
  /// reached (false); feeds [connectionStatusProvider]. Server and auth
  /// errors aren't reported.
  final void Function(bool reachable)? _onReachability;
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

  /// The performer's details for their channel's about tab, and how many
  /// images and galleries they have.
  Future<PerformerProfile> performerProfile(String id) async {
    final data = await _query(Options$Query$PerformerProfile(variables: Variables$Query$PerformerProfile(id: id)));
    final performer = data.findPerformer;
    if (performer == null) throw const StashApiException('Performer not found.', kind: StashErrorKind.notFound);
    return PerformerProfile.fromGraphql(performer);
  }

  /// Scene markers of all scenes (the markers page), or of a channel's.
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
          scene_marker_filter: _input(query.toMarkerFilter(), Input$SceneMarkerFilterType.fromJson, (i) => i.toJson()),
        ),
      ),
    );
    final result = data.findSceneMarkers;
    final markers = [for (final m in result.scene_markers) Marker.fromGraphql(m)];
    final ends = markers.isEmpty ? null : await _markerEnds([for (final m in markers) m.id]);
    return PageResult(
      items: ends == null ? markers : [for (final m in markers) ends.containsKey(m.id) ? m.withEnd(ends[m.id]) : m],
      totalCount: result.count,
    );
  }

  /// The marker end queries the server rejected (older Stash), so they
  /// aren't sent again.
  final _unsupportedMarkerEnds = <String>{};

  /// End times by marker id, or null on servers without them.
  Future<Map<String, double?>?> _markerEnds(List<String> ids) => _optionalMarkerEnds(
    'list',
    () async => [
      for (final m in (await _query(Options$Query$MarkerEnds(variables: Variables$Query$MarkerEnds(ids: ids))))
          .findSceneMarkers
          .scene_markers)
        (m.id, m.end_seconds),
    ],
  );

  /// End times of the scene's markers, or null on servers without them.
  Future<Map<String, double?>?> sceneMarkerEnds(String sceneId) => _optionalMarkerEnds(
    'scene',
    () async => [
      for (final m in (await _query(
            Options$Query$SceneMarkerEnds(variables: Variables$Query$SceneMarkerEnds(id: sceneId)),
          )).findScene?.scene_markers ??
          const <Query$SceneMarkerEnds$findScene$scene_markers>[])
        (m.id, m.end_seconds),
    ],
  );

  Future<Map<String, double?>?> _optionalMarkerEnds(
    String kind,
    Future<List<(String, double?)>> Function() load,
  ) async {
    if (_unsupportedMarkerEnds.contains(kind)) return null;
    try {
      return {for (final (id, end) in await load()) id: end};
    } on StashApiException catch (e) {
      if (e.isNetworkError) rethrow;
      _unsupportedMarkerEnds.add(kind);
      return null;
    }
  }

  /// How many markers [query] finds, without loading them.
  Future<int> countMarkers(MarkerQuery query) async {
    final data = await _query(
      Options$Query$SceneMarkerCount(
        variables: Variables$Query$SceneMarkerCount(
          scene_marker_filter: _input(query.toMarkerFilter(), Input$SceneMarkerFilterType.fromJson, (i) => i.toJson()),
        ),
      ),
    );
    return data.findSceneMarkers.count;
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

  /// How many images and galleries the studio and its sub-studios have.
  Future<ChannelMediaCounts> studioMediaCounts(String id) async {
    final data = await _query(Options$Query$StudioMediaCounts(variables: Variables$Query$StudioMediaCounts(id: id)));
    final studio = data.findStudio;
    if (studio == null) throw const StashApiException('Studio not found.', kind: StashErrorKind.notFound);
    return ChannelMediaCounts.fromStudio(studio);
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

  /// One image with everything the viewer's info sheet shows.
  Future<ImageDetails> findImageDetails(String id) async {
    final data = await _query(Options$Query$FindImageDetails(variables: Variables$Query$FindImageDetails(id: id)));
    final image = data.findImage;
    if (image == null) throw const StashApiException('Image not found.', kind: StashErrorKind.notFound);
    return ImageDetails.fromGraphql(image);
  }

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
          gallery_filter: _input(query.toGalleryFilter(), Input$GalleryFilterType.fromJson, (i) => i.toJson()),
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

  /// The groups [sceneId] is in, with its position in each (PL-1).
  Future<List<SceneGroupEntry>> sceneGroups(String sceneId) async {
    final data = await _query(Options$Query$SceneGroups(variables: Variables$Query$SceneGroups(id: sceneId)));
    final scene = data.findScene;
    if (scene == null) throw const StashApiException('Scene not found.', kind: StashErrorKind.notFound);
    return [for (final g in scene.groups) (groupId: g.group.id, sceneIndex: g.scene_index)];
  }

  /// Puts [sceneId] into exactly [groups]; returns them as saved.
  Future<List<SceneGroupEntry>> setSceneGroups(String sceneId, List<SceneGroupEntry> groups) async {
    final data = await _mutate(
      Options$Mutation$SceneSetGroups(
        variables: Variables$Mutation$SceneSetGroups(
          id: sceneId,
          groups: [for (final g in groups) Input$SceneGroupInput(group_id: g.groupId, scene_index: g.sceneIndex)],
        ),
      ),
    );
    final scene = data.sceneUpdate ?? _notSaved();
    return [for (final g in scene.groups) (groupId: g.group.id, sceneIndex: g.scene_index)];
  }

  /// The position after the group's last scene (1 for an empty group).
  Future<int> nextGroupIndex(String groupId) async {
    final data = await _query(
      Options$Query$LastGroupScene(variables: Variables$Query$LastGroupScene(group_id: groupId)),
    );
    final last = data.findScenes.scenes.firstOrNull;
    final index = last?.groups.where((g) => g.group.id == groupId).firstOrNull?.scene_index;
    return (index ?? 0) + 1;
  }

  /// Appends [sceneId] to the group, keeping the scene's other groups.
  /// Reads the scene's groups fresh, so a stale list can't drop any.
  Future<void> addSceneToGroup(String sceneId, String groupId) async {
    final current = await sceneGroups(sceneId);
    if (current.any((g) => g.groupId == groupId)) return;
    final index = await nextGroupIndex(groupId);
    await setSceneGroups(sceneId, [...current, (groupId: groupId, sceneIndex: index)]);
  }

  /// Removes [sceneId] from the group, keeping its other groups.
  Future<void> removeSceneFromGroup(String sceneId, String groupId) async {
    final current = await sceneGroups(sceneId);
    if (!current.any((g) => g.groupId == groupId)) return;
    await setSceneGroups(sceneId, [
      for (final g in current)
        if (g.groupId != groupId) g,
    ]);
  }

  Future<Group> createGroup(String name) async {
    final data = await _mutate(Options$Mutation$GroupCreate(variables: Variables$Mutation$GroupCreate(name: name)));
    final group = data.groupCreate;
    if (group == null) throw const StashApiException('Group was not created.', kind: StashErrorKind.notSaved);
    return Group.fromFields(group);
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
  /// When played scenes were played, from [since] on; null when the server
  /// has no play history (older Stash). Reads played scenes most recently
  /// played first, page by page, and stops at the first page without a
  /// play since [since] or after [PlayHistory.maxScenes] scenes.
  Future<PlayHistory?> playHistory({required DateTime since}) async {
    const perPage = 250;
    final plays = <DateTime>[];
    try {
      for (var page = 1; ; page++) {
        final data = await _query(
          Options$Query$PlayHistory(
            variables: Variables$Query$PlayHistory(
              filter: _findFilter(page: page, perPage: perPage, sort: 'last_played_at', direction: 'DESC'),
            ),
          ),
        );
        final result = data.findScenes;
        var recent = false;
        for (final scene in result.scenes) {
          for (final time in scene.play_history) {
            final played = DateTime.tryParse(time)?.toLocal();
            if (played == null || played.isBefore(since)) continue;
            plays.add(played);
            recent = true;
          }
        }
        final read = page * perPage;
        if (result.scenes.isEmpty || read >= result.count || !recent) break;
        if (read >= PlayHistory.maxScenes) return PlayHistory(plays, truncated: true);
      }
    } on StashApiException catch (e) {
      if (e.isNetworkError) rethrow;
      return null;
    }
    return PlayHistory(plays);
  }


  Future<SceneDetails> findSceneDetails(String sceneId) async {
    // Both at once; the end times are optional (older Stash has none).
    // Its error (a network error) is rethrown where awaited below, or not
    // reported when the details failed first.
    final ends = sceneMarkerEnds(sceneId)..ignore();
    final data = await _query(Options$Query$FindSceneDetails(variables: Variables$Query$FindSceneDetails(id: sceneId)));
    final scene = data.findScene;
    if (scene == null) throw const StashApiException('Scene not found.', kind: StashErrorKind.notFound);
    return SceneDetails.fromGraphql(scene).withMarkerEnds(await ends);
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

  Future<Performer> createPerformer(String name) async {
    final data =
        await _mutate(Options$Mutation$PerformerCreate(variables: Variables$Mutation$PerformerCreate(name: name)));
    final performer = data.performerCreate;
    if (performer == null) throw const StashApiException('Performer was not created.', kind: StashErrorKind.notSaved);
    return Performer.fromFields(performer);
  }

  Future<Studio> createStudio(String name) async {
    final data = await _mutate(Options$Mutation$StudioCreate(variables: Variables$Mutation$StudioCreate(name: name)));
    final studio = data.studioCreate;
    if (studio == null) throw const StashApiException('Studio was not created.', kind: StashErrorKind.notSaved);
    return Studio.fromFields(studio);
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
    double? endSeconds,
  }) async {
    final data = await _mutate(
      Options$Mutation$SceneMarkerCreate(
        variables: Variables$Mutation$SceneMarkerCreate(
          input: Input$SceneMarkerCreateInput(
            scene_id: sceneId,
            seconds: seconds,
            // Only sent when set: older servers reject the field.
            end_seconds: endSeconds,
            primary_tag_id: primaryTagId,
            title: title,
          ),
        ),
      ),
    );
    final marker = data.sceneMarkerCreate;
    if (marker == null) throw const StashApiException('Marker was not created.', kind: StashErrorKind.notSaved);
    return SceneMarker.fromFields(marker).withEnd(endSeconds);
  }

  Future<void> setPerformerFavorite(String performerId, bool favorite) => _mutate(
    Options$Mutation$PerformerSetFavorite(
      variables: Variables$Mutation$PerformerSetFavorite(id: performerId, favorite: favorite),
    ),
  );

  /// Whether the studio is a favorite; null when the server has no studio
  /// favorites (Stash before 0.25) or doesn't know the studio.
  Future<bool?> studioFavorite(String studioId) async {
    try {
      final data =
          await _query(Options$Query$StudioFavorite(variables: Variables$Query$StudioFavorite(id: studioId)));
      return data.findStudio?.favorite;
    } on StashApiException catch (e) {
      if (e.isNetworkError) rethrow;
      return null;
    }
  }

  Future<void> setStudioFavorite(String studioId, bool favorite) => _mutate(
    Options$Mutation$StudioSetFavorite(
      variables: Variables$Mutation$StudioSetFavorite(id: studioId, favorite: favorite),
    ),
  );

  /// [rating100] null removes the rating.
  Future<void> setPerformerRating(String performerId, int? rating100) => _mutate(
    Options$Mutation$PerformerSetRating(
      variables: Variables$Mutation$PerformerSetRating(id: performerId, rating100: rating100),
    ),
  );

  /// The studio's rating (its `rating100` null when unrated); null when the
  /// server has no studio ratings or doesn't know the studio.
  Future<({int? rating100})?> studioRating(String studioId) async {
    try {
      final data = await _query(Options$Query$StudioRating(variables: Variables$Query$StudioRating(id: studioId)));
      final studio = data.findStudio;
      return studio == null ? null : (rating100: studio.rating100);
    } on StashApiException catch (e) {
      if (e.isNetworkError) rethrow;
      return null;
    }
  }

  /// [rating100] null removes the rating.
  Future<void> setStudioRating(String studioId, int? rating100) => _mutate(
    Options$Mutation$StudioSetRating(
      variables: Variables$Mutation$StudioSetRating(id: studioId, rating100: rating100),
    ),
  );

  Future<List<ServerJob>> jobQueue() async => [
    for (final job in (await _query(Options$Query$JobQueue())).jobQueue ?? const <Fragment$JobFields>[])
      ServerJob.fromFields(job),
  ];

  Future<void> stopJob(String id) =>
      _mutate(Options$Mutation$StopJob(variables: Variables$Mutation$StopJob(job_id: id)));

  /// Scans all library paths; returns the job id.
  Future<String> scanLibrary(Set<ScanOption> options) async => (await _mutate(
    Options$Mutation$MetadataScan(
      variables: Variables$Mutation$MetadataScan(
        input: _input(
          {for (final o in ScanOption.values) o.key: options.contains(o)},
          Input$ScanMetadataInput.fromJson,
          (i) => i.toJson(),
        )!,
      ),
    ),
  )).metadataScan;

  /// Generates what's missing (no overwrite) for the whole library.
  Future<String> generate(Set<GenerateOption> options) async => (await _mutate(
    Options$Mutation$MetadataGenerate(
      variables: Variables$Mutation$MetadataGenerate(
        input: _input(
          {for (final o in GenerateOption.values) o.key: options.contains(o), 'overwrite': false},
          Input$GenerateMetadataInput.fromJson,
          (i) => i.toJson(),
        )!,
      ),
    ),
  )).metadataGenerate;

  /// Tags all files with every performer, studio and tag their paths name.
  Future<String> autoTag() async => (await _mutate(
    Options$Mutation$MetadataAutoTag(
      variables: Variables$Mutation$MetadataAutoTag(
        input: Input$AutoTagMetadataInput(performers: const ['*'], studios: const ['*'], tags: const ['*']),
      ),
    ),
  )).metadataAutoTag;

  /// Removes the entries of files that are gone from disk.
  Future<String> clean() async => (await _mutate(
    Options$Mutation$MetadataClean(
      variables: Variables$Mutation$MetadataClean(input: Input$CleanMetadataInput(dryRun: false)),
    ),
  )).metadataClean;

  /// Looks whether a few random scenes and markers have their previews
  /// generated: Stash names the preview URLs for every scene and answers
  /// 404 for missing files.
  Future<PreviewCheck> checkPreviews({int sample = 8}) async {
    final scenes = (await findScenes(SceneQuery(sort: SceneSort.random), perPage: sample)).items;
    final markers = (await findMarkers(MarkerQuery(sort: MarkerSort.random), perPage: sample ~/ 2)).items;
    Future<int> count(Iterable<String?> urls) async =>
        (await Future.wait(urls.map(_exists))).where((found) => found).length;
    final (animated, videos, markerAnimated) = await (
      count(scenes.map((s) => s.webpUrl)),
      count(scenes.map((s) => s.previewUrl)),
      count(markers.map((m) => m.previewUrl)),
    ).wait;
    return PreviewCheck(
      scenes: scenes.length,
      animated: animated,
      videos: videos,
      markers: markers.length,
      markerAnimated: markerAnimated,
    );
  }

  /// Whether the server has the file at [url]; asks for one byte only.
  Future<bool> _exists(String? url) async {
    if (url == null) return false;
    try {
      final response = await _http.get(Uri.parse(url), headers: {..._authHeaders, 'Range': 'bytes=0-0'});
      return response.statusCode == 200 || response.statusCode == 206;
    } catch (_) {
      return false;
    }
  }

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
    try {
      final data = await _send(request);
      _onReachability?.call(true);
      return data;
    } on StashApiException catch (e) {
      if (e.isNetworkError) _onReachability?.call(false);
      rethrow;
    }
  }

  /// The server's host, for telling a blocked local network apart.
  String? get _host => switch (_client.link) {
        HttpLink(:final uri) => uri.host,
        _ => null,
      };

  Future<T> _send<T>(Future<QueryResult<T>> Function() request) async {
    final QueryResult<T> result;
    try {
      result = await request();
    } catch (e) {
      throw unreachableException(e, host: _host, prefix: '');
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
        throw unreachableException(link.originalException ?? link, host: _host);
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
final stashRepositoryProvider = Provider<StashRepository>((ref) {
  final serverId = ref.watch(activeServerIdProvider);
  return StashRepository(
    ref.watch(graphQLClientProvider),
    authHeaders: ref.watch(serverConfigProvider)?.authHeaders ?? const {},
    httpClient: ref.watch(stashHttpClientProvider),
    // Read on each report, not watched: the status doesn't rebuild the
    // repository. Calls that end after a server switch report nothing.
    onReachability: (reachable) {
      if (ref.mounted && ref.read(activeServerIdProvider) == serverId) {
        ref.read(connectionStatusProvider.notifier).report(reachable: reachable);
      }
    },
  );
});
