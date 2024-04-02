/*
{
    "id": "30070",
    "title": "0h6mcmrw22oh7n84z3tnp_source",
    "code": "",
    "details": "",
    "director": "",
    "urls": [],
    "date": "2022-09-28",
    "rating100": null,
    "o_counter": 0,
    "organized": false,
    "interactive": false,
    "interactive_speed": null,
    "resume_time": 0,
    "play_duration": 0,
    "play_count": 0,
    "files": [
        {
            "id": "67394",
            "path": "/data/Downloads/Onlyfans/Nathan Luna Complete Onlyfans Collection 06-10-22 - nathanazzz/Videos/0h6mcmrw22oh7n84z3tnp_source.mp4",
            "size": 79975986,
            "mod_time": "2022-10-12T08:57:45+02:00",
            "duration": 102.85,
            "video_codec": "h264",
            "audio_codec": "aac",
            "width": 1080,
            "height": 1920,
            "frame_rate": 23.98,
            "bit_rate": 6220620,
            "fingerprints": [
                {
                    "type": "oshash",
                    "value": "85cb3801a647ff9b",
                    "__typename": "Fingerprint"
                },
                {
                    "type": "phash",
                    "value": "f96759264d3c4790",
                    "__typename": "Fingerprint"
                }
            ],
            "__typename": "VideoFile"
        }
    ],
    "paths": {
        "screenshot": "http://192.168.44.5:9999/scene/30070/screenshot?t=1666030618",
        "preview": "http://192.168.44.5:9999/scene/30070/preview",
        "stream": "http://192.168.44.5:9999/scene/30070/stream",
        "webp": "http://192.168.44.5:9999/scene/30070/webp",
        "vtt": "http://192.168.44.5:9999/scene/85cb3801a647ff9b_thumbs.vtt",
        "sprite": "http://192.168.44.5:9999/scene/85cb3801a647ff9b_sprite.jpg",
        "funscript": "http://192.168.44.5:9999/scene/30070/funscript",
        "interactive_heatmap": "http://192.168.44.5:9999/scene/30070/interactive_heatmap",
        "caption": "http://192.168.44.5:9999/scene/30070/caption",
        "__typename": "ScenePathsType"
    },
    "scene_markers": [],
    "galleries": [],
    "studio": {
        "id": "3",
        "name": "OnlyFans",
        "image_path": "http://192.168.44.5:9999/studio/3/image?t=1641002641",
        "__typename": "Studio"
    },
    "movies": [],
    "tags": [],
    "performers": [
        {
            "id": "127",
            "name": "nathanazzz",
            "disambiguation": "",
            "gender": "MALE",
            "favorite": false,
            "image_path": "http://192.168.44.5:9999/performer/127/image?t=1666093034&default=true",
            "__typename": "Performer"
        }
    ],
    "stash_ids": [],
    "__typename": "Scene"
}
 */


import 'package:flutter/material.dart';

// generate video object
class VideoObject {
  final String id;
  final String title;
  final String code;
  final String details;
  final String director;
  final List<String> urls;
  final String date;
  final int rating100;
  final int oCounter;
  final bool organized;
  final bool interactive;
  final int interactiveSpeed;
  final int resumeTime;
  final int playDuration;
  final int playCount;
  final List<VideoFile> files;
  final ScenePathsType paths;
  final List<SceneMarkers> sceneMarkers;
  final List<Galleries> galleries;
  final Studio studio;
  final List<Movies> movies;
  final List<Tags> tags;
  final List<Performers> performers;
  final List<StashIds> stashIds;

  VideoObject({
    required this.id,
    required this.title,
    required this.code,
    required this.details,
    required this.director,
    required this.urls,
    required this.date,
    required this.rating100,
    required this.oCounter,
    required this.organized,
    required this.interactive,
    required this.interactiveSpeed,
    required this.resumeTime,
    required this.playDuration,
    required this.playCount,
    required this.files,
    required this.paths,
    required this.sceneMarkers,
    required this.galleries,
    required this.studio,
    required this.movies,
    required this.tags,
    required this.performers,
    required this.stashIds,
  });

  factory VideoObject.fromJson(Map<String, dynamic> json) {
    return VideoObject(
      id: json['id'],
      title: json['title'],
      code: json['code'],
      details: json['details'],
      director: json['director'],
      urls: List<String>.from(json['urls']),
      date: json['date'],
      rating100: json['rating100'],
      oCounter: json['o_counter'],
      organized: json['organized'],
      interactive: json['interactive'],
      interactiveSpeed: json['interactive_speed'],
      resumeTime: json['resume_time'],
      playDuration: json['play_duration'],
      playCount: json['play_count'],
      files: List<VideoFile>.from(json['files'].map((x) => VideoFile.fromJson(x))),
      paths: ScenePathsType.fromJson(json['paths']),
      sceneMarkers: List<SceneMarkers>.from(json['scene_markers'].map((x) => SceneMarkers
          .fromJson(x))),
      galleries: List<Galleries>.from(json['galleries'].map((x) => Galleries.fromJson(x))),
      studio: Studio.fromJson(json['studio']),
      movies: List<Movies>.from(json['movies'].map((x) => Movies.fromJson(x))),
      tags: List<Tags>.from(json['tags'].map((x) => Tags.fromJson(x))),
      performers: List<Performers>.from(json['performers'].map((x) => Performers.fromJson(x))),
      stashIds: List<StashIds>.from(json['stash_ids'].map((x) => StashIds.fromJson(x))),
    );
  }
}
