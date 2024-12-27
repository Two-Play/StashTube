import 'stash-box.graphql.dart';

class Input$StudioCreateInput {
  factory Input$StudioCreateInput({
    required String name,
    String? url,
    String? parent_id,
    String? image,
    List<Input$StashIDInput>? stash_ids,
    int? rating100,
    bool? favorite,
    String? details,
    List<String>? aliases,
    List<String>? tag_ids,
    bool? ignore_auto_tag,
  }) =>
      Input$StudioCreateInput._({
        r'name': name,
        if (url != null) r'url': url,
        if (parent_id != null) r'parent_id': parent_id,
        if (image != null) r'image': image,
        if (stash_ids != null) r'stash_ids': stash_ids,
        if (rating100 != null) r'rating100': rating100,
        if (favorite != null) r'favorite': favorite,
        if (details != null) r'details': details,
        if (aliases != null) r'aliases': aliases,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (ignore_auto_tag != null) r'ignore_auto_tag': ignore_auto_tag,
      });

  Input$StudioCreateInput._(this._$data);

  factory Input$StudioCreateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    if (data.containsKey('url')) {
      final l$url = data['url'];
      result$data['url'] = (l$url as String?);
    }
    if (data.containsKey('parent_id')) {
      final l$parent_id = data['parent_id'];
      result$data['parent_id'] = (l$parent_id as String?);
    }
    if (data.containsKey('image')) {
      final l$image = data['image'];
      result$data['image'] = (l$image as String?);
    }
    if (data.containsKey('stash_ids')) {
      final l$stash_ids = data['stash_ids'];
      result$data['stash_ids'] = (l$stash_ids as List<dynamic>?)
          ?.map((e) => Input$StashIDInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    if (data.containsKey('favorite')) {
      final l$favorite = data['favorite'];
      result$data['favorite'] = (l$favorite as bool?);
    }
    if (data.containsKey('details')) {
      final l$details = data['details'];
      result$data['details'] = (l$details as String?);
    }
    if (data.containsKey('aliases')) {
      final l$aliases = data['aliases'];
      result$data['aliases'] =
          (l$aliases as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] =
          (l$tag_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = data['ignore_auto_tag'];
      result$data['ignore_auto_tag'] = (l$ignore_auto_tag as bool?);
    }
    return Input$StudioCreateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get name => (_$data['name'] as String);

  String? get url => (_$data['url'] as String?);

  String? get parent_id => (_$data['parent_id'] as String?);

  String? get image => (_$data['image'] as String?);

  List<Input$StashIDInput>? get stash_ids =>
      (_$data['stash_ids'] as List<Input$StashIDInput>?);

  int? get rating100 => (_$data['rating100'] as int?);

  bool? get favorite => (_$data['favorite'] as bool?);

  String? get details => (_$data['details'] as String?);

  List<String>? get aliases => (_$data['aliases'] as List<String>?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  bool? get ignore_auto_tag => (_$data['ignore_auto_tag'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$name = name;
    result$data['name'] = l$name;
    if (_$data.containsKey('url')) {
      final l$url = url;
      result$data['url'] = l$url;
    }
    if (_$data.containsKey('parent_id')) {
      final l$parent_id = parent_id;
      result$data['parent_id'] = l$parent_id;
    }
    if (_$data.containsKey('image')) {
      final l$image = image;
      result$data['image'] = l$image;
    }
    if (_$data.containsKey('stash_ids')) {
      final l$stash_ids = stash_ids;
      result$data['stash_ids'] = l$stash_ids?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    if (_$data.containsKey('favorite')) {
      final l$favorite = favorite;
      result$data['favorite'] = l$favorite;
    }
    if (_$data.containsKey('details')) {
      final l$details = details;
      result$data['details'] = l$details;
    }
    if (_$data.containsKey('aliases')) {
      final l$aliases = aliases;
      result$data['aliases'] = l$aliases?.map((e) => e).toList();
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = ignore_auto_tag;
      result$data['ignore_auto_tag'] = l$ignore_auto_tag;
    }
    return result$data;
  }

  CopyWith$Input$StudioCreateInput<Input$StudioCreateInput> get copyWith =>
      CopyWith$Input$StudioCreateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$StudioCreateInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
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
    final l$parent_id = parent_id;
    final lOther$parent_id = other.parent_id;
    if (_$data.containsKey('parent_id') !=
        other._$data.containsKey('parent_id')) {
      return false;
    }
    if (l$parent_id != lOther$parent_id) {
      return false;
    }
    final l$image = image;
    final lOther$image = other.image;
    if (_$data.containsKey('image') != other._$data.containsKey('image')) {
      return false;
    }
    if (l$image != lOther$image) {
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
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (_$data.containsKey('rating100') !=
        other._$data.containsKey('rating100')) {
      return false;
    }
    if (l$rating100 != lOther$rating100) {
      return false;
    }
    final l$favorite = favorite;
    final lOther$favorite = other.favorite;
    if (_$data.containsKey('favorite') !=
        other._$data.containsKey('favorite')) {
      return false;
    }
    if (l$favorite != lOther$favorite) {
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
    final l$aliases = aliases;
    final lOther$aliases = other.aliases;
    if (_$data.containsKey('aliases') != other._$data.containsKey('aliases')) {
      return false;
    }
    if (l$aliases != null && lOther$aliases != null) {
      if (l$aliases.length != lOther$aliases.length) {
        return false;
      }
      for (int i = 0; i < l$aliases.length; i++) {
        final l$aliases$entry = l$aliases[i];
        final lOther$aliases$entry = lOther$aliases[i];
        if (l$aliases$entry != lOther$aliases$entry) {
          return false;
        }
      }
    } else if (l$aliases != lOther$aliases) {
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
    final l$ignore_auto_tag = ignore_auto_tag;
    final lOther$ignore_auto_tag = other.ignore_auto_tag;
    if (_$data.containsKey('ignore_auto_tag') !=
        other._$data.containsKey('ignore_auto_tag')) {
      return false;
    }
    if (l$ignore_auto_tag != lOther$ignore_auto_tag) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$url = url;
    final l$parent_id = parent_id;
    final l$image = image;
    final l$stash_ids = stash_ids;
    final l$rating100 = rating100;
    final l$favorite = favorite;
    final l$details = details;
    final l$aliases = aliases;
    final l$tag_ids = tag_ids;
    final l$ignore_auto_tag = ignore_auto_tag;
    return Object.hashAll([
      l$name,
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('parent_id') ? l$parent_id : const {},
      _$data.containsKey('image') ? l$image : const {},
      _$data.containsKey('stash_ids')
          ? l$stash_ids == null
              ? null
              : Object.hashAll(l$stash_ids.map((v) => v))
          : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('favorite') ? l$favorite : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('aliases')
          ? l$aliases == null
              ? null
              : Object.hashAll(l$aliases.map((v) => v))
          : const {},
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
              ? null
              : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
      _$data.containsKey('ignore_auto_tag') ? l$ignore_auto_tag : const {},
    ]);
  }
}

abstract class CopyWith$Input$StudioCreateInput<TRes> {
  factory CopyWith$Input$StudioCreateInput(
    Input$StudioCreateInput instance,
    TRes Function(Input$StudioCreateInput) then,
  ) = _CopyWithImpl$Input$StudioCreateInput;

  factory CopyWith$Input$StudioCreateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StudioCreateInput;

  TRes call({
    String? name,
    String? url,
    String? parent_id,
    String? image,
    List<Input$StashIDInput>? stash_ids,
    int? rating100,
    bool? favorite,
    String? details,
    List<String>? aliases,
    List<String>? tag_ids,
    bool? ignore_auto_tag,
  });
}

class _CopyWithImpl$Input$StudioCreateInput<TRes>
    implements CopyWith$Input$StudioCreateInput<TRes> {
  _CopyWithImpl$Input$StudioCreateInput(
    this._instance,
    this._then,
  );

  final Input$StudioCreateInput _instance;

  final TRes Function(Input$StudioCreateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? url = _undefined,
    Object? parent_id = _undefined,
    Object? image = _undefined,
    Object? stash_ids = _undefined,
    Object? rating100 = _undefined,
    Object? favorite = _undefined,
    Object? details = _undefined,
    Object? aliases = _undefined,
    Object? tag_ids = _undefined,
    Object? ignore_auto_tag = _undefined,
  }) =>
      _then(Input$StudioCreateInput._({
        ..._instance._$data,
        if (name != _undefined && name != null) 'name': (name as String),
        if (url != _undefined) 'url': (url as String?),
        if (parent_id != _undefined) 'parent_id': (parent_id as String?),
        if (image != _undefined) 'image': (image as String?),
        if (stash_ids != _undefined)
          'stash_ids': (stash_ids as List<Input$StashIDInput>?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (favorite != _undefined) 'favorite': (favorite as bool?),
        if (details != _undefined) 'details': (details as String?),
        if (aliases != _undefined) 'aliases': (aliases as List<String>?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
        if (ignore_auto_tag != _undefined)
          'ignore_auto_tag': (ignore_auto_tag as bool?),
      }));
}

class _CopyWithStubImpl$Input$StudioCreateInput<TRes>
    implements CopyWith$Input$StudioCreateInput<TRes> {
  _CopyWithStubImpl$Input$StudioCreateInput(this._res);

  TRes _res;

  call({
    String? name,
    String? url,
    String? parent_id,
    String? image,
    List<Input$StashIDInput>? stash_ids,
    int? rating100,
    bool? favorite,
    String? details,
    List<String>? aliases,
    List<String>? tag_ids,
    bool? ignore_auto_tag,
  }) =>
      _res;
}

class Input$StudioUpdateInput {
  factory Input$StudioUpdateInput({
    required String id,
    String? name,
    String? url,
    String? parent_id,
    String? image,
    List<Input$StashIDInput>? stash_ids,
    int? rating100,
    bool? favorite,
    String? details,
    List<String>? aliases,
    List<String>? tag_ids,
    bool? ignore_auto_tag,
  }) =>
      Input$StudioUpdateInput._({
        r'id': id,
        if (name != null) r'name': name,
        if (url != null) r'url': url,
        if (parent_id != null) r'parent_id': parent_id,
        if (image != null) r'image': image,
        if (stash_ids != null) r'stash_ids': stash_ids,
        if (rating100 != null) r'rating100': rating100,
        if (favorite != null) r'favorite': favorite,
        if (details != null) r'details': details,
        if (aliases != null) r'aliases': aliases,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (ignore_auto_tag != null) r'ignore_auto_tag': ignore_auto_tag,
      });

  Input$StudioUpdateInput._(this._$data);

  factory Input$StudioUpdateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('name')) {
      final l$name = data['name'];
      result$data['name'] = (l$name as String?);
    }
    if (data.containsKey('url')) {
      final l$url = data['url'];
      result$data['url'] = (l$url as String?);
    }
    if (data.containsKey('parent_id')) {
      final l$parent_id = data['parent_id'];
      result$data['parent_id'] = (l$parent_id as String?);
    }
    if (data.containsKey('image')) {
      final l$image = data['image'];
      result$data['image'] = (l$image as String?);
    }
    if (data.containsKey('stash_ids')) {
      final l$stash_ids = data['stash_ids'];
      result$data['stash_ids'] = (l$stash_ids as List<dynamic>?)
          ?.map((e) => Input$StashIDInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    if (data.containsKey('favorite')) {
      final l$favorite = data['favorite'];
      result$data['favorite'] = (l$favorite as bool?);
    }
    if (data.containsKey('details')) {
      final l$details = data['details'];
      result$data['details'] = (l$details as String?);
    }
    if (data.containsKey('aliases')) {
      final l$aliases = data['aliases'];
      result$data['aliases'] =
          (l$aliases as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] =
          (l$tag_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = data['ignore_auto_tag'];
      result$data['ignore_auto_tag'] = (l$ignore_auto_tag as bool?);
    }
    return Input$StudioUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  String? get name => (_$data['name'] as String?);

  String? get url => (_$data['url'] as String?);

  String? get parent_id => (_$data['parent_id'] as String?);

  String? get image => (_$data['image'] as String?);

  List<Input$StashIDInput>? get stash_ids =>
      (_$data['stash_ids'] as List<Input$StashIDInput>?);

  int? get rating100 => (_$data['rating100'] as int?);

  bool? get favorite => (_$data['favorite'] as bool?);

  String? get details => (_$data['details'] as String?);

  List<String>? get aliases => (_$data['aliases'] as List<String>?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  bool? get ignore_auto_tag => (_$data['ignore_auto_tag'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('name')) {
      final l$name = name;
      result$data['name'] = l$name;
    }
    if (_$data.containsKey('url')) {
      final l$url = url;
      result$data['url'] = l$url;
    }
    if (_$data.containsKey('parent_id')) {
      final l$parent_id = parent_id;
      result$data['parent_id'] = l$parent_id;
    }
    if (_$data.containsKey('image')) {
      final l$image = image;
      result$data['image'] = l$image;
    }
    if (_$data.containsKey('stash_ids')) {
      final l$stash_ids = stash_ids;
      result$data['stash_ids'] = l$stash_ids?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    if (_$data.containsKey('favorite')) {
      final l$favorite = favorite;
      result$data['favorite'] = l$favorite;
    }
    if (_$data.containsKey('details')) {
      final l$details = details;
      result$data['details'] = l$details;
    }
    if (_$data.containsKey('aliases')) {
      final l$aliases = aliases;
      result$data['aliases'] = l$aliases?.map((e) => e).toList();
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = ignore_auto_tag;
      result$data['ignore_auto_tag'] = l$ignore_auto_tag;
    }
    return result$data;
  }

  CopyWith$Input$StudioUpdateInput<Input$StudioUpdateInput> get copyWith =>
      CopyWith$Input$StudioUpdateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$StudioUpdateInput) ||
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
    final l$url = url;
    final lOther$url = other.url;
    if (_$data.containsKey('url') != other._$data.containsKey('url')) {
      return false;
    }
    if (l$url != lOther$url) {
      return false;
    }
    final l$parent_id = parent_id;
    final lOther$parent_id = other.parent_id;
    if (_$data.containsKey('parent_id') !=
        other._$data.containsKey('parent_id')) {
      return false;
    }
    if (l$parent_id != lOther$parent_id) {
      return false;
    }
    final l$image = image;
    final lOther$image = other.image;
    if (_$data.containsKey('image') != other._$data.containsKey('image')) {
      return false;
    }
    if (l$image != lOther$image) {
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
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (_$data.containsKey('rating100') !=
        other._$data.containsKey('rating100')) {
      return false;
    }
    if (l$rating100 != lOther$rating100) {
      return false;
    }
    final l$favorite = favorite;
    final lOther$favorite = other.favorite;
    if (_$data.containsKey('favorite') !=
        other._$data.containsKey('favorite')) {
      return false;
    }
    if (l$favorite != lOther$favorite) {
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
    final l$aliases = aliases;
    final lOther$aliases = other.aliases;
    if (_$data.containsKey('aliases') != other._$data.containsKey('aliases')) {
      return false;
    }
    if (l$aliases != null && lOther$aliases != null) {
      if (l$aliases.length != lOther$aliases.length) {
        return false;
      }
      for (int i = 0; i < l$aliases.length; i++) {
        final l$aliases$entry = l$aliases[i];
        final lOther$aliases$entry = lOther$aliases[i];
        if (l$aliases$entry != lOther$aliases$entry) {
          return false;
        }
      }
    } else if (l$aliases != lOther$aliases) {
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
    final l$ignore_auto_tag = ignore_auto_tag;
    final lOther$ignore_auto_tag = other.ignore_auto_tag;
    if (_$data.containsKey('ignore_auto_tag') !=
        other._$data.containsKey('ignore_auto_tag')) {
      return false;
    }
    if (l$ignore_auto_tag != lOther$ignore_auto_tag) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$url = url;
    final l$parent_id = parent_id;
    final l$image = image;
    final l$stash_ids = stash_ids;
    final l$rating100 = rating100;
    final l$favorite = favorite;
    final l$details = details;
    final l$aliases = aliases;
    final l$tag_ids = tag_ids;
    final l$ignore_auto_tag = ignore_auto_tag;
    return Object.hashAll([
      l$id,
      _$data.containsKey('name') ? l$name : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('parent_id') ? l$parent_id : const {},
      _$data.containsKey('image') ? l$image : const {},
      _$data.containsKey('stash_ids')
          ? l$stash_ids == null
              ? null
              : Object.hashAll(l$stash_ids.map((v) => v))
          : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('favorite') ? l$favorite : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('aliases')
          ? l$aliases == null
              ? null
              : Object.hashAll(l$aliases.map((v) => v))
          : const {},
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
              ? null
              : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
      _$data.containsKey('ignore_auto_tag') ? l$ignore_auto_tag : const {},
    ]);
  }
}

abstract class CopyWith$Input$StudioUpdateInput<TRes> {
  factory CopyWith$Input$StudioUpdateInput(
    Input$StudioUpdateInput instance,
    TRes Function(Input$StudioUpdateInput) then,
  ) = _CopyWithImpl$Input$StudioUpdateInput;

  factory CopyWith$Input$StudioUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StudioUpdateInput;

  TRes call({
    String? id,
    String? name,
    String? url,
    String? parent_id,
    String? image,
    List<Input$StashIDInput>? stash_ids,
    int? rating100,
    bool? favorite,
    String? details,
    List<String>? aliases,
    List<String>? tag_ids,
    bool? ignore_auto_tag,
  });
}

class _CopyWithImpl$Input$StudioUpdateInput<TRes>
    implements CopyWith$Input$StudioUpdateInput<TRes> {
  _CopyWithImpl$Input$StudioUpdateInput(
    this._instance,
    this._then,
  );

  final Input$StudioUpdateInput _instance;

  final TRes Function(Input$StudioUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? url = _undefined,
    Object? parent_id = _undefined,
    Object? image = _undefined,
    Object? stash_ids = _undefined,
    Object? rating100 = _undefined,
    Object? favorite = _undefined,
    Object? details = _undefined,
    Object? aliases = _undefined,
    Object? tag_ids = _undefined,
    Object? ignore_auto_tag = _undefined,
  }) =>
      _then(Input$StudioUpdateInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (name != _undefined) 'name': (name as String?),
        if (url != _undefined) 'url': (url as String?),
        if (parent_id != _undefined) 'parent_id': (parent_id as String?),
        if (image != _undefined) 'image': (image as String?),
        if (stash_ids != _undefined)
          'stash_ids': (stash_ids as List<Input$StashIDInput>?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (favorite != _undefined) 'favorite': (favorite as bool?),
        if (details != _undefined) 'details': (details as String?),
        if (aliases != _undefined) 'aliases': (aliases as List<String>?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
        if (ignore_auto_tag != _undefined)
          'ignore_auto_tag': (ignore_auto_tag as bool?),
      }));
}

class _CopyWithStubImpl$Input$StudioUpdateInput<TRes>
    implements CopyWith$Input$StudioUpdateInput<TRes> {
  _CopyWithStubImpl$Input$StudioUpdateInput(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? url,
    String? parent_id,
    String? image,
    List<Input$StashIDInput>? stash_ids,
    int? rating100,
    bool? favorite,
    String? details,
    List<String>? aliases,
    List<String>? tag_ids,
    bool? ignore_auto_tag,
  }) =>
      _res;
}

class Input$StudioDestroyInput {
  factory Input$StudioDestroyInput({required String id}) =>
      Input$StudioDestroyInput._({
        r'id': id,
      });

  Input$StudioDestroyInput._(this._$data);

  factory Input$StudioDestroyInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Input$StudioDestroyInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Input$StudioDestroyInput<Input$StudioDestroyInput> get copyWith =>
      CopyWith$Input$StudioDestroyInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$StudioDestroyInput) ||
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

abstract class CopyWith$Input$StudioDestroyInput<TRes> {
  factory CopyWith$Input$StudioDestroyInput(
    Input$StudioDestroyInput instance,
    TRes Function(Input$StudioDestroyInput) then,
  ) = _CopyWithImpl$Input$StudioDestroyInput;

  factory CopyWith$Input$StudioDestroyInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StudioDestroyInput;

  TRes call({String? id});
}

class _CopyWithImpl$Input$StudioDestroyInput<TRes>
    implements CopyWith$Input$StudioDestroyInput<TRes> {
  _CopyWithImpl$Input$StudioDestroyInput(
    this._instance,
    this._then,
  );

  final Input$StudioDestroyInput _instance;

  final TRes Function(Input$StudioDestroyInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(Input$StudioDestroyInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
      }));
}

class _CopyWithStubImpl$Input$StudioDestroyInput<TRes>
    implements CopyWith$Input$StudioDestroyInput<TRes> {
  _CopyWithStubImpl$Input$StudioDestroyInput(this._res);

  TRes _res;

  call({String? id}) => _res;
}
