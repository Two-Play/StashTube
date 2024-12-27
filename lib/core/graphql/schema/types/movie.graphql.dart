import 'performer.graphql.dart';
import 'scene.graphql.dart';

class Input$MovieCreateInput {
  factory Input$MovieCreateInput({
    required String name,
    String? aliases,
    int? duration,
    String? date,
    int? rating100,
    String? studio_id,
    String? director,
    String? synopsis,
    String? url,
    List<String>? urls,
    List<String>? tag_ids,
    String? front_image,
    String? back_image,
  }) =>
      Input$MovieCreateInput._({
        r'name': name,
        if (aliases != null) r'aliases': aliases,
        if (duration != null) r'duration': duration,
        if (date != null) r'date': date,
        if (rating100 != null) r'rating100': rating100,
        if (studio_id != null) r'studio_id': studio_id,
        if (director != null) r'director': director,
        if (synopsis != null) r'synopsis': synopsis,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (front_image != null) r'front_image': front_image,
        if (back_image != null) r'back_image': back_image,
      });

  Input$MovieCreateInput._(this._$data);

  factory Input$MovieCreateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    if (data.containsKey('aliases')) {
      final l$aliases = data['aliases'];
      result$data['aliases'] = (l$aliases as String?);
    }
    if (data.containsKey('duration')) {
      final l$duration = data['duration'];
      result$data['duration'] = (l$duration as int?);
    }
    if (data.containsKey('date')) {
      final l$date = data['date'];
      result$data['date'] = (l$date as String?);
    }
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    if (data.containsKey('studio_id')) {
      final l$studio_id = data['studio_id'];
      result$data['studio_id'] = (l$studio_id as String?);
    }
    if (data.containsKey('director')) {
      final l$director = data['director'];
      result$data['director'] = (l$director as String?);
    }
    if (data.containsKey('synopsis')) {
      final l$synopsis = data['synopsis'];
      result$data['synopsis'] = (l$synopsis as String?);
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
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] =
          (l$tag_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('front_image')) {
      final l$front_image = data['front_image'];
      result$data['front_image'] = (l$front_image as String?);
    }
    if (data.containsKey('back_image')) {
      final l$back_image = data['back_image'];
      result$data['back_image'] = (l$back_image as String?);
    }
    return Input$MovieCreateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get name => (_$data['name'] as String);

  String? get aliases => (_$data['aliases'] as String?);

  int? get duration => (_$data['duration'] as int?);

  String? get date => (_$data['date'] as String?);

  int? get rating100 => (_$data['rating100'] as int?);

  String? get studio_id => (_$data['studio_id'] as String?);

  String? get director => (_$data['director'] as String?);

  String? get synopsis => (_$data['synopsis'] as String?);

  String? get url => (_$data['url'] as String?);

  List<String>? get urls => (_$data['urls'] as List<String>?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  String? get front_image => (_$data['front_image'] as String?);

  String? get back_image => (_$data['back_image'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$name = name;
    result$data['name'] = l$name;
    if (_$data.containsKey('aliases')) {
      final l$aliases = aliases;
      result$data['aliases'] = l$aliases;
    }
    if (_$data.containsKey('duration')) {
      final l$duration = duration;
      result$data['duration'] = l$duration;
    }
    if (_$data.containsKey('date')) {
      final l$date = date;
      result$data['date'] = l$date;
    }
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    if (_$data.containsKey('studio_id')) {
      final l$studio_id = studio_id;
      result$data['studio_id'] = l$studio_id;
    }
    if (_$data.containsKey('director')) {
      final l$director = director;
      result$data['director'] = l$director;
    }
    if (_$data.containsKey('synopsis')) {
      final l$synopsis = synopsis;
      result$data['synopsis'] = l$synopsis;
    }
    if (_$data.containsKey('url')) {
      final l$url = url;
      result$data['url'] = l$url;
    }
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.map((e) => e).toList();
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('front_image')) {
      final l$front_image = front_image;
      result$data['front_image'] = l$front_image;
    }
    if (_$data.containsKey('back_image')) {
      final l$back_image = back_image;
      result$data['back_image'] = l$back_image;
    }
    return result$data;
  }

  CopyWith$Input$MovieCreateInput<Input$MovieCreateInput> get copyWith =>
      CopyWith$Input$MovieCreateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$MovieCreateInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$aliases = aliases;
    final lOther$aliases = other.aliases;
    if (_$data.containsKey('aliases') != other._$data.containsKey('aliases')) {
      return false;
    }
    if (l$aliases != lOther$aliases) {
      return false;
    }
    final l$duration = duration;
    final lOther$duration = other.duration;
    if (_$data.containsKey('duration') !=
        other._$data.containsKey('duration')) {
      return false;
    }
    if (l$duration != lOther$duration) {
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
    final l$studio_id = studio_id;
    final lOther$studio_id = other.studio_id;
    if (_$data.containsKey('studio_id') !=
        other._$data.containsKey('studio_id')) {
      return false;
    }
    if (l$studio_id != lOther$studio_id) {
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
    final l$synopsis = synopsis;
    final lOther$synopsis = other.synopsis;
    if (_$data.containsKey('synopsis') !=
        other._$data.containsKey('synopsis')) {
      return false;
    }
    if (l$synopsis != lOther$synopsis) {
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
    final l$front_image = front_image;
    final lOther$front_image = other.front_image;
    if (_$data.containsKey('front_image') !=
        other._$data.containsKey('front_image')) {
      return false;
    }
    if (l$front_image != lOther$front_image) {
      return false;
    }
    final l$back_image = back_image;
    final lOther$back_image = other.back_image;
    if (_$data.containsKey('back_image') !=
        other._$data.containsKey('back_image')) {
      return false;
    }
    if (l$back_image != lOther$back_image) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$aliases = aliases;
    final l$duration = duration;
    final l$date = date;
    final l$rating100 = rating100;
    final l$studio_id = studio_id;
    final l$director = director;
    final l$synopsis = synopsis;
    final l$url = url;
    final l$urls = urls;
    final l$tag_ids = tag_ids;
    final l$front_image = front_image;
    final l$back_image = back_image;
    return Object.hashAll([
      l$name,
      _$data.containsKey('aliases') ? l$aliases : const {},
      _$data.containsKey('duration') ? l$duration : const {},
      _$data.containsKey('date') ? l$date : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('studio_id') ? l$studio_id : const {},
      _$data.containsKey('director') ? l$director : const {},
      _$data.containsKey('synopsis') ? l$synopsis : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls')
          ? l$urls == null
              ? null
              : Object.hashAll(l$urls.map((v) => v))
          : const {},
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
              ? null
              : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
      _$data.containsKey('front_image') ? l$front_image : const {},
      _$data.containsKey('back_image') ? l$back_image : const {},
    ]);
  }
}

abstract class CopyWith$Input$MovieCreateInput<TRes> {
  factory CopyWith$Input$MovieCreateInput(
    Input$MovieCreateInput instance,
    TRes Function(Input$MovieCreateInput) then,
  ) = _CopyWithImpl$Input$MovieCreateInput;

  factory CopyWith$Input$MovieCreateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$MovieCreateInput;

  TRes call({
    String? name,
    String? aliases,
    int? duration,
    String? date,
    int? rating100,
    String? studio_id,
    String? director,
    String? synopsis,
    String? url,
    List<String>? urls,
    List<String>? tag_ids,
    String? front_image,
    String? back_image,
  });
}

class _CopyWithImpl$Input$MovieCreateInput<TRes>
    implements CopyWith$Input$MovieCreateInput<TRes> {
  _CopyWithImpl$Input$MovieCreateInput(
    this._instance,
    this._then,
  );

  final Input$MovieCreateInput _instance;

  final TRes Function(Input$MovieCreateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? aliases = _undefined,
    Object? duration = _undefined,
    Object? date = _undefined,
    Object? rating100 = _undefined,
    Object? studio_id = _undefined,
    Object? director = _undefined,
    Object? synopsis = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? tag_ids = _undefined,
    Object? front_image = _undefined,
    Object? back_image = _undefined,
  }) =>
      _then(Input$MovieCreateInput._({
        ..._instance._$data,
        if (name != _undefined && name != null) 'name': (name as String),
        if (aliases != _undefined) 'aliases': (aliases as String?),
        if (duration != _undefined) 'duration': (duration as int?),
        if (date != _undefined) 'date': (date as String?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (studio_id != _undefined) 'studio_id': (studio_id as String?),
        if (director != _undefined) 'director': (director as String?),
        if (synopsis != _undefined) 'synopsis': (synopsis as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
        if (front_image != _undefined) 'front_image': (front_image as String?),
        if (back_image != _undefined) 'back_image': (back_image as String?),
      }));
}

class _CopyWithStubImpl$Input$MovieCreateInput<TRes>
    implements CopyWith$Input$MovieCreateInput<TRes> {
  _CopyWithStubImpl$Input$MovieCreateInput(this._res);

  TRes _res;

  call({
    String? name,
    String? aliases,
    int? duration,
    String? date,
    int? rating100,
    String? studio_id,
    String? director,
    String? synopsis,
    String? url,
    List<String>? urls,
    List<String>? tag_ids,
    String? front_image,
    String? back_image,
  }) =>
      _res;
}

class Input$MovieUpdateInput {
  factory Input$MovieUpdateInput({
    required String id,
    String? name,
    String? aliases,
    int? duration,
    String? date,
    int? rating100,
    String? studio_id,
    String? director,
    String? synopsis,
    String? url,
    List<String>? urls,
    List<String>? tag_ids,
    String? front_image,
    String? back_image,
  }) =>
      Input$MovieUpdateInput._({
        r'id': id,
        if (name != null) r'name': name,
        if (aliases != null) r'aliases': aliases,
        if (duration != null) r'duration': duration,
        if (date != null) r'date': date,
        if (rating100 != null) r'rating100': rating100,
        if (studio_id != null) r'studio_id': studio_id,
        if (director != null) r'director': director,
        if (synopsis != null) r'synopsis': synopsis,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (front_image != null) r'front_image': front_image,
        if (back_image != null) r'back_image': back_image,
      });

  Input$MovieUpdateInput._(this._$data);

  factory Input$MovieUpdateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('name')) {
      final l$name = data['name'];
      result$data['name'] = (l$name as String?);
    }
    if (data.containsKey('aliases')) {
      final l$aliases = data['aliases'];
      result$data['aliases'] = (l$aliases as String?);
    }
    if (data.containsKey('duration')) {
      final l$duration = data['duration'];
      result$data['duration'] = (l$duration as int?);
    }
    if (data.containsKey('date')) {
      final l$date = data['date'];
      result$data['date'] = (l$date as String?);
    }
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    if (data.containsKey('studio_id')) {
      final l$studio_id = data['studio_id'];
      result$data['studio_id'] = (l$studio_id as String?);
    }
    if (data.containsKey('director')) {
      final l$director = data['director'];
      result$data['director'] = (l$director as String?);
    }
    if (data.containsKey('synopsis')) {
      final l$synopsis = data['synopsis'];
      result$data['synopsis'] = (l$synopsis as String?);
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
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] =
          (l$tag_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('front_image')) {
      final l$front_image = data['front_image'];
      result$data['front_image'] = (l$front_image as String?);
    }
    if (data.containsKey('back_image')) {
      final l$back_image = data['back_image'];
      result$data['back_image'] = (l$back_image as String?);
    }
    return Input$MovieUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  String? get name => (_$data['name'] as String?);

  String? get aliases => (_$data['aliases'] as String?);

  int? get duration => (_$data['duration'] as int?);

  String? get date => (_$data['date'] as String?);

  int? get rating100 => (_$data['rating100'] as int?);

  String? get studio_id => (_$data['studio_id'] as String?);

  String? get director => (_$data['director'] as String?);

  String? get synopsis => (_$data['synopsis'] as String?);

  String? get url => (_$data['url'] as String?);

  List<String>? get urls => (_$data['urls'] as List<String>?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  String? get front_image => (_$data['front_image'] as String?);

  String? get back_image => (_$data['back_image'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('name')) {
      final l$name = name;
      result$data['name'] = l$name;
    }
    if (_$data.containsKey('aliases')) {
      final l$aliases = aliases;
      result$data['aliases'] = l$aliases;
    }
    if (_$data.containsKey('duration')) {
      final l$duration = duration;
      result$data['duration'] = l$duration;
    }
    if (_$data.containsKey('date')) {
      final l$date = date;
      result$data['date'] = l$date;
    }
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    if (_$data.containsKey('studio_id')) {
      final l$studio_id = studio_id;
      result$data['studio_id'] = l$studio_id;
    }
    if (_$data.containsKey('director')) {
      final l$director = director;
      result$data['director'] = l$director;
    }
    if (_$data.containsKey('synopsis')) {
      final l$synopsis = synopsis;
      result$data['synopsis'] = l$synopsis;
    }
    if (_$data.containsKey('url')) {
      final l$url = url;
      result$data['url'] = l$url;
    }
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.map((e) => e).toList();
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('front_image')) {
      final l$front_image = front_image;
      result$data['front_image'] = l$front_image;
    }
    if (_$data.containsKey('back_image')) {
      final l$back_image = back_image;
      result$data['back_image'] = l$back_image;
    }
    return result$data;
  }

  CopyWith$Input$MovieUpdateInput<Input$MovieUpdateInput> get copyWith =>
      CopyWith$Input$MovieUpdateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$MovieUpdateInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (_$data.containsKey('name') != other._$data.containsKey('name')) {
      return false;
    }
    if (l$name != lOther$name) {
      return false;
    }
    final l$aliases = aliases;
    final lOther$aliases = other.aliases;
    if (_$data.containsKey('aliases') != other._$data.containsKey('aliases')) {
      return false;
    }
    if (l$aliases != lOther$aliases) {
      return false;
    }
    final l$duration = duration;
    final lOther$duration = other.duration;
    if (_$data.containsKey('duration') !=
        other._$data.containsKey('duration')) {
      return false;
    }
    if (l$duration != lOther$duration) {
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
    final l$studio_id = studio_id;
    final lOther$studio_id = other.studio_id;
    if (_$data.containsKey('studio_id') !=
        other._$data.containsKey('studio_id')) {
      return false;
    }
    if (l$studio_id != lOther$studio_id) {
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
    final l$synopsis = synopsis;
    final lOther$synopsis = other.synopsis;
    if (_$data.containsKey('synopsis') !=
        other._$data.containsKey('synopsis')) {
      return false;
    }
    if (l$synopsis != lOther$synopsis) {
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
    final l$front_image = front_image;
    final lOther$front_image = other.front_image;
    if (_$data.containsKey('front_image') !=
        other._$data.containsKey('front_image')) {
      return false;
    }
    if (l$front_image != lOther$front_image) {
      return false;
    }
    final l$back_image = back_image;
    final lOther$back_image = other.back_image;
    if (_$data.containsKey('back_image') !=
        other._$data.containsKey('back_image')) {
      return false;
    }
    if (l$back_image != lOther$back_image) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$aliases = aliases;
    final l$duration = duration;
    final l$date = date;
    final l$rating100 = rating100;
    final l$studio_id = studio_id;
    final l$director = director;
    final l$synopsis = synopsis;
    final l$url = url;
    final l$urls = urls;
    final l$tag_ids = tag_ids;
    final l$front_image = front_image;
    final l$back_image = back_image;
    return Object.hashAll([
      l$id,
      _$data.containsKey('name') ? l$name : const {},
      _$data.containsKey('aliases') ? l$aliases : const {},
      _$data.containsKey('duration') ? l$duration : const {},
      _$data.containsKey('date') ? l$date : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('studio_id') ? l$studio_id : const {},
      _$data.containsKey('director') ? l$director : const {},
      _$data.containsKey('synopsis') ? l$synopsis : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls')
          ? l$urls == null
              ? null
              : Object.hashAll(l$urls.map((v) => v))
          : const {},
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
              ? null
              : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
      _$data.containsKey('front_image') ? l$front_image : const {},
      _$data.containsKey('back_image') ? l$back_image : const {},
    ]);
  }
}

abstract class CopyWith$Input$MovieUpdateInput<TRes> {
  factory CopyWith$Input$MovieUpdateInput(
    Input$MovieUpdateInput instance,
    TRes Function(Input$MovieUpdateInput) then,
  ) = _CopyWithImpl$Input$MovieUpdateInput;

  factory CopyWith$Input$MovieUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$MovieUpdateInput;

  TRes call({
    String? id,
    String? name,
    String? aliases,
    int? duration,
    String? date,
    int? rating100,
    String? studio_id,
    String? director,
    String? synopsis,
    String? url,
    List<String>? urls,
    List<String>? tag_ids,
    String? front_image,
    String? back_image,
  });
}

class _CopyWithImpl$Input$MovieUpdateInput<TRes>
    implements CopyWith$Input$MovieUpdateInput<TRes> {
  _CopyWithImpl$Input$MovieUpdateInput(
    this._instance,
    this._then,
  );

  final Input$MovieUpdateInput _instance;

  final TRes Function(Input$MovieUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? aliases = _undefined,
    Object? duration = _undefined,
    Object? date = _undefined,
    Object? rating100 = _undefined,
    Object? studio_id = _undefined,
    Object? director = _undefined,
    Object? synopsis = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? tag_ids = _undefined,
    Object? front_image = _undefined,
    Object? back_image = _undefined,
  }) =>
      _then(Input$MovieUpdateInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (name != _undefined) 'name': (name as String?),
        if (aliases != _undefined) 'aliases': (aliases as String?),
        if (duration != _undefined) 'duration': (duration as int?),
        if (date != _undefined) 'date': (date as String?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (studio_id != _undefined) 'studio_id': (studio_id as String?),
        if (director != _undefined) 'director': (director as String?),
        if (synopsis != _undefined) 'synopsis': (synopsis as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
        if (front_image != _undefined) 'front_image': (front_image as String?),
        if (back_image != _undefined) 'back_image': (back_image as String?),
      }));
}

class _CopyWithStubImpl$Input$MovieUpdateInput<TRes>
    implements CopyWith$Input$MovieUpdateInput<TRes> {
  _CopyWithStubImpl$Input$MovieUpdateInput(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? aliases,
    int? duration,
    String? date,
    int? rating100,
    String? studio_id,
    String? director,
    String? synopsis,
    String? url,
    List<String>? urls,
    List<String>? tag_ids,
    String? front_image,
    String? back_image,
  }) =>
      _res;
}

class Input$BulkMovieUpdateInput {
  factory Input$BulkMovieUpdateInput({
    String? clientMutationId,
    List<String>? ids,
    int? rating100,
    String? studio_id,
    String? director,
    Input$BulkUpdateStrings? urls,
    Input$BulkUpdateIds? tag_ids,
  }) =>
      Input$BulkMovieUpdateInput._({
        if (clientMutationId != null) r'clientMutationId': clientMutationId,
        if (ids != null) r'ids': ids,
        if (rating100 != null) r'rating100': rating100,
        if (studio_id != null) r'studio_id': studio_id,
        if (director != null) r'director': director,
        if (urls != null) r'urls': urls,
        if (tag_ids != null) r'tag_ids': tag_ids,
      });

  Input$BulkMovieUpdateInput._(this._$data);

  factory Input$BulkMovieUpdateInput.fromJson(Map<String, dynamic> data) {
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
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    if (data.containsKey('studio_id')) {
      final l$studio_id = data['studio_id'];
      result$data['studio_id'] = (l$studio_id as String?);
    }
    if (data.containsKey('director')) {
      final l$director = data['director'];
      result$data['director'] = (l$director as String?);
    }
    if (data.containsKey('urls')) {
      final l$urls = data['urls'];
      result$data['urls'] = l$urls == null
          ? null
          : Input$BulkUpdateStrings.fromJson((l$urls as Map<String, dynamic>));
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] = l$tag_ids == null
          ? null
          : Input$BulkUpdateIds.fromJson((l$tag_ids as Map<String, dynamic>));
    }
    return Input$BulkMovieUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get clientMutationId => (_$data['clientMutationId'] as String?);

  List<String>? get ids => (_$data['ids'] as List<String>?);

  int? get rating100 => (_$data['rating100'] as int?);

  String? get studio_id => (_$data['studio_id'] as String?);

  String? get director => (_$data['director'] as String?);

  Input$BulkUpdateStrings? get urls =>
      (_$data['urls'] as Input$BulkUpdateStrings?);

  Input$BulkUpdateIds? get tag_ids =>
      (_$data['tag_ids'] as Input$BulkUpdateIds?);

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
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    if (_$data.containsKey('studio_id')) {
      final l$studio_id = studio_id;
      result$data['studio_id'] = l$studio_id;
    }
    if (_$data.containsKey('director')) {
      final l$director = director;
      result$data['director'] = l$director;
    }
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.toJson();
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$BulkMovieUpdateInput<Input$BulkMovieUpdateInput>
      get copyWith => CopyWith$Input$BulkMovieUpdateInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$BulkMovieUpdateInput) ||
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
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (_$data.containsKey('rating100') !=
        other._$data.containsKey('rating100')) {
      return false;
    }
    if (l$rating100 != lOther$rating100) {
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
    final l$director = director;
    final lOther$director = other.director;
    if (_$data.containsKey('director') !=
        other._$data.containsKey('director')) {
      return false;
    }
    if (l$director != lOther$director) {
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
    final l$tag_ids = tag_ids;
    final lOther$tag_ids = other.tag_ids;
    if (_$data.containsKey('tag_ids') != other._$data.containsKey('tag_ids')) {
      return false;
    }
    if (l$tag_ids != lOther$tag_ids) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$clientMutationId = clientMutationId;
    final l$ids = ids;
    final l$rating100 = rating100;
    final l$studio_id = studio_id;
    final l$director = director;
    final l$urls = urls;
    final l$tag_ids = tag_ids;
    return Object.hashAll([
      _$data.containsKey('clientMutationId') ? l$clientMutationId : const {},
      _$data.containsKey('ids')
          ? l$ids == null
              ? null
              : Object.hashAll(l$ids.map((v) => v))
          : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('studio_id') ? l$studio_id : const {},
      _$data.containsKey('director') ? l$director : const {},
      _$data.containsKey('urls') ? l$urls : const {},
      _$data.containsKey('tag_ids') ? l$tag_ids : const {},
    ]);
  }
}

abstract class CopyWith$Input$BulkMovieUpdateInput<TRes> {
  factory CopyWith$Input$BulkMovieUpdateInput(
    Input$BulkMovieUpdateInput instance,
    TRes Function(Input$BulkMovieUpdateInput) then,
  ) = _CopyWithImpl$Input$BulkMovieUpdateInput;

  factory CopyWith$Input$BulkMovieUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$BulkMovieUpdateInput;

  TRes call({
    String? clientMutationId,
    List<String>? ids,
    int? rating100,
    String? studio_id,
    String? director,
    Input$BulkUpdateStrings? urls,
    Input$BulkUpdateIds? tag_ids,
  });
}

class _CopyWithImpl$Input$BulkMovieUpdateInput<TRes>
    implements CopyWith$Input$BulkMovieUpdateInput<TRes> {
  _CopyWithImpl$Input$BulkMovieUpdateInput(
    this._instance,
    this._then,
  );

  final Input$BulkMovieUpdateInput _instance;

  final TRes Function(Input$BulkMovieUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? clientMutationId = _undefined,
    Object? ids = _undefined,
    Object? rating100 = _undefined,
    Object? studio_id = _undefined,
    Object? director = _undefined,
    Object? urls = _undefined,
    Object? tag_ids = _undefined,
  }) =>
      _then(Input$BulkMovieUpdateInput._({
        ..._instance._$data,
        if (clientMutationId != _undefined)
          'clientMutationId': (clientMutationId as String?),
        if (ids != _undefined) 'ids': (ids as List<String>?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (studio_id != _undefined) 'studio_id': (studio_id as String?),
        if (director != _undefined) 'director': (director as String?),
        if (urls != _undefined) 'urls': (urls as Input$BulkUpdateStrings?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as Input$BulkUpdateIds?),
      }));
}

class _CopyWithStubImpl$Input$BulkMovieUpdateInput<TRes>
    implements CopyWith$Input$BulkMovieUpdateInput<TRes> {
  _CopyWithStubImpl$Input$BulkMovieUpdateInput(this._res);

  TRes _res;

  call({
    String? clientMutationId,
    List<String>? ids,
    int? rating100,
    String? studio_id,
    String? director,
    Input$BulkUpdateStrings? urls,
    Input$BulkUpdateIds? tag_ids,
  }) =>
      _res;
}

class Input$MovieDestroyInput {
  factory Input$MovieDestroyInput({required String id}) =>
      Input$MovieDestroyInput._({
        r'id': id,
      });

  Input$MovieDestroyInput._(this._$data);

  factory Input$MovieDestroyInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Input$MovieDestroyInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Input$MovieDestroyInput<Input$MovieDestroyInput> get copyWith =>
      CopyWith$Input$MovieDestroyInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$MovieDestroyInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

abstract class CopyWith$Input$MovieDestroyInput<TRes> {
  factory CopyWith$Input$MovieDestroyInput(
    Input$MovieDestroyInput instance,
    TRes Function(Input$MovieDestroyInput) then,
  ) = _CopyWithImpl$Input$MovieDestroyInput;

  factory CopyWith$Input$MovieDestroyInput.stub(TRes res) =
      _CopyWithStubImpl$Input$MovieDestroyInput;

  TRes call({String? id});
}

class _CopyWithImpl$Input$MovieDestroyInput<TRes>
    implements CopyWith$Input$MovieDestroyInput<TRes> {
  _CopyWithImpl$Input$MovieDestroyInput(
    this._instance,
    this._then,
  );

  final Input$MovieDestroyInput _instance;

  final TRes Function(Input$MovieDestroyInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(Input$MovieDestroyInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
      }));
}

class _CopyWithStubImpl$Input$MovieDestroyInput<TRes>
    implements CopyWith$Input$MovieDestroyInput<TRes> {
  _CopyWithStubImpl$Input$MovieDestroyInput(this._res);

  TRes _res;

  call({String? id}) => _res;
}
