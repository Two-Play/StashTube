class Input$SceneMarkerCreateInput {
  factory Input$SceneMarkerCreateInput({
    required String title,
    required double seconds,
    required String scene_id,
    required String primary_tag_id,
    List<String>? tag_ids,
  }) =>
      Input$SceneMarkerCreateInput._({
        r'title': title,
        r'seconds': seconds,
        r'scene_id': scene_id,
        r'primary_tag_id': primary_tag_id,
        if (tag_ids != null) r'tag_ids': tag_ids,
      });

  Input$SceneMarkerCreateInput._(this._$data);

  factory Input$SceneMarkerCreateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$title = data['title'];
    result$data['title'] = (l$title as String);
    final l$seconds = data['seconds'];
    result$data['seconds'] = (l$seconds as num).toDouble();
    final l$scene_id = data['scene_id'];
    result$data['scene_id'] = (l$scene_id as String);
    final l$primary_tag_id = data['primary_tag_id'];
    result$data['primary_tag_id'] = (l$primary_tag_id as String);
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] =
          (l$tag_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    return Input$SceneMarkerCreateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get title => (_$data['title'] as String);

  double get seconds => (_$data['seconds'] as double);

  String get scene_id => (_$data['scene_id'] as String);

  String get primary_tag_id => (_$data['primary_tag_id'] as String);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$title = title;
    result$data['title'] = l$title;
    final l$seconds = seconds;
    result$data['seconds'] = l$seconds;
    final l$scene_id = scene_id;
    result$data['scene_id'] = l$scene_id;
    final l$primary_tag_id = primary_tag_id;
    result$data['primary_tag_id'] = l$primary_tag_id;
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Input$SceneMarkerCreateInput<Input$SceneMarkerCreateInput>
      get copyWith => CopyWith$Input$SceneMarkerCreateInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$SceneMarkerCreateInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$seconds = seconds;
    final lOther$seconds = other.seconds;
    if (l$seconds != lOther$seconds) {
      return false;
    }
    final l$scene_id = scene_id;
    final lOther$scene_id = other.scene_id;
    if (l$scene_id != lOther$scene_id) {
      return false;
    }
    final l$primary_tag_id = primary_tag_id;
    final lOther$primary_tag_id = other.primary_tag_id;
    if (l$primary_tag_id != lOther$primary_tag_id) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$title = title;
    final l$seconds = seconds;
    final l$scene_id = scene_id;
    final l$primary_tag_id = primary_tag_id;
    final l$tag_ids = tag_ids;
    return Object.hashAll([
      l$title,
      l$seconds,
      l$scene_id,
      l$primary_tag_id,
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
              ? null
              : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$SceneMarkerCreateInput<TRes> {
  factory CopyWith$Input$SceneMarkerCreateInput(
    Input$SceneMarkerCreateInput instance,
    TRes Function(Input$SceneMarkerCreateInput) then,
  ) = _CopyWithImpl$Input$SceneMarkerCreateInput;

  factory CopyWith$Input$SceneMarkerCreateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SceneMarkerCreateInput;

  TRes call({
    String? title,
    double? seconds,
    String? scene_id,
    String? primary_tag_id,
    List<String>? tag_ids,
  });
}

class _CopyWithImpl$Input$SceneMarkerCreateInput<TRes>
    implements CopyWith$Input$SceneMarkerCreateInput<TRes> {
  _CopyWithImpl$Input$SceneMarkerCreateInput(
    this._instance,
    this._then,
  );

  final Input$SceneMarkerCreateInput _instance;

  final TRes Function(Input$SceneMarkerCreateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? title = _undefined,
    Object? seconds = _undefined,
    Object? scene_id = _undefined,
    Object? primary_tag_id = _undefined,
    Object? tag_ids = _undefined,
  }) =>
      _then(Input$SceneMarkerCreateInput._({
        ..._instance._$data,
        if (title != _undefined && title != null) 'title': (title as String),
        if (seconds != _undefined && seconds != null)
          'seconds': (seconds as double),
        if (scene_id != _undefined && scene_id != null)
          'scene_id': (scene_id as String),
        if (primary_tag_id != _undefined && primary_tag_id != null)
          'primary_tag_id': (primary_tag_id as String),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
      }));
}

class _CopyWithStubImpl$Input$SceneMarkerCreateInput<TRes>
    implements CopyWith$Input$SceneMarkerCreateInput<TRes> {
  _CopyWithStubImpl$Input$SceneMarkerCreateInput(this._res);

  TRes _res;

  call({
    String? title,
    double? seconds,
    String? scene_id,
    String? primary_tag_id,
    List<String>? tag_ids,
  }) =>
      _res;
}

class Input$SceneMarkerUpdateInput {
  factory Input$SceneMarkerUpdateInput({
    required String id,
    String? title,
    double? seconds,
    String? scene_id,
    String? primary_tag_id,
    List<String>? tag_ids,
  }) =>
      Input$SceneMarkerUpdateInput._({
        r'id': id,
        if (title != null) r'title': title,
        if (seconds != null) r'seconds': seconds,
        if (scene_id != null) r'scene_id': scene_id,
        if (primary_tag_id != null) r'primary_tag_id': primary_tag_id,
        if (tag_ids != null) r'tag_ids': tag_ids,
      });

  Input$SceneMarkerUpdateInput._(this._$data);

  factory Input$SceneMarkerUpdateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('title')) {
      final l$title = data['title'];
      result$data['title'] = (l$title as String?);
    }
    if (data.containsKey('seconds')) {
      final l$seconds = data['seconds'];
      result$data['seconds'] = (l$seconds as num?)?.toDouble();
    }
    if (data.containsKey('scene_id')) {
      final l$scene_id = data['scene_id'];
      result$data['scene_id'] = (l$scene_id as String?);
    }
    if (data.containsKey('primary_tag_id')) {
      final l$primary_tag_id = data['primary_tag_id'];
      result$data['primary_tag_id'] = (l$primary_tag_id as String?);
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] =
          (l$tag_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    return Input$SceneMarkerUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  String? get title => (_$data['title'] as String?);

  double? get seconds => (_$data['seconds'] as double?);

  String? get scene_id => (_$data['scene_id'] as String?);

  String? get primary_tag_id => (_$data['primary_tag_id'] as String?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('title')) {
      final l$title = title;
      result$data['title'] = l$title;
    }
    if (_$data.containsKey('seconds')) {
      final l$seconds = seconds;
      result$data['seconds'] = l$seconds;
    }
    if (_$data.containsKey('scene_id')) {
      final l$scene_id = scene_id;
      result$data['scene_id'] = l$scene_id;
    }
    if (_$data.containsKey('primary_tag_id')) {
      final l$primary_tag_id = primary_tag_id;
      result$data['primary_tag_id'] = l$primary_tag_id;
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Input$SceneMarkerUpdateInput<Input$SceneMarkerUpdateInput>
      get copyWith => CopyWith$Input$SceneMarkerUpdateInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$SceneMarkerUpdateInput) ||
        runtimeType != other.runtimeType) {
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
    final l$seconds = seconds;
    final lOther$seconds = other.seconds;
    if (_$data.containsKey('seconds') != other._$data.containsKey('seconds')) {
      return false;
    }
    if (l$seconds != lOther$seconds) {
      return false;
    }
    final l$scene_id = scene_id;
    final lOther$scene_id = other.scene_id;
    if (_$data.containsKey('scene_id') !=
        other._$data.containsKey('scene_id')) {
      return false;
    }
    if (l$scene_id != lOther$scene_id) {
      return false;
    }
    final l$primary_tag_id = primary_tag_id;
    final lOther$primary_tag_id = other.primary_tag_id;
    if (_$data.containsKey('primary_tag_id') !=
        other._$data.containsKey('primary_tag_id')) {
      return false;
    }
    if (l$primary_tag_id != lOther$primary_tag_id) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$seconds = seconds;
    final l$scene_id = scene_id;
    final l$primary_tag_id = primary_tag_id;
    final l$tag_ids = tag_ids;
    return Object.hashAll([
      l$id,
      _$data.containsKey('title') ? l$title : const {},
      _$data.containsKey('seconds') ? l$seconds : const {},
      _$data.containsKey('scene_id') ? l$scene_id : const {},
      _$data.containsKey('primary_tag_id') ? l$primary_tag_id : const {},
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
              ? null
              : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$SceneMarkerUpdateInput<TRes> {
  factory CopyWith$Input$SceneMarkerUpdateInput(
    Input$SceneMarkerUpdateInput instance,
    TRes Function(Input$SceneMarkerUpdateInput) then,
  ) = _CopyWithImpl$Input$SceneMarkerUpdateInput;

  factory CopyWith$Input$SceneMarkerUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SceneMarkerUpdateInput;

  TRes call({
    String? id,
    String? title,
    double? seconds,
    String? scene_id,
    String? primary_tag_id,
    List<String>? tag_ids,
  });
}

class _CopyWithImpl$Input$SceneMarkerUpdateInput<TRes>
    implements CopyWith$Input$SceneMarkerUpdateInput<TRes> {
  _CopyWithImpl$Input$SceneMarkerUpdateInput(
    this._instance,
    this._then,
  );

  final Input$SceneMarkerUpdateInput _instance;

  final TRes Function(Input$SceneMarkerUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? seconds = _undefined,
    Object? scene_id = _undefined,
    Object? primary_tag_id = _undefined,
    Object? tag_ids = _undefined,
  }) =>
      _then(Input$SceneMarkerUpdateInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (title != _undefined) 'title': (title as String?),
        if (seconds != _undefined) 'seconds': (seconds as double?),
        if (scene_id != _undefined) 'scene_id': (scene_id as String?),
        if (primary_tag_id != _undefined)
          'primary_tag_id': (primary_tag_id as String?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
      }));
}

class _CopyWithStubImpl$Input$SceneMarkerUpdateInput<TRes>
    implements CopyWith$Input$SceneMarkerUpdateInput<TRes> {
  _CopyWithStubImpl$Input$SceneMarkerUpdateInput(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    double? seconds,
    String? scene_id,
    String? primary_tag_id,
    List<String>? tag_ids,
  }) =>
      _res;
}
