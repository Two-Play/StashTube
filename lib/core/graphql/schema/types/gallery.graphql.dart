import 'performer.graphql.dart';
import 'scene.graphql.dart';

class Input$GalleryCreateInput {
  factory Input$GalleryCreateInput({
    required String title,
    String? code,
    String? url,
    List<String>? urls,
    String? date,
    String? details,
    String? photographer,
    int? rating100,
    bool? organized,
    List<String>? scene_ids,
    String? studio_id,
    List<String>? tag_ids,
    List<String>? performer_ids,
  }) =>
      Input$GalleryCreateInput._({
        r'title': title,
        if (code != null) r'code': code,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (date != null) r'date': date,
        if (details != null) r'details': details,
        if (photographer != null) r'photographer': photographer,
        if (rating100 != null) r'rating100': rating100,
        if (organized != null) r'organized': organized,
        if (scene_ids != null) r'scene_ids': scene_ids,
        if (studio_id != null) r'studio_id': studio_id,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (performer_ids != null) r'performer_ids': performer_ids,
      });

  Input$GalleryCreateInput._(this._$data);

  factory Input$GalleryCreateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$title = data['title'];
    result$data['title'] = (l$title as String);
    if (data.containsKey('code')) {
      final l$code = data['code'];
      result$data['code'] = (l$code as String?);
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
    if (data.containsKey('details')) {
      final l$details = data['details'];
      result$data['details'] = (l$details as String?);
    }
    if (data.containsKey('photographer')) {
      final l$photographer = data['photographer'];
      result$data['photographer'] = (l$photographer as String?);
    }
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    if (data.containsKey('organized')) {
      final l$organized = data['organized'];
      result$data['organized'] = (l$organized as bool?);
    }
    if (data.containsKey('scene_ids')) {
      final l$scene_ids = data['scene_ids'];
      result$data['scene_ids'] =
          (l$scene_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('studio_id')) {
      final l$studio_id = data['studio_id'];
      result$data['studio_id'] = (l$studio_id as String?);
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] =
          (l$tag_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('performer_ids')) {
      final l$performer_ids = data['performer_ids'];
      result$data['performer_ids'] = (l$performer_ids as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    return Input$GalleryCreateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get title => (_$data['title'] as String);

  String? get code => (_$data['code'] as String?);

  String? get url => (_$data['url'] as String?);

  List<String>? get urls => (_$data['urls'] as List<String>?);

  String? get date => (_$data['date'] as String?);

  String? get details => (_$data['details'] as String?);

  String? get photographer => (_$data['photographer'] as String?);

  int? get rating100 => (_$data['rating100'] as int?);

  bool? get organized => (_$data['organized'] as bool?);

  List<String>? get scene_ids => (_$data['scene_ids'] as List<String>?);

  String? get studio_id => (_$data['studio_id'] as String?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  List<String>? get performer_ids => (_$data['performer_ids'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$title = title;
    result$data['title'] = l$title;
    if (_$data.containsKey('code')) {
      final l$code = code;
      result$data['code'] = l$code;
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
    if (_$data.containsKey('details')) {
      final l$details = details;
      result$data['details'] = l$details;
    }
    if (_$data.containsKey('photographer')) {
      final l$photographer = photographer;
      result$data['photographer'] = l$photographer;
    }
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    if (_$data.containsKey('organized')) {
      final l$organized = organized;
      result$data['organized'] = l$organized;
    }
    if (_$data.containsKey('scene_ids')) {
      final l$scene_ids = scene_ids;
      result$data['scene_ids'] = l$scene_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('studio_id')) {
      final l$studio_id = studio_id;
      result$data['studio_id'] = l$studio_id;
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('performer_ids')) {
      final l$performer_ids = performer_ids;
      result$data['performer_ids'] = l$performer_ids?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Input$GalleryCreateInput<Input$GalleryCreateInput> get copyWith =>
      CopyWith$Input$GalleryCreateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GalleryCreateInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
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
    final l$details = details;
    final lOther$details = other.details;
    if (_$data.containsKey('details') != other._$data.containsKey('details')) {
      return false;
    }
    if (l$details != lOther$details) {
      return false;
    }
    final l$photographer = photographer;
    final lOther$photographer = other.photographer;
    if (_$data.containsKey('photographer') !=
        other._$data.containsKey('photographer')) {
      return false;
    }
    if (l$photographer != lOther$photographer) {
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
    final l$scene_ids = scene_ids;
    final lOther$scene_ids = other.scene_ids;
    if (_$data.containsKey('scene_ids') !=
        other._$data.containsKey('scene_ids')) {
      return false;
    }
    if (l$scene_ids != null && lOther$scene_ids != null) {
      if (l$scene_ids.length != lOther$scene_ids.length) {
        return false;
      }
      for (int i = 0; i < l$scene_ids.length; i++) {
        final l$scene_ids$entry = l$scene_ids[i];
        final lOther$scene_ids$entry = lOther$scene_ids[i];
        if (l$scene_ids$entry != lOther$scene_ids$entry) {
          return false;
        }
      }
    } else if (l$scene_ids != lOther$scene_ids) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$title = title;
    final l$code = code;
    final l$url = url;
    final l$urls = urls;
    final l$date = date;
    final l$details = details;
    final l$photographer = photographer;
    final l$rating100 = rating100;
    final l$organized = organized;
    final l$scene_ids = scene_ids;
    final l$studio_id = studio_id;
    final l$tag_ids = tag_ids;
    final l$performer_ids = performer_ids;
    return Object.hashAll([
      l$title,
      _$data.containsKey('code') ? l$code : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls')
          ? l$urls == null
              ? null
              : Object.hashAll(l$urls.map((v) => v))
          : const {},
      _$data.containsKey('date') ? l$date : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('photographer') ? l$photographer : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('organized') ? l$organized : const {},
      _$data.containsKey('scene_ids')
          ? l$scene_ids == null
              ? null
              : Object.hashAll(l$scene_ids.map((v) => v))
          : const {},
      _$data.containsKey('studio_id') ? l$studio_id : const {},
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
              ? null
              : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
      _$data.containsKey('performer_ids')
          ? l$performer_ids == null
              ? null
              : Object.hashAll(l$performer_ids.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$GalleryCreateInput<TRes> {
  factory CopyWith$Input$GalleryCreateInput(
    Input$GalleryCreateInput instance,
    TRes Function(Input$GalleryCreateInput) then,
  ) = _CopyWithImpl$Input$GalleryCreateInput;

  factory CopyWith$Input$GalleryCreateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GalleryCreateInput;

  TRes call({
    String? title,
    String? code,
    String? url,
    List<String>? urls,
    String? date,
    String? details,
    String? photographer,
    int? rating100,
    bool? organized,
    List<String>? scene_ids,
    String? studio_id,
    List<String>? tag_ids,
    List<String>? performer_ids,
  });
}

class _CopyWithImpl$Input$GalleryCreateInput<TRes>
    implements CopyWith$Input$GalleryCreateInput<TRes> {
  _CopyWithImpl$Input$GalleryCreateInput(
    this._instance,
    this._then,
  );

  final Input$GalleryCreateInput _instance;

  final TRes Function(Input$GalleryCreateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? title = _undefined,
    Object? code = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? date = _undefined,
    Object? details = _undefined,
    Object? photographer = _undefined,
    Object? rating100 = _undefined,
    Object? organized = _undefined,
    Object? scene_ids = _undefined,
    Object? studio_id = _undefined,
    Object? tag_ids = _undefined,
    Object? performer_ids = _undefined,
  }) =>
      _then(Input$GalleryCreateInput._({
        ..._instance._$data,
        if (title != _undefined && title != null) 'title': (title as String),
        if (code != _undefined) 'code': (code as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (date != _undefined) 'date': (date as String?),
        if (details != _undefined) 'details': (details as String?),
        if (photographer != _undefined)
          'photographer': (photographer as String?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (organized != _undefined) 'organized': (organized as bool?),
        if (scene_ids != _undefined) 'scene_ids': (scene_ids as List<String>?),
        if (studio_id != _undefined) 'studio_id': (studio_id as String?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
        if (performer_ids != _undefined)
          'performer_ids': (performer_ids as List<String>?),
      }));
}

class _CopyWithStubImpl$Input$GalleryCreateInput<TRes>
    implements CopyWith$Input$GalleryCreateInput<TRes> {
  _CopyWithStubImpl$Input$GalleryCreateInput(this._res);

  TRes _res;

  call({
    String? title,
    String? code,
    String? url,
    List<String>? urls,
    String? date,
    String? details,
    String? photographer,
    int? rating100,
    bool? organized,
    List<String>? scene_ids,
    String? studio_id,
    List<String>? tag_ids,
    List<String>? performer_ids,
  }) =>
      _res;
}

class Input$GalleryUpdateInput {
  factory Input$GalleryUpdateInput({
    String? clientMutationId,
    required String id,
    String? title,
    String? code,
    String? url,
    List<String>? urls,
    String? date,
    String? details,
    String? photographer,
    int? rating100,
    bool? organized,
    List<String>? scene_ids,
    String? studio_id,
    List<String>? tag_ids,
    List<String>? performer_ids,
    String? primary_file_id,
  }) =>
      Input$GalleryUpdateInput._({
        if (clientMutationId != null) r'clientMutationId': clientMutationId,
        r'id': id,
        if (title != null) r'title': title,
        if (code != null) r'code': code,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (date != null) r'date': date,
        if (details != null) r'details': details,
        if (photographer != null) r'photographer': photographer,
        if (rating100 != null) r'rating100': rating100,
        if (organized != null) r'organized': organized,
        if (scene_ids != null) r'scene_ids': scene_ids,
        if (studio_id != null) r'studio_id': studio_id,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (performer_ids != null) r'performer_ids': performer_ids,
        if (primary_file_id != null) r'primary_file_id': primary_file_id,
      });

  Input$GalleryUpdateInput._(this._$data);

  factory Input$GalleryUpdateInput.fromJson(Map<String, dynamic> data) {
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
    if (data.containsKey('details')) {
      final l$details = data['details'];
      result$data['details'] = (l$details as String?);
    }
    if (data.containsKey('photographer')) {
      final l$photographer = data['photographer'];
      result$data['photographer'] = (l$photographer as String?);
    }
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    if (data.containsKey('organized')) {
      final l$organized = data['organized'];
      result$data['organized'] = (l$organized as bool?);
    }
    if (data.containsKey('scene_ids')) {
      final l$scene_ids = data['scene_ids'];
      result$data['scene_ids'] =
          (l$scene_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('studio_id')) {
      final l$studio_id = data['studio_id'];
      result$data['studio_id'] = (l$studio_id as String?);
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] =
          (l$tag_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('performer_ids')) {
      final l$performer_ids = data['performer_ids'];
      result$data['performer_ids'] = (l$performer_ids as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('primary_file_id')) {
      final l$primary_file_id = data['primary_file_id'];
      result$data['primary_file_id'] = (l$primary_file_id as String?);
    }
    return Input$GalleryUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get clientMutationId => (_$data['clientMutationId'] as String?);

  String get id => (_$data['id'] as String);

  String? get title => (_$data['title'] as String?);

  String? get code => (_$data['code'] as String?);

  String? get url => (_$data['url'] as String?);

  List<String>? get urls => (_$data['urls'] as List<String>?);

  String? get date => (_$data['date'] as String?);

  String? get details => (_$data['details'] as String?);

  String? get photographer => (_$data['photographer'] as String?);

  int? get rating100 => (_$data['rating100'] as int?);

  bool? get organized => (_$data['organized'] as bool?);

  List<String>? get scene_ids => (_$data['scene_ids'] as List<String>?);

  String? get studio_id => (_$data['studio_id'] as String?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  List<String>? get performer_ids => (_$data['performer_ids'] as List<String>?);

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
    if (_$data.containsKey('details')) {
      final l$details = details;
      result$data['details'] = l$details;
    }
    if (_$data.containsKey('photographer')) {
      final l$photographer = photographer;
      result$data['photographer'] = l$photographer;
    }
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    if (_$data.containsKey('organized')) {
      final l$organized = organized;
      result$data['organized'] = l$organized;
    }
    if (_$data.containsKey('scene_ids')) {
      final l$scene_ids = scene_ids;
      result$data['scene_ids'] = l$scene_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('studio_id')) {
      final l$studio_id = studio_id;
      result$data['studio_id'] = l$studio_id;
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('performer_ids')) {
      final l$performer_ids = performer_ids;
      result$data['performer_ids'] = l$performer_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('primary_file_id')) {
      final l$primary_file_id = primary_file_id;
      result$data['primary_file_id'] = l$primary_file_id;
    }
    return result$data;
  }

  CopyWith$Input$GalleryUpdateInput<Input$GalleryUpdateInput> get copyWith =>
      CopyWith$Input$GalleryUpdateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GalleryUpdateInput) ||
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
    final l$details = details;
    final lOther$details = other.details;
    if (_$data.containsKey('details') != other._$data.containsKey('details')) {
      return false;
    }
    if (l$details != lOther$details) {
      return false;
    }
    final l$photographer = photographer;
    final lOther$photographer = other.photographer;
    if (_$data.containsKey('photographer') !=
        other._$data.containsKey('photographer')) {
      return false;
    }
    if (l$photographer != lOther$photographer) {
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
    final l$scene_ids = scene_ids;
    final lOther$scene_ids = other.scene_ids;
    if (_$data.containsKey('scene_ids') !=
        other._$data.containsKey('scene_ids')) {
      return false;
    }
    if (l$scene_ids != null && lOther$scene_ids != null) {
      if (l$scene_ids.length != lOther$scene_ids.length) {
        return false;
      }
      for (int i = 0; i < l$scene_ids.length; i++) {
        final l$scene_ids$entry = l$scene_ids[i];
        final lOther$scene_ids$entry = lOther$scene_ids[i];
        if (l$scene_ids$entry != lOther$scene_ids$entry) {
          return false;
        }
      }
    } else if (l$scene_ids != lOther$scene_ids) {
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
    final l$url = url;
    final l$urls = urls;
    final l$date = date;
    final l$details = details;
    final l$photographer = photographer;
    final l$rating100 = rating100;
    final l$organized = organized;
    final l$scene_ids = scene_ids;
    final l$studio_id = studio_id;
    final l$tag_ids = tag_ids;
    final l$performer_ids = performer_ids;
    final l$primary_file_id = primary_file_id;
    return Object.hashAll([
      _$data.containsKey('clientMutationId') ? l$clientMutationId : const {},
      l$id,
      _$data.containsKey('title') ? l$title : const {},
      _$data.containsKey('code') ? l$code : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls')
          ? l$urls == null
              ? null
              : Object.hashAll(l$urls.map((v) => v))
          : const {},
      _$data.containsKey('date') ? l$date : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('photographer') ? l$photographer : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('organized') ? l$organized : const {},
      _$data.containsKey('scene_ids')
          ? l$scene_ids == null
              ? null
              : Object.hashAll(l$scene_ids.map((v) => v))
          : const {},
      _$data.containsKey('studio_id') ? l$studio_id : const {},
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
              ? null
              : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
      _$data.containsKey('performer_ids')
          ? l$performer_ids == null
              ? null
              : Object.hashAll(l$performer_ids.map((v) => v))
          : const {},
      _$data.containsKey('primary_file_id') ? l$primary_file_id : const {},
    ]);
  }
}

abstract class CopyWith$Input$GalleryUpdateInput<TRes> {
  factory CopyWith$Input$GalleryUpdateInput(
    Input$GalleryUpdateInput instance,
    TRes Function(Input$GalleryUpdateInput) then,
  ) = _CopyWithImpl$Input$GalleryUpdateInput;

  factory CopyWith$Input$GalleryUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GalleryUpdateInput;

  TRes call({
    String? clientMutationId,
    String? id,
    String? title,
    String? code,
    String? url,
    List<String>? urls,
    String? date,
    String? details,
    String? photographer,
    int? rating100,
    bool? organized,
    List<String>? scene_ids,
    String? studio_id,
    List<String>? tag_ids,
    List<String>? performer_ids,
    String? primary_file_id,
  });
}

class _CopyWithImpl$Input$GalleryUpdateInput<TRes>
    implements CopyWith$Input$GalleryUpdateInput<TRes> {
  _CopyWithImpl$Input$GalleryUpdateInput(
    this._instance,
    this._then,
  );

  final Input$GalleryUpdateInput _instance;

  final TRes Function(Input$GalleryUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? clientMutationId = _undefined,
    Object? id = _undefined,
    Object? title = _undefined,
    Object? code = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? date = _undefined,
    Object? details = _undefined,
    Object? photographer = _undefined,
    Object? rating100 = _undefined,
    Object? organized = _undefined,
    Object? scene_ids = _undefined,
    Object? studio_id = _undefined,
    Object? tag_ids = _undefined,
    Object? performer_ids = _undefined,
    Object? primary_file_id = _undefined,
  }) =>
      _then(Input$GalleryUpdateInput._({
        ..._instance._$data,
        if (clientMutationId != _undefined)
          'clientMutationId': (clientMutationId as String?),
        if (id != _undefined && id != null) 'id': (id as String),
        if (title != _undefined) 'title': (title as String?),
        if (code != _undefined) 'code': (code as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (date != _undefined) 'date': (date as String?),
        if (details != _undefined) 'details': (details as String?),
        if (photographer != _undefined)
          'photographer': (photographer as String?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (organized != _undefined) 'organized': (organized as bool?),
        if (scene_ids != _undefined) 'scene_ids': (scene_ids as List<String>?),
        if (studio_id != _undefined) 'studio_id': (studio_id as String?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
        if (performer_ids != _undefined)
          'performer_ids': (performer_ids as List<String>?),
        if (primary_file_id != _undefined)
          'primary_file_id': (primary_file_id as String?),
      }));
}

class _CopyWithStubImpl$Input$GalleryUpdateInput<TRes>
    implements CopyWith$Input$GalleryUpdateInput<TRes> {
  _CopyWithStubImpl$Input$GalleryUpdateInput(this._res);

  TRes _res;

  call({
    String? clientMutationId,
    String? id,
    String? title,
    String? code,
    String? url,
    List<String>? urls,
    String? date,
    String? details,
    String? photographer,
    int? rating100,
    bool? organized,
    List<String>? scene_ids,
    String? studio_id,
    List<String>? tag_ids,
    List<String>? performer_ids,
    String? primary_file_id,
  }) =>
      _res;
}

class Input$BulkGalleryUpdateInput {
  factory Input$BulkGalleryUpdateInput({
    String? clientMutationId,
    List<String>? ids,
    String? code,
    String? url,
    Input$BulkUpdateStrings? urls,
    String? date,
    String? details,
    String? photographer,
    int? rating100,
    bool? organized,
    Input$BulkUpdateIds? scene_ids,
    String? studio_id,
    Input$BulkUpdateIds? tag_ids,
    Input$BulkUpdateIds? performer_ids,
  }) =>
      Input$BulkGalleryUpdateInput._({
        if (clientMutationId != null) r'clientMutationId': clientMutationId,
        if (ids != null) r'ids': ids,
        if (code != null) r'code': code,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (date != null) r'date': date,
        if (details != null) r'details': details,
        if (photographer != null) r'photographer': photographer,
        if (rating100 != null) r'rating100': rating100,
        if (organized != null) r'organized': organized,
        if (scene_ids != null) r'scene_ids': scene_ids,
        if (studio_id != null) r'studio_id': studio_id,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (performer_ids != null) r'performer_ids': performer_ids,
      });

  Input$BulkGalleryUpdateInput._(this._$data);

  factory Input$BulkGalleryUpdateInput.fromJson(Map<String, dynamic> data) {
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
    if (data.containsKey('code')) {
      final l$code = data['code'];
      result$data['code'] = (l$code as String?);
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
    if (data.containsKey('details')) {
      final l$details = data['details'];
      result$data['details'] = (l$details as String?);
    }
    if (data.containsKey('photographer')) {
      final l$photographer = data['photographer'];
      result$data['photographer'] = (l$photographer as String?);
    }
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    if (data.containsKey('organized')) {
      final l$organized = data['organized'];
      result$data['organized'] = (l$organized as bool?);
    }
    if (data.containsKey('scene_ids')) {
      final l$scene_ids = data['scene_ids'];
      result$data['scene_ids'] = l$scene_ids == null
          ? null
          : Input$BulkUpdateIds.fromJson((l$scene_ids as Map<String, dynamic>));
    }
    if (data.containsKey('studio_id')) {
      final l$studio_id = data['studio_id'];
      result$data['studio_id'] = (l$studio_id as String?);
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] = l$tag_ids == null
          ? null
          : Input$BulkUpdateIds.fromJson((l$tag_ids as Map<String, dynamic>));
    }
    if (data.containsKey('performer_ids')) {
      final l$performer_ids = data['performer_ids'];
      result$data['performer_ids'] = l$performer_ids == null
          ? null
          : Input$BulkUpdateIds.fromJson(
              (l$performer_ids as Map<String, dynamic>));
    }
    return Input$BulkGalleryUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get clientMutationId => (_$data['clientMutationId'] as String?);

  List<String>? get ids => (_$data['ids'] as List<String>?);

  String? get code => (_$data['code'] as String?);

  String? get url => (_$data['url'] as String?);

  Input$BulkUpdateStrings? get urls =>
      (_$data['urls'] as Input$BulkUpdateStrings?);

  String? get date => (_$data['date'] as String?);

  String? get details => (_$data['details'] as String?);

  String? get photographer => (_$data['photographer'] as String?);

  int? get rating100 => (_$data['rating100'] as int?);

  bool? get organized => (_$data['organized'] as bool?);

  Input$BulkUpdateIds? get scene_ids =>
      (_$data['scene_ids'] as Input$BulkUpdateIds?);

  String? get studio_id => (_$data['studio_id'] as String?);

  Input$BulkUpdateIds? get tag_ids =>
      (_$data['tag_ids'] as Input$BulkUpdateIds?);

  Input$BulkUpdateIds? get performer_ids =>
      (_$data['performer_ids'] as Input$BulkUpdateIds?);

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
    if (_$data.containsKey('code')) {
      final l$code = code;
      result$data['code'] = l$code;
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
    if (_$data.containsKey('details')) {
      final l$details = details;
      result$data['details'] = l$details;
    }
    if (_$data.containsKey('photographer')) {
      final l$photographer = photographer;
      result$data['photographer'] = l$photographer;
    }
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    if (_$data.containsKey('organized')) {
      final l$organized = organized;
      result$data['organized'] = l$organized;
    }
    if (_$data.containsKey('scene_ids')) {
      final l$scene_ids = scene_ids;
      result$data['scene_ids'] = l$scene_ids?.toJson();
    }
    if (_$data.containsKey('studio_id')) {
      final l$studio_id = studio_id;
      result$data['studio_id'] = l$studio_id;
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.toJson();
    }
    if (_$data.containsKey('performer_ids')) {
      final l$performer_ids = performer_ids;
      result$data['performer_ids'] = l$performer_ids?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$BulkGalleryUpdateInput<Input$BulkGalleryUpdateInput>
      get copyWith => CopyWith$Input$BulkGalleryUpdateInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$BulkGalleryUpdateInput) ||
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
    final l$code = code;
    final lOther$code = other.code;
    if (_$data.containsKey('code') != other._$data.containsKey('code')) {
      return false;
    }
    if (l$code != lOther$code) {
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
    final l$details = details;
    final lOther$details = other.details;
    if (_$data.containsKey('details') != other._$data.containsKey('details')) {
      return false;
    }
    if (l$details != lOther$details) {
      return false;
    }
    final l$photographer = photographer;
    final lOther$photographer = other.photographer;
    if (_$data.containsKey('photographer') !=
        other._$data.containsKey('photographer')) {
      return false;
    }
    if (l$photographer != lOther$photographer) {
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
    final l$scene_ids = scene_ids;
    final lOther$scene_ids = other.scene_ids;
    if (_$data.containsKey('scene_ids') !=
        other._$data.containsKey('scene_ids')) {
      return false;
    }
    if (l$scene_ids != lOther$scene_ids) {
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
    final l$tag_ids = tag_ids;
    final lOther$tag_ids = other.tag_ids;
    if (_$data.containsKey('tag_ids') != other._$data.containsKey('tag_ids')) {
      return false;
    }
    if (l$tag_ids != lOther$tag_ids) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$clientMutationId = clientMutationId;
    final l$ids = ids;
    final l$code = code;
    final l$url = url;
    final l$urls = urls;
    final l$date = date;
    final l$details = details;
    final l$photographer = photographer;
    final l$rating100 = rating100;
    final l$organized = organized;
    final l$scene_ids = scene_ids;
    final l$studio_id = studio_id;
    final l$tag_ids = tag_ids;
    final l$performer_ids = performer_ids;
    return Object.hashAll([
      _$data.containsKey('clientMutationId') ? l$clientMutationId : const {},
      _$data.containsKey('ids')
          ? l$ids == null
              ? null
              : Object.hashAll(l$ids.map((v) => v))
          : const {},
      _$data.containsKey('code') ? l$code : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls') ? l$urls : const {},
      _$data.containsKey('date') ? l$date : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('photographer') ? l$photographer : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('organized') ? l$organized : const {},
      _$data.containsKey('scene_ids') ? l$scene_ids : const {},
      _$data.containsKey('studio_id') ? l$studio_id : const {},
      _$data.containsKey('tag_ids') ? l$tag_ids : const {},
      _$data.containsKey('performer_ids') ? l$performer_ids : const {},
    ]);
  }
}

abstract class CopyWith$Input$BulkGalleryUpdateInput<TRes> {
  factory CopyWith$Input$BulkGalleryUpdateInput(
    Input$BulkGalleryUpdateInput instance,
    TRes Function(Input$BulkGalleryUpdateInput) then,
  ) = _CopyWithImpl$Input$BulkGalleryUpdateInput;

  factory CopyWith$Input$BulkGalleryUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$BulkGalleryUpdateInput;

  TRes call({
    String? clientMutationId,
    List<String>? ids,
    String? code,
    String? url,
    Input$BulkUpdateStrings? urls,
    String? date,
    String? details,
    String? photographer,
    int? rating100,
    bool? organized,
    Input$BulkUpdateIds? scene_ids,
    String? studio_id,
    Input$BulkUpdateIds? tag_ids,
    Input$BulkUpdateIds? performer_ids,
  });
}

class _CopyWithImpl$Input$BulkGalleryUpdateInput<TRes>
    implements CopyWith$Input$BulkGalleryUpdateInput<TRes> {
  _CopyWithImpl$Input$BulkGalleryUpdateInput(
    this._instance,
    this._then,
  );

  final Input$BulkGalleryUpdateInput _instance;

  final TRes Function(Input$BulkGalleryUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? clientMutationId = _undefined,
    Object? ids = _undefined,
    Object? code = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? date = _undefined,
    Object? details = _undefined,
    Object? photographer = _undefined,
    Object? rating100 = _undefined,
    Object? organized = _undefined,
    Object? scene_ids = _undefined,
    Object? studio_id = _undefined,
    Object? tag_ids = _undefined,
    Object? performer_ids = _undefined,
  }) =>
      _then(Input$BulkGalleryUpdateInput._({
        ..._instance._$data,
        if (clientMutationId != _undefined)
          'clientMutationId': (clientMutationId as String?),
        if (ids != _undefined) 'ids': (ids as List<String>?),
        if (code != _undefined) 'code': (code as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as Input$BulkUpdateStrings?),
        if (date != _undefined) 'date': (date as String?),
        if (details != _undefined) 'details': (details as String?),
        if (photographer != _undefined)
          'photographer': (photographer as String?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (organized != _undefined) 'organized': (organized as bool?),
        if (scene_ids != _undefined)
          'scene_ids': (scene_ids as Input$BulkUpdateIds?),
        if (studio_id != _undefined) 'studio_id': (studio_id as String?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as Input$BulkUpdateIds?),
        if (performer_ids != _undefined)
          'performer_ids': (performer_ids as Input$BulkUpdateIds?),
      }));
}

class _CopyWithStubImpl$Input$BulkGalleryUpdateInput<TRes>
    implements CopyWith$Input$BulkGalleryUpdateInput<TRes> {
  _CopyWithStubImpl$Input$BulkGalleryUpdateInput(this._res);

  TRes _res;

  call({
    String? clientMutationId,
    List<String>? ids,
    String? code,
    String? url,
    Input$BulkUpdateStrings? urls,
    String? date,
    String? details,
    String? photographer,
    int? rating100,
    bool? organized,
    Input$BulkUpdateIds? scene_ids,
    String? studio_id,
    Input$BulkUpdateIds? tag_ids,
    Input$BulkUpdateIds? performer_ids,
  }) =>
      _res;
}

class Input$GalleryDestroyInput {
  factory Input$GalleryDestroyInput({
    required List<String> ids,
    bool? delete_file,
    bool? delete_generated,
  }) =>
      Input$GalleryDestroyInput._({
        r'ids': ids,
        if (delete_file != null) r'delete_file': delete_file,
        if (delete_generated != null) r'delete_generated': delete_generated,
      });

  Input$GalleryDestroyInput._(this._$data);

  factory Input$GalleryDestroyInput.fromJson(Map<String, dynamic> data) {
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
    return Input$GalleryDestroyInput._(result$data);
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

  CopyWith$Input$GalleryDestroyInput<Input$GalleryDestroyInput> get copyWith =>
      CopyWith$Input$GalleryDestroyInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GalleryDestroyInput) ||
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

abstract class CopyWith$Input$GalleryDestroyInput<TRes> {
  factory CopyWith$Input$GalleryDestroyInput(
    Input$GalleryDestroyInput instance,
    TRes Function(Input$GalleryDestroyInput) then,
  ) = _CopyWithImpl$Input$GalleryDestroyInput;

  factory CopyWith$Input$GalleryDestroyInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GalleryDestroyInput;

  TRes call({
    List<String>? ids,
    bool? delete_file,
    bool? delete_generated,
  });
}

class _CopyWithImpl$Input$GalleryDestroyInput<TRes>
    implements CopyWith$Input$GalleryDestroyInput<TRes> {
  _CopyWithImpl$Input$GalleryDestroyInput(
    this._instance,
    this._then,
  );

  final Input$GalleryDestroyInput _instance;

  final TRes Function(Input$GalleryDestroyInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ids = _undefined,
    Object? delete_file = _undefined,
    Object? delete_generated = _undefined,
  }) =>
      _then(Input$GalleryDestroyInput._({
        ..._instance._$data,
        if (ids != _undefined && ids != null) 'ids': (ids as List<String>),
        if (delete_file != _undefined) 'delete_file': (delete_file as bool?),
        if (delete_generated != _undefined)
          'delete_generated': (delete_generated as bool?),
      }));
}

class _CopyWithStubImpl$Input$GalleryDestroyInput<TRes>
    implements CopyWith$Input$GalleryDestroyInput<TRes> {
  _CopyWithStubImpl$Input$GalleryDestroyInput(this._res);

  TRes _res;

  call({
    List<String>? ids,
    bool? delete_file,
    bool? delete_generated,
  }) =>
      _res;
}

class Input$GalleryAddInput {
  factory Input$GalleryAddInput({
    required String gallery_id,
    required List<String> image_ids,
  }) =>
      Input$GalleryAddInput._({
        r'gallery_id': gallery_id,
        r'image_ids': image_ids,
      });

  Input$GalleryAddInput._(this._$data);

  factory Input$GalleryAddInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$gallery_id = data['gallery_id'];
    result$data['gallery_id'] = (l$gallery_id as String);
    final l$image_ids = data['image_ids'];
    result$data['image_ids'] =
        (l$image_ids as List<dynamic>).map((e) => (e as String)).toList();
    return Input$GalleryAddInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get gallery_id => (_$data['gallery_id'] as String);

  List<String> get image_ids => (_$data['image_ids'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$gallery_id = gallery_id;
    result$data['gallery_id'] = l$gallery_id;
    final l$image_ids = image_ids;
    result$data['image_ids'] = l$image_ids.map((e) => e).toList();
    return result$data;
  }

  CopyWith$Input$GalleryAddInput<Input$GalleryAddInput> get copyWith =>
      CopyWith$Input$GalleryAddInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GalleryAddInput) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$gallery_id = gallery_id;
    final lOther$gallery_id = other.gallery_id;
    if (l$gallery_id != lOther$gallery_id) {
      return false;
    }
    final l$image_ids = image_ids;
    final lOther$image_ids = other.image_ids;
    if (l$image_ids.length != lOther$image_ids.length) {
      return false;
    }
    for (int i = 0; i < l$image_ids.length; i++) {
      final l$image_ids$entry = l$image_ids[i];
      final lOther$image_ids$entry = lOther$image_ids[i];
      if (l$image_ids$entry != lOther$image_ids$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$gallery_id = gallery_id;
    final l$image_ids = image_ids;
    return Object.hashAll([
      l$gallery_id,
      Object.hashAll(l$image_ids.map((v) => v)),
    ]);
  }
}

abstract class CopyWith$Input$GalleryAddInput<TRes> {
  factory CopyWith$Input$GalleryAddInput(
    Input$GalleryAddInput instance,
    TRes Function(Input$GalleryAddInput) then,
  ) = _CopyWithImpl$Input$GalleryAddInput;

  factory CopyWith$Input$GalleryAddInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GalleryAddInput;

  TRes call({
    String? gallery_id,
    List<String>? image_ids,
  });
}

class _CopyWithImpl$Input$GalleryAddInput<TRes>
    implements CopyWith$Input$GalleryAddInput<TRes> {
  _CopyWithImpl$Input$GalleryAddInput(
    this._instance,
    this._then,
  );

  final Input$GalleryAddInput _instance;

  final TRes Function(Input$GalleryAddInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? gallery_id = _undefined,
    Object? image_ids = _undefined,
  }) =>
      _then(Input$GalleryAddInput._({
        ..._instance._$data,
        if (gallery_id != _undefined && gallery_id != null)
          'gallery_id': (gallery_id as String),
        if (image_ids != _undefined && image_ids != null)
          'image_ids': (image_ids as List<String>),
      }));
}

class _CopyWithStubImpl$Input$GalleryAddInput<TRes>
    implements CopyWith$Input$GalleryAddInput<TRes> {
  _CopyWithStubImpl$Input$GalleryAddInput(this._res);

  TRes _res;

  call({
    String? gallery_id,
    List<String>? image_ids,
  }) =>
      _res;
}

class Input$GalleryRemoveInput {
  factory Input$GalleryRemoveInput({
    required String gallery_id,
    required List<String> image_ids,
  }) =>
      Input$GalleryRemoveInput._({
        r'gallery_id': gallery_id,
        r'image_ids': image_ids,
      });

  Input$GalleryRemoveInput._(this._$data);

  factory Input$GalleryRemoveInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$gallery_id = data['gallery_id'];
    result$data['gallery_id'] = (l$gallery_id as String);
    final l$image_ids = data['image_ids'];
    result$data['image_ids'] =
        (l$image_ids as List<dynamic>).map((e) => (e as String)).toList();
    return Input$GalleryRemoveInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get gallery_id => (_$data['gallery_id'] as String);

  List<String> get image_ids => (_$data['image_ids'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$gallery_id = gallery_id;
    result$data['gallery_id'] = l$gallery_id;
    final l$image_ids = image_ids;
    result$data['image_ids'] = l$image_ids.map((e) => e).toList();
    return result$data;
  }

  CopyWith$Input$GalleryRemoveInput<Input$GalleryRemoveInput> get copyWith =>
      CopyWith$Input$GalleryRemoveInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GalleryRemoveInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$gallery_id = gallery_id;
    final lOther$gallery_id = other.gallery_id;
    if (l$gallery_id != lOther$gallery_id) {
      return false;
    }
    final l$image_ids = image_ids;
    final lOther$image_ids = other.image_ids;
    if (l$image_ids.length != lOther$image_ids.length) {
      return false;
    }
    for (int i = 0; i < l$image_ids.length; i++) {
      final l$image_ids$entry = l$image_ids[i];
      final lOther$image_ids$entry = lOther$image_ids[i];
      if (l$image_ids$entry != lOther$image_ids$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$gallery_id = gallery_id;
    final l$image_ids = image_ids;
    return Object.hashAll([
      l$gallery_id,
      Object.hashAll(l$image_ids.map((v) => v)),
    ]);
  }
}

abstract class CopyWith$Input$GalleryRemoveInput<TRes> {
  factory CopyWith$Input$GalleryRemoveInput(
    Input$GalleryRemoveInput instance,
    TRes Function(Input$GalleryRemoveInput) then,
  ) = _CopyWithImpl$Input$GalleryRemoveInput;

  factory CopyWith$Input$GalleryRemoveInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GalleryRemoveInput;

  TRes call({
    String? gallery_id,
    List<String>? image_ids,
  });
}

class _CopyWithImpl$Input$GalleryRemoveInput<TRes>
    implements CopyWith$Input$GalleryRemoveInput<TRes> {
  _CopyWithImpl$Input$GalleryRemoveInput(
    this._instance,
    this._then,
  );

  final Input$GalleryRemoveInput _instance;

  final TRes Function(Input$GalleryRemoveInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? gallery_id = _undefined,
    Object? image_ids = _undefined,
  }) =>
      _then(Input$GalleryRemoveInput._({
        ..._instance._$data,
        if (gallery_id != _undefined && gallery_id != null)
          'gallery_id': (gallery_id as String),
        if (image_ids != _undefined && image_ids != null)
          'image_ids': (image_ids as List<String>),
      }));
}

class _CopyWithStubImpl$Input$GalleryRemoveInput<TRes>
    implements CopyWith$Input$GalleryRemoveInput<TRes> {
  _CopyWithStubImpl$Input$GalleryRemoveInput(this._res);

  TRes _res;

  call({
    String? gallery_id,
    List<String>? image_ids,
  }) =>
      _res;
}

class Input$GallerySetCoverInput {
  factory Input$GallerySetCoverInput({
    required String gallery_id,
    required String cover_image_id,
  }) =>
      Input$GallerySetCoverInput._({
        r'gallery_id': gallery_id,
        r'cover_image_id': cover_image_id,
      });

  Input$GallerySetCoverInput._(this._$data);

  factory Input$GallerySetCoverInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$gallery_id = data['gallery_id'];
    result$data['gallery_id'] = (l$gallery_id as String);
    final l$cover_image_id = data['cover_image_id'];
    result$data['cover_image_id'] = (l$cover_image_id as String);
    return Input$GallerySetCoverInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get gallery_id => (_$data['gallery_id'] as String);

  String get cover_image_id => (_$data['cover_image_id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$gallery_id = gallery_id;
    result$data['gallery_id'] = l$gallery_id;
    final l$cover_image_id = cover_image_id;
    result$data['cover_image_id'] = l$cover_image_id;
    return result$data;
  }

  CopyWith$Input$GallerySetCoverInput<Input$GallerySetCoverInput>
      get copyWith => CopyWith$Input$GallerySetCoverInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GallerySetCoverInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$gallery_id = gallery_id;
    final lOther$gallery_id = other.gallery_id;
    if (l$gallery_id != lOther$gallery_id) {
      return false;
    }
    final l$cover_image_id = cover_image_id;
    final lOther$cover_image_id = other.cover_image_id;
    if (l$cover_image_id != lOther$cover_image_id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$gallery_id = gallery_id;
    final l$cover_image_id = cover_image_id;
    return Object.hashAll([
      l$gallery_id,
      l$cover_image_id,
    ]);
  }
}

abstract class CopyWith$Input$GallerySetCoverInput<TRes> {
  factory CopyWith$Input$GallerySetCoverInput(
    Input$GallerySetCoverInput instance,
    TRes Function(Input$GallerySetCoverInput) then,
  ) = _CopyWithImpl$Input$GallerySetCoverInput;

  factory CopyWith$Input$GallerySetCoverInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GallerySetCoverInput;

  TRes call({
    String? gallery_id,
    String? cover_image_id,
  });
}

class _CopyWithImpl$Input$GallerySetCoverInput<TRes>
    implements CopyWith$Input$GallerySetCoverInput<TRes> {
  _CopyWithImpl$Input$GallerySetCoverInput(
    this._instance,
    this._then,
  );

  final Input$GallerySetCoverInput _instance;

  final TRes Function(Input$GallerySetCoverInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? gallery_id = _undefined,
    Object? cover_image_id = _undefined,
  }) =>
      _then(Input$GallerySetCoverInput._({
        ..._instance._$data,
        if (gallery_id != _undefined && gallery_id != null)
          'gallery_id': (gallery_id as String),
        if (cover_image_id != _undefined && cover_image_id != null)
          'cover_image_id': (cover_image_id as String),
      }));
}

class _CopyWithStubImpl$Input$GallerySetCoverInput<TRes>
    implements CopyWith$Input$GallerySetCoverInput<TRes> {
  _CopyWithStubImpl$Input$GallerySetCoverInput(this._res);

  TRes _res;

  call({
    String? gallery_id,
    String? cover_image_id,
  }) =>
      _res;
}

class Input$GalleryResetCoverInput {
  factory Input$GalleryResetCoverInput({required String gallery_id}) =>
      Input$GalleryResetCoverInput._({
        r'gallery_id': gallery_id,
      });

  Input$GalleryResetCoverInput._(this._$data);

  factory Input$GalleryResetCoverInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$gallery_id = data['gallery_id'];
    result$data['gallery_id'] = (l$gallery_id as String);
    return Input$GalleryResetCoverInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get gallery_id => (_$data['gallery_id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$gallery_id = gallery_id;
    result$data['gallery_id'] = l$gallery_id;
    return result$data;
  }

  CopyWith$Input$GalleryResetCoverInput<Input$GalleryResetCoverInput>
      get copyWith => CopyWith$Input$GalleryResetCoverInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GalleryResetCoverInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$gallery_id = gallery_id;
    final lOther$gallery_id = other.gallery_id;
    if (l$gallery_id != lOther$gallery_id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$gallery_id = gallery_id;
    return Object.hashAll([l$gallery_id]);
  }
}

abstract class CopyWith$Input$GalleryResetCoverInput<TRes> {
  factory CopyWith$Input$GalleryResetCoverInput(
    Input$GalleryResetCoverInput instance,
    TRes Function(Input$GalleryResetCoverInput) then,
  ) = _CopyWithImpl$Input$GalleryResetCoverInput;

  factory CopyWith$Input$GalleryResetCoverInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GalleryResetCoverInput;

  TRes call({String? gallery_id});
}

class _CopyWithImpl$Input$GalleryResetCoverInput<TRes>
    implements CopyWith$Input$GalleryResetCoverInput<TRes> {
  _CopyWithImpl$Input$GalleryResetCoverInput(
    this._instance,
    this._then,
  );

  final Input$GalleryResetCoverInput _instance;

  final TRes Function(Input$GalleryResetCoverInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? gallery_id = _undefined}) =>
      _then(Input$GalleryResetCoverInput._({
        ..._instance._$data,
        if (gallery_id != _undefined && gallery_id != null)
          'gallery_id': (gallery_id as String),
      }));
}

class _CopyWithStubImpl$Input$GalleryResetCoverInput<TRes>
    implements CopyWith$Input$GalleryResetCoverInput<TRes> {
  _CopyWithStubImpl$Input$GalleryResetCoverInput(this._res);

  TRes _res;

  call({String? gallery_id}) => _res;
}
