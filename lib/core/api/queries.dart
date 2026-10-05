/// GraphQL documents for the Stash API (https://github.com/stashapp/stash/tree/develop/graphql).
abstract final class StashQueries {
  static const _sceneFields = r'''
fragment SceneFields on Scene {
  id
  title
  details
  date
  created_at
  rating100
  play_count
  o_counter
  resume_time
  files { basename duration width height }
  paths { screenshot preview stream }
  studio { id name image_path }
  performers { id name image_path country favorite }
  tags { id name }
}
''';

  static const _performerFields = r'''
fragment PerformerFields on Performer {
  id
  name
  disambiguation
  image_path
  country
  birthdate
  gender
  favorite
  rating100
  scene_count
}
''';

  static const _studioFields = r'''
fragment StudioFields on Studio {
  id
  name
  image_path
  url
  scene_count
}
''';

  static const systemStatus = r'''
query SystemStatus {
  systemStatus { status }
}
''';

  static const version = r'''
query Version {
  version { version }
}
''';

  static const sceneSaveActivity = r'''
mutation SceneSaveActivity($id: ID!, $resume_time: Float, $playDuration: Float) {
  sceneSaveActivity(id: $id, resume_time: $resume_time, playDuration: $playDuration)
}
''';

  static const sceneAddPlay = r'''
mutation SceneAddPlay($id: ID!) {
  sceneAddPlay(id: $id) { count }
}
''';

  static const performerSetFavorite = r'''
mutation PerformerSetFavorite($id: ID!, $favorite: Boolean!) {
  performerUpdate(input: { id: $id, favorite: $favorite }) { id favorite }
}
''';

  static const findSceneDetails = r'''
query FindSceneDetails($id: ID!) {
  findScene(id: $id) {
    id
    sceneStreams { url mime_type label }
    scene_markers { id title seconds primary_tag { name } }
  }
}
''';

  static const findImages = r'''
query FindImages($filter: FindFilterType) {
  findImages(filter: $filter) {
    count
    images {
      id
      title
      date
      rating100
      paths { thumbnail image }
      studio { id name image_path }
      performers { id name image_path }
    }
  }
}
''';

  /// Library totals; supported by all Stash versions this app targets.
  static const stats = r'''
query Stats {
  stats {
    scene_count
    scenes_size
    scenes_duration
    image_count
    images_size
    gallery_count
    performer_count
    studio_count
    tag_count
  }
}
''';

  /// Watch activity totals; only on newer Stash versions, queried separately
  /// so older servers still get the library totals.
  static const activityStats = r'''
query ActivityStats {
  stats {
    total_play_count
    total_play_duration
    scenes_played
    total_o_count
  }
}
''';

  static const findScenes = r'''
query FindScenes($filter: FindFilterType, $scene_filter: SceneFilterType) {
  findScenes(filter: $filter, scene_filter: $scene_filter) {
    count
    scenes { ...SceneFields }
  }
}
''' '$_sceneFields';

  static const findPerformers = r'''
query FindPerformers($filter: FindFilterType, $performer_filter: PerformerFilterType) {
  findPerformers(filter: $filter, performer_filter: $performer_filter) {
    count
    performers { ...PerformerFields }
  }
}
''' '$_performerFields';

  static const findPerformer = r'''
query FindPerformer($id: ID!) {
  findPerformer(id: $id) { ...PerformerFields details }
}
''' '$_performerFields';

  static const findStudios = r'''
query FindStudios($filter: FindFilterType) {
  findStudios(filter: $filter) {
    count
    studios { ...StudioFields }
  }
}
''' '$_studioFields';

  static const findStudio = r'''
query FindStudio($id: ID!) {
  findStudio(id: $id) { ...StudioFields details }
}
''' '$_studioFields';
}
