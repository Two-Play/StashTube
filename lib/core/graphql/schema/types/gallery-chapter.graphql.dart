class Input$GalleryChapterCreateInput {
  factory Input$GalleryChapterCreateInput({
    required String gallery_id,
    required String title,
    required int image_index,
  }) =>
      Input$GalleryChapterCreateInput._({
        r'gallery_id': gallery_id,
        r'title': title,
        r'image_index': image_index,
      });

  Input$GalleryChapterCreateInput._(this._$data);

  factory Input$GalleryChapterCreateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$gallery_id = data['gallery_id'];
    result$data['gallery_id'] = (l$gallery_id as String);
    final l$title = data['title'];
    result$data['title'] = (l$title as String);
    final l$image_index = data['image_index'];
    result$data['image_index'] = (l$image_index as int);
    return Input$GalleryChapterCreateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get gallery_id => (_$data['gallery_id'] as String);

  String get title => (_$data['title'] as String);

  int get image_index => (_$data['image_index'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$gallery_id = gallery_id;
    result$data['gallery_id'] = l$gallery_id;
    final l$title = title;
    result$data['title'] = l$title;
    final l$image_index = image_index;
    result$data['image_index'] = l$image_index;
    return result$data;
  }

  CopyWith$Input$GalleryChapterCreateInput<Input$GalleryChapterCreateInput>
      get copyWith => CopyWith$Input$GalleryChapterCreateInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GalleryChapterCreateInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$gallery_id = gallery_id;
    final lOther$gallery_id = other.gallery_id;
    if (l$gallery_id != lOther$gallery_id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$image_index = image_index;
    final lOther$image_index = other.image_index;
    if (l$image_index != lOther$image_index) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$gallery_id = gallery_id;
    final l$title = title;
    final l$image_index = image_index;
    return Object.hashAll([
      l$gallery_id,
      l$title,
      l$image_index,
    ]);
  }
}

abstract class CopyWith$Input$GalleryChapterCreateInput<TRes> {
  factory CopyWith$Input$GalleryChapterCreateInput(
    Input$GalleryChapterCreateInput instance,
    TRes Function(Input$GalleryChapterCreateInput) then,
  ) = _CopyWithImpl$Input$GalleryChapterCreateInput;

  factory CopyWith$Input$GalleryChapterCreateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GalleryChapterCreateInput;

  TRes call({
    String? gallery_id,
    String? title,
    int? image_index,
  });
}

class _CopyWithImpl$Input$GalleryChapterCreateInput<TRes>
    implements CopyWith$Input$GalleryChapterCreateInput<TRes> {
  _CopyWithImpl$Input$GalleryChapterCreateInput(
    this._instance,
    this._then,
  );

  final Input$GalleryChapterCreateInput _instance;

  final TRes Function(Input$GalleryChapterCreateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? gallery_id = _undefined,
    Object? title = _undefined,
    Object? image_index = _undefined,
  }) =>
      _then(Input$GalleryChapterCreateInput._({
        ..._instance._$data,
        if (gallery_id != _undefined && gallery_id != null)
          'gallery_id': (gallery_id as String),
        if (title != _undefined && title != null) 'title': (title as String),
        if (image_index != _undefined && image_index != null)
          'image_index': (image_index as int),
      }));
}

class _CopyWithStubImpl$Input$GalleryChapterCreateInput<TRes>
    implements CopyWith$Input$GalleryChapterCreateInput<TRes> {
  _CopyWithStubImpl$Input$GalleryChapterCreateInput(this._res);

  TRes _res;

  call({
    String? gallery_id,
    String? title,
    int? image_index,
  }) =>
      _res;
}

class Input$GalleryChapterUpdateInput {
  factory Input$GalleryChapterUpdateInput({
    required String id,
    String? gallery_id,
    String? title,
    int? image_index,
  }) =>
      Input$GalleryChapterUpdateInput._({
        r'id': id,
        if (gallery_id != null) r'gallery_id': gallery_id,
        if (title != null) r'title': title,
        if (image_index != null) r'image_index': image_index,
      });

  Input$GalleryChapterUpdateInput._(this._$data);

  factory Input$GalleryChapterUpdateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('gallery_id')) {
      final l$gallery_id = data['gallery_id'];
      result$data['gallery_id'] = (l$gallery_id as String?);
    }
    if (data.containsKey('title')) {
      final l$title = data['title'];
      result$data['title'] = (l$title as String?);
    }
    if (data.containsKey('image_index')) {
      final l$image_index = data['image_index'];
      result$data['image_index'] = (l$image_index as int?);
    }
    return Input$GalleryChapterUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  String? get gallery_id => (_$data['gallery_id'] as String?);

  String? get title => (_$data['title'] as String?);

  int? get image_index => (_$data['image_index'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('gallery_id')) {
      final l$gallery_id = gallery_id;
      result$data['gallery_id'] = l$gallery_id;
    }
    if (_$data.containsKey('title')) {
      final l$title = title;
      result$data['title'] = l$title;
    }
    if (_$data.containsKey('image_index')) {
      final l$image_index = image_index;
      result$data['image_index'] = l$image_index;
    }
    return result$data;
  }

  CopyWith$Input$GalleryChapterUpdateInput<Input$GalleryChapterUpdateInput>
      get copyWith => CopyWith$Input$GalleryChapterUpdateInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GalleryChapterUpdateInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$gallery_id = gallery_id;
    final lOther$gallery_id = other.gallery_id;
    if (_$data.containsKey('gallery_id') !=
        other._$data.containsKey('gallery_id')) {
      return false;
    }
    if (l$gallery_id != lOther$gallery_id) {
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
    final l$image_index = image_index;
    final lOther$image_index = other.image_index;
    if (_$data.containsKey('image_index') !=
        other._$data.containsKey('image_index')) {
      return false;
    }
    if (l$image_index != lOther$image_index) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$gallery_id = gallery_id;
    final l$title = title;
    final l$image_index = image_index;
    return Object.hashAll([
      l$id,
      _$data.containsKey('gallery_id') ? l$gallery_id : const {},
      _$data.containsKey('title') ? l$title : const {},
      _$data.containsKey('image_index') ? l$image_index : const {},
    ]);
  }
}

abstract class CopyWith$Input$GalleryChapterUpdateInput<TRes> {
  factory CopyWith$Input$GalleryChapterUpdateInput(
    Input$GalleryChapterUpdateInput instance,
    TRes Function(Input$GalleryChapterUpdateInput) then,
  ) = _CopyWithImpl$Input$GalleryChapterUpdateInput;

  factory CopyWith$Input$GalleryChapterUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GalleryChapterUpdateInput;

  TRes call({
    String? id,
    String? gallery_id,
    String? title,
    int? image_index,
  });
}

class _CopyWithImpl$Input$GalleryChapterUpdateInput<TRes>
    implements CopyWith$Input$GalleryChapterUpdateInput<TRes> {
  _CopyWithImpl$Input$GalleryChapterUpdateInput(
    this._instance,
    this._then,
  );

  final Input$GalleryChapterUpdateInput _instance;

  final TRes Function(Input$GalleryChapterUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? gallery_id = _undefined,
    Object? title = _undefined,
    Object? image_index = _undefined,
  }) =>
      _then(Input$GalleryChapterUpdateInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (gallery_id != _undefined) 'gallery_id': (gallery_id as String?),
        if (title != _undefined) 'title': (title as String?),
        if (image_index != _undefined) 'image_index': (image_index as int?),
      }));
}

class _CopyWithStubImpl$Input$GalleryChapterUpdateInput<TRes>
    implements CopyWith$Input$GalleryChapterUpdateInput<TRes> {
  _CopyWithStubImpl$Input$GalleryChapterUpdateInput(this._res);

  TRes _res;

  call({
    String? id,
    String? gallery_id,
    String? title,
    int? image_index,
  }) =>
      _res;
}
