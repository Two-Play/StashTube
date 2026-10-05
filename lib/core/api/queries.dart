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
  organized
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
  parent_studio { id name image_path }
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

  static const sceneSetRating = r'''
mutation SceneSetRating($id: ID!, $rating100: Int) {
  sceneUpdate(input: { id: $id, rating100: $rating100 }) { id rating100 }
}
''';

  static const tagCreate = r'''
mutation TagCreate($name: String!) {
  tagCreate(input: { name: $name }) { id name image_path scene_count }
}
''';

  static const sceneSetTags = r'''
mutation SceneSetTags($id: ID!, $tag_ids: [ID!]) {
  sceneUpdate(input: { id: $id, tag_ids: $tag_ids }) { id tags { id name } }
}
''';

  static const sceneAddO = r'''
mutation SceneAddO($id: ID!) {
  sceneAddO(id: $id) { count }
}
''';

  static const sceneDeleteO = r'''
mutation SceneDeleteO($id: ID!) {
  sceneDeleteO(id: $id) { count }
}
''';

  static const sceneMarkerCreate = r'''
mutation SceneMarkerCreate($input: SceneMarkerCreateInput!) {
  sceneMarkerCreate(input: $input) { id title seconds primary_tag { name } }
}
''';

  static const sceneUpdate = r'''
mutation SceneEdit($input: SceneUpdateInput!) {
  sceneUpdate(input: $input) { ...SceneFields }
}
''' '$_sceneFields';

  static const performerUpdate = r'''
mutation PerformerEdit($input: PerformerUpdateInput!) {
  performerUpdate(input: $input) { ...PerformerFields details }
}
''' '$_performerFields';

  static const studioUpdate = r'''
mutation StudioEdit($input: StudioUpdateInput!) {
  studioUpdate(input: $input) {
    ...StudioFields
    details
    child_studios { id name image_path scene_count }
  }
}
''' '$_studioFields';

  static const tagUpdate = r'''
mutation TagEdit($input: TagUpdateInput!) {
  tagUpdate(input: $input) { id name image_path description scene_count }
}
''';

  static const galleryUpdate = r'''
mutation GalleryEdit($input: GalleryUpdateInput!) {
  galleryUpdate(input: $input) { ...GalleryFields }
}
''' '$_galleryFields';

  /// URL lists, queried separately so older Stash versions without `urls`
  /// only lose the URL editor, not the lists.
  static const sceneUrls = r'''
query SceneUrls($id: ID!) { findScene(id: $id) { id urls } }
''';

  static const performerUrls = r'''
query PerformerUrls($id: ID!) { findPerformer(id: $id) { id urls } }
''';

  static const galleryUrls = r'''
query GalleryUrls($id: ID!) { findGallery(id: $id) { id urls } }
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
    paths { sprite vtt }
    sceneStreams { url mime_type label }
    scene_markers { id title seconds primary_tag { name } }
    files { path size format width height duration video_codec audio_codec frame_rate bit_rate mod_time }
  }
}
''';

  static const findImages = r'''
query FindImages($filter: FindFilterType, $image_filter: ImageFilterType) {
  findImages(filter: $filter, image_filter: $image_filter) {
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

  static const _galleryFields = r'''
fragment GalleryFields on Gallery {
  id
  title
  date
  details
  image_count
  paths { cover }
  files { basename }
  folder { path }
  studio { id name image_path }
  performers { id name image_path }
}
''';

  static const findGalleries = r'''
query FindGalleries($filter: FindFilterType) {
  findGalleries(filter: $filter) {
    count
    galleries { ...GalleryFields }
  }
}
''' '$_galleryFields';

  static const findGallery = r'''
query FindGallery($id: ID!) {
  findGallery(id: $id) { ...GalleryFields }
}
''' '$_galleryFields';

  static const findTags = r'''
query FindTags($filter: FindFilterType, $tag_filter: TagFilterType) {
  findTags(filter: $filter, tag_filter: $tag_filter) {
    count
    tags { id name image_path scene_count }
  }
}
''';

  static const findTag = r'''
query FindTag($id: ID!) {
  findTag(id: $id) { id name image_path description scene_count }
}
''';

  /// Saved scene filters (object_filter needs Stash v0.25+).
  static const savedSceneFilters = r'''
query SavedSceneFilters {
  findSavedFilters(mode: SCENES) {
    id
    name
    find_filter { q sort direction }
    object_filter
  }
}
''';

  static const findScenesByIds = r'''
query FindScenesByIds($ids: [ID!]) {
  findScenes(ids: $ids, filter: { per_page: -1 }) {
    scenes { ...SceneFields }
  }
}
''' '$_sceneFields';

  static const _groupFields = r'''
fragment GroupFields on Group {
  id
  name
  date
  duration
  front_image_path
  scene_count
  studio { id name image_path }
}
''';

  /// Groups replaced movies in Stash v0.27.
  static const findGroups = r'''
query FindGroups($filter: FindFilterType) {
  findGroups(filter: $filter) {
    count
    groups { ...GroupFields }
  }
}
''' '$_groupFields';

  static const findGroup = r'''
query FindGroup($id: ID!) {
  findGroup(id: $id) { ...GroupFields synopsis }
}
''' '$_groupFields';

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
  findStudio(id: $id) {
    ...StudioFields
    details
    child_studios { id name image_path scene_count }
  }
}
''' '$_studioFields';
}
