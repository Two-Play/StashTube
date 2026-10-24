import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/scene_filter.dart';
import 'package:stash_app_mobile/data/models/server_task.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/demo/demo_library.dart';
import 'package:stash_app_mobile/features/demo/demo_server.dart';

/// The repository against the demo server's handler (no sockets), with the
/// bundled media from `assets/demo/`.
void main() {
  final media = DemoMedia.fromJson(
    jsonDecode(File('assets/demo/manifest.json').readAsStringSync()) as Map<String, dynamic>,
  );
  late DemoHandler handler;
  late StashRepository repo;

  setUp(() {
    final library = DemoLibrary(media)..baseUrl = ServerConfig.demoUrl;
    handler = DemoHandler(library, (path) async {
      final file = File('assets/demo/$path');
      return file.existsSync() ? file.readAsBytesSync() : null;
    });
    final client = MockClient((request) async {
      final response = await handler.handle(
        request.method,
        request.url,
        body: request.body,
        range: request.headers['range'],
      );
      return http.Response.bytes(
        response.body ?? const [],
        response.status,
        headers: {...response.headers, 'content-type': ?response.contentType},
      );
    });
    const config = ServerConfig(baseUrl: ServerConfig.demoUrl);
    repo = StashRepository(createGraphQLClient(config, httpClient: client), httpClient: client);
  });

  test('every clip, still and portrait the library names is bundled', () {
    for (final name in media.clips.keys) {
      for (final path in ['scenes/$name.mp4', 'covers/$name.jpg', 'previews/$name.webp', 'sprites/$name.jpg']) {
        expect(File('assets/demo/$path').existsSync(), isTrue, reason: path);
      }
    }
    for (final name in media.images) {
      expect(File('assets/demo/images/$name.jpg').existsSync(), isTrue, reason: name);
    }
    for (final name in ['big-buck-bunny', 'purple-bird', 'butterfly']) {
      expect(File('assets/demo/portraits/$name.jpg').existsSync(), isTrue, reason: name);
    }
  });

  test('lists, sorts and pages load', () async {
    expect(await repo.serverVersion(), 'demo');

    final all = await repo.findScenes(SceneQuery());
    expect(all.totalCount, 12);
    // Recently added: the shorts were added last.
    expect(all.items.first.title, 'Butterfly Hat');
    for (final sort in SceneSort.values) {
      expect((await repo.findScenes(SceneQuery(sort: sort))).items, hasLength(12), reason: '$sort');
    }
    final page2 = await repo.findScenes(SceneQuery(sort: SceneSort.title), page: 2, perPage: 5);
    expect(page2.items.map((s) => s.title), [
      'Opening Titles',
      'Rise and Shine',
      'Riverside',
      'Sunny Side Up',
      'The Burrow',
    ]);
    final shuffled = SceneQuery(sort: SceneSort.random, seed: 7);
    expect(
      (await repo.findScenes(shuffled)).items.map((s) => s.id),
      (await repo.findScenes(shuffled)).items.map((s) => s.id),
    );
    expect((await repo.findScenes(SceneQuery(search: 'bird'))).items.map((s) => s.title), [
      'Good Morning, Bird',
      'The Early Bird',
    ]);

    final scene = all.items.first;
    expect(scene.streamUrl, '${ServerConfig.demoUrl}/demo/scenes/short-butterfly.mp4');
    expect(scene.studio?.name, 'Peach Shorts');
    expect(scene.performers.map((p) => p.name), ['Big Buck Bunny', 'Butterfly']);
    expect(scene.height, greaterThan(scene.width!));
  });

  test('server tasks and the preview check', () async {
    expect(await repo.jobQueue(), isEmpty);
    expect(await repo.scanLibrary(ScanOption.standard), isNotEmpty);
    expect(await repo.generate(GenerateOption.standard), isNotEmpty);
    expect(await repo.autoTag(), isNotEmpty);
    expect(await repo.clean(), isNotEmpty);
    // The demo bundles every preview.
    final check = await repo.checkPreviews();
    expect(check.scenes, 8);
    expect(check.animated, 8);
    expect(check.videos, 8);
    expect(check.markers, 4);
    expect(check.markerAnimated, 4);
  });

  test('scene filters', () async {
    Future<List<String>> titles(SceneQuery query) async => [
      for (final s in (await repo.findScenes(query)).items) s.title,
    ];
    final shorts = SceneFilter(portraitOnly: true, maxSeconds: 60);
    expect(await titles(SceneQuery(filter: shorts)), hasLength(4));
    expect(await titles(SceneQuery(inProgressOnly: true, sort: SceneSort.lastPlayed)), [
      'Rise and Shine',
      'A Butterfly Appears',
    ]);
    expect(await titles(SceneQuery(playedOnly: true)), hasLength(3));
    expect(await titles(SceneQuery(favoritePerformersOnly: true)), hasLength(7));
    expect(await titles(SceneQuery(performerId: '2')), hasLength(3));
    expect(await titles(SceneQuery(studioId: '1')), isEmpty);
    expect(await titles(SceneQuery(studioId: '1', includeSubStudios: true)), hasLength(12));
    expect(await titles(SceneQuery(groupId: '1', sort: SceneSort.groupOrder)), hasLength(8));
    expect((await titles(SceneQuery(groupId: '1', sort: SceneSort.groupOrder))).first, 'Morning Sky');
    expect(await titles(SceneQuery(filter: const SceneFilter(minStars: 5))), hasLength(4));
    expect(await titles(SceneQuery(filter: const SceneFilter(resolution: ResolutionFilter.hd))), isEmpty);
    final tags = (await repo.findTags(const TagQuery())).items;
    final wildlife = tags.firstWhere((t) => t.name == 'Wildlife');
    final comedy = tags.firstWhere((t) => t.name == 'Comedy');
    expect(await titles(SceneQuery(filter: SceneFilter(tags: [wildlife, comedy]))), ['The Early Bird']);
    expect(await titles(SceneQuery(filter: SceneFilter(tags: [wildlife, comedy], anyTag: true))), hasLength(7));

    final saved = await repo.savedSceneFilters();
    expect(saved.map((f) => f.name), ['Shorts', 'Five stars']);
    expect(saved.expand((f) => f.unsupportedCriteria), isEmpty);
    final savedShorts = SceneFilter(savedFilter: saved.first.sceneFilter);
    expect(await titles(SceneQuery(filter: savedShorts)), hasLength(4));
  });

  test('details, markers, people, studios, tags, groups, galleries, images and stats', () async {
    final details = await repo.findSceneDetails('8');
    expect(details.streams.single.isDirect, isTrue);
    expect(details.markers.single.title, 'A visitor');
    expect(details.files.single.duration, greaterThan(10));
    final thumbs = await repo.scrubThumbnails(details);
    expect(thumbs!.cues, hasLength(details.files.single.duration!.ceil()));
    expect(thumbs.cues[6].x, 160);
    expect(thumbs.cues[6].y, 90);

    expect((await repo.findMarkers(MarkerQuery())).totalCount, 5);
    expect((await repo.findMarkers(MarkerQuery(search: 'butterfly'))).items.single.title, 'A visitor');

    final performers = await repo.findPerformers(PerformerQuery(sort: PerformerSort.mostScenes));
    expect(performers.items.first.name, 'Big Buck Bunny');
    expect((await repo.findPerformers(PerformerQuery(sort: PerformerSort.favorites))).items, hasLength(1));
    expect((await repo.findPerformer('1')).favorite, isTrue);
    expect(await repo.performerUrls('1'), isNotEmpty);

    expect((await repo.findStudios(const StudioQuery())).totalCount, 3);
    final blender = await repo.findStudio('1');
    expect(blender.children.map((s) => s.name), ['Peach Open Movie', 'Peach Shorts']);

    expect((await repo.findTags(const TagQuery())).items.first.name, 'Animation');
    expect((await repo.findTag('6')).name, 'Short');

    final group = await repo.findGroup('1');
    expect(group.sceneCount, 8);
    expect((await repo.findGroups(const GroupQuery())).items.single.name, group.name);

    final gallery = (await repo.findGalleries(GalleryQuery())).items.single;
    expect(gallery.imageCount, media.images.length);
    expect((await repo.findGallery(gallery.id)).title, 'Stills');
    final images = await repo.findImages(ImageQuery(galleryId: gallery.id, sort: ImageSort.path));
    expect(images.totalCount, media.images.length);
    expect(images.items.first.imageUrl, '${ServerConfig.demoUrl}/demo/images/${media.images.first}.jpg');

    final stats = await repo.libraryStats();
    expect(stats.sceneCount, 12);
    final activity = await repo.activityStats();
    expect(activity!.scenesPlayed, 3);
  });

  test('edits last while the app runs', () async {
    await repo.setSceneRating('1', 20);
    final edited = await repo.updateScene('1', {
      'title': 'Pink Clouds',
      'performer_ids': ['1'],
    });
    expect(edited.title, 'Pink Clouds');
    expect(edited.rating100, 20);
    expect(edited.performers.single.name, 'Big Buck Bunny');

    final tag = await repo.createTag('Clouds');
    expect((await repo.setSceneTags('1', [tag.id])).single.name, 'Clouds');
    expect((await repo.findTag(tag.id)).sceneCount, 1);

    expect(await repo.addSceneO('1'), 1);
    expect(await repo.removeSceneO('1'), 0);

    final marker = await repo.createMarker(sceneId: '1', seconds: 4, primaryTagId: tag.id, title: 'Clouds');
    expect((await repo.findSceneDetails('1')).markers.single.id, marker.id);

    await repo.setPerformerFavorite('2', true);
    expect((await repo.findPerformers(PerformerQuery(sort: PerformerSort.favorites))).items, hasLength(2));
    expect((await repo.updatePerformer('3', {'details': 'Pink'})).details, 'Pink');
    expect((await repo.updateStudio('3', {'name': 'Shorts'})).name, 'Shorts');
    expect((await repo.updateTag(tag.id, {'description': 'Sky'})).description, 'Sky');
    expect((await repo.updateGallery('1', {'title': 'Frames'})).title, 'Frames');

    await repo.addPlay('2');
    await repo.saveActivity('2', resumeTime: 3, playDuration: 3);
    final played = await repo.findScenesByIds(['2']);
    expect(played.single.playCount, 1);
    expect(played.single.resumeTime, 3);
  });

  test('media with byte ranges, for the player', () async {
    final uri = Uri.parse('${ServerConfig.demoUrl}/demo/scenes/riverside.mp4');
    final whole = await handler.handle('GET', uri);
    expect(whole.status, HttpStatus.ok);
    expect(whole.contentType, 'video/mp4');
    final size = whole.body!.length;

    final part = await handler.handle('GET', uri, range: 'bytes=100-199');
    expect(part.status, HttpStatus.partialContent);
    expect(part.body, whole.body!.sublist(100, 200));
    expect(part.headers['Content-Range'], 'bytes 100-199/$size');

    final tail = await handler.handle('GET', uri, range: 'bytes=-10');
    expect(tail.body, whole.body!.sublist(size - 10));
    expect((await handler.handle('GET', uri, range: 'bytes=$size-')).status, HttpStatus.requestedRangeNotSatisfiable);

    expect((await handler.handle('GET', Uri.parse('${ServerConfig.demoUrl}/demo/scenes/none.mp4'))).status, 404);
    expect((await handler.handle('GET', Uri.parse('${ServerConfig.demoUrl}/demo/../pubspec.yaml'))).status, 404);
  });
}
