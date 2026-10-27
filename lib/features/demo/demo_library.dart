import 'dart:math';

import 'demo_graphql.dart';

/// Facts about a demo clip, from `assets/demo/manifest.json`
/// (`tool/demo/make_demo_assets.sh`).
class DemoClip {
  const DemoClip({
    required this.duration,
    required this.size,
    required this.width,
    required this.height,
    this.videoCodec = 'h264',
    this.audioCodec = 'aac',
    this.frameRate = 24,
    this.bitRate = 0,
  });

  factory DemoClip.fromJson(Map<String, dynamic> json) => DemoClip(
    duration: (json['duration'] as num).toDouble(),
    size: json['size'] as int,
    width: json['width'] as int,
    height: json['height'] as int,
    videoCodec: json['video_codec'] as String,
    audioCodec: json['audio_codec'] as String,
    frameRate: (json['frame_rate'] as num).toDouble(),
    bitRate: json['bit_rate'] as int,
  );

  final double duration;
  final int size;
  final int width;
  final int height;
  final String videoCodec;
  final String audioCodec;
  final double frameRate;
  final int bitRate;
}

class DemoMedia {
  const DemoMedia({required this.clips, required this.images});

  factory DemoMedia.fromJson(Map<String, dynamic> json) => DemoMedia(
    clips: {
      for (final MapEntry(:key, :value) in (json['clips'] as Map<String, dynamic>).entries)
        key: DemoClip.fromJson(value as Map<String, dynamic>),
    },
    images: [for (final i in json['images'] as List) i as String],
  );

  /// By file name (without extension).
  final Map<String, DemoClip> clips;

  /// Still images, by file name (without extension).
  final List<String> images;
}

/// The demo's seek sprites: one frame per second, this many per row.
const demoSpriteColumns = 5;

/// The built-in demo library: scenes from Blender's open movie Big Buck
/// Bunny (CC BY 3.0) with performers, studios, tags, markers, a group, a
/// gallery and some watch history, kept in memory. Answers the app's
/// GraphQL documents through [graphql] like a Stash server would, filters,
/// sorts and pages included; edits last until the app is closed.
class DemoLibrary {
  DemoLibrary(this.media, {DateTime? now}) : _now = now ?? DateTime.now() {
    _seed();
  }

  final DemoMedia media;
  final DateTime _now;

  /// Where the demo server serves the media, e.g. `http://127.0.0.1:47999`.
  String baseUrl = '';

  late final graphql = DemoGraphql(query: _queryRoot(), mutation: _mutationRoot());

  final _studios = <_Studio>[];
  final _performers = <_Performer>[];
  final _tags = <_Tag>[];
  final _scenes = <_Scene>[];
  final _markers = <_Marker>[];
  final _groups = <_Group>[];
  final _galleries = <_Gallery>[];
  final _images = <_Image>[];
  var _nextId = 100;

  static const _filmDate = '2008-05-30';

  /// A still's file size in bytes, roughly (they are 10 to 40 kB).
  static const _imageSize = 60000;
  static const _filmUrl = 'https://studio.blender.org/films/big-buck-bunny/';
  static const _credit = 'From Big Buck Bunny, the open movie by the Blender Foundation (CC BY 3.0).';

  void _seed() {
    final blender = _Studio(
      '1',
      'Blender Studio',
      details: 'Makers of open movies.',
      url: 'https://studio.blender.org',
    );
    final peach = _Studio('2', 'Peach Open Movie', parentId: '1', url: _filmUrl, details: _credit);
    final shorts = _Studio('3', 'Peach Shorts', parentId: '1', details: 'Portrait clips from Big Buck Bunny.');
    _studios.addAll([blender, peach, shorts]);

    _performers.addAll([
      _Performer(
        '1',
        'Big Buck Bunny',
        image: 'big-buck-bunny',
        favorite: true,
        rating100: 100,
        country: 'NL',
        birthdate: _filmDate,
        details: 'A big, friendly rabbit who loves sunny mornings and flowers.',
        urls: [_filmUrl],
        aliases: ['Bunny'],
        heightCm: 180,
        hairColor: 'Grey',
        eyeColor: 'Brown',
        career: '2008 -',
      ),
      _Performer('2', 'Purple Bird', image: 'purple-bird', rating100: 80, details: 'Always the first one awake.'),
      _Performer('3', 'Butterfly', image: 'butterfly', rating100: 80, disambiguation: 'pink'),
    ]);

    const tagNames = ['Animation', 'Nature', 'Morning', 'Comedy', 'Wildlife', 'Short'];
    for (final (i, name) in tagNames.indexed) {
      _tags.add(_Tag('${i + 1}', name));
    }
    String tag(String name) => _tags.firstWhere((t) => t.name == name).id;

    // file, title, studio, performers, tags, rating
    final scenes = [
      ('morning-sky', 'Morning Sky', '2', <String>[], ['Animation', 'Nature', 'Morning'], 80),
      ('riverside', 'Riverside', '2', <String>[], ['Animation', 'Nature'], 60),
      ('the-early-bird', 'The Early Bird', '2', ['2'], ['Animation', 'Morning', 'Wildlife', 'Comedy'], 100),
      ('opening-titles', 'Opening Titles', '2', ['2'], ['Animation'], 60),
      ('the-burrow', 'The Burrow', '2', ['1'], ['Animation', 'Nature', 'Morning'], 80),
      ('rise-and-shine', 'Rise and Shine', '2', ['1'], ['Animation', 'Morning', 'Comedy'], 100),
      ('sunny-side', 'Sunny Side Up', '2', ['1'], ['Animation', 'Nature', 'Comedy'], 80),
      ('a-butterfly-appears', 'A Butterfly Appears', '2', ['1', '3'], ['Animation', 'Nature', 'Wildlife'], 100),
      ('short-bird', 'Good Morning, Bird', '3', ['2'], ['Animation', 'Short', 'Comedy'], 80),
      ('short-wake-up', 'Who\'s in There?', '3', ['1'], ['Animation', 'Short'], 60),
      ('short-stretch', 'Big Stretch', '3', ['1'], ['Animation', 'Short', 'Comedy'], 100),
      ('short-butterfly', 'Butterfly Hat', '3', ['1', '3'], ['Animation', 'Short', 'Wildlife'], 80),
    ];
    for (final (i, (file, title, studio, performers, tags, rating)) in scenes.indexed) {
      final clip = media.clips[file];
      if (clip == null) continue;
      _scenes.add(
        _Scene(
          '${i + 1}',
          file,
          clip,
          title: title,
          studioId: studio,
          performerIds: performers,
          tagIds: [for (final t in tags) tag(t)],
          rating100: rating,
          // The film's order, the shorts last: "recently added" starts with them.
          createdAt: _now.subtract(Duration(hours: 12 * (scenes.length - i))),
          groupIndex: studio == '2' ? i + 1 : null,
        ),
      );
    }

    // Some watch history: (scene, resume position, plays as hours ago, the
    // last play first), spread over the stats' watch chart (12 weeks).
    for (final (id, resume, hoursAgo) in [
      ('6', 5.0, [3, 30, 75, 200, 340, 510, 700, 900, 1300]),
      ('3', 0.0, [26, 120, 260, 610, 1100, 1800]),
      ('8', 8.0, [50, 170, 420, 800]),
    ]) {
      final scene = _scene(id);
      if (scene == null) continue;
      scene
        ..resumeTime = resume
        ..playHistory = [for (final h in hoursAgo.reversed) _now.subtract(Duration(hours: h))]
        ..playCount = hoursAgo.length
        ..playDuration = hoursAgo.length * scene.clip.duration
        ..lastPlayedAt = _now.subtract(Duration(hours: hoursAgo.first));
    }

    // scene, seconds, end (ranged markers, newer Stash), title, tag
    final markers = [
      ('3', 2.0, null, 'Chirp', 'Wildlife'),
      ('5', 6.0, null, 'Something stirs', 'Nature'),
      ('6', 3.0, 7.0, 'The big stretch', 'Comedy'),
      ('7', 8.0, null, 'Flowers', 'Nature'),
      ('8', 9.0, 15.0, 'A visitor', 'Wildlife'),
      // In a portrait short, for the shorts' "portrait videos only".
      ('11', 1.0, 4.0, 'Reaching up', 'Comedy'),
    ];
    for (final (i, (scene, seconds, end, title, t)) in markers.indexed) {
      if (_scene(scene) == null) continue;
      _markers.add(
        _Marker(
          '${i + 1}',
          scene,
          seconds,
          title,
          tag(t),
          endSeconds: end,
          createdAt: _now.subtract(Duration(hours: 6 * (markers.length - i))),
        ),
      );
    }

    _groups.add(
      _Group(
        '1',
        'Big Buck Bunny: The Opening',
        studioId: '2',
        cover: 'rise-and-shine',
        date: _filmDate,
        synopsis: 'The opening of the film, scene by scene.',
      ),
    );

    for (final (i, file) in media.images.indexed) {
      _images.add(
        _Image(
          '${i + 1}',
          file,
          title: 'Still ${i + 1}',
          studioId: '2',
          galleryIds: ['1'],
          performerIds: ['1'],
          tagIds: [tag('Animation')],
          rating100: i.isEven ? 80 : null,
          createdAt: _now.subtract(Duration(hours: i)),
        ),
      );
    }
    _galleries.add(
      _Gallery('1', 'Stills', studioId: '2', performerIds: ['1'], details: _credit, cover: media.images.firstOrNull),
    );
  }

  String _newId() => '${_nextId++}';

  _Scene? _scene(Object? id) => _scenes.where((s) => s.id == id).firstOrNull;

  // --- URLs ---------------------------------------------------------------

  String _media(String path) => '$baseUrl/demo/$path';

  /// The WebVTT for a scene's seek sprite (served by the demo server).
  String? spriteVtt(String file) {
    final clip = media.clips[file];
    if (clip == null) return null;
    final portrait = clip.height > clip.width;
    final (w, h) = portrait ? (90, 160) : (160, 90);
    String time(int s) => '00:${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}.000';
    final out = StringBuffer('WEBVTT\n');
    for (var s = 0; s < clip.duration.ceil(); s++) {
      final x = (s % demoSpriteColumns) * w;
      final y = (s ~/ demoSpriteColumns) * h;
      out.write('\n${time(s)} --> ${time(s + 1)}\n$file.jpg#xywh=$x,$y,$w,$h\n');
    }
    return out.toString();
  }

  // --- Objects --------------------------------------------------------------

  Map<String, Object?> _studioObject(_Studio s) => {
    '__typename': 'Studio',
    'id': s.id,
    'name': s.name,
    'image_path': null,
    'url': s.url,
    'details': s.details,
    'favorite': s.favorite,
    'rating100': s.rating100,
    'scene_count': (Map<String, dynamic> _) => _scenes.where((sc) => sc.studioId == s.id).length,
    'image_count': (Map<String, dynamic> args) =>
        _images.where((i) => _inStudio(i.studioId, s.id, deep: args['depth'] == -1)).length,
    'gallery_count': (Map<String, dynamic> args) =>
        _galleries.where((g) => _inStudio(g.studioId, s.id, deep: args['depth'] == -1)).length,
    'parent_studio': (Map<String, dynamic> _) =>
        _studios.where((p) => p.id == s.parentId).map(_studioObject).firstOrNull,
    'child_studios': (Map<String, dynamic> _) => _studios.where((c) => c.parentId == s.id).map(_studioObject).toList(),
  };

  Map<String, Object?> _performerObject(_Performer p) => {
    '__typename': 'Performer',
    'id': p.id,
    'name': p.name,
    'disambiguation': p.disambiguation,
    'image_path': p.image == null ? null : _media('portraits/${p.image}.jpg'),
    'country': p.country,
    'birthdate': p.birthdate,
    'gender': p.gender,
    'favorite': p.favorite,
    'rating100': p.rating100,
    'details': p.details,
    'urls': p.urls,
    'alias_list': p.aliases,
    'death_date': null,
    'ethnicity': null,
    'hair_color': p.hairColor,
    'eye_color': p.eyeColor,
    'height_cm': p.heightCm,
    'weight': null,
    'measurements': null,
    'career_length': p.career,
    'tattoos': null,
    'piercings': null,
    'scene_count': (Map<String, dynamic> _) => _scenes.where((s) => s.performerIds.contains(p.id)).length,
    'image_count': (Map<String, dynamic> _) => _images.where((i) => i.performerIds.contains(p.id)).length,
    'gallery_count': (Map<String, dynamic> _) => _galleries.where((g) => g.performerIds.contains(p.id)).length,
  };

  Map<String, Object?> _tagObject(_Tag t) => {
    '__typename': 'Tag',
    'id': t.id,
    'name': t.name,
    'description': t.description,
    'image_path': null,
    'scene_count': (Map<String, dynamic> _) => _scenes.where((s) => s.tagIds.contains(t.id)).length,
  };

  Map<String, Object?> _sceneObject(_Scene s) {
    final stream = _media('scenes/${s.file}.mp4');
    return {
      '__typename': 'Scene',
      'id': s.id,
      'title': s.title,
      'details': s.details,
      'date': s.date,
      'created_at': s.createdAt.toUtc().toIso8601String(),
      'rating100': s.rating100,
      'play_count': s.playCount,
      'play_history': [for (final t in s.playHistory) t.toUtc().toIso8601String()],
      'o_counter': s.oCounter,
      'resume_time': s.resumeTime,
      'organized': s.organized,
      'urls': s.urls,
      'files': [
        {
          '__typename': 'VideoFile',
          'basename': '${s.file}.mp4',
          'path': '/demo/${s.file}.mp4',
          'size': s.clip.size,
          'format': 'mp4',
          'duration': s.clip.duration,
          'width': s.clip.width,
          'height': s.clip.height,
          'video_codec': s.clip.videoCodec,
          'audio_codec': s.clip.audioCodec,
          'frame_rate': s.clip.frameRate,
          'bit_rate': s.clip.bitRate,
          'mod_time': s.createdAt.toUtc().toIso8601String(),
        },
      ],
      'paths': {
        '__typename': 'ScenePathsType',
        'screenshot': _media('covers/${s.file}.jpg'),
        'preview': stream,
        'webp': _media('previews/${s.file}.webp'),
        'stream': stream,
        'sprite': _media('sprites/${s.file}.jpg'),
        'vtt': _media('vtt/${s.file}.vtt'),
      },
      'sceneStreams': [
        {'__typename': 'SceneStreamEndpoint', 'url': stream, 'mime_type': 'video/mp4', 'label': 'Direct stream'},
      ],
      'studio': (Map<String, dynamic> _) => _studios.where((st) => st.id == s.studioId).map(_studioObject).firstOrNull,
      'performers': (Map<String, dynamic> _) => [
        for (final id in s.performerIds) ..._performers.where((p) => p.id == id).map(_performerObject),
      ],
      'tags': (Map<String, dynamic> _) => [
        for (final id in s.tagIds) ..._tags.where((t) => t.id == id).map(_tagObject),
      ],
      'groups': (Map<String, dynamic> _) => [
        for (final MapEntry(key: id, value: index) in s.groups.entries)
          for (final g in _groups.where((g) => g.id == id))
            {'__typename': 'SceneGroup', 'group': _groupObject(g), 'scene_index': index},
      ],
      'scene_markers': (Map<String, dynamic> _) =>
          (_markers.where((m) => m.sceneId == s.id).toList()..sort((a, b) => a.seconds.compareTo(b.seconds)))
              .map(_markerObject)
              .toList(),
    };
  }

  Map<String, Object?> _markerObject(_Marker m) {
    final scene = _scene(m.sceneId)!;
    return {
      '__typename': 'SceneMarker',
      'id': m.id,
      'title': m.title,
      'seconds': m.seconds,
      'end_seconds': m.endSeconds,
      'screenshot': _media('covers/${scene.file}.jpg'),
      'preview': _media('previews/${scene.file}.webp'),
      'primary_tag': (Map<String, dynamic> _) => _tagObject(_tags.firstWhere((t) => t.id == m.tagId)),
      'scene': (Map<String, dynamic> _) => _sceneObject(scene),
    };
  }

  /// The group's scenes, in order (scenes without a position last).
  Iterable<_Scene> _groupScenes(_Group g) {
    final scenes = _scenes.where((s) => s.groups.containsKey(g.id)).toList();
    final indexed = scenes.indexed.toList()
      ..sort((a, b) {
        final (ia, ib) = (a.$2.groups[g.id], b.$2.groups[g.id]);
        if (ia == null || ib == null) return ia == ib ? a.$1.compareTo(b.$1) : (ia == null ? 1 : -1);
        final c = ia.compareTo(ib);
        return c != 0 ? c : a.$1.compareTo(b.$1);
      });
    return indexed.map((e) => e.$2);
  }

  Map<String, Object?> _groupObject(_Group g) => {
    '__typename': 'Group',
    'id': g.id,
    'name': g.name,
    'date': g.date,
    'duration': _groupScenes(g).fold<double>(0, (sum, s) => sum + s.clip.duration).round(),
    'front_image_path': g.cover == null ? null : _media('covers/${g.cover}.jpg'),
    'synopsis': g.synopsis,
    'scene_count': (Map<String, dynamic> _) => _groupScenes(g).length,
    'studio': (Map<String, dynamic> _) => _studios.where((s) => s.id == g.studioId).map(_studioObject).firstOrNull,
  };

  Map<String, Object?> _galleryObject(_Gallery g) => {
    '__typename': 'Gallery',
    'id': g.id,
    'title': g.title,
    'date': g.date,
    'details': g.details,
    'urls': g.urls,
    'image_count': (Map<String, dynamic> _) => _images.where((i) => i.galleryIds.contains(g.id)).length,
    'paths': {'__typename': 'GalleryPathsType', 'cover': g.cover == null ? '' : _media('images/${g.cover}.jpg')},
    'files': const <Object>[],
    'folder': null,
    'studio': (Map<String, dynamic> _) => _studios.where((s) => s.id == g.studioId).map(_studioObject).firstOrNull,
    'performers': (Map<String, dynamic> _) => [
      for (final id in g.performerIds) ..._performers.where((p) => p.id == id).map(_performerObject),
    ],
  };

  Map<String, Object?> _imageObject(_Image i) => {
    '__typename': 'Image',
    'id': i.id,
    'title': i.title,
    'date': _filmDate,
    'rating100': i.rating100,
    'code': null,
    'details': _credit,
    'photographer': 'Blender Foundation',
    'o_counter': 0,
    'organized': true,
    'created_at': i.createdAt.toUtc().toIso8601String(),
    'updated_at': i.createdAt.toUtc().toIso8601String(),
    // The stills are 640 × 360 JPEGs (tool/demo/make_demo_assets.sh).
    'visual_files': [
      {
        '__typename': 'ImageFile',
        'path': '/demo/images/${i.file}.jpg',
        'basename': '${i.file}.jpg',
        'size': _imageSize,
        'format': 'jpeg',
        'width': 640,
        'height': 360,
      },
    ],
    'tags': (Map<String, dynamic> _) => [
      for (final id in i.tagIds) ..._tags.where((t) => t.id == id).map(_tagObject),
    ],
    'galleries': (Map<String, dynamic> _) => [
      for (final id in i.galleryIds) ..._galleries.where((g) => g.id == id).map(_galleryObject),
    ],
    'paths': {
      '__typename': 'ImagePathsType',
      'thumbnail': _media('images/${i.file}.jpg'),
      'image': _media('images/${i.file}.jpg'),
    },
    'studio': (Map<String, dynamic> _) => _studios.where((s) => s.id == i.studioId).map(_studioObject).firstOrNull,
    'performers': (Map<String, dynamic> _) => [
      for (final id in i.performerIds) ..._performers.where((p) => p.id == id).map(_performerObject),
    ],
  };

  // --- Queries --------------------------------------------------------------

  Map<String, Object?> _queryRoot() => {
    '__typename': 'Query',
    'systemStatus': {'__typename': 'SystemStatus', 'status': 'OK'},
    'jobQueue': const <Object>[],
    'version': {'__typename': 'Version', 'version': 'demo'},
    'findScenes': (Map<String, dynamic> args) {
      final ids = (args['ids'] as List?)?.map((e) => '$e').toSet();
      final filter = args['scene_filter'] as Map<String, dynamic>?;
      final matching = _scenes.where((s) => (ids == null || ids.contains(s.id)) && _sceneMatches(s, filter));
      // Group order is the position in the filtered group.
      final groupId = ((filter?['groups'] as Map?)?['value'] as List?)?.firstOrNull?.toString();
      final page = _page(
        matching,
        args['filter'],
        text: (s) => '${s.title} ${s.details}',
        sortKey: (s, sort) => _sceneSortKey(s, sort, groupId),
      );
      return {
        '__typename': 'FindScenesResultType',
        'count': page.count,
        'scenes': page.items.map(_sceneObject).toList(),
      };
    },
    'findScene': (Map<String, dynamic> args) {
      final scene = _scene(args['id']);
      return scene == null ? null : _sceneObject(scene);
    },
    'findSceneMarkers': (Map<String, dynamic> args) {
      // Markers have the performers of their scene (as in Stash).
      final filter = args['scene_marker_filter'] as Map<String, dynamic>?;
      final ids = (args['ids'] as List?)?.map((id) => '$id').toSet();
      final tagIds = ((filter?['tags'] as Map<String, dynamic>?)?['value'] as List?)?.cast<String>();
      final matching = _markers.where((m) {
        if (ids != null && !ids.contains(m.id)) return false;
        if (tagIds != null && !tagIds.contains(m.tagId)) return false;
        if (filter == null) return true;
        final scene = _scene(m.sceneId);
        return scene != null &&
            _ids(filter['performers'], scene.performerIds) &&
            _sceneMatches(scene, filter['scene_filter'] as Map<String, dynamic>?);
      });
      final page = _page(
        matching,
        args['filter'],
        text: (m) => '${m.title} ${_scene(m.sceneId)?.title}',
        sortKey: (m, sort) => switch (sort) {
          'title' => m.title.toLowerCase(),
          'seconds' => m.seconds,
          _ => m.createdAt,
        },
      );
      return {
        '__typename': 'FindSceneMarkersResultType',
        'count': page.count,
        'scene_markers': page.items.map(_markerObject).toList(),
      };
    },
    'findPerformers': (Map<String, dynamic> args) {
      final filter = args['performer_filter'] as Map<String, dynamic>?;
      final favoritesOnly = filter?['filter_favorites'] == true;
      final page = _page(
        _performers.where((p) => !favoritesOnly || p.favorite),
        args['filter'],
        text: (p) => p.name,
        sortKey: (p, sort) => switch (sort) {
          'scenes_count' => _scenes.where((s) => s.performerIds.contains(p.id)).length,
          'rating' => p.rating100 ?? 0,
          _ => p.name.toLowerCase(),
        },
      );
      return {
        '__typename': 'FindPerformersResultType',
        'count': page.count,
        'performers': page.items.map(_performerObject).toList(),
      };
    },
    'findPerformer': (Map<String, dynamic> args) =>
        _performers.where((p) => p.id == args['id']).map(_performerObject).firstOrNull,
    'findStudios': (Map<String, dynamic> args) {
      final page = _page(_studios, args['filter'], text: (s) => s.name, sortKey: (s, _) => s.name.toLowerCase());
      return {
        '__typename': 'FindStudiosResultType',
        'count': page.count,
        'studios': page.items.map(_studioObject).toList(),
      };
    },
    'findStudio': (Map<String, dynamic> args) =>
        _studios.where((s) => s.id == args['id']).map(_studioObject).firstOrNull,
    'findTags': (Map<String, dynamic> args) {
      final filter = args['tag_filter'] as Map<String, dynamic>?;
      int count(_Tag t) => _scenes.where((s) => s.tagIds.contains(t.id)).length;
      final page = _page(
        _tags.where((t) => _number(filter?['scene_count'], count(t))),
        args['filter'],
        text: (t) => t.name,
        sortKey: (t, sort) => switch (sort) {
          'scenes_count' => count(t),
          'created_at' => int.parse(t.id),
          _ => t.name.toLowerCase(),
        },
      );
      return {'__typename': 'FindTagsResultType', 'count': page.count, 'tags': page.items.map(_tagObject).toList()};
    },
    'findTag': (Map<String, dynamic> args) => _tags.where((t) => t.id == args['id']).map(_tagObject).firstOrNull,
    'findGroups': (Map<String, dynamic> args) {
      final page = _page(_groups, args['filter'], text: (g) => g.name, sortKey: (g, _) => g.name.toLowerCase());
      return {
        '__typename': 'FindGroupsResultType',
        'count': page.count,
        'groups': page.items.map(_groupObject).toList(),
      };
    },
    'findGroup': (Map<String, dynamic> args) => _groups.where((g) => g.id == args['id']).map(_groupObject).firstOrNull,
    'findGalleries': (Map<String, dynamic> args) {
      final filter = args['gallery_filter'] as Map<String, dynamic>?;
      final page = _page(
        _galleries.where(
          (g) =>
              _ids(filter?['performers'], g.performerIds) &&
              _ids(filter?['studios'], _studioIds(g.studioId, filter?['studios'])),
        ),
        args['filter'],
        text: (g) => g.title,
        sortKey: (g, sort) => switch (sort) {
          'images_count' => _images.where((i) => i.galleryIds.contains(g.id)).length,
          _ => g.title.toLowerCase(),
        },
      );
      return {
        '__typename': 'FindGalleriesResultType',
        'count': page.count,
        'galleries': page.items.map(_galleryObject).toList(),
      };
    },
    'findGallery': (Map<String, dynamic> args) =>
        _galleries.where((g) => g.id == args['id']).map(_galleryObject).firstOrNull,
    'findImage': (Map<String, dynamic> args) => _images.where((i) => i.id == args['id']).map(_imageObject).firstOrNull,
    'findImages': (Map<String, dynamic> args) {
      final filter = args['image_filter'] as Map<String, dynamic>?;
      final page = _page(
        _images.where(
          (i) =>
              _ids(filter?['galleries'], i.galleryIds) &&
              _ids(filter?['performers'], i.performerIds) &&
              _ids(filter?['studios'], _studioIds(i.studioId, filter?['studios'])) &&
              _ids(filter?['tags'], i.tagIds) &&
              _number(filter?['rating100'], i.rating100) &&
              _resolution(filter?['resolution'], 480),
        ),
        args['filter'],
        text: (i) => i.title,
        sortKey: (i, sort) => switch (sort) {
          'title' || 'path' => i.file,
          'rating' => i.rating100 ?? 0,
          _ => i.createdAt,
        },
      );
      return {
        '__typename': 'FindImagesResultType',
        'count': page.count,
        'images': page.items.map(_imageObject).toList(),
      };
    },
    'findSavedFilters': (Map<String, dynamic> args) => [
      _savedFilter('1', 'Shorts', {
        'tags': {
          'modifier': 'INCLUDES',
          'value': {
            'items': [
              {'id': _tags.firstWhere((t) => t.name == 'Short').id, 'label': 'Short'},
            ],
            'excluded': <Object>[],
            'depth': 0,
          },
        },
      }),
      _savedFilter('2', 'Five stars', {
        'rating100': {
          'modifier': 'GREATER_THAN',
          'value': {'value': 80},
        },
      }, sort: 'date'),
    ],
    'stats': (Map<String, dynamic> _) => {
      '__typename': 'StatsResultType',
      'scene_count': _scenes.length,
      'scenes_size': _scenes.fold<double>(0, (sum, s) => sum + s.clip.size),
      'scenes_duration': _scenes.fold<double>(0, (sum, s) => sum + s.clip.duration),
      'image_count': _images.length,
      'images_size': _images.length * _imageSize.toDouble(),
      'gallery_count': _galleries.length,
      'performer_count': _performers.length,
      'studio_count': _studios.length,
      'tag_count': _tags.length,
      'total_play_count': _scenes.fold<int>(0, (sum, s) => sum + s.playCount),
      'total_play_duration': _scenes.fold<double>(0, (sum, s) => sum + s.playDuration),
      'scenes_played': _scenes.where((s) => s.playCount > 0).length,
      'total_o_count': _scenes.fold<int>(0, (sum, s) => sum + s.oCounter),
    },
  };

  Map<String, Object?> _savedFilter(String id, String name, Map<String, dynamic> objectFilter, {String? sort}) => {
    '__typename': 'SavedFilter',
    'id': id,
    'name': name,
    'find_filter': {
      '__typename': 'SavedFindFilterType',
      'q': null,
      'sort': sort,
      'direction': sort == null ? null : 'DESC',
    },
    'object_filter': objectFilter,
  };

  static Object? _sceneSortKey(_Scene s, String sort, [String? groupId]) => switch (sort) {
    'date' => s.date,
    'rating' => s.rating100 ?? 0,
    'play_count' => s.playCount,
    'last_played_at' => s.lastPlayedAt?.millisecondsSinceEpoch ?? 0,
    'title' => s.title.toLowerCase(),
    'group_scene_number' => (groupId == null ? s.groups.values.nonNulls.firstOrNull : s.groups[groupId]) ?? 0,
    'duration' => s.clip.duration,
    _ => s.createdAt,
  };

  bool _sceneMatches(_Scene s, Map<String, dynamic>? f) {
    if (f == null) return true;
    final studios = f['studios'] as Map<String, dynamic>?;
    final studioIds = [?s.studioId];
    if (studios != null && studios['depth'] == -1) {
      // With sub-studios: the scene's studio and every parent above it.
      for (var parent = _studioParent(s.studioId); parent != null; parent = _studioParent(parent)) {
        studioIds.add(parent);
      }
    }
    final orientation = f['orientation'] as Map<String, dynamic>?;
    final shape = s.clip.height > s.clip.width
        ? 'PORTRAIT'
        : s.clip.height == s.clip.width
        ? 'SQUARE'
        : 'LANDSCAPE';
    final matches =
        _ids(f['tags'], s.tagIds) &&
        _ids(f['performers'], s.performerIds) &&
        _ids(studios, studioIds) &&
        _ids(f['groups'], s.groups.keys.toList()) &&
        _number(f['rating100'], s.rating100) &&
        _number(f['duration'], s.clip.duration) &&
        _number(f['resume_time'], s.resumeTime) &&
        _number(f['play_count'], s.playCount) &&
        _number(f['o_counter'], s.oCounter) &&
        _timestamp(f['created_at'], s.createdAt) &&
        _resolution(f['resolution'], min(s.clip.width, s.clip.height)) &&
        (orientation == null || (orientation['value'] as List).contains(shape)) &&
        (f['performer_favorite'] != true || _performers.any((p) => p.favorite && s.performerIds.contains(p.id))) &&
        (f['organized'] == null || f['organized'] == s.organized);
    if (!matches) return false;
    if (f['AND'] case final Map<String, dynamic> and when !_sceneMatches(s, and)) return false;
    if (f['NOT'] case final Map<String, dynamic> not when _sceneMatches(s, not)) return false;
    return true;
  }

  /// Whether [studioId] is [id], or with [deep] one of its sub-studios.
  bool _inStudio(String? studioId, String id, {required bool deep}) {
    for (var s = studioId; s != null; s = deep ? _studioParent(s) : null) {
      if (s == id) return true;
    }
    return false;
  }

  /// The ids a `studios` [criterion] matches an item of [studioId] by: the
  /// studio, with depth -1 also every parent above it.
  List<String> _studioIds(String? studioId, Object? criterion) => [
    for (var s = studioId; s != null; s = criterion is Map && criterion['depth'] == -1 ? _studioParent(s) : null) s,
  ];

  String? _studioParent(String? id) => _studios.where((s) => s.id == id).firstOrNull?.parentId;

  /// A multi criterion (`{value: [ids], excludes, modifier}`) against [ids].
  static bool _ids(Object? criterion, List<String> ids) {
    if (criterion is! Map) return true;
    final values = [for (final v in criterion['value'] as List? ?? const []) '$v'];
    final excludes = [for (final v in criterion['excludes'] as List? ?? const []) '$v'];
    if (excludes.any(ids.contains)) return false;
    return switch (criterion['modifier']) {
      'INCLUDES_ALL' => values.every(ids.contains),
      'EXCLUDES' => !values.any(ids.contains),
      'IS_NULL' => ids.isEmpty,
      'NOT_NULL' => ids.isNotEmpty,
      'EQUALS' => values.length == ids.length && values.every(ids.contains),
      _ => values.isEmpty || values.any(ids.contains),
    };
  }

  /// A timestamp criterion (`{value, value2, modifier}`, ISO 8601) against
  /// [time], to the second like Stash.
  static bool _timestamp(Object? criterion, DateTime time) {
    if (criterion is! Map) return true;
    DateTime? parse(Object? v) => v is String ? DateTime.tryParse(v)?.toUtc() : null;
    final a = parse(criterion['value']);
    final b = parse(criterion['value2']);
    final t = time.toUtc().copyWith(millisecond: 0, microsecond: 0);
    if (a == null) return true;
    return switch (criterion['modifier']) {
      'GREATER_THAN' => t.isAfter(a),
      'LESS_THAN' => t.isBefore(a),
      'BETWEEN' => !t.isBefore(a) && (b == null || !t.isAfter(b)),
      'NOT_BETWEEN' => t.isBefore(a) || (b != null && t.isAfter(b)),
      'NOT_EQUALS' => t != a,
      _ => t == a,
    };
  }

  /// An int/float criterion against [value].
  static bool _number(Object? criterion, num? value) {
    if (criterion is! Map) return true;
    final a = criterion['value'] as num? ?? 0;
    final b = criterion['value2'] as num?;
    final v = value ?? 0;
    return switch (criterion['modifier']) {
      'EQUALS' => v == a,
      'NOT_EQUALS' => v != a,
      'GREATER_THAN' => v > a,
      'LESS_THAN' => v < a,
      'BETWEEN' => v >= a && (b == null || v <= b),
      'NOT_BETWEEN' => v < a || (b != null && v > b),
      'IS_NULL' => value == null,
      'NOT_NULL' => value != null,
      _ => true,
    };
  }

  static const _resolutionHeights = {
    'VERY_LOW': 144,
    'LOW': 240,
    'R360P': 360,
    'STANDARD': 480,
    'WEB_HD': 540,
    'STANDARD_HD': 720,
    'FULL_HD': 1080,
    'QUAD_HD': 1440,
    'FOUR_K': 2160,
    'FIVE_K': 2880,
    'SIX_K': 3384,
    'SEVEN_K': 4032,
    'EIGHT_K': 4320,
  };

  static bool _resolution(Object? criterion, int height) {
    if (criterion is! Map) return true;
    final limit = _resolutionHeights[criterion['value']];
    if (limit == null) return true;
    return switch (criterion['modifier']) {
      'GREATER_THAN' => height > limit,
      'LESS_THAN' => height < limit,
      'NOT_EQUALS' => height != limit,
      _ => height == limit,
    };
  }

  /// Searches, sorts and pages [items] by a `FindFilterType`.
  static ({int count, List<T> items}) _page<T>(
    Iterable<T> items,
    Object? findFilter, {
    required String Function(T) text,
    required Object? Function(T, String sort) sortKey,
  }) {
    final filter = findFilter is Map ? findFilter : const {};
    final q = (filter['q'] as String?)?.trim().toLowerCase() ?? '';
    final list = [
      for (final item in items)
        if (q.isEmpty || text(item).toLowerCase().contains(q)) item,
    ];
    final sort = filter['sort'] as String? ?? '';
    if (sort.startsWith('random')) {
      list.shuffle(Random(int.tryParse(sort.split('_').last) ?? 0));
    } else {
      final descending = filter['direction'] == 'DESC';
      int compare(T a, T b) {
        final ka = sortKey(a, sort);
        final kb = sortKey(b, sort);
        if (ka == null || kb == null) return ka == kb ? 0 : (ka == null ? 1 : -1);
        final c = (ka as Comparable<Object?>).compareTo(kb);
        return descending ? -c : c;
      }

      // Stable: equal keys keep the library's order.
      final indexed = list.indexed.toList()
        ..sort((a, b) {
          final c = compare(a.$2, b.$2);
          return c != 0 ? c : a.$1.compareTo(b.$1);
        });
      list
        ..clear()
        ..addAll(indexed.map((e) => e.$2));
    }
    final perPage = filter['per_page'] as int? ?? 25;
    final page = filter['page'] as int? ?? 1;
    if (perPage < 0) return (count: list.length, items: list);
    return (count: list.length, items: list.skip((page - 1) * perPage).take(perPage).toList());
  }

  // --- Mutations ------------------------------------------------------------

  Map<String, Object?> _mutationRoot() => {
    '__typename': 'Mutation',
    // Server tasks: accepted, but there is nothing to scan or generate.
    for (final task in ['metadataScan', 'metadataGenerate', 'metadataAutoTag', 'metadataClean'])
      task: (Map<String, dynamic> _) => '${_nextId++}',
    'stopJob': (Map<String, dynamic> _) => true,
    'sceneSaveActivity': (Map<String, dynamic> args) {
      final scene = _scene(args['id']);
      if (scene == null) return false;
      if (args['resume_time'] case final num t) scene.resumeTime = t.toDouble();
      if (args['playDuration'] case final num d) scene.playDuration += d;
      scene.lastPlayedAt = DateTime.now();
      return true;
    },
    'sceneAddPlay': (Map<String, dynamic> args) {
      final scene = _scene(args['id']);
      if (scene != null) {
        final now = DateTime.now();
        scene
          ..playCount += 1
          ..playHistory.add(now)
          ..lastPlayedAt = now;
      }
      return _history(scene?.playCount ?? 0);
    },
    'sceneAddO': (Map<String, dynamic> args) {
      final scene = _scene(args['id']);
      if (scene != null) scene.oCounter += 1;
      return _history(scene?.oCounter ?? 0);
    },
    'sceneDeleteO': (Map<String, dynamic> args) {
      final scene = _scene(args['id']);
      if (scene != null && scene.oCounter > 0) scene.oCounter -= 1;
      return _history(scene?.oCounter ?? 0);
    },
    'sceneUpdate': (Map<String, dynamic> args) {
      final input = args['input'] as Map<String, dynamic>;
      final scene = _scene(input['id']);
      if (scene == null) return null;
      if (input.containsKey('title')) scene.title = input['title'] as String? ?? '';
      if (input.containsKey('details')) scene.details = input['details'] as String?;
      if (input.containsKey('date')) scene.date = input['date'] as String?;
      if (input.containsKey('rating100')) scene.rating100 = input['rating100'] as int?;
      if (input.containsKey('organized')) scene.organized = input['organized'] as bool? ?? false;
      if (input.containsKey('studio_id')) scene.studioId = input['studio_id'] as String?;
      if (input['performer_ids'] case final List ids) scene.performerIds = [for (final id in ids) '$id'];
      if (input['tag_ids'] case final List ids) scene.tagIds = [for (final id in ids) '$id'];
      if (input['urls'] case final List urls) scene.urls = [for (final u in urls) '$u'];
      if (input['groups'] case final List groups) {
        scene.groups = {
          for (final g in groups.cast<Map<String, dynamic>>())
            if (_groups.any((group) => group.id == '${g['group_id']}')) '${g['group_id']}': g['scene_index'] as int?,
        };
      }
      return _sceneObject(scene);
    },
    'sceneMarkerCreate': (Map<String, dynamic> args) {
      final input = args['input'] as Map<String, dynamic>;
      if (_scene(input['scene_id']) == null) return null;
      final marker = _Marker(
        _newId(),
        '${input['scene_id']}',
        (input['seconds'] as num).toDouble(),
        input['title'] as String? ?? '',
        '${input['primary_tag_id']}',
        endSeconds: (input['end_seconds'] as num?)?.toDouble(),
        createdAt: DateTime.now(),
      );
      _markers.add(marker);
      return _markerObject(marker);
    },
    'sceneMarkerUpdate': (Map<String, dynamic> args) {
      final input = args['input'] as Map<String, dynamic>;
      final m = _markers.where((m) => m.id == input['id']).firstOrNull;
      if (m == null) return null;
      if (input['title'] case final String title) m.title = title;
      if (input['seconds'] case final num seconds) m.seconds = seconds.toDouble();
      if (input.containsKey('end_seconds')) m.endSeconds = (input['end_seconds'] as num?)?.toDouble();
      if (input['primary_tag_id'] case final String tagId) m.tagId = tagId;
      return _markerObject(m);
    },
    'sceneMarkerDestroy': (Map<String, dynamic> args) {
      final before = _markers.length;
      _markers.removeWhere((m) => m.id == args['id']);
      return _markers.length < before;
    },
    'performerUpdate': (Map<String, dynamic> args) {
      final input = args['input'] as Map<String, dynamic>;
      final p = _performers.where((p) => p.id == input['id']).firstOrNull;
      if (p == null) return null;
      if (input['name'] case final String name) p.name = name;
      if (input.containsKey('disambiguation')) p.disambiguation = input['disambiguation'] as String?;
      if (input.containsKey('country')) p.country = input['country'] as String?;
      if (input.containsKey('birthdate')) p.birthdate = input['birthdate'] as String?;
      if (input.containsKey('gender')) p.gender = input['gender'] as String?;
      if (input.containsKey('details')) p.details = input['details'] as String?;
      if (input.containsKey('rating100')) p.rating100 = input['rating100'] as int?;
      if (input['favorite'] case final bool favorite) p.favorite = favorite;
      if (input['urls'] case final List urls) p.urls = [for (final u in urls) '$u'];
      return _performerObject(p);
    },
    'studioUpdate': (Map<String, dynamic> args) {
      final input = args['input'] as Map<String, dynamic>;
      final s = _studios.where((s) => s.id == input['id']).firstOrNull;
      if (s == null) return null;
      if (input['name'] case final String name) s.name = name;
      if (input.containsKey('url')) s.url = input['url'] as String?;
      if (input.containsKey('details')) s.details = input['details'] as String?;
      if (input.containsKey('parent_id')) s.parentId = input['parent_id'] as String?;
      if (input['favorite'] case final bool favorite) s.favorite = favorite;
      if (input.containsKey('rating100')) s.rating100 = input['rating100'] as int?;
      return _studioObject(s);
    },
    'performerCreate': (Map<String, dynamic> args) {
      final performer = _Performer(_newId(), (args['input'] as Map)['name'] as String);
      _performers.add(performer);
      return _performerObject(performer);
    },
    'studioCreate': (Map<String, dynamic> args) {
      final studio = _Studio(_newId(), (args['input'] as Map)['name'] as String);
      _studios.add(studio);
      return _studioObject(studio);
    },
    'groupCreate': (Map<String, dynamic> args) {
      final input = args['input'] as Map<String, dynamic>;
      final group = _Group(_newId(), input['name'] as String, synopsis: input['synopsis'] as String?);
      _groups.add(group);
      return _groupObject(group);
    },
    'tagCreate': (Map<String, dynamic> args) {
      final tag = _Tag(_newId(), (args['input'] as Map)['name'] as String);
      _tags.add(tag);
      return _tagObject(tag);
    },
    'tagUpdate': (Map<String, dynamic> args) {
      final input = args['input'] as Map<String, dynamic>;
      final t = _tags.where((t) => t.id == input['id']).firstOrNull;
      if (t == null) return null;
      if (input['name'] case final String name) t.name = name;
      if (input.containsKey('description')) t.description = input['description'] as String?;
      return _tagObject(t);
    },
    'galleryUpdate': (Map<String, dynamic> args) {
      final input = args['input'] as Map<String, dynamic>;
      final g = _galleries.where((g) => g.id == input['id']).firstOrNull;
      if (g == null) return null;
      if (input['title'] case final String title) g.title = title;
      if (input.containsKey('date')) g.date = input['date'] as String?;
      if (input.containsKey('details')) g.details = input['details'] as String?;
      if (input.containsKey('studio_id')) g.studioId = input['studio_id'] as String?;
      if (input['performer_ids'] case final List ids) g.performerIds = [for (final id in ids) '$id'];
      if (input['urls'] case final List urls) g.urls = [for (final u in urls) '$u'];
      return _galleryObject(g);
    },
  };

  static Map<String, Object?> _history(int count) => {
    '__typename': 'HistoryMutationResult',
    'count': count,
    'history': const <Object>[],
  };
}

class _Studio {
  _Studio(this.id, this.name, {this.parentId, this.details, this.url});

  final String id;
  String name;
  String? parentId;
  String? details;
  String? url;
  bool favorite = false;
  int? rating100;
}

class _Performer {
  _Performer(
    this.id,
    this.name, {
    this.image,
    this.favorite = false,
    this.rating100,
    this.country,
    this.birthdate,
    this.details,
    this.disambiguation,
    this.urls = const [],
    this.aliases = const [],
    this.heightCm,
    this.hairColor,
    this.eyeColor,
    this.career,
  });

  final String id;
  String name;
  final String? image;
  bool favorite;
  int? rating100;
  String? country;
  String? birthdate;
  String? gender;
  String? details;
  String? disambiguation;
  List<String> urls;
  final List<String> aliases;
  final int? heightCm;
  final String? hairColor;
  final String? eyeColor;
  final String? career;
}

class _Tag {
  _Tag(this.id, this.name);

  final String id;
  String name;
  String? description;
}

class _Scene {
  _Scene(
    this.id,
    this.file,
    this.clip, {
    required this.title,
    required this.studioId,
    required this.performerIds,
    required this.tagIds,
    required this.rating100,
    required this.createdAt,
    int? groupIndex,
  }) : groups = {'1': ?groupIndex};

  final String id;
  final String file;
  final DemoClip clip;
  String title;
  String? details = DemoLibrary._credit;
  String? date = DemoLibrary._filmDate;
  final DateTime createdAt;
  int? rating100;
  int playCount = 0;
  int oCounter = 0;
  double resumeTime = 0;
  double playDuration = 0;
  DateTime? lastPlayedAt;

  /// When it was played, oldest first.
  List<DateTime> playHistory = [];
  bool organized = true;
  String? studioId;
  List<String> performerIds;
  List<String> tagIds;
  List<String> urls = const [DemoLibrary._filmUrl];

  /// Group id to the scene's position in it (the film's scenes are in '1').
  Map<String, int?> groups;
}

class _Marker {
  _Marker(this.id, this.sceneId, this.seconds, this.title, this.tagId, {this.endSeconds, required this.createdAt});

  final String id;
  final String sceneId;
  double seconds;
  double? endSeconds;
  String title;
  String tagId;
  final DateTime createdAt;
}

class _Group {
  _Group(this.id, this.name, {this.studioId, this.cover, this.date, this.synopsis});

  final String id;
  final String name;
  final String? studioId;
  final String? cover;
  final String? date;
  final String? synopsis;
}

class _Gallery {
  _Gallery(this.id, this.title, {this.studioId, this.performerIds = const [], this.details, this.cover});

  final String id;
  String title;
  String? date = DemoLibrary._filmDate;
  String? details;
  String? studioId;
  List<String> performerIds;
  List<String> urls = const [];
  final String? cover;
}

class _Image {
  _Image(
    this.id,
    this.file, {
    required this.title,
    required this.studioId,
    required this.galleryIds,
    required this.createdAt,
    this.rating100,
    this.performerIds = const [],
    this.tagIds = const [],
  });

  final String id;
  final String file;
  final List<String> performerIds;
  final List<String> tagIds;
  final String title;
  final String studioId;
  final List<String> galleryIds;
  final DateTime createdAt;
  final int? rating100;
}
