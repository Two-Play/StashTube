// Complete GraphQL results, the way Stash sends them, for building models
// through the generated types (1.8). Each helper fills every field the
// documents select with an empty value and adds the `__typename`s the app
// requests (also in nested objects a test passes); tests pass only what
// they check.
import 'package:stash_app_mobile/core/api/documents/galleries.graphql.dart';
import 'package:stash_app_mobile/core/api/documents/groups.graphql.dart';
import 'package:stash_app_mobile/core/api/documents/images.graphql.dart';
import 'package:stash_app_mobile/core/api/documents/performers.graphql.dart';
import 'package:stash_app_mobile/core/api/documents/refs.graphql.dart';
import 'package:stash_app_mobile/core/api/documents/scenes.graphql.dart';
import 'package:stash_app_mobile/core/api/documents/studios.graphql.dart';
import 'package:stash_app_mobile/core/api/documents/system.graphql.dart';
import 'package:stash_app_mobile/data/models/gallery.dart';
import 'package:stash_app_mobile/data/models/group.dart';
import 'package:stash_app_mobile/data/models/image_item.dart';
import 'package:stash_app_mobile/data/models/json.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/models/stats.dart';
import 'package:stash_app_mobile/data/models/studio.dart';
import 'package:stash_app_mobile/data/models/tag.dart';

/// [json] as a [type], with [nested] fields (objects or lists of them)
/// typed as well; typenames already present win.
Json typed(String type, Json json, [Map<String, String> nested = const {}]) => {
      '__typename': type,
      for (final MapEntry(:key, :value) in json.entries)
        key: switch ((nested[key], value)) {
          (final String t, final Map<String, dynamic> map) => {'__typename': t, ...map},
          (final String t, final List<dynamic> list) => [
              for (final item in list) item is Map<String, dynamic> ? {'__typename': t, ...item} : item,
            ],
          _ => value,
        },
    };

Json studioRefJson([Json fields = const {}]) =>
    typed('Studio', {'id': '1', 'name': 'Studio', 'image_path': null, ...fields});

Json performerRefJson([Json fields = const {}]) =>
    typed('Performer', {'id': '1', 'name': 'Performer', 'image_path': null, ...fields});

Json sceneFileJson([Json fields = const {}]) =>
    typed('VideoFile', {'basename': 'video.mp4', 'duration': 0, 'width': 0, 'height': 0, ...fields});

Json sceneJson([Json fields = const {}]) => typed('Scene', {
      'id': '1',
      'title': null,
      'details': null,
      'date': null,
      'created_at': '2024-01-01T00:00:00Z',
      'rating100': null,
      'play_count': null,
      'o_counter': null,
      'resume_time': null,
      'organized': false,
      'files': const [],
      'paths': const {'screenshot': null, 'preview': null, 'webp': null, 'stream': null},
      'studio': null,
      'performers': const [],
      'tags': const [],
      ...fields,
    }, const {
      'files': 'VideoFile',
      'paths': 'ScenePathsType',
      'studio': 'Studio',
      'performers': 'Performer',
      'tags': 'Tag',
    });

/// A performer as scenes select it.
Json scenePerformerJson([Json fields = const {}]) =>
    typed('Performer', {...performerRefJson(), 'country': null, 'favorite': false, ...fields});

Scene sceneFrom([Json fields = const {}]) => Scene.fromFields(Fragment$SceneFields.fromJson(sceneJson(fields)));

Json performerJson([Json fields = const {}]) => typed('Performer', {
      'id': '1',
      'name': 'Performer',
      'disambiguation': null,
      'image_path': null,
      'country': null,
      'birthdate': null,
      'gender': null,
      'favorite': false,
      'rating100': null,
      'scene_count': 0,
      ...fields,
    });

Performer performerFrom([Json fields = const {}]) =>
    Performer.fromFields(Fragment$PerformerFields.fromJson(performerJson(fields)));

Json studioJson([Json fields = const {}]) => typed('Studio', {
      ...studioRefJson(),
      'url': null,
      'scene_count': 0,
      'parent_studio': null,
      'details': null,
      'child_studios': const [],
      ...fields,
    }, const {'parent_studio': 'Studio', 'child_studios': 'Studio'});

Studio studioFrom([Json fields = const {}]) => Studio.fromFields(Fragment$StudioDetails.fromJson(studioJson(fields)));

Json tagJson([Json fields = const {}]) =>
    typed('Tag', {'id': '1', 'name': 'Tag', 'image_path': null, 'scene_count': 0, ...fields});

Tag tagFrom([Json fields = const {}]) => Tag.fromFields(Fragment$TagFields.fromJson(tagJson(fields)));

Json galleryJson([Json fields = const {}]) => typed('Gallery', {
      'id': '1',
      'title': null,
      'date': null,
      'details': null,
      'image_count': 0,
      'paths': const {'cover': ''},
      'files': const [],
      'folder': null,
      'studio': null,
      'performers': const [],
      ...fields,
    }, const {
      'paths': 'GalleryPathsType',
      'files': 'GalleryFile',
      'folder': 'Folder',
      'studio': 'Studio',
      'performers': 'Performer',
    });

Gallery galleryFrom([Json fields = const {}]) =>
    Gallery.fromFields(Fragment$GalleryFields.fromJson(galleryJson(fields)));

Json groupJson([Json fields = const {}]) => typed('Group', {
      'id': '1',
      'name': 'Group',
      'date': null,
      'duration': null,
      'front_image_path': null,
      'scene_count': 0,
      'studio': null,
      ...fields,
    }, const {'studio': 'Studio'});

Group groupFrom([Json fields = const {}]) => Group.fromFields(Fragment$GroupFields.fromJson(groupJson(fields)));

Json imageJson([Json fields = const {}]) => typed('Image', {
      'id': '1',
      'title': null,
      'date': null,
      'rating100': null,
      'paths': const {'thumbnail': null, 'image': null},
      'studio': null,
      'performers': const [],
      ...fields,
    }, const {'paths': 'ImagePathsType', 'studio': 'Studio', 'performers': 'Performer'});

ImageItem imageFrom([Json fields = const {}]) =>
    ImageItem.fromGraphql(Query$FindImages$findImages$images.fromJson(imageJson(fields)));

Json statsJson([Json fields = const {}]) => typed('StatsResultType', {
      'scene_count': 0,
      'scenes_size': 0,
      'scenes_duration': 0,
      'image_count': 0,
      'images_size': 0,
      'gallery_count': 0,
      'performer_count': 0,
      'studio_count': 0,
      'tag_count': 0,
      ...fields,
    });

LibraryStats statsFrom([Json fields = const {}]) => LibraryStats.fromGraphql(Query$Stats$stats.fromJson(statsJson(fields)));

ActivityStats activityFrom([Json fields = const {}]) =>
    ActivityStats.fromGraphql(Query$ActivityStats$stats.fromJson(typed('StatsResultType', {
      'total_play_count': 0,
      'total_play_duration': 0,
      'scenes_played': 0,
      'total_o_count': 0,
      ...fields,
    })));

Json sceneDetailsJson([Json fields = const {}]) => typed('Scene', {
      'id': '1',
      'paths': const {'sprite': null, 'vtt': null},
      'sceneStreams': const [],
      'scene_markers': const [],
      'files': const [],
      ...fields,
    }, const {
      'paths': 'ScenePathsType',
      'sceneStreams': 'SceneStreamEndpoint',
      'scene_markers': 'SceneMarker',
      'files': 'VideoFile',
    });

Json markerJson([Json fields = const {}]) => typed(
      'SceneMarker',
      {'id': '1', 'title': '', 'seconds': 0, 'primary_tag': const {'name': 'Tag'}, ...fields},
      const {'primary_tag': 'Tag'},
    );

Json videoFileJson([Json fields = const {}]) => typed('VideoFile', {
      'path': '/video.mp4',
      'size': 0,
      'format': '',
      'width': 0,
      'height': 0,
      'duration': 0,
      'video_codec': '',
      'audio_codec': '',
      'frame_rate': 0,
      'bit_rate': 0,
      'mod_time': '2024-01-01T00:00:00Z',
      ...fields,
    });

SceneDetails sceneDetailsFrom([Json fields = const {}]) =>
    SceneDetails.fromGraphql(Query$FindSceneDetails$findScene.fromJson(sceneDetailsJson(fields)));

SavedFilter savedFilterFrom([Json fields = const {}]) =>
    SavedFilter.fromGraphql(Query$SavedSceneFilters$findSavedFilters.fromJson(typed(
      'SavedFilter',
      {'id': '1', 'name': 'Filter', 'find_filter': null, 'object_filter': null, ...fields},
      const {'find_filter': 'SavedFindFilterType'},
    )));
