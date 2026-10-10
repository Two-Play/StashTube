import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene_filter.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';

import '../fixtures.dart';

/// The repository through a real GraphQL client with the app's policies
/// (network only, normalized cache): responses go through the cache, which
/// resolves fragments by `__typename` (1.8).
void main() {
  late List<Request> sent;

  StashRepository repo(Map<String, Map<String, dynamic>> dataByOperation) {
    sent = [];
    return StashRepository(GraphQLClient(
      cache: GraphQLCache(),
      defaultPolicies: DefaultPolicies(query: Policies(fetch: FetchPolicy.networkOnly)),
      link: Link.function((request, [forward]) {
        sent.add(request);
        final data = dataByOperation[request.operation.operationName];
        return Stream.value(Response(data: {'__typename': 'Query', ...?data}, response: const {}));
      }),
    ));
  }

  Map<String, dynamic> page(String field, String resultType, String listField, List<Map<String, dynamic>> items) =>
      {field: {'__typename': resultType, 'count': items.length, listField: items}};

  test('lists and details resolve their fragments through the cache', () async {
    final r = repo({
      'FindScenes': page('findScenes', 'FindScenesResultType', 'scenes', [
        sceneJson({
          'id': '1',
          'title': 'Sunset',
          'studio': studioRefJson({'name': 'Studio A'}),
          'performers': [scenePerformerJson({'name': 'Alice', 'favorite': true})],
          'tags': [{'id': '3', 'name': 'Outdoor'}],
        }),
      ]),
      'FindPerformers': page('findPerformers', 'FindPerformersResultType', 'performers', [
        performerJson({'name': 'Bob', 'scene_count': 4}),
      ]),
      'FindStudio': {
        'findStudio': studioJson({
          'id': '2',
          'name': 'Label',
          'parent_studio': studioRefJson({'name': 'Network'}),
          'child_studios': [studioRefJson({'id': '5', 'name': 'Sub', 'scene_count': 2})],
        }),
      },
      'FindGalleries': page('findGalleries', 'FindGalleriesResultType', 'galleries', [galleryJson({'title': 'Trip'})]),
      'FindImages': page('findImages', 'FindImagesResultType', 'images', [
        imageJson({'performers': [performerRefJson({'name': 'Cleo'})]}),
      ]),
      'FindGroups': page('findGroups', 'FindGroupsResultType', 'groups', [groupJson({'name': 'Trilogy'})]),
      'FindTags': page('findTags', 'FindTagsResultType', 'tags', [tagJson({'name': 'Beach', 'scene_count': 7})]),
      'FindSceneDetails': {
        'findScene': sceneDetailsJson({
          'sceneStreams': [
            {'url': 'http://s/stream', 'mime_type': 'video/mp4', 'label': 'Direct stream'},
          ],
          'scene_markers': [markerJson({'title': 'Intro'})],
          'files': [videoFileJson({'path': '/a.mp4', 'height': 1080})],
        }),
      },
      'Stats': {'stats': statsJson({'scene_count': 12})},
    });

    final scene = (await r.findScenes(SceneQuery())).items.single;
    expect([scene.title, scene.studio?.name, scene.performers.single.name, scene.tags.single.name],
        ['Sunset', 'Studio A', 'Alice', 'Outdoor']);
    expect(scene.performers.single.favorite, isTrue);
    expect((await r.findPerformers(PerformerQuery())).items.single.sceneCount, 4);
    final studio = await r.findStudio('2');
    expect([studio.parent?.name, studio.children.single.name, studio.children.single.sceneCount], ['Network', 'Sub', 2]);
    expect((await r.findGalleries(GalleryQuery())).items.single.title, 'Trip');
    expect((await r.findImages(ImageQuery())).items.single.performers.single.name, 'Cleo');
    expect((await r.findGroups(const GroupQuery())).items.single.name, 'Trilogy');
    expect((await r.findTags(const TagQuery())).items.single.sceneCount, 7);
    final details = await r.findSceneDetails('1');
    expect([details.streams.single.label, details.markers.single.title, details.files.single.height],
        ['Direct stream', 'Intro', 1080]);
    expect((await r.libraryStats()).sceneCount, 12);
  });

  test('markers come with their tag and scene', () async {
    final r = repo({
      'FindSceneMarkers': page('findSceneMarkers', 'FindSceneMarkersResultType', 'scene_markers', [
        {
          '__typename': 'SceneMarker',
          'id': 'm1',
          'title': '',
          'seconds': 83.5,
          'end_seconds': null,
          'screenshot': 'http://s/scene/1/scene_marker/m1/screenshot',
          'preview': 'http://s/scene/1/scene_marker/m1/preview',
          'primary_tag': {'__typename': 'Tag', 'id': '3', 'name': 'Outdoor'},
          'scene': sceneJson({'id': '1', 'title': 'Sunset'}),
        },
      ]),
    });
    final result = await r.findMarkers(MarkerQuery(sort: MarkerSort.title));
    final marker = result.items.single;
    expect([marker.title, marker.seconds, marker.tag.id, marker.scene.title], ['Outdoor', 83.5, '3', 'Sunset']);
    expect(marker.screenshotUrl, 'http://s/scene/1/scene_marker/m1/screenshot');
    expect(marker.previewUrl, 'http://s/scene/1/scene_marker/m1/preview');
    expect(result.totalCount, 1);
    expect(sent.single.variables['filter'], containsPair('sort', 'title'));
  });

  test('filters are sent in the schema\'s input types', () async {
    final r = repo({'FindScenes': page('findScenes', 'FindScenesResultType', 'scenes', const [])});
    final saved = convertSavedSceneFilter({
      'organized': {'modifier': 'EQUALS', 'value': 'true'},
      'studios': {'modifier': 'IS_NULL', 'value': null},
    });
    await r.findScenes(SceneQuery(
      search: 'beach',
      sort: SceneSort.random,
      performerId: '4',
      studioId: '2',
      includeSubStudios: true,
      inProgressOnly: true,
      favoritePerformersOnly: true,
      playedOnly: true,
      filter: SceneFilter(
        tags: const [Tag(id: '7', name: 'x')],
        minStars: 3,
        duration: DurationFilter.medium,
        resolution: ResolutionFilter.fullHd,
        portraitOnly: true,
        savedFilter: saved.filter,
      ),
    ));
    final variables = sent.single.variables;
    expect(variables['filter'], containsPair('q', 'beach'));
    expect(variables['filter'], containsPair('direction', 'DESC'));
    expect(variables['scene_filter'], containsPair('organized', true));
    expect(variables['scene_filter'], containsPair('studios', {'value': ['2'], 'modifier': 'INCLUDES', 'depth': -1}));
    expect(variables['scene_filter'], containsPair('orientation', {'value': ['PORTRAIT']}));
  });

  test('performer, image and tag filters fit the schema too', () async {
    final r = repo({
      'FindPerformers': page('findPerformers', 'FindPerformersResultType', 'performers', const []),
      'FindImages': page('findImages', 'FindImagesResultType', 'images', const []),
    });
    await r.findPerformers(PerformerQuery(sort: PerformerSort.favorites));
    await r.findImages(ImageQuery(galleryId: '3', filter: const SceneFilter(minStars: 2)));
    expect(sent.first.variables['performer_filter'], {'filter_favorites': true});
    expect(sent.last.variables['image_filter'], containsPair('galleries', {'value': ['3'], 'modifier': 'INCLUDES'}));
  });
}
