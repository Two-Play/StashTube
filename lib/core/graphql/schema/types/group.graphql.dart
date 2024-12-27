import 'performer.graphql.dart';
import 'scene.graphql.dart';

class Input$GroupDescriptionInput {
  factory Input$GroupDescriptionInput({
    required String group_id,
    String? description,
  }) =>
      Input$GroupDescriptionInput._({
        r'group_id': group_id,
        if (description != null) r'description': description,
      });

  Input$GroupDescriptionInput._(this._$data);

  factory Input$GroupDescriptionInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$group_id = data['group_id'];
    result$data['group_id'] = (l$group_id as String);
    if (data.containsKey('description')) {
      final l$description = data['description'];
      result$data['description'] = (l$description as String?);
    }
    return Input$GroupDescriptionInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get group_id => (_$data['group_id'] as String);

  String? get description => (_$data['description'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$group_id = group_id;
    result$data['group_id'] = l$group_id;
    if (_$data.containsKey('description')) {
      final l$description = description;
      result$data['description'] = l$description;
    }
    return result$data;
  }

  CopyWith$Input$GroupDescriptionInput<Input$GroupDescriptionInput>
      get copyWith => CopyWith$Input$GroupDescriptionInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GroupDescriptionInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$group_id = group_id;
    final lOther$group_id = other.group_id;
    if (l$group_id != lOther$group_id) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (_$data.containsKey('description') !=
        other._$data.containsKey('description')) {
      return false;
    }
    if (l$description != lOther$description) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$group_id = group_id;
    final l$description = description;
    return Object.hashAll([
      l$group_id,
      _$data.containsKey('description') ? l$description : const {},
    ]);
  }
}

abstract class CopyWith$Input$GroupDescriptionInput<TRes> {
  factory CopyWith$Input$GroupDescriptionInput(
    Input$GroupDescriptionInput instance,
    TRes Function(Input$GroupDescriptionInput) then,
  ) = _CopyWithImpl$Input$GroupDescriptionInput;

  factory CopyWith$Input$GroupDescriptionInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GroupDescriptionInput;

  TRes call({
    String? group_id,
    String? description,
  });
}

class _CopyWithImpl$Input$GroupDescriptionInput<TRes>
    implements CopyWith$Input$GroupDescriptionInput<TRes> {
  _CopyWithImpl$Input$GroupDescriptionInput(
    this._instance,
    this._then,
  );

  final Input$GroupDescriptionInput _instance;

  final TRes Function(Input$GroupDescriptionInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? group_id = _undefined,
    Object? description = _undefined,
  }) =>
      _then(Input$GroupDescriptionInput._({
        ..._instance._$data,
        if (group_id != _undefined && group_id != null)
          'group_id': (group_id as String),
        if (description != _undefined) 'description': (description as String?),
      }));
}

class _CopyWithStubImpl$Input$GroupDescriptionInput<TRes>
    implements CopyWith$Input$GroupDescriptionInput<TRes> {
  _CopyWithStubImpl$Input$GroupDescriptionInput(this._res);

  TRes _res;

  call({
    String? group_id,
    String? description,
  }) =>
      _res;
}

class Input$GroupCreateInput {
  factory Input$GroupCreateInput({
    required String name,
    String? aliases,
    int? duration,
    String? date,
    int? rating100,
    String? studio_id,
    String? director,
    String? synopsis,
    List<String>? urls,
    List<String>? tag_ids,
    List<Input$GroupDescriptionInput>? containing_groups,
    List<Input$GroupDescriptionInput>? sub_groups,
    String? front_image,
    String? back_image,
  }) =>
      Input$GroupCreateInput._({
        r'name': name,
        if (aliases != null) r'aliases': aliases,
        if (duration != null) r'duration': duration,
        if (date != null) r'date': date,
        if (rating100 != null) r'rating100': rating100,
        if (studio_id != null) r'studio_id': studio_id,
        if (director != null) r'director': director,
        if (synopsis != null) r'synopsis': synopsis,
        if (urls != null) r'urls': urls,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (containing_groups != null) r'containing_groups': containing_groups,
        if (sub_groups != null) r'sub_groups': sub_groups,
        if (front_image != null) r'front_image': front_image,
        if (back_image != null) r'back_image': back_image,
      });

  Input$GroupCreateInput._(this._$data);

  factory Input$GroupCreateInput.fromJson(Map<String, dynamic> data) {
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
    if (data.containsKey('containing_groups')) {
      final l$containing_groups = data['containing_groups'];
      result$data['containing_groups'] = (l$containing_groups as List<dynamic>?)
          ?.map((e) =>
              Input$GroupDescriptionInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('sub_groups')) {
      final l$sub_groups = data['sub_groups'];
      result$data['sub_groups'] = (l$sub_groups as List<dynamic>?)
          ?.map((e) =>
              Input$GroupDescriptionInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('front_image')) {
      final l$front_image = data['front_image'];
      result$data['front_image'] = (l$front_image as String?);
    }
    if (data.containsKey('back_image')) {
      final l$back_image = data['back_image'];
      result$data['back_image'] = (l$back_image as String?);
    }
    return Input$GroupCreateInput._(result$data);
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

  List<String>? get urls => (_$data['urls'] as List<String>?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  List<Input$GroupDescriptionInput>? get containing_groups =>
      (_$data['containing_groups'] as List<Input$GroupDescriptionInput>?);

  List<Input$GroupDescriptionInput>? get sub_groups =>
      (_$data['sub_groups'] as List<Input$GroupDescriptionInput>?);

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
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.map((e) => e).toList();
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('containing_groups')) {
      final l$containing_groups = containing_groups;
      result$data['containing_groups'] =
          l$containing_groups?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('sub_groups')) {
      final l$sub_groups = sub_groups;
      result$data['sub_groups'] = l$sub_groups?.map((e) => e.toJson()).toList();
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

  CopyWith$Input$GroupCreateInput<Input$GroupCreateInput> get copyWith =>
      CopyWith$Input$GroupCreateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GroupCreateInput) ||
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
    final l$containing_groups = containing_groups;
    final lOther$containing_groups = other.containing_groups;
    if (_$data.containsKey('containing_groups') !=
        other._$data.containsKey('containing_groups')) {
      return false;
    }
    if (l$containing_groups != null && lOther$containing_groups != null) {
      if (l$containing_groups.length != lOther$containing_groups.length) {
        return false;
      }
      for (int i = 0; i < l$containing_groups.length; i++) {
        final l$containing_groups$entry = l$containing_groups[i];
        final lOther$containing_groups$entry = lOther$containing_groups[i];
        if (l$containing_groups$entry != lOther$containing_groups$entry) {
          return false;
        }
      }
    } else if (l$containing_groups != lOther$containing_groups) {
      return false;
    }
    final l$sub_groups = sub_groups;
    final lOther$sub_groups = other.sub_groups;
    if (_$data.containsKey('sub_groups') !=
        other._$data.containsKey('sub_groups')) {
      return false;
    }
    if (l$sub_groups != null && lOther$sub_groups != null) {
      if (l$sub_groups.length != lOther$sub_groups.length) {
        return false;
      }
      for (int i = 0; i < l$sub_groups.length; i++) {
        final l$sub_groups$entry = l$sub_groups[i];
        final lOther$sub_groups$entry = lOther$sub_groups[i];
        if (l$sub_groups$entry != lOther$sub_groups$entry) {
          return false;
        }
      }
    } else if (l$sub_groups != lOther$sub_groups) {
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
    final l$urls = urls;
    final l$tag_ids = tag_ids;
    final l$containing_groups = containing_groups;
    final l$sub_groups = sub_groups;
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
      _$data.containsKey('containing_groups')
          ? l$containing_groups == null
              ? null
              : Object.hashAll(l$containing_groups.map((v) => v))
          : const {},
      _$data.containsKey('sub_groups')
          ? l$sub_groups == null
              ? null
              : Object.hashAll(l$sub_groups.map((v) => v))
          : const {},
      _$data.containsKey('front_image') ? l$front_image : const {},
      _$data.containsKey('back_image') ? l$back_image : const {},
    ]);
  }
}

abstract class CopyWith$Input$GroupCreateInput<TRes> {
  factory CopyWith$Input$GroupCreateInput(
    Input$GroupCreateInput instance,
    TRes Function(Input$GroupCreateInput) then,
  ) = _CopyWithImpl$Input$GroupCreateInput;

  factory CopyWith$Input$GroupCreateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GroupCreateInput;

  TRes call({
    String? name,
    String? aliases,
    int? duration,
    String? date,
    int? rating100,
    String? studio_id,
    String? director,
    String? synopsis,
    List<String>? urls,
    List<String>? tag_ids,
    List<Input$GroupDescriptionInput>? containing_groups,
    List<Input$GroupDescriptionInput>? sub_groups,
    String? front_image,
    String? back_image,
  });
  TRes containing_groups(
      Iterable<Input$GroupDescriptionInput>? Function(
              Iterable<
                  CopyWith$Input$GroupDescriptionInput<
                      Input$GroupDescriptionInput>>?)
          _fn);
  TRes sub_groups(
      Iterable<Input$GroupDescriptionInput>? Function(
              Iterable<
                  CopyWith$Input$GroupDescriptionInput<
                      Input$GroupDescriptionInput>>?)
          _fn);
}

class _CopyWithImpl$Input$GroupCreateInput<TRes>
    implements CopyWith$Input$GroupCreateInput<TRes> {
  _CopyWithImpl$Input$GroupCreateInput(
    this._instance,
    this._then,
  );

  final Input$GroupCreateInput _instance;

  final TRes Function(Input$GroupCreateInput) _then;

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
    Object? urls = _undefined,
    Object? tag_ids = _undefined,
    Object? containing_groups = _undefined,
    Object? sub_groups = _undefined,
    Object? front_image = _undefined,
    Object? back_image = _undefined,
  }) =>
      _then(Input$GroupCreateInput._({
        ..._instance._$data,
        if (name != _undefined && name != null) 'name': (name as String),
        if (aliases != _undefined) 'aliases': (aliases as String?),
        if (duration != _undefined) 'duration': (duration as int?),
        if (date != _undefined) 'date': (date as String?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (studio_id != _undefined) 'studio_id': (studio_id as String?),
        if (director != _undefined) 'director': (director as String?),
        if (synopsis != _undefined) 'synopsis': (synopsis as String?),
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
        if (containing_groups != _undefined)
          'containing_groups':
              (containing_groups as List<Input$GroupDescriptionInput>?),
        if (sub_groups != _undefined)
          'sub_groups': (sub_groups as List<Input$GroupDescriptionInput>?),
        if (front_image != _undefined) 'front_image': (front_image as String?),
        if (back_image != _undefined) 'back_image': (back_image as String?),
      }));

  TRes containing_groups(
          Iterable<Input$GroupDescriptionInput>? Function(
                  Iterable<
                      CopyWith$Input$GroupDescriptionInput<
                          Input$GroupDescriptionInput>>?)
              _fn) =>
      call(
          containing_groups: _fn(_instance.containing_groups
              ?.map((e) => CopyWith$Input$GroupDescriptionInput(
                    e,
                    (i) => i,
                  )))?.toList());

  TRes sub_groups(
          Iterable<Input$GroupDescriptionInput>? Function(
                  Iterable<
                      CopyWith$Input$GroupDescriptionInput<
                          Input$GroupDescriptionInput>>?)
              _fn) =>
      call(
          sub_groups: _fn(_instance.sub_groups
              ?.map((e) => CopyWith$Input$GroupDescriptionInput(
                    e,
                    (i) => i,
                  )))?.toList());
}

class _CopyWithStubImpl$Input$GroupCreateInput<TRes>
    implements CopyWith$Input$GroupCreateInput<TRes> {
  _CopyWithStubImpl$Input$GroupCreateInput(this._res);

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
    List<String>? urls,
    List<String>? tag_ids,
    List<Input$GroupDescriptionInput>? containing_groups,
    List<Input$GroupDescriptionInput>? sub_groups,
    String? front_image,
    String? back_image,
  }) =>
      _res;

  containing_groups(_fn) => _res;

  sub_groups(_fn) => _res;
}

class Input$GroupUpdateInput {
  factory Input$GroupUpdateInput({
    required String id,
    String? name,
    String? aliases,
    int? duration,
    String? date,
    int? rating100,
    String? studio_id,
    String? director,
    String? synopsis,
    List<String>? urls,
    List<String>? tag_ids,
    List<Input$GroupDescriptionInput>? containing_groups,
    List<Input$GroupDescriptionInput>? sub_groups,
    String? front_image,
    String? back_image,
  }) =>
      Input$GroupUpdateInput._({
        r'id': id,
        if (name != null) r'name': name,
        if (aliases != null) r'aliases': aliases,
        if (duration != null) r'duration': duration,
        if (date != null) r'date': date,
        if (rating100 != null) r'rating100': rating100,
        if (studio_id != null) r'studio_id': studio_id,
        if (director != null) r'director': director,
        if (synopsis != null) r'synopsis': synopsis,
        if (urls != null) r'urls': urls,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (containing_groups != null) r'containing_groups': containing_groups,
        if (sub_groups != null) r'sub_groups': sub_groups,
        if (front_image != null) r'front_image': front_image,
        if (back_image != null) r'back_image': back_image,
      });

  Input$GroupUpdateInput._(this._$data);

  factory Input$GroupUpdateInput.fromJson(Map<String, dynamic> data) {
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
    if (data.containsKey('containing_groups')) {
      final l$containing_groups = data['containing_groups'];
      result$data['containing_groups'] = (l$containing_groups as List<dynamic>?)
          ?.map((e) =>
              Input$GroupDescriptionInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('sub_groups')) {
      final l$sub_groups = data['sub_groups'];
      result$data['sub_groups'] = (l$sub_groups as List<dynamic>?)
          ?.map((e) =>
              Input$GroupDescriptionInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('front_image')) {
      final l$front_image = data['front_image'];
      result$data['front_image'] = (l$front_image as String?);
    }
    if (data.containsKey('back_image')) {
      final l$back_image = data['back_image'];
      result$data['back_image'] = (l$back_image as String?);
    }
    return Input$GroupUpdateInput._(result$data);
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

  List<String>? get urls => (_$data['urls'] as List<String>?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  List<Input$GroupDescriptionInput>? get containing_groups =>
      (_$data['containing_groups'] as List<Input$GroupDescriptionInput>?);

  List<Input$GroupDescriptionInput>? get sub_groups =>
      (_$data['sub_groups'] as List<Input$GroupDescriptionInput>?);

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
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.map((e) => e).toList();
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('containing_groups')) {
      final l$containing_groups = containing_groups;
      result$data['containing_groups'] =
          l$containing_groups?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('sub_groups')) {
      final l$sub_groups = sub_groups;
      result$data['sub_groups'] = l$sub_groups?.map((e) => e.toJson()).toList();
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

  CopyWith$Input$GroupUpdateInput<Input$GroupUpdateInput> get copyWith =>
      CopyWith$Input$GroupUpdateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GroupUpdateInput) ||
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
    final l$containing_groups = containing_groups;
    final lOther$containing_groups = other.containing_groups;
    if (_$data.containsKey('containing_groups') !=
        other._$data.containsKey('containing_groups')) {
      return false;
    }
    if (l$containing_groups != null && lOther$containing_groups != null) {
      if (l$containing_groups.length != lOther$containing_groups.length) {
        return false;
      }
      for (int i = 0; i < l$containing_groups.length; i++) {
        final l$containing_groups$entry = l$containing_groups[i];
        final lOther$containing_groups$entry = lOther$containing_groups[i];
        if (l$containing_groups$entry != lOther$containing_groups$entry) {
          return false;
        }
      }
    } else if (l$containing_groups != lOther$containing_groups) {
      return false;
    }
    final l$sub_groups = sub_groups;
    final lOther$sub_groups = other.sub_groups;
    if (_$data.containsKey('sub_groups') !=
        other._$data.containsKey('sub_groups')) {
      return false;
    }
    if (l$sub_groups != null && lOther$sub_groups != null) {
      if (l$sub_groups.length != lOther$sub_groups.length) {
        return false;
      }
      for (int i = 0; i < l$sub_groups.length; i++) {
        final l$sub_groups$entry = l$sub_groups[i];
        final lOther$sub_groups$entry = lOther$sub_groups[i];
        if (l$sub_groups$entry != lOther$sub_groups$entry) {
          return false;
        }
      }
    } else if (l$sub_groups != lOther$sub_groups) {
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
    final l$urls = urls;
    final l$tag_ids = tag_ids;
    final l$containing_groups = containing_groups;
    final l$sub_groups = sub_groups;
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
      _$data.containsKey('containing_groups')
          ? l$containing_groups == null
              ? null
              : Object.hashAll(l$containing_groups.map((v) => v))
          : const {},
      _$data.containsKey('sub_groups')
          ? l$sub_groups == null
              ? null
              : Object.hashAll(l$sub_groups.map((v) => v))
          : const {},
      _$data.containsKey('front_image') ? l$front_image : const {},
      _$data.containsKey('back_image') ? l$back_image : const {},
    ]);
  }
}

abstract class CopyWith$Input$GroupUpdateInput<TRes> {
  factory CopyWith$Input$GroupUpdateInput(
    Input$GroupUpdateInput instance,
    TRes Function(Input$GroupUpdateInput) then,
  ) = _CopyWithImpl$Input$GroupUpdateInput;

  factory CopyWith$Input$GroupUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GroupUpdateInput;

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
    List<String>? urls,
    List<String>? tag_ids,
    List<Input$GroupDescriptionInput>? containing_groups,
    List<Input$GroupDescriptionInput>? sub_groups,
    String? front_image,
    String? back_image,
  });
  TRes containing_groups(
      Iterable<Input$GroupDescriptionInput>? Function(
              Iterable<
                  CopyWith$Input$GroupDescriptionInput<
                      Input$GroupDescriptionInput>>?)
          _fn);
  TRes sub_groups(
      Iterable<Input$GroupDescriptionInput>? Function(
              Iterable<
                  CopyWith$Input$GroupDescriptionInput<
                      Input$GroupDescriptionInput>>?)
          _fn);
}

class _CopyWithImpl$Input$GroupUpdateInput<TRes>
    implements CopyWith$Input$GroupUpdateInput<TRes> {
  _CopyWithImpl$Input$GroupUpdateInput(
    this._instance,
    this._then,
  );

  final Input$GroupUpdateInput _instance;

  final TRes Function(Input$GroupUpdateInput) _then;

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
    Object? urls = _undefined,
    Object? tag_ids = _undefined,
    Object? containing_groups = _undefined,
    Object? sub_groups = _undefined,
    Object? front_image = _undefined,
    Object? back_image = _undefined,
  }) =>
      _then(Input$GroupUpdateInput._({
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
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
        if (containing_groups != _undefined)
          'containing_groups':
              (containing_groups as List<Input$GroupDescriptionInput>?),
        if (sub_groups != _undefined)
          'sub_groups': (sub_groups as List<Input$GroupDescriptionInput>?),
        if (front_image != _undefined) 'front_image': (front_image as String?),
        if (back_image != _undefined) 'back_image': (back_image as String?),
      }));

  TRes containing_groups(
          Iterable<Input$GroupDescriptionInput>? Function(
                  Iterable<
                      CopyWith$Input$GroupDescriptionInput<
                          Input$GroupDescriptionInput>>?)
              _fn) =>
      call(
          containing_groups: _fn(_instance.containing_groups
              ?.map((e) => CopyWith$Input$GroupDescriptionInput(
                    e,
                    (i) => i,
                  )))?.toList());

  TRes sub_groups(
          Iterable<Input$GroupDescriptionInput>? Function(
                  Iterable<
                      CopyWith$Input$GroupDescriptionInput<
                          Input$GroupDescriptionInput>>?)
              _fn) =>
      call(
          sub_groups: _fn(_instance.sub_groups
              ?.map((e) => CopyWith$Input$GroupDescriptionInput(
                    e,
                    (i) => i,
                  )))?.toList());
}

class _CopyWithStubImpl$Input$GroupUpdateInput<TRes>
    implements CopyWith$Input$GroupUpdateInput<TRes> {
  _CopyWithStubImpl$Input$GroupUpdateInput(this._res);

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
    List<String>? urls,
    List<String>? tag_ids,
    List<Input$GroupDescriptionInput>? containing_groups,
    List<Input$GroupDescriptionInput>? sub_groups,
    String? front_image,
    String? back_image,
  }) =>
      _res;

  containing_groups(_fn) => _res;

  sub_groups(_fn) => _res;
}

class Input$BulkUpdateGroupDescriptionsInput {
  factory Input$BulkUpdateGroupDescriptionsInput({
    required List<Input$GroupDescriptionInput> groups,
    required Enum$BulkUpdateIdMode mode,
  }) =>
      Input$BulkUpdateGroupDescriptionsInput._({
        r'groups': groups,
        r'mode': mode,
      });

  Input$BulkUpdateGroupDescriptionsInput._(this._$data);

  factory Input$BulkUpdateGroupDescriptionsInput.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$groups = data['groups'];
    result$data['groups'] = (l$groups as List<dynamic>)
        .map((e) =>
            Input$GroupDescriptionInput.fromJson((e as Map<String, dynamic>)))
        .toList();
    final l$mode = data['mode'];
    result$data['mode'] = fromJson$Enum$BulkUpdateIdMode((l$mode as String));
    return Input$BulkUpdateGroupDescriptionsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<Input$GroupDescriptionInput> get groups =>
      (_$data['groups'] as List<Input$GroupDescriptionInput>);

  Enum$BulkUpdateIdMode get mode => (_$data['mode'] as Enum$BulkUpdateIdMode);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$groups = groups;
    result$data['groups'] = l$groups.map((e) => e.toJson()).toList();
    final l$mode = mode;
    result$data['mode'] = toJson$Enum$BulkUpdateIdMode(l$mode);
    return result$data;
  }

  CopyWith$Input$BulkUpdateGroupDescriptionsInput<
          Input$BulkUpdateGroupDescriptionsInput>
      get copyWith => CopyWith$Input$BulkUpdateGroupDescriptionsInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$BulkUpdateGroupDescriptionsInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$groups = groups;
    final lOther$groups = other.groups;
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
    final l$mode = mode;
    final lOther$mode = other.mode;
    if (l$mode != lOther$mode) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$groups = groups;
    final l$mode = mode;
    return Object.hashAll([
      Object.hashAll(l$groups.map((v) => v)),
      l$mode,
    ]);
  }
}

abstract class CopyWith$Input$BulkUpdateGroupDescriptionsInput<TRes> {
  factory CopyWith$Input$BulkUpdateGroupDescriptionsInput(
    Input$BulkUpdateGroupDescriptionsInput instance,
    TRes Function(Input$BulkUpdateGroupDescriptionsInput) then,
  ) = _CopyWithImpl$Input$BulkUpdateGroupDescriptionsInput;

  factory CopyWith$Input$BulkUpdateGroupDescriptionsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$BulkUpdateGroupDescriptionsInput;

  TRes call({
    List<Input$GroupDescriptionInput>? groups,
    Enum$BulkUpdateIdMode? mode,
  });
  TRes groups(
      Iterable<Input$GroupDescriptionInput> Function(
              Iterable<
                  CopyWith$Input$GroupDescriptionInput<
                      Input$GroupDescriptionInput>>)
          _fn);
}

class _CopyWithImpl$Input$BulkUpdateGroupDescriptionsInput<TRes>
    implements CopyWith$Input$BulkUpdateGroupDescriptionsInput<TRes> {
  _CopyWithImpl$Input$BulkUpdateGroupDescriptionsInput(
    this._instance,
    this._then,
  );

  final Input$BulkUpdateGroupDescriptionsInput _instance;

  final TRes Function(Input$BulkUpdateGroupDescriptionsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? groups = _undefined,
    Object? mode = _undefined,
  }) =>
      _then(Input$BulkUpdateGroupDescriptionsInput._({
        ..._instance._$data,
        if (groups != _undefined && groups != null)
          'groups': (groups as List<Input$GroupDescriptionInput>),
        if (mode != _undefined && mode != null)
          'mode': (mode as Enum$BulkUpdateIdMode),
      }));

  TRes groups(
          Iterable<Input$GroupDescriptionInput> Function(
                  Iterable<
                      CopyWith$Input$GroupDescriptionInput<
                          Input$GroupDescriptionInput>>)
              _fn) =>
      call(
          groups: _fn(
              _instance.groups.map((e) => CopyWith$Input$GroupDescriptionInput(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Input$BulkUpdateGroupDescriptionsInput<TRes>
    implements CopyWith$Input$BulkUpdateGroupDescriptionsInput<TRes> {
  _CopyWithStubImpl$Input$BulkUpdateGroupDescriptionsInput(this._res);

  TRes _res;

  call({
    List<Input$GroupDescriptionInput>? groups,
    Enum$BulkUpdateIdMode? mode,
  }) =>
      _res;

  groups(_fn) => _res;
}

class Input$BulkGroupUpdateInput {
  factory Input$BulkGroupUpdateInput({
    String? clientMutationId,
    List<String>? ids,
    int? rating100,
    String? studio_id,
    String? director,
    Input$BulkUpdateStrings? urls,
    Input$BulkUpdateIds? tag_ids,
    Input$BulkUpdateGroupDescriptionsInput? containing_groups,
    Input$BulkUpdateGroupDescriptionsInput? sub_groups,
  }) =>
      Input$BulkGroupUpdateInput._({
        if (clientMutationId != null) r'clientMutationId': clientMutationId,
        if (ids != null) r'ids': ids,
        if (rating100 != null) r'rating100': rating100,
        if (studio_id != null) r'studio_id': studio_id,
        if (director != null) r'director': director,
        if (urls != null) r'urls': urls,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (containing_groups != null) r'containing_groups': containing_groups,
        if (sub_groups != null) r'sub_groups': sub_groups,
      });

  Input$BulkGroupUpdateInput._(this._$data);

  factory Input$BulkGroupUpdateInput.fromJson(Map<String, dynamic> data) {
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
    if (data.containsKey('containing_groups')) {
      final l$containing_groups = data['containing_groups'];
      result$data['containing_groups'] = l$containing_groups == null
          ? null
          : Input$BulkUpdateGroupDescriptionsInput.fromJson(
              (l$containing_groups as Map<String, dynamic>));
    }
    if (data.containsKey('sub_groups')) {
      final l$sub_groups = data['sub_groups'];
      result$data['sub_groups'] = l$sub_groups == null
          ? null
          : Input$BulkUpdateGroupDescriptionsInput.fromJson(
              (l$sub_groups as Map<String, dynamic>));
    }
    return Input$BulkGroupUpdateInput._(result$data);
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

  Input$BulkUpdateGroupDescriptionsInput? get containing_groups =>
      (_$data['containing_groups'] as Input$BulkUpdateGroupDescriptionsInput?);

  Input$BulkUpdateGroupDescriptionsInput? get sub_groups =>
      (_$data['sub_groups'] as Input$BulkUpdateGroupDescriptionsInput?);

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
    if (_$data.containsKey('containing_groups')) {
      final l$containing_groups = containing_groups;
      result$data['containing_groups'] = l$containing_groups?.toJson();
    }
    if (_$data.containsKey('sub_groups')) {
      final l$sub_groups = sub_groups;
      result$data['sub_groups'] = l$sub_groups?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$BulkGroupUpdateInput<Input$BulkGroupUpdateInput>
      get copyWith => CopyWith$Input$BulkGroupUpdateInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$BulkGroupUpdateInput) ||
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
    final l$containing_groups = containing_groups;
    final lOther$containing_groups = other.containing_groups;
    if (_$data.containsKey('containing_groups') !=
        other._$data.containsKey('containing_groups')) {
      return false;
    }
    if (l$containing_groups != lOther$containing_groups) {
      return false;
    }
    final l$sub_groups = sub_groups;
    final lOther$sub_groups = other.sub_groups;
    if (_$data.containsKey('sub_groups') !=
        other._$data.containsKey('sub_groups')) {
      return false;
    }
    if (l$sub_groups != lOther$sub_groups) {
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
    final l$containing_groups = containing_groups;
    final l$sub_groups = sub_groups;
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
      _$data.containsKey('containing_groups') ? l$containing_groups : const {},
      _$data.containsKey('sub_groups') ? l$sub_groups : const {},
    ]);
  }
}

abstract class CopyWith$Input$BulkGroupUpdateInput<TRes> {
  factory CopyWith$Input$BulkGroupUpdateInput(
    Input$BulkGroupUpdateInput instance,
    TRes Function(Input$BulkGroupUpdateInput) then,
  ) = _CopyWithImpl$Input$BulkGroupUpdateInput;

  factory CopyWith$Input$BulkGroupUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$BulkGroupUpdateInput;

  TRes call({
    String? clientMutationId,
    List<String>? ids,
    int? rating100,
    String? studio_id,
    String? director,
    Input$BulkUpdateStrings? urls,
    Input$BulkUpdateIds? tag_ids,
    Input$BulkUpdateGroupDescriptionsInput? containing_groups,
    Input$BulkUpdateGroupDescriptionsInput? sub_groups,
  });
  CopyWith$Input$BulkUpdateGroupDescriptionsInput<TRes> get containing_groups;
  CopyWith$Input$BulkUpdateGroupDescriptionsInput<TRes> get sub_groups;
}

class _CopyWithImpl$Input$BulkGroupUpdateInput<TRes>
    implements CopyWith$Input$BulkGroupUpdateInput<TRes> {
  _CopyWithImpl$Input$BulkGroupUpdateInput(
    this._instance,
    this._then,
  );

  final Input$BulkGroupUpdateInput _instance;

  final TRes Function(Input$BulkGroupUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? clientMutationId = _undefined,
    Object? ids = _undefined,
    Object? rating100 = _undefined,
    Object? studio_id = _undefined,
    Object? director = _undefined,
    Object? urls = _undefined,
    Object? tag_ids = _undefined,
    Object? containing_groups = _undefined,
    Object? sub_groups = _undefined,
  }) =>
      _then(Input$BulkGroupUpdateInput._({
        ..._instance._$data,
        if (clientMutationId != _undefined)
          'clientMutationId': (clientMutationId as String?),
        if (ids != _undefined) 'ids': (ids as List<String>?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (studio_id != _undefined) 'studio_id': (studio_id as String?),
        if (director != _undefined) 'director': (director as String?),
        if (urls != _undefined) 'urls': (urls as Input$BulkUpdateStrings?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as Input$BulkUpdateIds?),
        if (containing_groups != _undefined)
          'containing_groups':
              (containing_groups as Input$BulkUpdateGroupDescriptionsInput?),
        if (sub_groups != _undefined)
          'sub_groups': (sub_groups as Input$BulkUpdateGroupDescriptionsInput?),
      }));

  CopyWith$Input$BulkUpdateGroupDescriptionsInput<TRes> get containing_groups {
    final local$containing_groups = _instance.containing_groups;
    return local$containing_groups == null
        ? CopyWith$Input$BulkUpdateGroupDescriptionsInput.stub(_then(_instance))
        : CopyWith$Input$BulkUpdateGroupDescriptionsInput(
            local$containing_groups, (e) => call(containing_groups: e));
  }

  CopyWith$Input$BulkUpdateGroupDescriptionsInput<TRes> get sub_groups {
    final local$sub_groups = _instance.sub_groups;
    return local$sub_groups == null
        ? CopyWith$Input$BulkUpdateGroupDescriptionsInput.stub(_then(_instance))
        : CopyWith$Input$BulkUpdateGroupDescriptionsInput(
            local$sub_groups, (e) => call(sub_groups: e));
  }
}

class _CopyWithStubImpl$Input$BulkGroupUpdateInput<TRes>
    implements CopyWith$Input$BulkGroupUpdateInput<TRes> {
  _CopyWithStubImpl$Input$BulkGroupUpdateInput(this._res);

  TRes _res;

  call({
    String? clientMutationId,
    List<String>? ids,
    int? rating100,
    String? studio_id,
    String? director,
    Input$BulkUpdateStrings? urls,
    Input$BulkUpdateIds? tag_ids,
    Input$BulkUpdateGroupDescriptionsInput? containing_groups,
    Input$BulkUpdateGroupDescriptionsInput? sub_groups,
  }) =>
      _res;

  CopyWith$Input$BulkUpdateGroupDescriptionsInput<TRes> get containing_groups =>
      CopyWith$Input$BulkUpdateGroupDescriptionsInput.stub(_res);

  CopyWith$Input$BulkUpdateGroupDescriptionsInput<TRes> get sub_groups =>
      CopyWith$Input$BulkUpdateGroupDescriptionsInput.stub(_res);
}

class Input$GroupDestroyInput {
  factory Input$GroupDestroyInput({required String id}) =>
      Input$GroupDestroyInput._({
        r'id': id,
      });

  Input$GroupDestroyInput._(this._$data);

  factory Input$GroupDestroyInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Input$GroupDestroyInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Input$GroupDestroyInput<Input$GroupDestroyInput> get copyWith =>
      CopyWith$Input$GroupDestroyInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GroupDestroyInput) ||
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

abstract class CopyWith$Input$GroupDestroyInput<TRes> {
  factory CopyWith$Input$GroupDestroyInput(
    Input$GroupDestroyInput instance,
    TRes Function(Input$GroupDestroyInput) then,
  ) = _CopyWithImpl$Input$GroupDestroyInput;

  factory CopyWith$Input$GroupDestroyInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GroupDestroyInput;

  TRes call({String? id});
}

class _CopyWithImpl$Input$GroupDestroyInput<TRes>
    implements CopyWith$Input$GroupDestroyInput<TRes> {
  _CopyWithImpl$Input$GroupDestroyInput(
    this._instance,
    this._then,
  );

  final Input$GroupDestroyInput _instance;

  final TRes Function(Input$GroupDestroyInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(Input$GroupDestroyInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
      }));
}

class _CopyWithStubImpl$Input$GroupDestroyInput<TRes>
    implements CopyWith$Input$GroupDestroyInput<TRes> {
  _CopyWithStubImpl$Input$GroupDestroyInput(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Input$ReorderSubGroupsInput {
  factory Input$ReorderSubGroupsInput({
    required String group_id,
    required List<String> sub_group_ids,
    required String insert_at_id,
    bool? insert_after,
  }) =>
      Input$ReorderSubGroupsInput._({
        r'group_id': group_id,
        r'sub_group_ids': sub_group_ids,
        r'insert_at_id': insert_at_id,
        if (insert_after != null) r'insert_after': insert_after,
      });

  Input$ReorderSubGroupsInput._(this._$data);

  factory Input$ReorderSubGroupsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$group_id = data['group_id'];
    result$data['group_id'] = (l$group_id as String);
    final l$sub_group_ids = data['sub_group_ids'];
    result$data['sub_group_ids'] =
        (l$sub_group_ids as List<dynamic>).map((e) => (e as String)).toList();
    final l$insert_at_id = data['insert_at_id'];
    result$data['insert_at_id'] = (l$insert_at_id as String);
    if (data.containsKey('insert_after')) {
      final l$insert_after = data['insert_after'];
      result$data['insert_after'] = (l$insert_after as bool?);
    }
    return Input$ReorderSubGroupsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get group_id => (_$data['group_id'] as String);

  List<String> get sub_group_ids => (_$data['sub_group_ids'] as List<String>);

  String get insert_at_id => (_$data['insert_at_id'] as String);

  bool? get insert_after => (_$data['insert_after'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$group_id = group_id;
    result$data['group_id'] = l$group_id;
    final l$sub_group_ids = sub_group_ids;
    result$data['sub_group_ids'] = l$sub_group_ids.map((e) => e).toList();
    final l$insert_at_id = insert_at_id;
    result$data['insert_at_id'] = l$insert_at_id;
    if (_$data.containsKey('insert_after')) {
      final l$insert_after = insert_after;
      result$data['insert_after'] = l$insert_after;
    }
    return result$data;
  }

  CopyWith$Input$ReorderSubGroupsInput<Input$ReorderSubGroupsInput>
      get copyWith => CopyWith$Input$ReorderSubGroupsInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ReorderSubGroupsInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$group_id = group_id;
    final lOther$group_id = other.group_id;
    if (l$group_id != lOther$group_id) {
      return false;
    }
    final l$sub_group_ids = sub_group_ids;
    final lOther$sub_group_ids = other.sub_group_ids;
    if (l$sub_group_ids.length != lOther$sub_group_ids.length) {
      return false;
    }
    for (int i = 0; i < l$sub_group_ids.length; i++) {
      final l$sub_group_ids$entry = l$sub_group_ids[i];
      final lOther$sub_group_ids$entry = lOther$sub_group_ids[i];
      if (l$sub_group_ids$entry != lOther$sub_group_ids$entry) {
        return false;
      }
    }
    final l$insert_at_id = insert_at_id;
    final lOther$insert_at_id = other.insert_at_id;
    if (l$insert_at_id != lOther$insert_at_id) {
      return false;
    }
    final l$insert_after = insert_after;
    final lOther$insert_after = other.insert_after;
    if (_$data.containsKey('insert_after') !=
        other._$data.containsKey('insert_after')) {
      return false;
    }
    if (l$insert_after != lOther$insert_after) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$group_id = group_id;
    final l$sub_group_ids = sub_group_ids;
    final l$insert_at_id = insert_at_id;
    final l$insert_after = insert_after;
    return Object.hashAll([
      l$group_id,
      Object.hashAll(l$sub_group_ids.map((v) => v)),
      l$insert_at_id,
      _$data.containsKey('insert_after') ? l$insert_after : const {},
    ]);
  }
}

abstract class CopyWith$Input$ReorderSubGroupsInput<TRes> {
  factory CopyWith$Input$ReorderSubGroupsInput(
    Input$ReorderSubGroupsInput instance,
    TRes Function(Input$ReorderSubGroupsInput) then,
  ) = _CopyWithImpl$Input$ReorderSubGroupsInput;

  factory CopyWith$Input$ReorderSubGroupsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ReorderSubGroupsInput;

  TRes call({
    String? group_id,
    List<String>? sub_group_ids,
    String? insert_at_id,
    bool? insert_after,
  });
}

class _CopyWithImpl$Input$ReorderSubGroupsInput<TRes>
    implements CopyWith$Input$ReorderSubGroupsInput<TRes> {
  _CopyWithImpl$Input$ReorderSubGroupsInput(
    this._instance,
    this._then,
  );

  final Input$ReorderSubGroupsInput _instance;

  final TRes Function(Input$ReorderSubGroupsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? group_id = _undefined,
    Object? sub_group_ids = _undefined,
    Object? insert_at_id = _undefined,
    Object? insert_after = _undefined,
  }) =>
      _then(Input$ReorderSubGroupsInput._({
        ..._instance._$data,
        if (group_id != _undefined && group_id != null)
          'group_id': (group_id as String),
        if (sub_group_ids != _undefined && sub_group_ids != null)
          'sub_group_ids': (sub_group_ids as List<String>),
        if (insert_at_id != _undefined && insert_at_id != null)
          'insert_at_id': (insert_at_id as String),
        if (insert_after != _undefined) 'insert_after': (insert_after as bool?),
      }));
}

class _CopyWithStubImpl$Input$ReorderSubGroupsInput<TRes>
    implements CopyWith$Input$ReorderSubGroupsInput<TRes> {
  _CopyWithStubImpl$Input$ReorderSubGroupsInput(this._res);

  TRes _res;

  call({
    String? group_id,
    List<String>? sub_group_ids,
    String? insert_at_id,
    bool? insert_after,
  }) =>
      _res;
}

class Input$GroupSubGroupAddInput {
  factory Input$GroupSubGroupAddInput({
    required String containing_group_id,
    required List<Input$GroupDescriptionInput> sub_groups,
    int? insert_index,
  }) =>
      Input$GroupSubGroupAddInput._({
        r'containing_group_id': containing_group_id,
        r'sub_groups': sub_groups,
        if (insert_index != null) r'insert_index': insert_index,
      });

  Input$GroupSubGroupAddInput._(this._$data);

  factory Input$GroupSubGroupAddInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$containing_group_id = data['containing_group_id'];
    result$data['containing_group_id'] = (l$containing_group_id as String);
    final l$sub_groups = data['sub_groups'];
    result$data['sub_groups'] = (l$sub_groups as List<dynamic>)
        .map((e) =>
            Input$GroupDescriptionInput.fromJson((e as Map<String, dynamic>)))
        .toList();
    if (data.containsKey('insert_index')) {
      final l$insert_index = data['insert_index'];
      result$data['insert_index'] = (l$insert_index as int?);
    }
    return Input$GroupSubGroupAddInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get containing_group_id => (_$data['containing_group_id'] as String);

  List<Input$GroupDescriptionInput> get sub_groups =>
      (_$data['sub_groups'] as List<Input$GroupDescriptionInput>);

  int? get insert_index => (_$data['insert_index'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$containing_group_id = containing_group_id;
    result$data['containing_group_id'] = l$containing_group_id;
    final l$sub_groups = sub_groups;
    result$data['sub_groups'] = l$sub_groups.map((e) => e.toJson()).toList();
    if (_$data.containsKey('insert_index')) {
      final l$insert_index = insert_index;
      result$data['insert_index'] = l$insert_index;
    }
    return result$data;
  }

  CopyWith$Input$GroupSubGroupAddInput<Input$GroupSubGroupAddInput>
      get copyWith => CopyWith$Input$GroupSubGroupAddInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GroupSubGroupAddInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$containing_group_id = containing_group_id;
    final lOther$containing_group_id = other.containing_group_id;
    if (l$containing_group_id != lOther$containing_group_id) {
      return false;
    }
    final l$sub_groups = sub_groups;
    final lOther$sub_groups = other.sub_groups;
    if (l$sub_groups.length != lOther$sub_groups.length) {
      return false;
    }
    for (int i = 0; i < l$sub_groups.length; i++) {
      final l$sub_groups$entry = l$sub_groups[i];
      final lOther$sub_groups$entry = lOther$sub_groups[i];
      if (l$sub_groups$entry != lOther$sub_groups$entry) {
        return false;
      }
    }
    final l$insert_index = insert_index;
    final lOther$insert_index = other.insert_index;
    if (_$data.containsKey('insert_index') !=
        other._$data.containsKey('insert_index')) {
      return false;
    }
    if (l$insert_index != lOther$insert_index) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$containing_group_id = containing_group_id;
    final l$sub_groups = sub_groups;
    final l$insert_index = insert_index;
    return Object.hashAll([
      l$containing_group_id,
      Object.hashAll(l$sub_groups.map((v) => v)),
      _$data.containsKey('insert_index') ? l$insert_index : const {},
    ]);
  }
}

abstract class CopyWith$Input$GroupSubGroupAddInput<TRes> {
  factory CopyWith$Input$GroupSubGroupAddInput(
    Input$GroupSubGroupAddInput instance,
    TRes Function(Input$GroupSubGroupAddInput) then,
  ) = _CopyWithImpl$Input$GroupSubGroupAddInput;

  factory CopyWith$Input$GroupSubGroupAddInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GroupSubGroupAddInput;

  TRes call({
    String? containing_group_id,
    List<Input$GroupDescriptionInput>? sub_groups,
    int? insert_index,
  });
  TRes sub_groups(
      Iterable<Input$GroupDescriptionInput> Function(
              Iterable<
                  CopyWith$Input$GroupDescriptionInput<
                      Input$GroupDescriptionInput>>)
          _fn);
}

class _CopyWithImpl$Input$GroupSubGroupAddInput<TRes>
    implements CopyWith$Input$GroupSubGroupAddInput<TRes> {
  _CopyWithImpl$Input$GroupSubGroupAddInput(
    this._instance,
    this._then,
  );

  final Input$GroupSubGroupAddInput _instance;

  final TRes Function(Input$GroupSubGroupAddInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? containing_group_id = _undefined,
    Object? sub_groups = _undefined,
    Object? insert_index = _undefined,
  }) =>
      _then(Input$GroupSubGroupAddInput._({
        ..._instance._$data,
        if (containing_group_id != _undefined && containing_group_id != null)
          'containing_group_id': (containing_group_id as String),
        if (sub_groups != _undefined && sub_groups != null)
          'sub_groups': (sub_groups as List<Input$GroupDescriptionInput>),
        if (insert_index != _undefined) 'insert_index': (insert_index as int?),
      }));

  TRes sub_groups(
          Iterable<Input$GroupDescriptionInput> Function(
                  Iterable<
                      CopyWith$Input$GroupDescriptionInput<
                          Input$GroupDescriptionInput>>)
              _fn) =>
      call(
          sub_groups: _fn(_instance.sub_groups
              .map((e) => CopyWith$Input$GroupDescriptionInput(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Input$GroupSubGroupAddInput<TRes>
    implements CopyWith$Input$GroupSubGroupAddInput<TRes> {
  _CopyWithStubImpl$Input$GroupSubGroupAddInput(this._res);

  TRes _res;

  call({
    String? containing_group_id,
    List<Input$GroupDescriptionInput>? sub_groups,
    int? insert_index,
  }) =>
      _res;

  sub_groups(_fn) => _res;
}

class Input$GroupSubGroupRemoveInput {
  factory Input$GroupSubGroupRemoveInput({
    required String containing_group_id,
    required List<String> sub_group_ids,
  }) =>
      Input$GroupSubGroupRemoveInput._({
        r'containing_group_id': containing_group_id,
        r'sub_group_ids': sub_group_ids,
      });

  Input$GroupSubGroupRemoveInput._(this._$data);

  factory Input$GroupSubGroupRemoveInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$containing_group_id = data['containing_group_id'];
    result$data['containing_group_id'] = (l$containing_group_id as String);
    final l$sub_group_ids = data['sub_group_ids'];
    result$data['sub_group_ids'] =
        (l$sub_group_ids as List<dynamic>).map((e) => (e as String)).toList();
    return Input$GroupSubGroupRemoveInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get containing_group_id => (_$data['containing_group_id'] as String);

  List<String> get sub_group_ids => (_$data['sub_group_ids'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$containing_group_id = containing_group_id;
    result$data['containing_group_id'] = l$containing_group_id;
    final l$sub_group_ids = sub_group_ids;
    result$data['sub_group_ids'] = l$sub_group_ids.map((e) => e).toList();
    return result$data;
  }

  CopyWith$Input$GroupSubGroupRemoveInput<Input$GroupSubGroupRemoveInput>
      get copyWith => CopyWith$Input$GroupSubGroupRemoveInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GroupSubGroupRemoveInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$containing_group_id = containing_group_id;
    final lOther$containing_group_id = other.containing_group_id;
    if (l$containing_group_id != lOther$containing_group_id) {
      return false;
    }
    final l$sub_group_ids = sub_group_ids;
    final lOther$sub_group_ids = other.sub_group_ids;
    if (l$sub_group_ids.length != lOther$sub_group_ids.length) {
      return false;
    }
    for (int i = 0; i < l$sub_group_ids.length; i++) {
      final l$sub_group_ids$entry = l$sub_group_ids[i];
      final lOther$sub_group_ids$entry = lOther$sub_group_ids[i];
      if (l$sub_group_ids$entry != lOther$sub_group_ids$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$containing_group_id = containing_group_id;
    final l$sub_group_ids = sub_group_ids;
    return Object.hashAll([
      l$containing_group_id,
      Object.hashAll(l$sub_group_ids.map((v) => v)),
    ]);
  }
}

abstract class CopyWith$Input$GroupSubGroupRemoveInput<TRes> {
  factory CopyWith$Input$GroupSubGroupRemoveInput(
    Input$GroupSubGroupRemoveInput instance,
    TRes Function(Input$GroupSubGroupRemoveInput) then,
  ) = _CopyWithImpl$Input$GroupSubGroupRemoveInput;

  factory CopyWith$Input$GroupSubGroupRemoveInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GroupSubGroupRemoveInput;

  TRes call({
    String? containing_group_id,
    List<String>? sub_group_ids,
  });
}

class _CopyWithImpl$Input$GroupSubGroupRemoveInput<TRes>
    implements CopyWith$Input$GroupSubGroupRemoveInput<TRes> {
  _CopyWithImpl$Input$GroupSubGroupRemoveInput(
    this._instance,
    this._then,
  );

  final Input$GroupSubGroupRemoveInput _instance;

  final TRes Function(Input$GroupSubGroupRemoveInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? containing_group_id = _undefined,
    Object? sub_group_ids = _undefined,
  }) =>
      _then(Input$GroupSubGroupRemoveInput._({
        ..._instance._$data,
        if (containing_group_id != _undefined && containing_group_id != null)
          'containing_group_id': (containing_group_id as String),
        if (sub_group_ids != _undefined && sub_group_ids != null)
          'sub_group_ids': (sub_group_ids as List<String>),
      }));
}

class _CopyWithStubImpl$Input$GroupSubGroupRemoveInput<TRes>
    implements CopyWith$Input$GroupSubGroupRemoveInput<TRes> {
  _CopyWithStubImpl$Input$GroupSubGroupRemoveInput(this._res);

  TRes _res;

  call({
    String? containing_group_id,
    List<String>? sub_group_ids,
  }) =>
      _res;
}
