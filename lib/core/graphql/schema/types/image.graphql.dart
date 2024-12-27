import 'performer.graphql.dart';
import 'scene.graphql.dart';

class Input$ImageUpdateInput {
  factory Input$ImageUpdateInput({
    String? clientMutationId,
    required String id,
    String? title,
    String? code,
    int? rating100,
    bool? organized,
    String? url,
    List<String>? urls,
    String? date,
    String? details,
    String? photographer,
    String? studio_id,
    List<String>? performer_ids,
    List<String>? tag_ids,
    List<String>? gallery_ids,
    String? primary_file_id,
  }) =>
      Input$ImageUpdateInput._({
        if (clientMutationId != null) r'clientMutationId': clientMutationId,
        r'id': id,
        if (title != null) r'title': title,
        if (code != null) r'code': code,
        if (rating100 != null) r'rating100': rating100,
        if (organized != null) r'organized': organized,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (date != null) r'date': date,
        if (details != null) r'details': details,
        if (photographer != null) r'photographer': photographer,
        if (studio_id != null) r'studio_id': studio_id,
        if (performer_ids != null) r'performer_ids': performer_ids,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (gallery_ids != null) r'gallery_ids': gallery_ids,
        if (primary_file_id != null) r'primary_file_id': primary_file_id,
      });

  Input$ImageUpdateInput._(this._$data);

  factory Input$ImageUpdateInput.fromJson(Map<String, dynamic> data) {
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
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    if (data.containsKey('organized')) {
      final l$organized = data['organized'];
      result$data['organized'] = (l$organized as bool?);
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
    if (data.containsKey('studio_id')) {
      final l$studio_id = data['studio_id'];
      result$data['studio_id'] = (l$studio_id as String?);
    }
    if (data.containsKey('performer_ids')) {
      final l$performer_ids = data['performer_ids'];
      result$data['performer_ids'] = (l$performer_ids as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] =
          (l$tag_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('gallery_ids')) {
      final l$gallery_ids = data['gallery_ids'];
      result$data['gallery_ids'] =
          (l$gallery_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('primary_file_id')) {
      final l$primary_file_id = data['primary_file_id'];
      result$data['primary_file_id'] = (l$primary_file_id as String?);
    }
    return Input$ImageUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get clientMutationId => (_$data['clientMutationId'] as String?);

  String get id => (_$data['id'] as String);

  String? get title => (_$data['title'] as String?);

  String? get code => (_$data['code'] as String?);

  int? get rating100 => (_$data['rating100'] as int?);

  bool? get organized => (_$data['organized'] as bool?);

  String? get url => (_$data['url'] as String?);

  List<String>? get urls => (_$data['urls'] as List<String>?);

  String? get date => (_$data['date'] as String?);

  String? get details => (_$data['details'] as String?);

  String? get photographer => (_$data['photographer'] as String?);

  String? get studio_id => (_$data['studio_id'] as String?);

  List<String>? get performer_ids => (_$data['performer_ids'] as List<String>?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  List<String>? get gallery_ids => (_$data['gallery_ids'] as List<String>?);

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
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    if (_$data.containsKey('organized')) {
      final l$organized = organized;
      result$data['organized'] = l$organized;
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
    if (_$data.containsKey('studio_id')) {
      final l$studio_id = studio_id;
      result$data['studio_id'] = l$studio_id;
    }
    if (_$data.containsKey('performer_ids')) {
      final l$performer_ids = performer_ids;
      result$data['performer_ids'] = l$performer_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('gallery_ids')) {
      final l$gallery_ids = gallery_ids;
      result$data['gallery_ids'] = l$gallery_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('primary_file_id')) {
      final l$primary_file_id = primary_file_id;
      result$data['primary_file_id'] = l$primary_file_id;
    }
    return result$data;
  }

  CopyWith$Input$ImageUpdateInput<Input$ImageUpdateInput> get copyWith =>
      CopyWith$Input$ImageUpdateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ImageUpdateInput) ||
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
    final l$studio_id = studio_id;
    final lOther$studio_id = other.studio_id;
    if (_$data.containsKey('studio_id') !=
        other._$data.containsKey('studio_id')) {
      return false;
    }
    if (l$studio_id != lOther$studio_id) {
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
    final l$rating100 = rating100;
    final l$organized = organized;
    final l$url = url;
    final l$urls = urls;
    final l$date = date;
    final l$details = details;
    final l$photographer = photographer;
    final l$studio_id = studio_id;
    final l$performer_ids = performer_ids;
    final l$tag_ids = tag_ids;
    final l$gallery_ids = gallery_ids;
    final l$primary_file_id = primary_file_id;
    return Object.hashAll([
      _$data.containsKey('clientMutationId') ? l$clientMutationId : const {},
      l$id,
      _$data.containsKey('title') ? l$title : const {},
      _$data.containsKey('code') ? l$code : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('organized') ? l$organized : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls')
          ? l$urls == null
              ? null
              : Object.hashAll(l$urls.map((v) => v))
          : const {},
      _$data.containsKey('date') ? l$date : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('photographer') ? l$photographer : const {},
      _$data.containsKey('studio_id') ? l$studio_id : const {},
      _$data.containsKey('performer_ids')
          ? l$performer_ids == null
              ? null
              : Object.hashAll(l$performer_ids.map((v) => v))
          : const {},
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
              ? null
              : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
      _$data.containsKey('gallery_ids')
          ? l$gallery_ids == null
              ? null
              : Object.hashAll(l$gallery_ids.map((v) => v))
          : const {},
      _$data.containsKey('primary_file_id') ? l$primary_file_id : const {},
    ]);
  }
}

abstract class CopyWith$Input$ImageUpdateInput<TRes> {
  factory CopyWith$Input$ImageUpdateInput(
    Input$ImageUpdateInput instance,
    TRes Function(Input$ImageUpdateInput) then,
  ) = _CopyWithImpl$Input$ImageUpdateInput;

  factory CopyWith$Input$ImageUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ImageUpdateInput;

  TRes call({
    String? clientMutationId,
    String? id,
    String? title,
    String? code,
    int? rating100,
    bool? organized,
    String? url,
    List<String>? urls,
    String? date,
    String? details,
    String? photographer,
    String? studio_id,
    List<String>? performer_ids,
    List<String>? tag_ids,
    List<String>? gallery_ids,
    String? primary_file_id,
  });
}

class _CopyWithImpl$Input$ImageUpdateInput<TRes>
    implements CopyWith$Input$ImageUpdateInput<TRes> {
  _CopyWithImpl$Input$ImageUpdateInput(
    this._instance,
    this._then,
  );

  final Input$ImageUpdateInput _instance;

  final TRes Function(Input$ImageUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? clientMutationId = _undefined,
    Object? id = _undefined,
    Object? title = _undefined,
    Object? code = _undefined,
    Object? rating100 = _undefined,
    Object? organized = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? date = _undefined,
    Object? details = _undefined,
    Object? photographer = _undefined,
    Object? studio_id = _undefined,
    Object? performer_ids = _undefined,
    Object? tag_ids = _undefined,
    Object? gallery_ids = _undefined,
    Object? primary_file_id = _undefined,
  }) =>
      _then(Input$ImageUpdateInput._({
        ..._instance._$data,
        if (clientMutationId != _undefined)
          'clientMutationId': (clientMutationId as String?),
        if (id != _undefined && id != null) 'id': (id as String),
        if (title != _undefined) 'title': (title as String?),
        if (code != _undefined) 'code': (code as String?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (organized != _undefined) 'organized': (organized as bool?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (date != _undefined) 'date': (date as String?),
        if (details != _undefined) 'details': (details as String?),
        if (photographer != _undefined)
          'photographer': (photographer as String?),
        if (studio_id != _undefined) 'studio_id': (studio_id as String?),
        if (performer_ids != _undefined)
          'performer_ids': (performer_ids as List<String>?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
        if (gallery_ids != _undefined)
          'gallery_ids': (gallery_ids as List<String>?),
        if (primary_file_id != _undefined)
          'primary_file_id': (primary_file_id as String?),
      }));
}

class _CopyWithStubImpl$Input$ImageUpdateInput<TRes>
    implements CopyWith$Input$ImageUpdateInput<TRes> {
  _CopyWithStubImpl$Input$ImageUpdateInput(this._res);

  TRes _res;

  call({
    String? clientMutationId,
    String? id,
    String? title,
    String? code,
    int? rating100,
    bool? organized,
    String? url,
    List<String>? urls,
    String? date,
    String? details,
    String? photographer,
    String? studio_id,
    List<String>? performer_ids,
    List<String>? tag_ids,
    List<String>? gallery_ids,
    String? primary_file_id,
  }) =>
      _res;
}

class Input$BulkImageUpdateInput {
  factory Input$BulkImageUpdateInput({
    String? clientMutationId,
    List<String>? ids,
    String? title,
    String? code,
    int? rating100,
    bool? organized,
    String? url,
    Input$BulkUpdateStrings? urls,
    String? date,
    String? details,
    String? photographer,
    String? studio_id,
    Input$BulkUpdateIds? performer_ids,
    Input$BulkUpdateIds? tag_ids,
    Input$BulkUpdateIds? gallery_ids,
  }) =>
      Input$BulkImageUpdateInput._({
        if (clientMutationId != null) r'clientMutationId': clientMutationId,
        if (ids != null) r'ids': ids,
        if (title != null) r'title': title,
        if (code != null) r'code': code,
        if (rating100 != null) r'rating100': rating100,
        if (organized != null) r'organized': organized,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (date != null) r'date': date,
        if (details != null) r'details': details,
        if (photographer != null) r'photographer': photographer,
        if (studio_id != null) r'studio_id': studio_id,
        if (performer_ids != null) r'performer_ids': performer_ids,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (gallery_ids != null) r'gallery_ids': gallery_ids,
      });

  Input$BulkImageUpdateInput._(this._$data);

  factory Input$BulkImageUpdateInput.fromJson(Map<String, dynamic> data) {
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
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    if (data.containsKey('organized')) {
      final l$organized = data['organized'];
      result$data['organized'] = (l$organized as bool?);
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
    if (data.containsKey('studio_id')) {
      final l$studio_id = data['studio_id'];
      result$data['studio_id'] = (l$studio_id as String?);
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
    if (data.containsKey('gallery_ids')) {
      final l$gallery_ids = data['gallery_ids'];
      result$data['gallery_ids'] = l$gallery_ids == null
          ? null
          : Input$BulkUpdateIds.fromJson(
              (l$gallery_ids as Map<String, dynamic>));
    }
    return Input$BulkImageUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get clientMutationId => (_$data['clientMutationId'] as String?);

  List<String>? get ids => (_$data['ids'] as List<String>?);

  String? get title => (_$data['title'] as String?);

  String? get code => (_$data['code'] as String?);

  int? get rating100 => (_$data['rating100'] as int?);

  bool? get organized => (_$data['organized'] as bool?);

  String? get url => (_$data['url'] as String?);

  Input$BulkUpdateStrings? get urls =>
      (_$data['urls'] as Input$BulkUpdateStrings?);

  String? get date => (_$data['date'] as String?);

  String? get details => (_$data['details'] as String?);

  String? get photographer => (_$data['photographer'] as String?);

  String? get studio_id => (_$data['studio_id'] as String?);

  Input$BulkUpdateIds? get performer_ids =>
      (_$data['performer_ids'] as Input$BulkUpdateIds?);

  Input$BulkUpdateIds? get tag_ids =>
      (_$data['tag_ids'] as Input$BulkUpdateIds?);

  Input$BulkUpdateIds? get gallery_ids =>
      (_$data['gallery_ids'] as Input$BulkUpdateIds?);

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
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    if (_$data.containsKey('organized')) {
      final l$organized = organized;
      result$data['organized'] = l$organized;
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
    if (_$data.containsKey('studio_id')) {
      final l$studio_id = studio_id;
      result$data['studio_id'] = l$studio_id;
    }
    if (_$data.containsKey('performer_ids')) {
      final l$performer_ids = performer_ids;
      result$data['performer_ids'] = l$performer_ids?.toJson();
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.toJson();
    }
    if (_$data.containsKey('gallery_ids')) {
      final l$gallery_ids = gallery_ids;
      result$data['gallery_ids'] = l$gallery_ids?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$BulkImageUpdateInput<Input$BulkImageUpdateInput>
      get copyWith => CopyWith$Input$BulkImageUpdateInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$BulkImageUpdateInput) ||
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
    final l$studio_id = studio_id;
    final lOther$studio_id = other.studio_id;
    if (_$data.containsKey('studio_id') !=
        other._$data.containsKey('studio_id')) {
      return false;
    }
    if (l$studio_id != lOther$studio_id) {
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
    final l$gallery_ids = gallery_ids;
    final lOther$gallery_ids = other.gallery_ids;
    if (_$data.containsKey('gallery_ids') !=
        other._$data.containsKey('gallery_ids')) {
      return false;
    }
    if (l$gallery_ids != lOther$gallery_ids) {
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
    final l$rating100 = rating100;
    final l$organized = organized;
    final l$url = url;
    final l$urls = urls;
    final l$date = date;
    final l$details = details;
    final l$photographer = photographer;
    final l$studio_id = studio_id;
    final l$performer_ids = performer_ids;
    final l$tag_ids = tag_ids;
    final l$gallery_ids = gallery_ids;
    return Object.hashAll([
      _$data.containsKey('clientMutationId') ? l$clientMutationId : const {},
      _$data.containsKey('ids')
          ? l$ids == null
              ? null
              : Object.hashAll(l$ids.map((v) => v))
          : const {},
      _$data.containsKey('title') ? l$title : const {},
      _$data.containsKey('code') ? l$code : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('organized') ? l$organized : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls') ? l$urls : const {},
      _$data.containsKey('date') ? l$date : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('photographer') ? l$photographer : const {},
      _$data.containsKey('studio_id') ? l$studio_id : const {},
      _$data.containsKey('performer_ids') ? l$performer_ids : const {},
      _$data.containsKey('tag_ids') ? l$tag_ids : const {},
      _$data.containsKey('gallery_ids') ? l$gallery_ids : const {},
    ]);
  }
}

abstract class CopyWith$Input$BulkImageUpdateInput<TRes> {
  factory CopyWith$Input$BulkImageUpdateInput(
    Input$BulkImageUpdateInput instance,
    TRes Function(Input$BulkImageUpdateInput) then,
  ) = _CopyWithImpl$Input$BulkImageUpdateInput;

  factory CopyWith$Input$BulkImageUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$BulkImageUpdateInput;

  TRes call({
    String? clientMutationId,
    List<String>? ids,
    String? title,
    String? code,
    int? rating100,
    bool? organized,
    String? url,
    Input$BulkUpdateStrings? urls,
    String? date,
    String? details,
    String? photographer,
    String? studio_id,
    Input$BulkUpdateIds? performer_ids,
    Input$BulkUpdateIds? tag_ids,
    Input$BulkUpdateIds? gallery_ids,
  });
}

class _CopyWithImpl$Input$BulkImageUpdateInput<TRes>
    implements CopyWith$Input$BulkImageUpdateInput<TRes> {
  _CopyWithImpl$Input$BulkImageUpdateInput(
    this._instance,
    this._then,
  );

  final Input$BulkImageUpdateInput _instance;

  final TRes Function(Input$BulkImageUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? clientMutationId = _undefined,
    Object? ids = _undefined,
    Object? title = _undefined,
    Object? code = _undefined,
    Object? rating100 = _undefined,
    Object? organized = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? date = _undefined,
    Object? details = _undefined,
    Object? photographer = _undefined,
    Object? studio_id = _undefined,
    Object? performer_ids = _undefined,
    Object? tag_ids = _undefined,
    Object? gallery_ids = _undefined,
  }) =>
      _then(Input$BulkImageUpdateInput._({
        ..._instance._$data,
        if (clientMutationId != _undefined)
          'clientMutationId': (clientMutationId as String?),
        if (ids != _undefined) 'ids': (ids as List<String>?),
        if (title != _undefined) 'title': (title as String?),
        if (code != _undefined) 'code': (code as String?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (organized != _undefined) 'organized': (organized as bool?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as Input$BulkUpdateStrings?),
        if (date != _undefined) 'date': (date as String?),
        if (details != _undefined) 'details': (details as String?),
        if (photographer != _undefined)
          'photographer': (photographer as String?),
        if (studio_id != _undefined) 'studio_id': (studio_id as String?),
        if (performer_ids != _undefined)
          'performer_ids': (performer_ids as Input$BulkUpdateIds?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as Input$BulkUpdateIds?),
        if (gallery_ids != _undefined)
          'gallery_ids': (gallery_ids as Input$BulkUpdateIds?),
      }));
}

class _CopyWithStubImpl$Input$BulkImageUpdateInput<TRes>
    implements CopyWith$Input$BulkImageUpdateInput<TRes> {
  _CopyWithStubImpl$Input$BulkImageUpdateInput(this._res);

  TRes _res;

  call({
    String? clientMutationId,
    List<String>? ids,
    String? title,
    String? code,
    int? rating100,
    bool? organized,
    String? url,
    Input$BulkUpdateStrings? urls,
    String? date,
    String? details,
    String? photographer,
    String? studio_id,
    Input$BulkUpdateIds? performer_ids,
    Input$BulkUpdateIds? tag_ids,
    Input$BulkUpdateIds? gallery_ids,
  }) =>
      _res;
}

class Input$ImageDestroyInput {
  factory Input$ImageDestroyInput({
    required String id,
    bool? delete_file,
    bool? delete_generated,
  }) =>
      Input$ImageDestroyInput._({
        r'id': id,
        if (delete_file != null) r'delete_file': delete_file,
        if (delete_generated != null) r'delete_generated': delete_generated,
      });

  Input$ImageDestroyInput._(this._$data);

  factory Input$ImageDestroyInput.fromJson(Map<String, dynamic> data) {
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
    return Input$ImageDestroyInput._(result$data);
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

  CopyWith$Input$ImageDestroyInput<Input$ImageDestroyInput> get copyWith =>
      CopyWith$Input$ImageDestroyInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ImageDestroyInput) ||
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

abstract class CopyWith$Input$ImageDestroyInput<TRes> {
  factory CopyWith$Input$ImageDestroyInput(
    Input$ImageDestroyInput instance,
    TRes Function(Input$ImageDestroyInput) then,
  ) = _CopyWithImpl$Input$ImageDestroyInput;

  factory CopyWith$Input$ImageDestroyInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ImageDestroyInput;

  TRes call({
    String? id,
    bool? delete_file,
    bool? delete_generated,
  });
}

class _CopyWithImpl$Input$ImageDestroyInput<TRes>
    implements CopyWith$Input$ImageDestroyInput<TRes> {
  _CopyWithImpl$Input$ImageDestroyInput(
    this._instance,
    this._then,
  );

  final Input$ImageDestroyInput _instance;

  final TRes Function(Input$ImageDestroyInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? delete_file = _undefined,
    Object? delete_generated = _undefined,
  }) =>
      _then(Input$ImageDestroyInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (delete_file != _undefined) 'delete_file': (delete_file as bool?),
        if (delete_generated != _undefined)
          'delete_generated': (delete_generated as bool?),
      }));
}

class _CopyWithStubImpl$Input$ImageDestroyInput<TRes>
    implements CopyWith$Input$ImageDestroyInput<TRes> {
  _CopyWithStubImpl$Input$ImageDestroyInput(this._res);

  TRes _res;

  call({
    String? id,
    bool? delete_file,
    bool? delete_generated,
  }) =>
      _res;
}

class Input$ImagesDestroyInput {
  factory Input$ImagesDestroyInput({
    required List<String> ids,
    bool? delete_file,
    bool? delete_generated,
  }) =>
      Input$ImagesDestroyInput._({
        r'ids': ids,
        if (delete_file != null) r'delete_file': delete_file,
        if (delete_generated != null) r'delete_generated': delete_generated,
      });

  Input$ImagesDestroyInput._(this._$data);

  factory Input$ImagesDestroyInput.fromJson(Map<String, dynamic> data) {
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
    return Input$ImagesDestroyInput._(result$data);
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

  CopyWith$Input$ImagesDestroyInput<Input$ImagesDestroyInput> get copyWith =>
      CopyWith$Input$ImagesDestroyInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ImagesDestroyInput) ||
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

abstract class CopyWith$Input$ImagesDestroyInput<TRes> {
  factory CopyWith$Input$ImagesDestroyInput(
    Input$ImagesDestroyInput instance,
    TRes Function(Input$ImagesDestroyInput) then,
  ) = _CopyWithImpl$Input$ImagesDestroyInput;

  factory CopyWith$Input$ImagesDestroyInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ImagesDestroyInput;

  TRes call({
    List<String>? ids,
    bool? delete_file,
    bool? delete_generated,
  });
}

class _CopyWithImpl$Input$ImagesDestroyInput<TRes>
    implements CopyWith$Input$ImagesDestroyInput<TRes> {
  _CopyWithImpl$Input$ImagesDestroyInput(
    this._instance,
    this._then,
  );

  final Input$ImagesDestroyInput _instance;

  final TRes Function(Input$ImagesDestroyInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ids = _undefined,
    Object? delete_file = _undefined,
    Object? delete_generated = _undefined,
  }) =>
      _then(Input$ImagesDestroyInput._({
        ..._instance._$data,
        if (ids != _undefined && ids != null) 'ids': (ids as List<String>),
        if (delete_file != _undefined) 'delete_file': (delete_file as bool?),
        if (delete_generated != _undefined)
          'delete_generated': (delete_generated as bool?),
      }));
}

class _CopyWithStubImpl$Input$ImagesDestroyInput<TRes>
    implements CopyWith$Input$ImagesDestroyInput<TRes> {
  _CopyWithStubImpl$Input$ImagesDestroyInput(this._res);

  TRes _res;

  call({
    List<String>? ids,
    bool? delete_file,
    bool? delete_generated,
  }) =>
      _res;
}
