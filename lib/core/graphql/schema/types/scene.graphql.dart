import 'performer.graphql.dart';
import 'stash-box.graphql.dart';

class Input$SceneMovieInput {
  factory Input$SceneMovieInput({
    required String movie_id,
    int? scene_index,
  }) =>
      Input$SceneMovieInput._({
        r'movie_id': movie_id,
        if (scene_index != null) r'scene_index': scene_index,
      });

  Input$SceneMovieInput._(this._$data);

  factory Input$SceneMovieInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$movie_id = data['movie_id'];
    result$data['movie_id'] = (l$movie_id as String);
    if (data.containsKey('scene_index')) {
      final l$scene_index = data['scene_index'];
      result$data['scene_index'] = (l$scene_index as int?);
    }
    return Input$SceneMovieInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get movie_id => (_$data['movie_id'] as String);

  int? get scene_index => (_$data['scene_index'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$movie_id = movie_id;
    result$data['movie_id'] = l$movie_id;
    if (_$data.containsKey('scene_index')) {
      final l$scene_index = scene_index;
      result$data['scene_index'] = l$scene_index;
    }
    return result$data;
  }

  CopyWith$Input$SceneMovieInput<Input$SceneMovieInput> get copyWith =>
      CopyWith$Input$SceneMovieInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$SceneMovieInput) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$movie_id = movie_id;
    final lOther$movie_id = other.movie_id;
    if (l$movie_id != lOther$movie_id) {
      return false;
    }
    final l$scene_index = scene_index;
    final lOther$scene_index = other.scene_index;
    if (_$data.containsKey('scene_index') !=
        other._$data.containsKey('scene_index')) {
      return false;
    }
    if (l$scene_index != lOther$scene_index) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$movie_id = movie_id;
    final l$scene_index = scene_index;
    return Object.hashAll([
      l$movie_id,
      _$data.containsKey('scene_index') ? l$scene_index : const {},
    ]);
  }
}

abstract class CopyWith$Input$SceneMovieInput<TRes> {
  factory CopyWith$Input$SceneMovieInput(
    Input$SceneMovieInput instance,
    TRes Function(Input$SceneMovieInput) then,
  ) = _CopyWithImpl$Input$SceneMovieInput;

  factory CopyWith$Input$SceneMovieInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SceneMovieInput;

  TRes call({
    String? movie_id,
    int? scene_index,
  });
}

class _CopyWithImpl$Input$SceneMovieInput<TRes>
    implements CopyWith$Input$SceneMovieInput<TRes> {
  _CopyWithImpl$Input$SceneMovieInput(
    this._instance,
    this._then,
  );

  final Input$SceneMovieInput _instance;

  final TRes Function(Input$SceneMovieInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? movie_id = _undefined,
    Object? scene_index = _undefined,
  }) =>
      _then(Input$SceneMovieInput._({
        ..._instance._$data,
        if (movie_id != _undefined && movie_id != null)
          'movie_id': (movie_id as String),
        if (scene_index != _undefined) 'scene_index': (scene_index as int?),
      }));
}

class _CopyWithStubImpl$Input$SceneMovieInput<TRes>
    implements CopyWith$Input$SceneMovieInput<TRes> {
  _CopyWithStubImpl$Input$SceneMovieInput(this._res);

  TRes _res;

  call({
    String? movie_id,
    int? scene_index,
  }) =>
      _res;
}

class Input$SceneGroupInput {
  factory Input$SceneGroupInput({
    required String group_id,
    int? scene_index,
  }) =>
      Input$SceneGroupInput._({
        r'group_id': group_id,
        if (scene_index != null) r'scene_index': scene_index,
      });

  Input$SceneGroupInput._(this._$data);

  factory Input$SceneGroupInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$group_id = data['group_id'];
    result$data['group_id'] = (l$group_id as String);
    if (data.containsKey('scene_index')) {
      final l$scene_index = data['scene_index'];
      result$data['scene_index'] = (l$scene_index as int?);
    }
    return Input$SceneGroupInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get group_id => (_$data['group_id'] as String);

  int? get scene_index => (_$data['scene_index'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$group_id = group_id;
    result$data['group_id'] = l$group_id;
    if (_$data.containsKey('scene_index')) {
      final l$scene_index = scene_index;
      result$data['scene_index'] = l$scene_index;
    }
    return result$data;
  }

  CopyWith$Input$SceneGroupInput<Input$SceneGroupInput> get copyWith =>
      CopyWith$Input$SceneGroupInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$SceneGroupInput) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$group_id = group_id;
    final lOther$group_id = other.group_id;
    if (l$group_id != lOther$group_id) {
      return false;
    }
    final l$scene_index = scene_index;
    final lOther$scene_index = other.scene_index;
    if (_$data.containsKey('scene_index') !=
        other._$data.containsKey('scene_index')) {
      return false;
    }
    if (l$scene_index != lOther$scene_index) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$group_id = group_id;
    final l$scene_index = scene_index;
    return Object.hashAll([
      l$group_id,
      _$data.containsKey('scene_index') ? l$scene_index : const {},
    ]);
  }
}

abstract class CopyWith$Input$SceneGroupInput<TRes> {
  factory CopyWith$Input$SceneGroupInput(
    Input$SceneGroupInput instance,
    TRes Function(Input$SceneGroupInput) then,
  ) = _CopyWithImpl$Input$SceneGroupInput;

  factory CopyWith$Input$SceneGroupInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SceneGroupInput;

  TRes call({
    String? group_id,
    int? scene_index,
  });
}

class _CopyWithImpl$Input$SceneGroupInput<TRes>
    implements CopyWith$Input$SceneGroupInput<TRes> {
  _CopyWithImpl$Input$SceneGroupInput(
    this._instance,
    this._then,
  );

  final Input$SceneGroupInput _instance;

  final TRes Function(Input$SceneGroupInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? group_id = _undefined,
    Object? scene_index = _undefined,
  }) =>
      _then(Input$SceneGroupInput._({
        ..._instance._$data,
        if (group_id != _undefined && group_id != null)
          'group_id': (group_id as String),
        if (scene_index != _undefined) 'scene_index': (scene_index as int?),
      }));
}

class _CopyWithStubImpl$Input$SceneGroupInput<TRes>
    implements CopyWith$Input$SceneGroupInput<TRes> {
  _CopyWithStubImpl$Input$SceneGroupInput(this._res);

  TRes _res;

  call({
    String? group_id,
    int? scene_index,
  }) =>
      _res;
}

class Input$SceneCreateInput {
  factory Input$SceneCreateInput({
    String? title,
    String? code,
    String? details,
    String? director,
    String? url,
    List<String>? urls,
    String? date,
    int? rating100,
    bool? organized,
    String? studio_id,
    List<String>? gallery_ids,
    List<String>? performer_ids,
    List<Input$SceneGroupInput>? groups,
    List<Input$SceneMovieInput>? movies,
    List<String>? tag_ids,
    String? cover_image,
    List<Input$StashIDInput>? stash_ids,
    List<String>? file_ids,
  }) =>
      Input$SceneCreateInput._({
        if (title != null) r'title': title,
        if (code != null) r'code': code,
        if (details != null) r'details': details,
        if (director != null) r'director': director,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (date != null) r'date': date,
        if (rating100 != null) r'rating100': rating100,
        if (organized != null) r'organized': organized,
        if (studio_id != null) r'studio_id': studio_id,
        if (gallery_ids != null) r'gallery_ids': gallery_ids,
        if (performer_ids != null) r'performer_ids': performer_ids,
        if (groups != null) r'groups': groups,
        if (movies != null) r'movies': movies,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (cover_image != null) r'cover_image': cover_image,
        if (stash_ids != null) r'stash_ids': stash_ids,
        if (file_ids != null) r'file_ids': file_ids,
      });

  Input$SceneCreateInput._(this._$data);

  factory Input$SceneCreateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('title')) {
      final l$title = data['title'];
      result$data['title'] = (l$title as String?);
    }
    if (data.containsKey('code')) {
      final l$code = data['code'];
      result$data['code'] = (l$code as String?);
    }
    if (data.containsKey('details')) {
      final l$details = data['details'];
      result$data['details'] = (l$details as String?);
    }
    if (data.containsKey('director')) {
      final l$director = data['director'];
      result$data['director'] = (l$director as String?);
    }
    if (data.containsKey('url')) {
      final l$url = data['url'];
      result$data['url'] = (l$url as String?);
    }
    if (data.containsKey('urls')) {
      final l$urls = data['urls'];
      result$data['urls'] =
          (l$urls as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('date')) {
      final l$date = data['date'];
      result$data['date'] = (l$date as String?);
    }
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    if (data.containsKey('organized')) {
      final l$organized = data['organized'];
      result$data['organized'] = (l$organized as bool?);
    }
    if (data.containsKey('studio_id')) {
      final l$studio_id = data['studio_id'];
      result$data['studio_id'] = (l$studio_id as String?);
    }
    if (data.containsKey('gallery_ids')) {
      final l$gallery_ids = data['gallery_ids'];
      result$data['gallery_ids'] =
          (l$gallery_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('performer_ids')) {
      final l$performer_ids = data['performer_ids'];
      result$data['performer_ids'] = (l$performer_ids as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('groups')) {
      final l$groups = data['groups'];
      result$data['groups'] = (l$groups as List<dynamic>?)
          ?.map((e) =>
              Input$SceneGroupInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('movies')) {
      final l$movies = data['movies'];
      result$data['movies'] = (l$movies as List<dynamic>?)
          ?.map((e) =>
              Input$SceneMovieInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] =
          (l$tag_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('cover_image')) {
      final l$cover_image = data['cover_image'];
      result$data['cover_image'] = (l$cover_image as String?);
    }
    if (data.containsKey('stash_ids')) {
      final l$stash_ids = data['stash_ids'];
      result$data['stash_ids'] = (l$stash_ids as List<dynamic>?)
          ?.map((e) => Input$StashIDInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('file_ids')) {
      final l$file_ids = data['file_ids'];
      result$data['file_ids'] =
          (l$file_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    return Input$SceneCreateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get title => (_$data['title'] as String?);

  String? get code => (_$data['code'] as String?);

  String? get details => (_$data['details'] as String?);

  String? get director => (_$data['director'] as String?);

  String? get url => (_$data['url'] as String?);

  List<String>? get urls => (_$data['urls'] as List<String>?);

  String? get date => (_$data['date'] as String?);

  int? get rating100 => (_$data['rating100'] as int?);

  bool? get organized => (_$data['organized'] as bool?);

  String? get studio_id => (_$data['studio_id'] as String?);

  List<String>? get gallery_ids => (_$data['gallery_ids'] as List<String>?);

  List<String>? get performer_ids => (_$data['performer_ids'] as List<String>?);

  List<Input$SceneGroupInput>? get groups =>
      (_$data['groups'] as List<Input$SceneGroupInput>?);

  List<Input$SceneMovieInput>? get movies =>
      (_$data['movies'] as List<Input$SceneMovieInput>?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  String? get cover_image => (_$data['cover_image'] as String?);

  List<Input$StashIDInput>? get stash_ids =>
      (_$data['stash_ids'] as List<Input$StashIDInput>?);

  List<String>? get file_ids => (_$data['file_ids'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('title')) {
      final l$title = title;
      result$data['title'] = l$title;
    }
    if (_$data.containsKey('code')) {
      final l$code = code;
      result$data['code'] = l$code;
    }
    if (_$data.containsKey('details')) {
      final l$details = details;
      result$data['details'] = l$details;
    }
    if (_$data.containsKey('director')) {
      final l$director = director;
      result$data['director'] = l$director;
    }
    if (_$data.containsKey('url')) {
      final l$url = url;
      result$data['url'] = l$url;
    }
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.map((e) => e).toList();
    }
    if (_$data.containsKey('date')) {
      final l$date = date;
      result$data['date'] = l$date;
    }
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    if (_$data.containsKey('organized')) {
      final l$organized = organized;
      result$data['organized'] = l$organized;
    }
    if (_$data.containsKey('studio_id')) {
      final l$studio_id = studio_id;
      result$data['studio_id'] = l$studio_id;
    }
    if (_$data.containsKey('gallery_ids')) {
      final l$gallery_ids = gallery_ids;
      result$data['gallery_ids'] = l$gallery_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('performer_ids')) {
      final l$performer_ids = performer_ids;
      result$data['performer_ids'] = l$performer_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('groups')) {
      final l$groups = groups;
      result$data['groups'] = l$groups?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('movies')) {
      final l$movies = movies;
      result$data['movies'] = l$movies?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('cover_image')) {
      final l$cover_image = cover_image;
      result$data['cover_image'] = l$cover_image;
    }
    if (_$data.containsKey('stash_ids')) {
      final l$stash_ids = stash_ids;
      result$data['stash_ids'] = l$stash_ids?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('file_ids')) {
      final l$file_ids = file_ids;
      result$data['file_ids'] = l$file_ids?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Input$SceneCreateInput<Input$SceneCreateInput> get copyWith =>
      CopyWith$Input$SceneCreateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$SceneCreateInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (_$data.containsKey('title') != other._$data.containsKey('title')) {
      return false;
    }
    if (l$title != lOther$title) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (_$data.containsKey('code') != other._$data.containsKey('code')) {
      return false;
    }
    if (l$code != lOther$code) {
      return false;
    }
    final l$details = details;
    final lOther$details = other.details;
    if (_$data.containsKey('details') != other._$data.containsKey('details')) {
      return false;
    }
    if (l$details != lOther$details) {
      return false;
    }
    final l$director = director;
    final lOther$director = other.director;
    if (_$data.containsKey('director') !=
        other._$data.containsKey('director')) {
      return false;
    }
    if (l$director != lOther$director) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (_$data.containsKey('url') != other._$data.containsKey('url')) {
      return false;
    }
    if (l$url != lOther$url) {
      return false;
    }
    final l$urls = urls;
    final lOther$urls = other.urls;
    if (_$data.containsKey('urls') != other._$data.containsKey('urls')) {
      return false;
    }
    if (l$urls != null && lOther$urls != null) {
      if (l$urls.length != lOther$urls.length) {
        return false;
      }
      for (int i = 0; i < l$urls.length; i++) {
        final l$urls$entry = l$urls[i];
        final lOther$urls$entry = lOther$urls[i];
        if (l$urls$entry != lOther$urls$entry) {
          return false;
        }
      }
    } else if (l$urls != lOther$urls) {
      return false;
    }
    final l$date = date;
    final lOther$date = other.date;
    if (_$data.containsKey('date') != other._$data.containsKey('date')) {
      return false;
    }
    if (l$date != lOther$date) {
      return false;
    }
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (_$data.containsKey('rating100') !=
        other._$data.containsKey('rating100')) {
      return false;
    }
    if (l$rating100 != lOther$rating100) {
      return false;
    }
    final l$organized = organized;
    final lOther$organized = other.organized;
    if (_$data.containsKey('organized') !=
        other._$data.containsKey('organized')) {
      return false;
    }
    if (l$organized != lOther$organized) {
      return false;
    }
    final l$studio_id = studio_id;
    final lOther$studio_id = other.studio_id;
    if (_$data.containsKey('studio_id') !=
        other._$data.containsKey('studio_id')) {
      return false;
    }
    if (l$studio_id != lOther$studio_id) {
      return false;
    }
    final l$gallery_ids = gallery_ids;
    final lOther$gallery_ids = other.gallery_ids;
    if (_$data.containsKey('gallery_ids') !=
        other._$data.containsKey('gallery_ids')) {
      return false;
    }
    if (l$gallery_ids != null && lOther$gallery_ids != null) {
      if (l$gallery_ids.length != lOther$gallery_ids.length) {
        return false;
      }
      for (int i = 0; i < l$gallery_ids.length; i++) {
        final l$gallery_ids$entry = l$gallery_ids[i];
        final lOther$gallery_ids$entry = lOther$gallery_ids[i];
        if (l$gallery_ids$entry != lOther$gallery_ids$entry) {
          return false;
        }
      }
    } else if (l$gallery_ids != lOther$gallery_ids) {
      return false;
    }
    final l$performer_ids = performer_ids;
    final lOther$performer_ids = other.performer_ids;
    if (_$data.containsKey('performer_ids') !=
        other._$data.containsKey('performer_ids')) {
      return false;
    }
    if (l$performer_ids != null && lOther$performer_ids != null) {
      if (l$performer_ids.length != lOther$performer_ids.length) {
        return false;
      }
      for (int i = 0; i < l$performer_ids.length; i++) {
        final l$performer_ids$entry = l$performer_ids[i];
        final lOther$performer_ids$entry = lOther$performer_ids[i];
        if (l$performer_ids$entry != lOther$performer_ids$entry) {
          return false;
        }
      }
    } else if (l$performer_ids != lOther$performer_ids) {
      return false;
    }
    final l$groups = groups;
    final lOther$groups = other.groups;
    if (_$data.containsKey('groups') != other._$data.containsKey('groups')) {
      return false;
    }
    if (l$groups != null && lOther$groups != null) {
      if (l$groups.length != lOther$groups.length) {
        return false;
      }
      for (int i = 0; i < l$groups.length; i++) {
        final l$groups$entry = l$groups[i];
        final lOther$groups$entry = lOther$groups[i];
        if (l$groups$entry != lOther$groups$entry) {
          return false;
        }
      }
    } else if (l$groups != lOther$groups) {
      return false;
    }
    final l$movies = movies;
    final lOther$movies = other.movies;
    if (_$data.containsKey('movies') != other._$data.containsKey('movies')) {
      return false;
    }
    if (l$movies != null && lOther$movies != null) {
      if (l$movies.length != lOther$movies.length) {
        return false;
      }
      for (int i = 0; i < l$movies.length; i++) {
        final l$movies$entry = l$movies[i];
        final lOther$movies$entry = lOther$movies[i];
        if (l$movies$entry != lOther$movies$entry) {
          return false;
        }
      }
    } else if (l$movies != lOther$movies) {
      return false;
    }
    final l$tag_ids = tag_ids;
    final lOther$tag_ids = other.tag_ids;
    if (_$data.containsKey('tag_ids') != other._$data.containsKey('tag_ids')) {
      return false;
    }
    if (l$tag_ids != null && lOther$tag_ids != null) {
      if (l$tag_ids.length != lOther$tag_ids.length) {
        return false;
      }
      for (int i = 0; i < l$tag_ids.length; i++) {
        final l$tag_ids$entry = l$tag_ids[i];
        final lOther$tag_ids$entry = lOther$tag_ids[i];
        if (l$tag_ids$entry != lOther$tag_ids$entry) {
          return false;
        }
      }
    } else if (l$tag_ids != lOther$tag_ids) {
      return false;
    }
    final l$cover_image = cover_image;
    final lOther$cover_image = other.cover_image;
    if (_$data.containsKey('cover_image') !=
        other._$data.containsKey('cover_image')) {
      return false;
    }
    if (l$cover_image != lOther$cover_image) {
      return false;
    }
    final l$stash_ids = stash_ids;
    final lOther$stash_ids = other.stash_ids;
    if (_$data.containsKey('stash_ids') !=
        other._$data.containsKey('stash_ids')) {
      return false;
    }
    if (l$stash_ids != null && lOther$stash_ids != null) {
      if (l$stash_ids.length != lOther$stash_ids.length) {
        return false;
      }
      for (int i = 0; i < l$stash_ids.length; i++) {
        final l$stash_ids$entry = l$stash_ids[i];
        final lOther$stash_ids$entry = lOther$stash_ids[i];
        if (l$stash_ids$entry != lOther$stash_ids$entry) {
          return false;
        }
      }
    } else if (l$stash_ids != lOther$stash_ids) {
      return false;
    }
    final l$file_ids = file_ids;
    final lOther$file_ids = other.file_ids;
    if (_$data.containsKey('file_ids') !=
        other._$data.containsKey('file_ids')) {
      return false;
    }
    if (l$file_ids != null && lOther$file_ids != null) {
      if (l$file_ids.length != lOther$file_ids.length) {
        return false;
      }
      for (int i = 0; i < l$file_ids.length; i++) {
        final l$file_ids$entry = l$file_ids[i];
        final lOther$file_ids$entry = lOther$file_ids[i];
        if (l$file_ids$entry != lOther$file_ids$entry) {
          return false;
        }
      }
    } else if (l$file_ids != lOther$file_ids) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$title = title;
    final l$code = code;
    final l$details = details;
    final l$director = director;
    final l$url = url;
    final l$urls = urls;
    final l$date = date;
    final l$rating100 = rating100;
    final l$organized = organized;
    final l$studio_id = studio_id;
    final l$gallery_ids = gallery_ids;
    final l$performer_ids = performer_ids;
    final l$groups = groups;
    final l$movies = movies;
    final l$tag_ids = tag_ids;
    final l$cover_image = cover_image;
    final l$stash_ids = stash_ids;
    final l$file_ids = file_ids;
    return Object.hashAll([
      _$data.containsKey('title') ? l$title : const {},
      _$data.containsKey('code') ? l$code : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('director') ? l$director : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls')
          ? l$urls == null
              ? null
              : Object.hashAll(l$urls.map((v) => v))
          : const {},
      _$data.containsKey('date') ? l$date : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('organized') ? l$organized : const {},
      _$data.containsKey('studio_id') ? l$studio_id : const {},
      _$data.containsKey('gallery_ids')
          ? l$gallery_ids == null
              ? null
              : Object.hashAll(l$gallery_ids.map((v) => v))
          : const {},
      _$data.containsKey('performer_ids')
          ? l$performer_ids == null
              ? null
              : Object.hashAll(l$performer_ids.map((v) => v))
          : const {},
      _$data.containsKey('groups')
          ? l$groups == null
              ? null
              : Object.hashAll(l$groups.map((v) => v))
          : const {},
      _$data.containsKey('movies')
          ? l$movies == null
              ? null
              : Object.hashAll(l$movies.map((v) => v))
          : const {},
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
              ? null
              : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
      _$data.containsKey('cover_image') ? l$cover_image : const {},
      _$data.containsKey('stash_ids')
          ? l$stash_ids == null
              ? null
              : Object.hashAll(l$stash_ids.map((v) => v))
          : const {},
      _$data.containsKey('file_ids')
          ? l$file_ids == null
              ? null
              : Object.hashAll(l$file_ids.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$SceneCreateInput<TRes> {
  factory CopyWith$Input$SceneCreateInput(
    Input$SceneCreateInput instance,
    TRes Function(Input$SceneCreateInput) then,
  ) = _CopyWithImpl$Input$SceneCreateInput;

  factory CopyWith$Input$SceneCreateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SceneCreateInput;

  TRes call({
    String? title,
    String? code,
    String? details,
    String? director,
    String? url,
    List<String>? urls,
    String? date,
    int? rating100,
    bool? organized,
    String? studio_id,
    List<String>? gallery_ids,
    List<String>? performer_ids,
    List<Input$SceneGroupInput>? groups,
    List<Input$SceneMovieInput>? movies,
    List<String>? tag_ids,
    String? cover_image,
    List<Input$StashIDInput>? stash_ids,
    List<String>? file_ids,
  });
  TRes groups(
      Iterable<Input$SceneGroupInput>? Function(
              Iterable<CopyWith$Input$SceneGroupInput<Input$SceneGroupInput>>?)
          _fn);
  TRes movies(
      Iterable<Input$SceneMovieInput>? Function(
              Iterable<CopyWith$Input$SceneMovieInput<Input$SceneMovieInput>>?)
          _fn);
}

class _CopyWithImpl$Input$SceneCreateInput<TRes>
    implements CopyWith$Input$SceneCreateInput<TRes> {
  _CopyWithImpl$Input$SceneCreateInput(
    this._instance,
    this._then,
  );

  final Input$SceneCreateInput _instance;

  final TRes Function(Input$SceneCreateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? title = _undefined,
    Object? code = _undefined,
    Object? details = _undefined,
    Object? director = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? date = _undefined,
    Object? rating100 = _undefined,
    Object? organized = _undefined,
    Object? studio_id = _undefined,
    Object? gallery_ids = _undefined,
    Object? performer_ids = _undefined,
    Object? groups = _undefined,
    Object? movies = _undefined,
    Object? tag_ids = _undefined,
    Object? cover_image = _undefined,
    Object? stash_ids = _undefined,
    Object? file_ids = _undefined,
  }) =>
      _then(Input$SceneCreateInput._({
        ..._instance._$data,
        if (title != _undefined) 'title': (title as String?),
        if (code != _undefined) 'code': (code as String?),
        if (details != _undefined) 'details': (details as String?),
        if (director != _undefined) 'director': (director as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (date != _undefined) 'date': (date as String?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (organized != _undefined) 'organized': (organized as bool?),
        if (studio_id != _undefined) 'studio_id': (studio_id as String?),
        if (gallery_ids != _undefined)
          'gallery_ids': (gallery_ids as List<String>?),
        if (performer_ids != _undefined)
          'performer_ids': (performer_ids as List<String>?),
        if (groups != _undefined)
          'groups': (groups as List<Input$SceneGroupInput>?),
        if (movies != _undefined)
          'movies': (movies as List<Input$SceneMovieInput>?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
        if (cover_image != _undefined) 'cover_image': (cover_image as String?),
        if (stash_ids != _undefined)
          'stash_ids': (stash_ids as List<Input$StashIDInput>?),
        if (file_ids != _undefined) 'file_ids': (file_ids as List<String>?),
      }));

  TRes groups(
          Iterable<Input$SceneGroupInput>? Function(
                  Iterable<
                      CopyWith$Input$SceneGroupInput<Input$SceneGroupInput>>?)
              _fn) =>
      call(
          groups:
              _fn(_instance.groups?.map((e) => CopyWith$Input$SceneGroupInput(
                    e,
                    (i) => i,
                  )))?.toList());

  TRes movies(
          Iterable<Input$SceneMovieInput>? Function(
                  Iterable<
                      CopyWith$Input$SceneMovieInput<Input$SceneMovieInput>>?)
              _fn) =>
      call(
          movies:
              _fn(_instance.movies?.map((e) => CopyWith$Input$SceneMovieInput(
                    e,
                    (i) => i,
                  )))?.toList());
}

class _CopyWithStubImpl$Input$SceneCreateInput<TRes>
    implements CopyWith$Input$SceneCreateInput<TRes> {
  _CopyWithStubImpl$Input$SceneCreateInput(this._res);

  TRes _res;

  call({
    String? title,
    String? code,
    String? details,
    String? director,
    String? url,
    List<String>? urls,
    String? date,
    int? rating100,
    bool? organized,
    String? studio_id,
    List<String>? gallery_ids,
    List<String>? performer_ids,
    List<Input$SceneGroupInput>? groups,
    List<Input$SceneMovieInput>? movies,
    List<String>? tag_ids,
    String? cover_image,
    List<Input$StashIDInput>? stash_ids,
    List<String>? file_ids,
  }) =>
      _res;

  groups(_fn) => _res;

  movies(_fn) => _res;
}

class Input$SceneUpdateInput {
  factory Input$SceneUpdateInput({
    String? clientMutationId,
    required String id,
    String? title,
    String? code,
    String? details,
    String? director,
    String? url,
    List<String>? urls,
    String? date,
    int? rating100,
    int? o_counter,
    bool? organized,
    String? studio_id,
    List<String>? gallery_ids,
    List<String>? performer_ids,
    List<Input$SceneGroupInput>? groups,
    List<Input$SceneMovieInput>? movies,
    List<String>? tag_ids,
    String? cover_image,
    List<Input$StashIDInput>? stash_ids,
    double? resume_time,
    double? play_duration,
    int? play_count,
    String? primary_file_id,
  }) =>
      Input$SceneUpdateInput._({
        if (clientMutationId != null) r'clientMutationId': clientMutationId,
        r'id': id,
        if (title != null) r'title': title,
        if (code != null) r'code': code,
        if (details != null) r'details': details,
        if (director != null) r'director': director,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (date != null) r'date': date,
        if (rating100 != null) r'rating100': rating100,
        if (o_counter != null) r'o_counter': o_counter,
        if (organized != null) r'organized': organized,
        if (studio_id != null) r'studio_id': studio_id,
        if (gallery_ids != null) r'gallery_ids': gallery_ids,
        if (performer_ids != null) r'performer_ids': performer_ids,
        if (groups != null) r'groups': groups,
        if (movies != null) r'movies': movies,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (cover_image != null) r'cover_image': cover_image,
        if (stash_ids != null) r'stash_ids': stash_ids,
        if (resume_time != null) r'resume_time': resume_time,
        if (play_duration != null) r'play_duration': play_duration,
        if (play_count != null) r'play_count': play_count,
        if (primary_file_id != null) r'primary_file_id': primary_file_id,
      });

  Input$SceneUpdateInput._(this._$data);

  factory Input$SceneUpdateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('clientMutationId')) {
      final l$clientMutationId = data['clientMutationId'];
      result$data['clientMutationId'] = (l$clientMutationId as String?);
    }
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('title')) {
      final l$title = data['title'];
      result$data['title'] = (l$title as String?);
    }
    if (data.containsKey('code')) {
      final l$code = data['code'];
      result$data['code'] = (l$code as String?);
    }
    if (data.containsKey('details')) {
      final l$details = data['details'];
      result$data['details'] = (l$details as String?);
    }
    if (data.containsKey('director')) {
      final l$director = data['director'];
      result$data['director'] = (l$director as String?);
    }
    if (data.containsKey('url')) {
      final l$url = data['url'];
      result$data['url'] = (l$url as String?);
    }
    if (data.containsKey('urls')) {
      final l$urls = data['urls'];
      result$data['urls'] =
          (l$urls as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('date')) {
      final l$date = data['date'];
      result$data['date'] = (l$date as String?);
    }
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    if (data.containsKey('o_counter')) {
      final l$o_counter = data['o_counter'];
      result$data['o_counter'] = (l$o_counter as int?);
    }
    if (data.containsKey('organized')) {
      final l$organized = data['organized'];
      result$data['organized'] = (l$organized as bool?);
    }
    if (data.containsKey('studio_id')) {
      final l$studio_id = data['studio_id'];
      result$data['studio_id'] = (l$studio_id as String?);
    }
    if (data.containsKey('gallery_ids')) {
      final l$gallery_ids = data['gallery_ids'];
      result$data['gallery_ids'] =
          (l$gallery_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('performer_ids')) {
      final l$performer_ids = data['performer_ids'];
      result$data['performer_ids'] = (l$performer_ids as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('groups')) {
      final l$groups = data['groups'];
      result$data['groups'] = (l$groups as List<dynamic>?)
          ?.map((e) =>
              Input$SceneGroupInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('movies')) {
      final l$movies = data['movies'];
      result$data['movies'] = (l$movies as List<dynamic>?)
          ?.map((e) =>
              Input$SceneMovieInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] =
          (l$tag_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('cover_image')) {
      final l$cover_image = data['cover_image'];
      result$data['cover_image'] = (l$cover_image as String?);
    }
    if (data.containsKey('stash_ids')) {
      final l$stash_ids = data['stash_ids'];
      result$data['stash_ids'] = (l$stash_ids as List<dynamic>?)
          ?.map((e) => Input$StashIDInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('resume_time')) {
      final l$resume_time = data['resume_time'];
      result$data['resume_time'] = (l$resume_time as num?)?.toDouble();
    }
    if (data.containsKey('play_duration')) {
      final l$play_duration = data['play_duration'];
      result$data['play_duration'] = (l$play_duration as num?)?.toDouble();
    }
    if (data.containsKey('play_count')) {
      final l$play_count = data['play_count'];
      result$data['play_count'] = (l$play_count as int?);
    }
    if (data.containsKey('primary_file_id')) {
      final l$primary_file_id = data['primary_file_id'];
      result$data['primary_file_id'] = (l$primary_file_id as String?);
    }
    return Input$SceneUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get clientMutationId => (_$data['clientMutationId'] as String?);

  String get id => (_$data['id'] as String);

  String? get title => (_$data['title'] as String?);

  String? get code => (_$data['code'] as String?);

  String? get details => (_$data['details'] as String?);

  String? get director => (_$data['director'] as String?);

  String? get url => (_$data['url'] as String?);

  List<String>? get urls => (_$data['urls'] as List<String>?);

  String? get date => (_$data['date'] as String?);

  int? get rating100 => (_$data['rating100'] as int?);

  int? get o_counter => (_$data['o_counter'] as int?);

  bool? get organized => (_$data['organized'] as bool?);

  String? get studio_id => (_$data['studio_id'] as String?);

  List<String>? get gallery_ids => (_$data['gallery_ids'] as List<String>?);

  List<String>? get performer_ids => (_$data['performer_ids'] as List<String>?);

  List<Input$SceneGroupInput>? get groups =>
      (_$data['groups'] as List<Input$SceneGroupInput>?);

  List<Input$SceneMovieInput>? get movies =>
      (_$data['movies'] as List<Input$SceneMovieInput>?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  String? get cover_image => (_$data['cover_image'] as String?);

  List<Input$StashIDInput>? get stash_ids =>
      (_$data['stash_ids'] as List<Input$StashIDInput>?);

  double? get resume_time => (_$data['resume_time'] as double?);

  double? get play_duration => (_$data['play_duration'] as double?);

  int? get play_count => (_$data['play_count'] as int?);

  String? get primary_file_id => (_$data['primary_file_id'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('clientMutationId')) {
      final l$clientMutationId = clientMutationId;
      result$data['clientMutationId'] = l$clientMutationId;
    }
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('title')) {
      final l$title = title;
      result$data['title'] = l$title;
    }
    if (_$data.containsKey('code')) {
      final l$code = code;
      result$data['code'] = l$code;
    }
    if (_$data.containsKey('details')) {
      final l$details = details;
      result$data['details'] = l$details;
    }
    if (_$data.containsKey('director')) {
      final l$director = director;
      result$data['director'] = l$director;
    }
    if (_$data.containsKey('url')) {
      final l$url = url;
      result$data['url'] = l$url;
    }
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.map((e) => e).toList();
    }
    if (_$data.containsKey('date')) {
      final l$date = date;
      result$data['date'] = l$date;
    }
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    if (_$data.containsKey('o_counter')) {
      final l$o_counter = o_counter;
      result$data['o_counter'] = l$o_counter;
    }
    if (_$data.containsKey('organized')) {
      final l$organized = organized;
      result$data['organized'] = l$organized;
    }
    if (_$data.containsKey('studio_id')) {
      final l$studio_id = studio_id;
      result$data['studio_id'] = l$studio_id;
    }
    if (_$data.containsKey('gallery_ids')) {
      final l$gallery_ids = gallery_ids;
      result$data['gallery_ids'] = l$gallery_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('performer_ids')) {
      final l$performer_ids = performer_ids;
      result$data['performer_ids'] = l$performer_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('groups')) {
      final l$groups = groups;
      result$data['groups'] = l$groups?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('movies')) {
      final l$movies = movies;
      result$data['movies'] = l$movies?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('cover_image')) {
      final l$cover_image = cover_image;
      result$data['cover_image'] = l$cover_image;
    }
    if (_$data.containsKey('stash_ids')) {
      final l$stash_ids = stash_ids;
      result$data['stash_ids'] = l$stash_ids?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('resume_time')) {
      final l$resume_time = resume_time;
      result$data['resume_time'] = l$resume_time;
    }
    if (_$data.containsKey('play_duration')) {
      final l$play_duration = play_duration;
      result$data['play_duration'] = l$play_duration;
    }
    if (_$data.containsKey('play_count')) {
      final l$play_count = play_count;
      result$data['play_count'] = l$play_count;
    }
    if (_$data.containsKey('primary_file_id')) {
      final l$primary_file_id = primary_file_id;
      result$data['primary_file_id'] = l$primary_file_id;
    }
    return result$data;
  }

  CopyWith$Input$SceneUpdateInput<Input$SceneUpdateInput> get copyWith =>
      CopyWith$Input$SceneUpdateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$SceneUpdateInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$clientMutationId = clientMutationId;
    final lOther$clientMutationId = other.clientMutationId;
    if (_$data.containsKey('clientMutationId') !=
        other._$data.containsKey('clientMutationId')) {
      return false;
    }
    if (l$clientMutationId != lOther$clientMutationId) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (_$data.containsKey('title') != other._$data.containsKey('title')) {
      return false;
    }
    if (l$title != lOther$title) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (_$data.containsKey('code') != other._$data.containsKey('code')) {
      return false;
    }
    if (l$code != lOther$code) {
      return false;
    }
    final l$details = details;
    final lOther$details = other.details;
    if (_$data.containsKey('details') != other._$data.containsKey('details')) {
      return false;
    }
    if (l$details != lOther$details) {
      return false;
    }
    final l$director = director;
    final lOther$director = other.director;
    if (_$data.containsKey('director') !=
        other._$data.containsKey('director')) {
      return false;
    }
    if (l$director != lOther$director) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (_$data.containsKey('url') != other._$data.containsKey('url')) {
      return false;
    }
    if (l$url != lOther$url) {
      return false;
    }
    final l$urls = urls;
    final lOther$urls = other.urls;
    if (_$data.containsKey('urls') != other._$data.containsKey('urls')) {
      return false;
    }
    if (l$urls != null && lOther$urls != null) {
      if (l$urls.length != lOther$urls.length) {
        return false;
      }
      for (int i = 0; i < l$urls.length; i++) {
        final l$urls$entry = l$urls[i];
        final lOther$urls$entry = lOther$urls[i];
        if (l$urls$entry != lOther$urls$entry) {
          return false;
        }
      }
    } else if (l$urls != lOther$urls) {
      return false;
    }
    final l$date = date;
    final lOther$date = other.date;
    if (_$data.containsKey('date') != other._$data.containsKey('date')) {
      return false;
    }
    if (l$date != lOther$date) {
      return false;
    }
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (_$data.containsKey('rating100') !=
        other._$data.containsKey('rating100')) {
      return false;
    }
    if (l$rating100 != lOther$rating100) {
      return false;
    }
    final l$o_counter = o_counter;
    final lOther$o_counter = other.o_counter;
    if (_$data.containsKey('o_counter') !=
        other._$data.containsKey('o_counter')) {
      return false;
    }
    if (l$o_counter != lOther$o_counter) {
      return false;
    }
    final l$organized = organized;
    final lOther$organized = other.organized;
    if (_$data.containsKey('organized') !=
        other._$data.containsKey('organized')) {
      return false;
    }
    if (l$organized != lOther$organized) {
      return false;
    }
    final l$studio_id = studio_id;
    final lOther$studio_id = other.studio_id;
    if (_$data.containsKey('studio_id') !=
        other._$data.containsKey('studio_id')) {
      return false;
    }
    if (l$studio_id != lOther$studio_id) {
      return false;
    }
    final l$gallery_ids = gallery_ids;
    final lOther$gallery_ids = other.gallery_ids;
    if (_$data.containsKey('gallery_ids') !=
        other._$data.containsKey('gallery_ids')) {
      return false;
    }
    if (l$gallery_ids != null && lOther$gallery_ids != null) {
      if (l$gallery_ids.length != lOther$gallery_ids.length) {
        return false;
      }
      for (int i = 0; i < l$gallery_ids.length; i++) {
        final l$gallery_ids$entry = l$gallery_ids[i];
        final lOther$gallery_ids$entry = lOther$gallery_ids[i];
        if (l$gallery_ids$entry != lOther$gallery_ids$entry) {
          return false;
        }
      }
    } else if (l$gallery_ids != lOther$gallery_ids) {
      return false;
    }
    final l$performer_ids = performer_ids;
    final lOther$performer_ids = other.performer_ids;
    if (_$data.containsKey('performer_ids') !=
        other._$data.containsKey('performer_ids')) {
      return false;
    }
    if (l$performer_ids != null && lOther$performer_ids != null) {
      if (l$performer_ids.length != lOther$performer_ids.length) {
        return false;
      }
      for (int i = 0; i < l$performer_ids.length; i++) {
        final l$performer_ids$entry = l$performer_ids[i];
        final lOther$performer_ids$entry = lOther$performer_ids[i];
        if (l$performer_ids$entry != lOther$performer_ids$entry) {
          return false;
        }
      }
    } else if (l$performer_ids != lOther$performer_ids) {
      return false;
    }
    final l$groups = groups;
    final lOther$groups = other.groups;
    if (_$data.containsKey('groups') != other._$data.containsKey('groups')) {
      return false;
    }
    if (l$groups != null && lOther$groups != null) {
      if (l$groups.length != lOther$groups.length) {
        return false;
      }
      for (int i = 0; i < l$groups.length; i++) {
        final l$groups$entry = l$groups[i];
        final lOther$groups$entry = lOther$groups[i];
        if (l$groups$entry != lOther$groups$entry) {
          return false;
        }
      }
    } else if (l$groups != lOther$groups) {
      return false;
    }
    final l$movies = movies;
    final lOther$movies = other.movies;
    if (_$data.containsKey('movies') != other._$data.containsKey('movies')) {
      return false;
    }
    if (l$movies != null && lOther$movies != null) {
      if (l$movies.length != lOther$movies.length) {
        return false;
      }
      for (int i = 0; i < l$movies.length; i++) {
        final l$movies$entry = l$movies[i];
        final lOther$movies$entry = lOther$movies[i];
        if (l$movies$entry != lOther$movies$entry) {
          return false;
        }
      }
    } else if (l$movies != lOther$movies) {
      return false;
    }
    final l$tag_ids = tag_ids;
    final lOther$tag_ids = other.tag_ids;
    if (_$data.containsKey('tag_ids') != other._$data.containsKey('tag_ids')) {
      return false;
    }
    if (l$tag_ids != null && lOther$tag_ids != null) {
      if (l$tag_ids.length != lOther$tag_ids.length) {
        return false;
      }
      for (int i = 0; i < l$tag_ids.length; i++) {
        final l$tag_ids$entry = l$tag_ids[i];
        final lOther$tag_ids$entry = lOther$tag_ids[i];
        if (l$tag_ids$entry != lOther$tag_ids$entry) {
          return false;
        }
      }
    } else if (l$tag_ids != lOther$tag_ids) {
      return false;
    }
    final l$cover_image = cover_image;
    final lOther$cover_image = other.cover_image;
    if (_$data.containsKey('cover_image') !=
        other._$data.containsKey('cover_image')) {
      return false;
    }
    if (l$cover_image != lOther$cover_image) {
      return false;
    }
    final l$stash_ids = stash_ids;
    final lOther$stash_ids = other.stash_ids;
    if (_$data.containsKey('stash_ids') !=
        other._$data.containsKey('stash_ids')) {
      return false;
    }
    if (l$stash_ids != null && lOther$stash_ids != null) {
      if (l$stash_ids.length != lOther$stash_ids.length) {
        return false;
      }
      for (int i = 0; i < l$stash_ids.length; i++) {
        final l$stash_ids$entry = l$stash_ids[i];
        final lOther$stash_ids$entry = lOther$stash_ids[i];
        if (l$stash_ids$entry != lOther$stash_ids$entry) {
          return false;
        }
      }
    } else if (l$stash_ids != lOther$stash_ids) {
      return false;
    }
    final l$resume_time = resume_time;
    final lOther$resume_time = other.resume_time;
    if (_$data.containsKey('resume_time') !=
        other._$data.containsKey('resume_time')) {
      return false;
    }
    if (l$resume_time != lOther$resume_time) {
      return false;
    }
    final l$play_duration = play_duration;
    final lOther$play_duration = other.play_duration;
    if (_$data.containsKey('play_duration') !=
        other._$data.containsKey('play_duration')) {
      return false;
    }
    if (l$play_duration != lOther$play_duration) {
      return false;
    }
    final l$play_count = play_count;
    final lOther$play_count = other.play_count;
    if (_$data.containsKey('play_count') !=
        other._$data.containsKey('play_count')) {
      return false;
    }
    if (l$play_count != lOther$play_count) {
      return false;
    }
    final l$primary_file_id = primary_file_id;
    final lOther$primary_file_id = other.primary_file_id;
    if (_$data.containsKey('primary_file_id') !=
        other._$data.containsKey('primary_file_id')) {
      return false;
    }
    if (l$primary_file_id != lOther$primary_file_id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$clientMutationId = clientMutationId;
    final l$id = id;
    final l$title = title;
    final l$code = code;
    final l$details = details;
    final l$director = director;
    final l$url = url;
    final l$urls = urls;
    final l$date = date;
    final l$rating100 = rating100;
    final l$o_counter = o_counter;
    final l$organized = organized;
    final l$studio_id = studio_id;
    final l$gallery_ids = gallery_ids;
    final l$performer_ids = performer_ids;
    final l$groups = groups;
    final l$movies = movies;
    final l$tag_ids = tag_ids;
    final l$cover_image = cover_image;
    final l$stash_ids = stash_ids;
    final l$resume_time = resume_time;
    final l$play_duration = play_duration;
    final l$play_count = play_count;
    final l$primary_file_id = primary_file_id;
    return Object.hashAll([
      _$data.containsKey('clientMutationId') ? l$clientMutationId : const {},
      l$id,
      _$data.containsKey('title') ? l$title : const {},
      _$data.containsKey('code') ? l$code : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('director') ? l$director : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls')
          ? l$urls == null
              ? null
              : Object.hashAll(l$urls.map((v) => v))
          : const {},
      _$data.containsKey('date') ? l$date : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('o_counter') ? l$o_counter : const {},
      _$data.containsKey('organized') ? l$organized : const {},
      _$data.containsKey('studio_id') ? l$studio_id : const {},
      _$data.containsKey('gallery_ids')
          ? l$gallery_ids == null
              ? null
              : Object.hashAll(l$gallery_ids.map((v) => v))
          : const {},
      _$data.containsKey('performer_ids')
          ? l$performer_ids == null
              ? null
              : Object.hashAll(l$performer_ids.map((v) => v))
          : const {},
      _$data.containsKey('groups')
          ? l$groups == null
              ? null
              : Object.hashAll(l$groups.map((v) => v))
          : const {},
      _$data.containsKey('movies')
          ? l$movies == null
              ? null
              : Object.hashAll(l$movies.map((v) => v))
          : const {},
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
              ? null
              : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
      _$data.containsKey('cover_image') ? l$cover_image : const {},
      _$data.containsKey('stash_ids')
          ? l$stash_ids == null
              ? null
              : Object.hashAll(l$stash_ids.map((v) => v))
          : const {},
      _$data.containsKey('resume_time') ? l$resume_time : const {},
      _$data.containsKey('play_duration') ? l$play_duration : const {},
      _$data.containsKey('play_count') ? l$play_count : const {},
      _$data.containsKey('primary_file_id') ? l$primary_file_id : const {},
    ]);
  }
}

abstract class CopyWith$Input$SceneUpdateInput<TRes> {
  factory CopyWith$Input$SceneUpdateInput(
    Input$SceneUpdateInput instance,
    TRes Function(Input$SceneUpdateInput) then,
  ) = _CopyWithImpl$Input$SceneUpdateInput;

  factory CopyWith$Input$SceneUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SceneUpdateInput;

  TRes call({
    String? clientMutationId,
    String? id,
    String? title,
    String? code,
    String? details,
    String? director,
    String? url,
    List<String>? urls,
    String? date,
    int? rating100,
    int? o_counter,
    bool? organized,
    String? studio_id,
    List<String>? gallery_ids,
    List<String>? performer_ids,
    List<Input$SceneGroupInput>? groups,
    List<Input$SceneMovieInput>? movies,
    List<String>? tag_ids,
    String? cover_image,
    List<Input$StashIDInput>? stash_ids,
    double? resume_time,
    double? play_duration,
    int? play_count,
    String? primary_file_id,
  });
  TRes groups(
      Iterable<Input$SceneGroupInput>? Function(
              Iterable<CopyWith$Input$SceneGroupInput<Input$SceneGroupInput>>?)
          _fn);
  TRes movies(
      Iterable<Input$SceneMovieInput>? Function(
              Iterable<CopyWith$Input$SceneMovieInput<Input$SceneMovieInput>>?)
          _fn);
}

class _CopyWithImpl$Input$SceneUpdateInput<TRes>
    implements CopyWith$Input$SceneUpdateInput<TRes> {
  _CopyWithImpl$Input$SceneUpdateInput(
    this._instance,
    this._then,
  );

  final Input$SceneUpdateInput _instance;

  final TRes Function(Input$SceneUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? clientMutationId = _undefined,
    Object? id = _undefined,
    Object? title = _undefined,
    Object? code = _undefined,
    Object? details = _undefined,
    Object? director = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? date = _undefined,
    Object? rating100 = _undefined,
    Object? o_counter = _undefined,
    Object? organized = _undefined,
    Object? studio_id = _undefined,
    Object? gallery_ids = _undefined,
    Object? performer_ids = _undefined,
    Object? groups = _undefined,
    Object? movies = _undefined,
    Object? tag_ids = _undefined,
    Object? cover_image = _undefined,
    Object? stash_ids = _undefined,
    Object? resume_time = _undefined,
    Object? play_duration = _undefined,
    Object? play_count = _undefined,
    Object? primary_file_id = _undefined,
  }) =>
      _then(Input$SceneUpdateInput._({
        ..._instance._$data,
        if (clientMutationId != _undefined)
          'clientMutationId': (clientMutationId as String?),
        if (id != _undefined && id != null) 'id': (id as String),
        if (title != _undefined) 'title': (title as String?),
        if (code != _undefined) 'code': (code as String?),
        if (details != _undefined) 'details': (details as String?),
        if (director != _undefined) 'director': (director as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (date != _undefined) 'date': (date as String?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (o_counter != _undefined) 'o_counter': (o_counter as int?),
        if (organized != _undefined) 'organized': (organized as bool?),
        if (studio_id != _undefined) 'studio_id': (studio_id as String?),
        if (gallery_ids != _undefined)
          'gallery_ids': (gallery_ids as List<String>?),
        if (performer_ids != _undefined)
          'performer_ids': (performer_ids as List<String>?),
        if (groups != _undefined)
          'groups': (groups as List<Input$SceneGroupInput>?),
        if (movies != _undefined)
          'movies': (movies as List<Input$SceneMovieInput>?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
        if (cover_image != _undefined) 'cover_image': (cover_image as String?),
        if (stash_ids != _undefined)
          'stash_ids': (stash_ids as List<Input$StashIDInput>?),
        if (resume_time != _undefined) 'resume_time': (resume_time as double?),
        if (play_duration != _undefined)
          'play_duration': (play_duration as double?),
        if (play_count != _undefined) 'play_count': (play_count as int?),
        if (primary_file_id != _undefined)
          'primary_file_id': (primary_file_id as String?),
      }));

  TRes groups(
          Iterable<Input$SceneGroupInput>? Function(
                  Iterable<
                      CopyWith$Input$SceneGroupInput<Input$SceneGroupInput>>?)
              _fn) =>
      call(
          groups:
              _fn(_instance.groups?.map((e) => CopyWith$Input$SceneGroupInput(
                    e,
                    (i) => i,
                  )))?.toList());

  TRes movies(
          Iterable<Input$SceneMovieInput>? Function(
                  Iterable<
                      CopyWith$Input$SceneMovieInput<Input$SceneMovieInput>>?)
              _fn) =>
      call(
          movies:
              _fn(_instance.movies?.map((e) => CopyWith$Input$SceneMovieInput(
                    e,
                    (i) => i,
                  )))?.toList());
}

class _CopyWithStubImpl$Input$SceneUpdateInput<TRes>
    implements CopyWith$Input$SceneUpdateInput<TRes> {
  _CopyWithStubImpl$Input$SceneUpdateInput(this._res);

  TRes _res;

  call({
    String? clientMutationId,
    String? id,
    String? title,
    String? code,
    String? details,
    String? director,
    String? url,
    List<String>? urls,
    String? date,
    int? rating100,
    int? o_counter,
    bool? organized,
    String? studio_id,
    List<String>? gallery_ids,
    List<String>? performer_ids,
    List<Input$SceneGroupInput>? groups,
    List<Input$SceneMovieInput>? movies,
    List<String>? tag_ids,
    String? cover_image,
    List<Input$StashIDInput>? stash_ids,
    double? resume_time,
    double? play_duration,
    int? play_count,
    String? primary_file_id,
  }) =>
      _res;

  groups(_fn) => _res;

  movies(_fn) => _res;
}

class Input$BulkUpdateIds {
  factory Input$BulkUpdateIds({
    List<String>? ids,
    required Enum$BulkUpdateIdMode mode,
  }) =>
      Input$BulkUpdateIds._({
        if (ids != null) r'ids': ids,
        r'mode': mode,
      });

  Input$BulkUpdateIds._(this._$data);

  factory Input$BulkUpdateIds.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('ids')) {
      final l$ids = data['ids'];
      result$data['ids'] =
          (l$ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    final l$mode = data['mode'];
    result$data['mode'] = fromJson$Enum$BulkUpdateIdMode((l$mode as String));
    return Input$BulkUpdateIds._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String>? get ids => (_$data['ids'] as List<String>?);

  Enum$BulkUpdateIdMode get mode => (_$data['mode'] as Enum$BulkUpdateIdMode);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('ids')) {
      final l$ids = ids;
      result$data['ids'] = l$ids?.map((e) => e).toList();
    }
    final l$mode = mode;
    result$data['mode'] = toJson$Enum$BulkUpdateIdMode(l$mode);
    return result$data;
  }

  CopyWith$Input$BulkUpdateIds<Input$BulkUpdateIds> get copyWith =>
      CopyWith$Input$BulkUpdateIds(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$BulkUpdateIds) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$ids = ids;
    final lOther$ids = other.ids;
    if (_$data.containsKey('ids') != other._$data.containsKey('ids')) {
      return false;
    }
    if (l$ids != null && lOther$ids != null) {
      if (l$ids.length != lOther$ids.length) {
        return false;
      }
      for (int i = 0; i < l$ids.length; i++) {
        final l$ids$entry = l$ids[i];
        final lOther$ids$entry = lOther$ids[i];
        if (l$ids$entry != lOther$ids$entry) {
          return false;
        }
      }
    } else if (l$ids != lOther$ids) {
      return false;
    }
    final l$mode = mode;
    final lOther$mode = other.mode;
    if (l$mode != lOther$mode) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$ids = ids;
    final l$mode = mode;
    return Object.hashAll([
      _$data.containsKey('ids')
          ? l$ids == null
              ? null
              : Object.hashAll(l$ids.map((v) => v))
          : const {},
      l$mode,
    ]);
  }
}

abstract class CopyWith$Input$BulkUpdateIds<TRes> {
  factory CopyWith$Input$BulkUpdateIds(
    Input$BulkUpdateIds instance,
    TRes Function(Input$BulkUpdateIds) then,
  ) = _CopyWithImpl$Input$BulkUpdateIds;

  factory CopyWith$Input$BulkUpdateIds.stub(TRes res) =
      _CopyWithStubImpl$Input$BulkUpdateIds;

  TRes call({
    List<String>? ids,
    Enum$BulkUpdateIdMode? mode,
  });
}

class _CopyWithImpl$Input$BulkUpdateIds<TRes>
    implements CopyWith$Input$BulkUpdateIds<TRes> {
  _CopyWithImpl$Input$BulkUpdateIds(
    this._instance,
    this._then,
  );

  final Input$BulkUpdateIds _instance;

  final TRes Function(Input$BulkUpdateIds) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ids = _undefined,
    Object? mode = _undefined,
  }) =>
      _then(Input$BulkUpdateIds._({
        ..._instance._$data,
        if (ids != _undefined) 'ids': (ids as List<String>?),
        if (mode != _undefined && mode != null)
          'mode': (mode as Enum$BulkUpdateIdMode),
      }));
}

class _CopyWithStubImpl$Input$BulkUpdateIds<TRes>
    implements CopyWith$Input$BulkUpdateIds<TRes> {
  _CopyWithStubImpl$Input$BulkUpdateIds(this._res);

  TRes _res;

  call({
    List<String>? ids,
    Enum$BulkUpdateIdMode? mode,
  }) =>
      _res;
}

class Input$BulkSceneUpdateInput {
  factory Input$BulkSceneUpdateInput({
    String? clientMutationId,
    List<String>? ids,
    String? title,
    String? code,
    String? details,
    String? director,
    String? url,
    Input$BulkUpdateStrings? urls,
    String? date,
    int? rating100,
    bool? organized,
    String? studio_id,
    Input$BulkUpdateIds? gallery_ids,
    Input$BulkUpdateIds? performer_ids,
    Input$BulkUpdateIds? tag_ids,
    Input$BulkUpdateIds? group_ids,
    Input$BulkUpdateIds? movie_ids,
  }) =>
      Input$BulkSceneUpdateInput._({
        if (clientMutationId != null) r'clientMutationId': clientMutationId,
        if (ids != null) r'ids': ids,
        if (title != null) r'title': title,
        if (code != null) r'code': code,
        if (details != null) r'details': details,
        if (director != null) r'director': director,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (date != null) r'date': date,
        if (rating100 != null) r'rating100': rating100,
        if (organized != null) r'organized': organized,
        if (studio_id != null) r'studio_id': studio_id,
        if (gallery_ids != null) r'gallery_ids': gallery_ids,
        if (performer_ids != null) r'performer_ids': performer_ids,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (group_ids != null) r'group_ids': group_ids,
        if (movie_ids != null) r'movie_ids': movie_ids,
      });

  Input$BulkSceneUpdateInput._(this._$data);

  factory Input$BulkSceneUpdateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('clientMutationId')) {
      final l$clientMutationId = data['clientMutationId'];
      result$data['clientMutationId'] = (l$clientMutationId as String?);
    }
    if (data.containsKey('ids')) {
      final l$ids = data['ids'];
      result$data['ids'] =
          (l$ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('title')) {
      final l$title = data['title'];
      result$data['title'] = (l$title as String?);
    }
    if (data.containsKey('code')) {
      final l$code = data['code'];
      result$data['code'] = (l$code as String?);
    }
    if (data.containsKey('details')) {
      final l$details = data['details'];
      result$data['details'] = (l$details as String?);
    }
    if (data.containsKey('director')) {
      final l$director = data['director'];
      result$data['director'] = (l$director as String?);
    }
    if (data.containsKey('url')) {
      final l$url = data['url'];
      result$data['url'] = (l$url as String?);
    }
    if (data.containsKey('urls')) {
      final l$urls = data['urls'];
      result$data['urls'] = l$urls == null
          ? null
          : Input$BulkUpdateStrings.fromJson((l$urls as Map<String, dynamic>));
    }
    if (data.containsKey('date')) {
      final l$date = data['date'];
      result$data['date'] = (l$date as String?);
    }
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    if (data.containsKey('organized')) {
      final l$organized = data['organized'];
      result$data['organized'] = (l$organized as bool?);
    }
    if (data.containsKey('studio_id')) {
      final l$studio_id = data['studio_id'];
      result$data['studio_id'] = (l$studio_id as String?);
    }
    if (data.containsKey('gallery_ids')) {
      final l$gallery_ids = data['gallery_ids'];
      result$data['gallery_ids'] = l$gallery_ids == null
          ? null
          : Input$BulkUpdateIds.fromJson(
              (l$gallery_ids as Map<String, dynamic>));
    }
    if (data.containsKey('performer_ids')) {
      final l$performer_ids = data['performer_ids'];
      result$data['performer_ids'] = l$performer_ids == null
          ? null
          : Input$BulkUpdateIds.fromJson(
              (l$performer_ids as Map<String, dynamic>));
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] = l$tag_ids == null
          ? null
          : Input$BulkUpdateIds.fromJson((l$tag_ids as Map<String, dynamic>));
    }
    if (data.containsKey('group_ids')) {
      final l$group_ids = data['group_ids'];
      result$data['group_ids'] = l$group_ids == null
          ? null
          : Input$BulkUpdateIds.fromJson((l$group_ids as Map<String, dynamic>));
    }
    if (data.containsKey('movie_ids')) {
      final l$movie_ids = data['movie_ids'];
      result$data['movie_ids'] = l$movie_ids == null
          ? null
          : Input$BulkUpdateIds.fromJson((l$movie_ids as Map<String, dynamic>));
    }
    return Input$BulkSceneUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get clientMutationId => (_$data['clientMutationId'] as String?);

  List<String>? get ids => (_$data['ids'] as List<String>?);

  String? get title => (_$data['title'] as String?);

  String? get code => (_$data['code'] as String?);

  String? get details => (_$data['details'] as String?);

  String? get director => (_$data['director'] as String?);

  String? get url => (_$data['url'] as String?);

  Input$BulkUpdateStrings? get urls =>
      (_$data['urls'] as Input$BulkUpdateStrings?);

  String? get date => (_$data['date'] as String?);

  int? get rating100 => (_$data['rating100'] as int?);

  bool? get organized => (_$data['organized'] as bool?);

  String? get studio_id => (_$data['studio_id'] as String?);

  Input$BulkUpdateIds? get gallery_ids =>
      (_$data['gallery_ids'] as Input$BulkUpdateIds?);

  Input$BulkUpdateIds? get performer_ids =>
      (_$data['performer_ids'] as Input$BulkUpdateIds?);

  Input$BulkUpdateIds? get tag_ids =>
      (_$data['tag_ids'] as Input$BulkUpdateIds?);

  Input$BulkUpdateIds? get group_ids =>
      (_$data['group_ids'] as Input$BulkUpdateIds?);

  Input$BulkUpdateIds? get movie_ids =>
      (_$data['movie_ids'] as Input$BulkUpdateIds?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('clientMutationId')) {
      final l$clientMutationId = clientMutationId;
      result$data['clientMutationId'] = l$clientMutationId;
    }
    if (_$data.containsKey('ids')) {
      final l$ids = ids;
      result$data['ids'] = l$ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('title')) {
      final l$title = title;
      result$data['title'] = l$title;
    }
    if (_$data.containsKey('code')) {
      final l$code = code;
      result$data['code'] = l$code;
    }
    if (_$data.containsKey('details')) {
      final l$details = details;
      result$data['details'] = l$details;
    }
    if (_$data.containsKey('director')) {
      final l$director = director;
      result$data['director'] = l$director;
    }
    if (_$data.containsKey('url')) {
      final l$url = url;
      result$data['url'] = l$url;
    }
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.toJson();
    }
    if (_$data.containsKey('date')) {
      final l$date = date;
      result$data['date'] = l$date;
    }
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    if (_$data.containsKey('organized')) {
      final l$organized = organized;
      result$data['organized'] = l$organized;
    }
    if (_$data.containsKey('studio_id')) {
      final l$studio_id = studio_id;
      result$data['studio_id'] = l$studio_id;
    }
    if (_$data.containsKey('gallery_ids')) {
      final l$gallery_ids = gallery_ids;
      result$data['gallery_ids'] = l$gallery_ids?.toJson();
    }
    if (_$data.containsKey('performer_ids')) {
      final l$performer_ids = performer_ids;
      result$data['performer_ids'] = l$performer_ids?.toJson();
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.toJson();
    }
    if (_$data.containsKey('group_ids')) {
      final l$group_ids = group_ids;
      result$data['group_ids'] = l$group_ids?.toJson();
    }
    if (_$data.containsKey('movie_ids')) {
      final l$movie_ids = movie_ids;
      result$data['movie_ids'] = l$movie_ids?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$BulkSceneUpdateInput<Input$BulkSceneUpdateInput>
      get copyWith => CopyWith$Input$BulkSceneUpdateInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$BulkSceneUpdateInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$clientMutationId = clientMutationId;
    final lOther$clientMutationId = other.clientMutationId;
    if (_$data.containsKey('clientMutationId') !=
        other._$data.containsKey('clientMutationId')) {
      return false;
    }
    if (l$clientMutationId != lOther$clientMutationId) {
      return false;
    }
    final l$ids = ids;
    final lOther$ids = other.ids;
    if (_$data.containsKey('ids') != other._$data.containsKey('ids')) {
      return false;
    }
    if (l$ids != null && lOther$ids != null) {
      if (l$ids.length != lOther$ids.length) {
        return false;
      }
      for (int i = 0; i < l$ids.length; i++) {
        final l$ids$entry = l$ids[i];
        final lOther$ids$entry = lOther$ids[i];
        if (l$ids$entry != lOther$ids$entry) {
          return false;
        }
      }
    } else if (l$ids != lOther$ids) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (_$data.containsKey('title') != other._$data.containsKey('title')) {
      return false;
    }
    if (l$title != lOther$title) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (_$data.containsKey('code') != other._$data.containsKey('code')) {
      return false;
    }
    if (l$code != lOther$code) {
      return false;
    }
    final l$details = details;
    final lOther$details = other.details;
    if (_$data.containsKey('details') != other._$data.containsKey('details')) {
      return false;
    }
    if (l$details != lOther$details) {
      return false;
    }
    final l$director = director;
    final lOther$director = other.director;
    if (_$data.containsKey('director') !=
        other._$data.containsKey('director')) {
      return false;
    }
    if (l$director != lOther$director) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (_$data.containsKey('url') != other._$data.containsKey('url')) {
      return false;
    }
    if (l$url != lOther$url) {
      return false;
    }
    final l$urls = urls;
    final lOther$urls = other.urls;
    if (_$data.containsKey('urls') != other._$data.containsKey('urls')) {
      return false;
    }
    if (l$urls != lOther$urls) {
      return false;
    }
    final l$date = date;
    final lOther$date = other.date;
    if (_$data.containsKey('date') != other._$data.containsKey('date')) {
      return false;
    }
    if (l$date != lOther$date) {
      return false;
    }
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (_$data.containsKey('rating100') !=
        other._$data.containsKey('rating100')) {
      return false;
    }
    if (l$rating100 != lOther$rating100) {
      return false;
    }
    final l$organized = organized;
    final lOther$organized = other.organized;
    if (_$data.containsKey('organized') !=
        other._$data.containsKey('organized')) {
      return false;
    }
    if (l$organized != lOther$organized) {
      return false;
    }
    final l$studio_id = studio_id;
    final lOther$studio_id = other.studio_id;
    if (_$data.containsKey('studio_id') !=
        other._$data.containsKey('studio_id')) {
      return false;
    }
    if (l$studio_id != lOther$studio_id) {
      return false;
    }
    final l$gallery_ids = gallery_ids;
    final lOther$gallery_ids = other.gallery_ids;
    if (_$data.containsKey('gallery_ids') !=
        other._$data.containsKey('gallery_ids')) {
      return false;
    }
    if (l$gallery_ids != lOther$gallery_ids) {
      return false;
    }
    final l$performer_ids = performer_ids;
    final lOther$performer_ids = other.performer_ids;
    if (_$data.containsKey('performer_ids') !=
        other._$data.containsKey('performer_ids')) {
      return false;
    }
    if (l$performer_ids != lOther$performer_ids) {
      return false;
    }
    final l$tag_ids = tag_ids;
    final lOther$tag_ids = other.tag_ids;
    if (_$data.containsKey('tag_ids') != other._$data.containsKey('tag_ids')) {
      return false;
    }
    if (l$tag_ids != lOther$tag_ids) {
      return false;
    }
    final l$group_ids = group_ids;
    final lOther$group_ids = other.group_ids;
    if (_$data.containsKey('group_ids') !=
        other._$data.containsKey('group_ids')) {
      return false;
    }
    if (l$group_ids != lOther$group_ids) {
      return false;
    }
    final l$movie_ids = movie_ids;
    final lOther$movie_ids = other.movie_ids;
    if (_$data.containsKey('movie_ids') !=
        other._$data.containsKey('movie_ids')) {
      return false;
    }
    if (l$movie_ids != lOther$movie_ids) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$clientMutationId = clientMutationId;
    final l$ids = ids;
    final l$title = title;
    final l$code = code;
    final l$details = details;
    final l$director = director;
    final l$url = url;
    final l$urls = urls;
    final l$date = date;
    final l$rating100 = rating100;
    final l$organized = organized;
    final l$studio_id = studio_id;
    final l$gallery_ids = gallery_ids;
    final l$performer_ids = performer_ids;
    final l$tag_ids = tag_ids;
    final l$group_ids = group_ids;
    final l$movie_ids = movie_ids;
    return Object.hashAll([
      _$data.containsKey('clientMutationId') ? l$clientMutationId : const {},
      _$data.containsKey('ids')
          ? l$ids == null
              ? null
              : Object.hashAll(l$ids.map((v) => v))
          : const {},
      _$data.containsKey('title') ? l$title : const {},
      _$data.containsKey('code') ? l$code : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('director') ? l$director : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls') ? l$urls : const {},
      _$data.containsKey('date') ? l$date : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('organized') ? l$organized : const {},
      _$data.containsKey('studio_id') ? l$studio_id : const {},
      _$data.containsKey('gallery_ids') ? l$gallery_ids : const {},
      _$data.containsKey('performer_ids') ? l$performer_ids : const {},
      _$data.containsKey('tag_ids') ? l$tag_ids : const {},
      _$data.containsKey('group_ids') ? l$group_ids : const {},
      _$data.containsKey('movie_ids') ? l$movie_ids : const {},
    ]);
  }
}

abstract class CopyWith$Input$BulkSceneUpdateInput<TRes> {
  factory CopyWith$Input$BulkSceneUpdateInput(
    Input$BulkSceneUpdateInput instance,
    TRes Function(Input$BulkSceneUpdateInput) then,
  ) = _CopyWithImpl$Input$BulkSceneUpdateInput;

  factory CopyWith$Input$BulkSceneUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$BulkSceneUpdateInput;

  TRes call({
    String? clientMutationId,
    List<String>? ids,
    String? title,
    String? code,
    String? details,
    String? director,
    String? url,
    Input$BulkUpdateStrings? urls,
    String? date,
    int? rating100,
    bool? organized,
    String? studio_id,
    Input$BulkUpdateIds? gallery_ids,
    Input$BulkUpdateIds? performer_ids,
    Input$BulkUpdateIds? tag_ids,
    Input$BulkUpdateIds? group_ids,
    Input$BulkUpdateIds? movie_ids,
  });
  CopyWith$Input$BulkUpdateIds<TRes> get gallery_ids;
  CopyWith$Input$BulkUpdateIds<TRes> get performer_ids;
  CopyWith$Input$BulkUpdateIds<TRes> get tag_ids;
  CopyWith$Input$BulkUpdateIds<TRes> get group_ids;
  CopyWith$Input$BulkUpdateIds<TRes> get movie_ids;
}

class _CopyWithImpl$Input$BulkSceneUpdateInput<TRes>
    implements CopyWith$Input$BulkSceneUpdateInput<TRes> {
  _CopyWithImpl$Input$BulkSceneUpdateInput(
    this._instance,
    this._then,
  );

  final Input$BulkSceneUpdateInput _instance;

  final TRes Function(Input$BulkSceneUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? clientMutationId = _undefined,
    Object? ids = _undefined,
    Object? title = _undefined,
    Object? code = _undefined,
    Object? details = _undefined,
    Object? director = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? date = _undefined,
    Object? rating100 = _undefined,
    Object? organized = _undefined,
    Object? studio_id = _undefined,
    Object? gallery_ids = _undefined,
    Object? performer_ids = _undefined,
    Object? tag_ids = _undefined,
    Object? group_ids = _undefined,
    Object? movie_ids = _undefined,
  }) =>
      _then(Input$BulkSceneUpdateInput._({
        ..._instance._$data,
        if (clientMutationId != _undefined)
          'clientMutationId': (clientMutationId as String?),
        if (ids != _undefined) 'ids': (ids as List<String>?),
        if (title != _undefined) 'title': (title as String?),
        if (code != _undefined) 'code': (code as String?),
        if (details != _undefined) 'details': (details as String?),
        if (director != _undefined) 'director': (director as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as Input$BulkUpdateStrings?),
        if (date != _undefined) 'date': (date as String?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (organized != _undefined) 'organized': (organized as bool?),
        if (studio_id != _undefined) 'studio_id': (studio_id as String?),
        if (gallery_ids != _undefined)
          'gallery_ids': (gallery_ids as Input$BulkUpdateIds?),
        if (performer_ids != _undefined)
          'performer_ids': (performer_ids as Input$BulkUpdateIds?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as Input$BulkUpdateIds?),
        if (group_ids != _undefined)
          'group_ids': (group_ids as Input$BulkUpdateIds?),
        if (movie_ids != _undefined)
          'movie_ids': (movie_ids as Input$BulkUpdateIds?),
      }));

  CopyWith$Input$BulkUpdateIds<TRes> get gallery_ids {
    final local$gallery_ids = _instance.gallery_ids;
    return local$gallery_ids == null
        ? CopyWith$Input$BulkUpdateIds.stub(_then(_instance))
        : CopyWith$Input$BulkUpdateIds(
            local$gallery_ids, (e) => call(gallery_ids: e));
  }

  CopyWith$Input$BulkUpdateIds<TRes> get performer_ids {
    final local$performer_ids = _instance.performer_ids;
    return local$performer_ids == null
        ? CopyWith$Input$BulkUpdateIds.stub(_then(_instance))
        : CopyWith$Input$BulkUpdateIds(
            local$performer_ids, (e) => call(performer_ids: e));
  }

  CopyWith$Input$BulkUpdateIds<TRes> get tag_ids {
    final local$tag_ids = _instance.tag_ids;
    return local$tag_ids == null
        ? CopyWith$Input$BulkUpdateIds.stub(_then(_instance))
        : CopyWith$Input$BulkUpdateIds(local$tag_ids, (e) => call(tag_ids: e));
  }

  CopyWith$Input$BulkUpdateIds<TRes> get group_ids {
    final local$group_ids = _instance.group_ids;
    return local$group_ids == null
        ? CopyWith$Input$BulkUpdateIds.stub(_then(_instance))
        : CopyWith$Input$BulkUpdateIds(
            local$group_ids, (e) => call(group_ids: e));
  }

  CopyWith$Input$BulkUpdateIds<TRes> get movie_ids {
    final local$movie_ids = _instance.movie_ids;
    return local$movie_ids == null
        ? CopyWith$Input$BulkUpdateIds.stub(_then(_instance))
        : CopyWith$Input$BulkUpdateIds(
            local$movie_ids, (e) => call(movie_ids: e));
  }
}

class _CopyWithStubImpl$Input$BulkSceneUpdateInput<TRes>
    implements CopyWith$Input$BulkSceneUpdateInput<TRes> {
  _CopyWithStubImpl$Input$BulkSceneUpdateInput(this._res);

  TRes _res;

  call({
    String? clientMutationId,
    List<String>? ids,
    String? title,
    String? code,
    String? details,
    String? director,
    String? url,
    Input$BulkUpdateStrings? urls,
    String? date,
    int? rating100,
    bool? organized,
    String? studio_id,
    Input$BulkUpdateIds? gallery_ids,
    Input$BulkUpdateIds? performer_ids,
    Input$BulkUpdateIds? tag_ids,
    Input$BulkUpdateIds? group_ids,
    Input$BulkUpdateIds? movie_ids,
  }) =>
      _res;

  CopyWith$Input$BulkUpdateIds<TRes> get gallery_ids =>
      CopyWith$Input$BulkUpdateIds.stub(_res);

  CopyWith$Input$BulkUpdateIds<TRes> get performer_ids =>
      CopyWith$Input$BulkUpdateIds.stub(_res);

  CopyWith$Input$BulkUpdateIds<TRes> get tag_ids =>
      CopyWith$Input$BulkUpdateIds.stub(_res);

  CopyWith$Input$BulkUpdateIds<TRes> get group_ids =>
      CopyWith$Input$BulkUpdateIds.stub(_res);

  CopyWith$Input$BulkUpdateIds<TRes> get movie_ids =>
      CopyWith$Input$BulkUpdateIds.stub(_res);
}

class Input$SceneDestroyInput {
  factory Input$SceneDestroyInput({
    required String id,
    bool? delete_file,
    bool? delete_generated,
  }) =>
      Input$SceneDestroyInput._({
        r'id': id,
        if (delete_file != null) r'delete_file': delete_file,
        if (delete_generated != null) r'delete_generated': delete_generated,
      });

  Input$SceneDestroyInput._(this._$data);

  factory Input$SceneDestroyInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('delete_file')) {
      final l$delete_file = data['delete_file'];
      result$data['delete_file'] = (l$delete_file as bool?);
    }
    if (data.containsKey('delete_generated')) {
      final l$delete_generated = data['delete_generated'];
      result$data['delete_generated'] = (l$delete_generated as bool?);
    }
    return Input$SceneDestroyInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  bool? get delete_file => (_$data['delete_file'] as bool?);

  bool? get delete_generated => (_$data['delete_generated'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('delete_file')) {
      final l$delete_file = delete_file;
      result$data['delete_file'] = l$delete_file;
    }
    if (_$data.containsKey('delete_generated')) {
      final l$delete_generated = delete_generated;
      result$data['delete_generated'] = l$delete_generated;
    }
    return result$data;
  }

  CopyWith$Input$SceneDestroyInput<Input$SceneDestroyInput> get copyWith =>
      CopyWith$Input$SceneDestroyInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$SceneDestroyInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$delete_file = delete_file;
    final lOther$delete_file = other.delete_file;
    if (_$data.containsKey('delete_file') !=
        other._$data.containsKey('delete_file')) {
      return false;
    }
    if (l$delete_file != lOther$delete_file) {
      return false;
    }
    final l$delete_generated = delete_generated;
    final lOther$delete_generated = other.delete_generated;
    if (_$data.containsKey('delete_generated') !=
        other._$data.containsKey('delete_generated')) {
      return false;
    }
    if (l$delete_generated != lOther$delete_generated) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$delete_file = delete_file;
    final l$delete_generated = delete_generated;
    return Object.hashAll([
      l$id,
      _$data.containsKey('delete_file') ? l$delete_file : const {},
      _$data.containsKey('delete_generated') ? l$delete_generated : const {},
    ]);
  }
}

abstract class CopyWith$Input$SceneDestroyInput<TRes> {
  factory CopyWith$Input$SceneDestroyInput(
    Input$SceneDestroyInput instance,
    TRes Function(Input$SceneDestroyInput) then,
  ) = _CopyWithImpl$Input$SceneDestroyInput;

  factory CopyWith$Input$SceneDestroyInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SceneDestroyInput;

  TRes call({
    String? id,
    bool? delete_file,
    bool? delete_generated,
  });
}

class _CopyWithImpl$Input$SceneDestroyInput<TRes>
    implements CopyWith$Input$SceneDestroyInput<TRes> {
  _CopyWithImpl$Input$SceneDestroyInput(
    this._instance,
    this._then,
  );

  final Input$SceneDestroyInput _instance;

  final TRes Function(Input$SceneDestroyInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? delete_file = _undefined,
    Object? delete_generated = _undefined,
  }) =>
      _then(Input$SceneDestroyInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (delete_file != _undefined) 'delete_file': (delete_file as bool?),
        if (delete_generated != _undefined)
          'delete_generated': (delete_generated as bool?),
      }));
}

class _CopyWithStubImpl$Input$SceneDestroyInput<TRes>
    implements CopyWith$Input$SceneDestroyInput<TRes> {
  _CopyWithStubImpl$Input$SceneDestroyInput(this._res);

  TRes _res;

  call({
    String? id,
    bool? delete_file,
    bool? delete_generated,
  }) =>
      _res;
}

class Input$ScenesDestroyInput {
  factory Input$ScenesDestroyInput({
    required List<String> ids,
    bool? delete_file,
    bool? delete_generated,
  }) =>
      Input$ScenesDestroyInput._({
        r'ids': ids,
        if (delete_file != null) r'delete_file': delete_file,
        if (delete_generated != null) r'delete_generated': delete_generated,
      });

  Input$ScenesDestroyInput._(this._$data);

  factory Input$ScenesDestroyInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$ids = data['ids'];
    result$data['ids'] =
        (l$ids as List<dynamic>).map((e) => (e as String)).toList();
    if (data.containsKey('delete_file')) {
      final l$delete_file = data['delete_file'];
      result$data['delete_file'] = (l$delete_file as bool?);
    }
    if (data.containsKey('delete_generated')) {
      final l$delete_generated = data['delete_generated'];
      result$data['delete_generated'] = (l$delete_generated as bool?);
    }
    return Input$ScenesDestroyInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String> get ids => (_$data['ids'] as List<String>);

  bool? get delete_file => (_$data['delete_file'] as bool?);

  bool? get delete_generated => (_$data['delete_generated'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$ids = ids;
    result$data['ids'] = l$ids.map((e) => e).toList();
    if (_$data.containsKey('delete_file')) {
      final l$delete_file = delete_file;
      result$data['delete_file'] = l$delete_file;
    }
    if (_$data.containsKey('delete_generated')) {
      final l$delete_generated = delete_generated;
      result$data['delete_generated'] = l$delete_generated;
    }
    return result$data;
  }

  CopyWith$Input$ScenesDestroyInput<Input$ScenesDestroyInput> get copyWith =>
      CopyWith$Input$ScenesDestroyInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScenesDestroyInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ids = ids;
    final lOther$ids = other.ids;
    if (l$ids.length != lOther$ids.length) {
      return false;
    }
    for (int i = 0; i < l$ids.length; i++) {
      final l$ids$entry = l$ids[i];
      final lOther$ids$entry = lOther$ids[i];
      if (l$ids$entry != lOther$ids$entry) {
        return false;
      }
    }
    final l$delete_file = delete_file;
    final lOther$delete_file = other.delete_file;
    if (_$data.containsKey('delete_file') !=
        other._$data.containsKey('delete_file')) {
      return false;
    }
    if (l$delete_file != lOther$delete_file) {
      return false;
    }
    final l$delete_generated = delete_generated;
    final lOther$delete_generated = other.delete_generated;
    if (_$data.containsKey('delete_generated') !=
        other._$data.containsKey('delete_generated')) {
      return false;
    }
    if (l$delete_generated != lOther$delete_generated) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$ids = ids;
    final l$delete_file = delete_file;
    final l$delete_generated = delete_generated;
    return Object.hashAll([
      Object.hashAll(l$ids.map((v) => v)),
      _$data.containsKey('delete_file') ? l$delete_file : const {},
      _$data.containsKey('delete_generated') ? l$delete_generated : const {},
    ]);
  }
}

abstract class CopyWith$Input$ScenesDestroyInput<TRes> {
  factory CopyWith$Input$ScenesDestroyInput(
    Input$ScenesDestroyInput instance,
    TRes Function(Input$ScenesDestroyInput) then,
  ) = _CopyWithImpl$Input$ScenesDestroyInput;

  factory CopyWith$Input$ScenesDestroyInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScenesDestroyInput;

  TRes call({
    List<String>? ids,
    bool? delete_file,
    bool? delete_generated,
  });
}

class _CopyWithImpl$Input$ScenesDestroyInput<TRes>
    implements CopyWith$Input$ScenesDestroyInput<TRes> {
  _CopyWithImpl$Input$ScenesDestroyInput(
    this._instance,
    this._then,
  );

  final Input$ScenesDestroyInput _instance;

  final TRes Function(Input$ScenesDestroyInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ids = _undefined,
    Object? delete_file = _undefined,
    Object? delete_generated = _undefined,
  }) =>
      _then(Input$ScenesDestroyInput._({
        ..._instance._$data,
        if (ids != _undefined && ids != null) 'ids': (ids as List<String>),
        if (delete_file != _undefined) 'delete_file': (delete_file as bool?),
        if (delete_generated != _undefined)
          'delete_generated': (delete_generated as bool?),
      }));
}

class _CopyWithStubImpl$Input$ScenesDestroyInput<TRes>
    implements CopyWith$Input$ScenesDestroyInput<TRes> {
  _CopyWithStubImpl$Input$ScenesDestroyInput(this._res);

  TRes _res;

  call({
    List<String>? ids,
    bool? delete_file,
    bool? delete_generated,
  }) =>
      _res;
}

class Input$SceneParserInput {
  factory Input$SceneParserInput({
    List<String>? ignoreWords,
    String? whitespaceCharacters,
    bool? capitalizeTitle,
    bool? ignoreOrganized,
  }) =>
      Input$SceneParserInput._({
        if (ignoreWords != null) r'ignoreWords': ignoreWords,
        if (whitespaceCharacters != null)
          r'whitespaceCharacters': whitespaceCharacters,
        if (capitalizeTitle != null) r'capitalizeTitle': capitalizeTitle,
        if (ignoreOrganized != null) r'ignoreOrganized': ignoreOrganized,
      });

  Input$SceneParserInput._(this._$data);

  factory Input$SceneParserInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('ignoreWords')) {
      final l$ignoreWords = data['ignoreWords'];
      result$data['ignoreWords'] =
          (l$ignoreWords as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('whitespaceCharacters')) {
      final l$whitespaceCharacters = data['whitespaceCharacters'];
      result$data['whitespaceCharacters'] = (l$whitespaceCharacters as String?);
    }
    if (data.containsKey('capitalizeTitle')) {
      final l$capitalizeTitle = data['capitalizeTitle'];
      result$data['capitalizeTitle'] = (l$capitalizeTitle as bool?);
    }
    if (data.containsKey('ignoreOrganized')) {
      final l$ignoreOrganized = data['ignoreOrganized'];
      result$data['ignoreOrganized'] = (l$ignoreOrganized as bool?);
    }
    return Input$SceneParserInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String>? get ignoreWords => (_$data['ignoreWords'] as List<String>?);

  String? get whitespaceCharacters =>
      (_$data['whitespaceCharacters'] as String?);

  bool? get capitalizeTitle => (_$data['capitalizeTitle'] as bool?);

  bool? get ignoreOrganized => (_$data['ignoreOrganized'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('ignoreWords')) {
      final l$ignoreWords = ignoreWords;
      result$data['ignoreWords'] = l$ignoreWords?.map((e) => e).toList();
    }
    if (_$data.containsKey('whitespaceCharacters')) {
      final l$whitespaceCharacters = whitespaceCharacters;
      result$data['whitespaceCharacters'] = l$whitespaceCharacters;
    }
    if (_$data.containsKey('capitalizeTitle')) {
      final l$capitalizeTitle = capitalizeTitle;
      result$data['capitalizeTitle'] = l$capitalizeTitle;
    }
    if (_$data.containsKey('ignoreOrganized')) {
      final l$ignoreOrganized = ignoreOrganized;
      result$data['ignoreOrganized'] = l$ignoreOrganized;
    }
    return result$data;
  }

  CopyWith$Input$SceneParserInput<Input$SceneParserInput> get copyWith =>
      CopyWith$Input$SceneParserInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$SceneParserInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ignoreWords = ignoreWords;
    final lOther$ignoreWords = other.ignoreWords;
    if (_$data.containsKey('ignoreWords') !=
        other._$data.containsKey('ignoreWords')) {
      return false;
    }
    if (l$ignoreWords != null && lOther$ignoreWords != null) {
      if (l$ignoreWords.length != lOther$ignoreWords.length) {
        return false;
      }
      for (int i = 0; i < l$ignoreWords.length; i++) {
        final l$ignoreWords$entry = l$ignoreWords[i];
        final lOther$ignoreWords$entry = lOther$ignoreWords[i];
        if (l$ignoreWords$entry != lOther$ignoreWords$entry) {
          return false;
        }
      }
    } else if (l$ignoreWords != lOther$ignoreWords) {
      return false;
    }
    final l$whitespaceCharacters = whitespaceCharacters;
    final lOther$whitespaceCharacters = other.whitespaceCharacters;
    if (_$data.containsKey('whitespaceCharacters') !=
        other._$data.containsKey('whitespaceCharacters')) {
      return false;
    }
    if (l$whitespaceCharacters != lOther$whitespaceCharacters) {
      return false;
    }
    final l$capitalizeTitle = capitalizeTitle;
    final lOther$capitalizeTitle = other.capitalizeTitle;
    if (_$data.containsKey('capitalizeTitle') !=
        other._$data.containsKey('capitalizeTitle')) {
      return false;
    }
    if (l$capitalizeTitle != lOther$capitalizeTitle) {
      return false;
    }
    final l$ignoreOrganized = ignoreOrganized;
    final lOther$ignoreOrganized = other.ignoreOrganized;
    if (_$data.containsKey('ignoreOrganized') !=
        other._$data.containsKey('ignoreOrganized')) {
      return false;
    }
    if (l$ignoreOrganized != lOther$ignoreOrganized) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$ignoreWords = ignoreWords;
    final l$whitespaceCharacters = whitespaceCharacters;
    final l$capitalizeTitle = capitalizeTitle;
    final l$ignoreOrganized = ignoreOrganized;
    return Object.hashAll([
      _$data.containsKey('ignoreWords')
          ? l$ignoreWords == null
              ? null
              : Object.hashAll(l$ignoreWords.map((v) => v))
          : const {},
      _$data.containsKey('whitespaceCharacters')
          ? l$whitespaceCharacters
          : const {},
      _$data.containsKey('capitalizeTitle') ? l$capitalizeTitle : const {},
      _$data.containsKey('ignoreOrganized') ? l$ignoreOrganized : const {},
    ]);
  }
}

abstract class CopyWith$Input$SceneParserInput<TRes> {
  factory CopyWith$Input$SceneParserInput(
    Input$SceneParserInput instance,
    TRes Function(Input$SceneParserInput) then,
  ) = _CopyWithImpl$Input$SceneParserInput;

  factory CopyWith$Input$SceneParserInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SceneParserInput;

  TRes call({
    List<String>? ignoreWords,
    String? whitespaceCharacters,
    bool? capitalizeTitle,
    bool? ignoreOrganized,
  });
}

class _CopyWithImpl$Input$SceneParserInput<TRes>
    implements CopyWith$Input$SceneParserInput<TRes> {
  _CopyWithImpl$Input$SceneParserInput(
    this._instance,
    this._then,
  );

  final Input$SceneParserInput _instance;

  final TRes Function(Input$SceneParserInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ignoreWords = _undefined,
    Object? whitespaceCharacters = _undefined,
    Object? capitalizeTitle = _undefined,
    Object? ignoreOrganized = _undefined,
  }) =>
      _then(Input$SceneParserInput._({
        ..._instance._$data,
        if (ignoreWords != _undefined)
          'ignoreWords': (ignoreWords as List<String>?),
        if (whitespaceCharacters != _undefined)
          'whitespaceCharacters': (whitespaceCharacters as String?),
        if (capitalizeTitle != _undefined)
          'capitalizeTitle': (capitalizeTitle as bool?),
        if (ignoreOrganized != _undefined)
          'ignoreOrganized': (ignoreOrganized as bool?),
      }));
}

class _CopyWithStubImpl$Input$SceneParserInput<TRes>
    implements CopyWith$Input$SceneParserInput<TRes> {
  _CopyWithStubImpl$Input$SceneParserInput(this._res);

  TRes _res;

  call({
    List<String>? ignoreWords,
    String? whitespaceCharacters,
    bool? capitalizeTitle,
    bool? ignoreOrganized,
  }) =>
      _res;
}

class Input$SceneHashInput {
  factory Input$SceneHashInput({
    String? checksum,
    String? oshash,
  }) =>
      Input$SceneHashInput._({
        if (checksum != null) r'checksum': checksum,
        if (oshash != null) r'oshash': oshash,
      });

  Input$SceneHashInput._(this._$data);

  factory Input$SceneHashInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('checksum')) {
      final l$checksum = data['checksum'];
      result$data['checksum'] = (l$checksum as String?);
    }
    if (data.containsKey('oshash')) {
      final l$oshash = data['oshash'];
      result$data['oshash'] = (l$oshash as String?);
    }
    return Input$SceneHashInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get checksum => (_$data['checksum'] as String?);

  String? get oshash => (_$data['oshash'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('checksum')) {
      final l$checksum = checksum;
      result$data['checksum'] = l$checksum;
    }
    if (_$data.containsKey('oshash')) {
      final l$oshash = oshash;
      result$data['oshash'] = l$oshash;
    }
    return result$data;
  }

  CopyWith$Input$SceneHashInput<Input$SceneHashInput> get copyWith =>
      CopyWith$Input$SceneHashInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$SceneHashInput) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$checksum = checksum;
    final lOther$checksum = other.checksum;
    if (_$data.containsKey('checksum') !=
        other._$data.containsKey('checksum')) {
      return false;
    }
    if (l$checksum != lOther$checksum) {
      return false;
    }
    final l$oshash = oshash;
    final lOther$oshash = other.oshash;
    if (_$data.containsKey('oshash') != other._$data.containsKey('oshash')) {
      return false;
    }
    if (l$oshash != lOther$oshash) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$checksum = checksum;
    final l$oshash = oshash;
    return Object.hashAll([
      _$data.containsKey('checksum') ? l$checksum : const {},
      _$data.containsKey('oshash') ? l$oshash : const {},
    ]);
  }
}

abstract class CopyWith$Input$SceneHashInput<TRes> {
  factory CopyWith$Input$SceneHashInput(
    Input$SceneHashInput instance,
    TRes Function(Input$SceneHashInput) then,
  ) = _CopyWithImpl$Input$SceneHashInput;

  factory CopyWith$Input$SceneHashInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SceneHashInput;

  TRes call({
    String? checksum,
    String? oshash,
  });
}

class _CopyWithImpl$Input$SceneHashInput<TRes>
    implements CopyWith$Input$SceneHashInput<TRes> {
  _CopyWithImpl$Input$SceneHashInput(
    this._instance,
    this._then,
  );

  final Input$SceneHashInput _instance;

  final TRes Function(Input$SceneHashInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? checksum = _undefined,
    Object? oshash = _undefined,
  }) =>
      _then(Input$SceneHashInput._({
        ..._instance._$data,
        if (checksum != _undefined) 'checksum': (checksum as String?),
        if (oshash != _undefined) 'oshash': (oshash as String?),
      }));
}

class _CopyWithStubImpl$Input$SceneHashInput<TRes>
    implements CopyWith$Input$SceneHashInput<TRes> {
  _CopyWithStubImpl$Input$SceneHashInput(this._res);

  TRes _res;

  call({
    String? checksum,
    String? oshash,
  }) =>
      _res;
}

class Input$AssignSceneFileInput {
  factory Input$AssignSceneFileInput({
    required String scene_id,
    required String file_id,
  }) =>
      Input$AssignSceneFileInput._({
        r'scene_id': scene_id,
        r'file_id': file_id,
      });

  Input$AssignSceneFileInput._(this._$data);

  factory Input$AssignSceneFileInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$scene_id = data['scene_id'];
    result$data['scene_id'] = (l$scene_id as String);
    final l$file_id = data['file_id'];
    result$data['file_id'] = (l$file_id as String);
    return Input$AssignSceneFileInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get scene_id => (_$data['scene_id'] as String);

  String get file_id => (_$data['file_id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$scene_id = scene_id;
    result$data['scene_id'] = l$scene_id;
    final l$file_id = file_id;
    result$data['file_id'] = l$file_id;
    return result$data;
  }

  CopyWith$Input$AssignSceneFileInput<Input$AssignSceneFileInput>
      get copyWith => CopyWith$Input$AssignSceneFileInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$AssignSceneFileInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$scene_id = scene_id;
    final lOther$scene_id = other.scene_id;
    if (l$scene_id != lOther$scene_id) {
      return false;
    }
    final l$file_id = file_id;
    final lOther$file_id = other.file_id;
    if (l$file_id != lOther$file_id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$scene_id = scene_id;
    final l$file_id = file_id;
    return Object.hashAll([
      l$scene_id,
      l$file_id,
    ]);
  }
}

abstract class CopyWith$Input$AssignSceneFileInput<TRes> {
  factory CopyWith$Input$AssignSceneFileInput(
    Input$AssignSceneFileInput instance,
    TRes Function(Input$AssignSceneFileInput) then,
  ) = _CopyWithImpl$Input$AssignSceneFileInput;

  factory CopyWith$Input$AssignSceneFileInput.stub(TRes res) =
      _CopyWithStubImpl$Input$AssignSceneFileInput;

  TRes call({
    String? scene_id,
    String? file_id,
  });
}

class _CopyWithImpl$Input$AssignSceneFileInput<TRes>
    implements CopyWith$Input$AssignSceneFileInput<TRes> {
  _CopyWithImpl$Input$AssignSceneFileInput(
    this._instance,
    this._then,
  );

  final Input$AssignSceneFileInput _instance;

  final TRes Function(Input$AssignSceneFileInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? scene_id = _undefined,
    Object? file_id = _undefined,
  }) =>
      _then(Input$AssignSceneFileInput._({
        ..._instance._$data,
        if (scene_id != _undefined && scene_id != null)
          'scene_id': (scene_id as String),
        if (file_id != _undefined && file_id != null)
          'file_id': (file_id as String),
      }));
}

class _CopyWithStubImpl$Input$AssignSceneFileInput<TRes>
    implements CopyWith$Input$AssignSceneFileInput<TRes> {
  _CopyWithStubImpl$Input$AssignSceneFileInput(this._res);

  TRes _res;

  call({
    String? scene_id,
    String? file_id,
  }) =>
      _res;
}

class Input$SceneMergeInput {
  factory Input$SceneMergeInput({
    required List<String> source,
    required String destination,
    Input$SceneUpdateInput? values,
    bool? play_history,
    bool? o_history,
  }) =>
      Input$SceneMergeInput._({
        r'source': source,
        r'destination': destination,
        if (values != null) r'values': values,
        if (play_history != null) r'play_history': play_history,
        if (o_history != null) r'o_history': o_history,
      });

  Input$SceneMergeInput._(this._$data);

  factory Input$SceneMergeInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$source = data['source'];
    result$data['source'] =
        (l$source as List<dynamic>).map((e) => (e as String)).toList();
    final l$destination = data['destination'];
    result$data['destination'] = (l$destination as String);
    if (data.containsKey('values')) {
      final l$values = data['values'];
      result$data['values'] = l$values == null
          ? null
          : Input$SceneUpdateInput.fromJson((l$values as Map<String, dynamic>));
    }
    if (data.containsKey('play_history')) {
      final l$play_history = data['play_history'];
      result$data['play_history'] = (l$play_history as bool?);
    }
    if (data.containsKey('o_history')) {
      final l$o_history = data['o_history'];
      result$data['o_history'] = (l$o_history as bool?);
    }
    return Input$SceneMergeInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String> get source => (_$data['source'] as List<String>);

  String get destination => (_$data['destination'] as String);

  Input$SceneUpdateInput? get values =>
      (_$data['values'] as Input$SceneUpdateInput?);

  bool? get play_history => (_$data['play_history'] as bool?);

  bool? get o_history => (_$data['o_history'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$source = source;
    result$data['source'] = l$source.map((e) => e).toList();
    final l$destination = destination;
    result$data['destination'] = l$destination;
    if (_$data.containsKey('values')) {
      final l$values = values;
      result$data['values'] = l$values?.toJson();
    }
    if (_$data.containsKey('play_history')) {
      final l$play_history = play_history;
      result$data['play_history'] = l$play_history;
    }
    if (_$data.containsKey('o_history')) {
      final l$o_history = o_history;
      result$data['o_history'] = l$o_history;
    }
    return result$data;
  }

  CopyWith$Input$SceneMergeInput<Input$SceneMergeInput> get copyWith =>
      CopyWith$Input$SceneMergeInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$SceneMergeInput) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$source = source;
    final lOther$source = other.source;
    if (l$source.length != lOther$source.length) {
      return false;
    }
    for (int i = 0; i < l$source.length; i++) {
      final l$source$entry = l$source[i];
      final lOther$source$entry = lOther$source[i];
      if (l$source$entry != lOther$source$entry) {
        return false;
      }
    }
    final l$destination = destination;
    final lOther$destination = other.destination;
    if (l$destination != lOther$destination) {
      return false;
    }
    final l$values = values;
    final lOther$values = other.values;
    if (_$data.containsKey('values') != other._$data.containsKey('values')) {
      return false;
    }
    if (l$values != lOther$values) {
      return false;
    }
    final l$play_history = play_history;
    final lOther$play_history = other.play_history;
    if (_$data.containsKey('play_history') !=
        other._$data.containsKey('play_history')) {
      return false;
    }
    if (l$play_history != lOther$play_history) {
      return false;
    }
    final l$o_history = o_history;
    final lOther$o_history = other.o_history;
    if (_$data.containsKey('o_history') !=
        other._$data.containsKey('o_history')) {
      return false;
    }
    if (l$o_history != lOther$o_history) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$source = source;
    final l$destination = destination;
    final l$values = values;
    final l$play_history = play_history;
    final l$o_history = o_history;
    return Object.hashAll([
      Object.hashAll(l$source.map((v) => v)),
      l$destination,
      _$data.containsKey('values') ? l$values : const {},
      _$data.containsKey('play_history') ? l$play_history : const {},
      _$data.containsKey('o_history') ? l$o_history : const {},
    ]);
  }
}

abstract class CopyWith$Input$SceneMergeInput<TRes> {
  factory CopyWith$Input$SceneMergeInput(
    Input$SceneMergeInput instance,
    TRes Function(Input$SceneMergeInput) then,
  ) = _CopyWithImpl$Input$SceneMergeInput;

  factory CopyWith$Input$SceneMergeInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SceneMergeInput;

  TRes call({
    List<String>? source,
    String? destination,
    Input$SceneUpdateInput? values,
    bool? play_history,
    bool? o_history,
  });
  CopyWith$Input$SceneUpdateInput<TRes> get values;
}

class _CopyWithImpl$Input$SceneMergeInput<TRes>
    implements CopyWith$Input$SceneMergeInput<TRes> {
  _CopyWithImpl$Input$SceneMergeInput(
    this._instance,
    this._then,
  );

  final Input$SceneMergeInput _instance;

  final TRes Function(Input$SceneMergeInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? source = _undefined,
    Object? destination = _undefined,
    Object? values = _undefined,
    Object? play_history = _undefined,
    Object? o_history = _undefined,
  }) =>
      _then(Input$SceneMergeInput._({
        ..._instance._$data,
        if (source != _undefined && source != null)
          'source': (source as List<String>),
        if (destination != _undefined && destination != null)
          'destination': (destination as String),
        if (values != _undefined) 'values': (values as Input$SceneUpdateInput?),
        if (play_history != _undefined) 'play_history': (play_history as bool?),
        if (o_history != _undefined) 'o_history': (o_history as bool?),
      }));

  CopyWith$Input$SceneUpdateInput<TRes> get values {
    final local$values = _instance.values;
    return local$values == null
        ? CopyWith$Input$SceneUpdateInput.stub(_then(_instance))
        : CopyWith$Input$SceneUpdateInput(local$values, (e) => call(values: e));
  }
}

class _CopyWithStubImpl$Input$SceneMergeInput<TRes>
    implements CopyWith$Input$SceneMergeInput<TRes> {
  _CopyWithStubImpl$Input$SceneMergeInput(this._res);

  TRes _res;

  call({
    List<String>? source,
    String? destination,
    Input$SceneUpdateInput? values,
    bool? play_history,
    bool? o_history,
  }) =>
      _res;

  CopyWith$Input$SceneUpdateInput<TRes> get values =>
      CopyWith$Input$SceneUpdateInput.stub(_res);
}

enum Enum$BulkUpdateIdMode {
  SET,
  ADD,
  REMOVE,
  $unknown;

  factory Enum$BulkUpdateIdMode.fromJson(String value) =>
      fromJson$Enum$BulkUpdateIdMode(value);

  String toJson() => toJson$Enum$BulkUpdateIdMode(this);
}

String toJson$Enum$BulkUpdateIdMode(Enum$BulkUpdateIdMode e) {
  switch (e) {
    case Enum$BulkUpdateIdMode.SET:
      return r'SET';
    case Enum$BulkUpdateIdMode.ADD:
      return r'ADD';
    case Enum$BulkUpdateIdMode.REMOVE:
      return r'REMOVE';
    case Enum$BulkUpdateIdMode.$unknown:
      return r'$unknown';
  }
}

Enum$BulkUpdateIdMode fromJson$Enum$BulkUpdateIdMode(String value) {
  switch (value) {
    case r'SET':
      return Enum$BulkUpdateIdMode.SET;
    case r'ADD':
      return Enum$BulkUpdateIdMode.ADD;
    case r'REMOVE':
      return Enum$BulkUpdateIdMode.REMOVE;
    default:
      return Enum$BulkUpdateIdMode.$unknown;
  }
}
