import 'performer.graphql.dart';
import 'scene.graphql.dart';

class Input$TagCreateInput {
  factory Input$TagCreateInput({
    required String name,
    String? description,
    List<String>? aliases,
    bool? ignore_auto_tag,
    bool? favorite,
    String? image,
    List<String>? parent_ids,
    List<String>? child_ids,
  }) =>
      Input$TagCreateInput._({
        r'name': name,
        if (description != null) r'description': description,
        if (aliases != null) r'aliases': aliases,
        if (ignore_auto_tag != null) r'ignore_auto_tag': ignore_auto_tag,
        if (favorite != null) r'favorite': favorite,
        if (image != null) r'image': image,
        if (parent_ids != null) r'parent_ids': parent_ids,
        if (child_ids != null) r'child_ids': child_ids,
      });

  Input$TagCreateInput._(this._$data);

  factory Input$TagCreateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    if (data.containsKey('description')) {
      final l$description = data['description'];
      result$data['description'] = (l$description as String?);
    }
    if (data.containsKey('aliases')) {
      final l$aliases = data['aliases'];
      result$data['aliases'] =
          (l$aliases as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = data['ignore_auto_tag'];
      result$data['ignore_auto_tag'] = (l$ignore_auto_tag as bool?);
    }
    if (data.containsKey('favorite')) {
      final l$favorite = data['favorite'];
      result$data['favorite'] = (l$favorite as bool?);
    }
    if (data.containsKey('image')) {
      final l$image = data['image'];
      result$data['image'] = (l$image as String?);
    }
    if (data.containsKey('parent_ids')) {
      final l$parent_ids = data['parent_ids'];
      result$data['parent_ids'] =
          (l$parent_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('child_ids')) {
      final l$child_ids = data['child_ids'];
      result$data['child_ids'] =
          (l$child_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    return Input$TagCreateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get name => (_$data['name'] as String);

  String? get description => (_$data['description'] as String?);

  List<String>? get aliases => (_$data['aliases'] as List<String>?);

  bool? get ignore_auto_tag => (_$data['ignore_auto_tag'] as bool?);

  bool? get favorite => (_$data['favorite'] as bool?);

  String? get image => (_$data['image'] as String?);

  List<String>? get parent_ids => (_$data['parent_ids'] as List<String>?);

  List<String>? get child_ids => (_$data['child_ids'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$name = name;
    result$data['name'] = l$name;
    if (_$data.containsKey('description')) {
      final l$description = description;
      result$data['description'] = l$description;
    }
    if (_$data.containsKey('aliases')) {
      final l$aliases = aliases;
      result$data['aliases'] = l$aliases?.map((e) => e).toList();
    }
    if (_$data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = ignore_auto_tag;
      result$data['ignore_auto_tag'] = l$ignore_auto_tag;
    }
    if (_$data.containsKey('favorite')) {
      final l$favorite = favorite;
      result$data['favorite'] = l$favorite;
    }
    if (_$data.containsKey('image')) {
      final l$image = image;
      result$data['image'] = l$image;
    }
    if (_$data.containsKey('parent_ids')) {
      final l$parent_ids = parent_ids;
      result$data['parent_ids'] = l$parent_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('child_ids')) {
      final l$child_ids = child_ids;
      result$data['child_ids'] = l$child_ids?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Input$TagCreateInput<Input$TagCreateInput> get copyWith =>
      CopyWith$Input$TagCreateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$TagCreateInput) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
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
    final l$ignore_auto_tag = ignore_auto_tag;
    final lOther$ignore_auto_tag = other.ignore_auto_tag;
    if (_$data.containsKey('ignore_auto_tag') !=
        other._$data.containsKey('ignore_auto_tag')) {
      return false;
    }
    if (l$ignore_auto_tag != lOther$ignore_auto_tag) {
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
    final l$image = image;
    final lOther$image = other.image;
    if (_$data.containsKey('image') != other._$data.containsKey('image')) {
      return false;
    }
    if (l$image != lOther$image) {
      return false;
    }
    final l$parent_ids = parent_ids;
    final lOther$parent_ids = other.parent_ids;
    if (_$data.containsKey('parent_ids') !=
        other._$data.containsKey('parent_ids')) {
      return false;
    }
    if (l$parent_ids != null && lOther$parent_ids != null) {
      if (l$parent_ids.length != lOther$parent_ids.length) {
        return false;
      }
      for (int i = 0; i < l$parent_ids.length; i++) {
        final l$parent_ids$entry = l$parent_ids[i];
        final lOther$parent_ids$entry = lOther$parent_ids[i];
        if (l$parent_ids$entry != lOther$parent_ids$entry) {
          return false;
        }
      }
    } else if (l$parent_ids != lOther$parent_ids) {
      return false;
    }
    final l$child_ids = child_ids;
    final lOther$child_ids = other.child_ids;
    if (_$data.containsKey('child_ids') !=
        other._$data.containsKey('child_ids')) {
      return false;
    }
    if (l$child_ids != null && lOther$child_ids != null) {
      if (l$child_ids.length != lOther$child_ids.length) {
        return false;
      }
      for (int i = 0; i < l$child_ids.length; i++) {
        final l$child_ids$entry = l$child_ids[i];
        final lOther$child_ids$entry = lOther$child_ids[i];
        if (l$child_ids$entry != lOther$child_ids$entry) {
          return false;
        }
      }
    } else if (l$child_ids != lOther$child_ids) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$description = description;
    final l$aliases = aliases;
    final l$ignore_auto_tag = ignore_auto_tag;
    final l$favorite = favorite;
    final l$image = image;
    final l$parent_ids = parent_ids;
    final l$child_ids = child_ids;
    return Object.hashAll([
      l$name,
      _$data.containsKey('description') ? l$description : const {},
      _$data.containsKey('aliases')
          ? l$aliases == null
              ? null
              : Object.hashAll(l$aliases.map((v) => v))
          : const {},
      _$data.containsKey('ignore_auto_tag') ? l$ignore_auto_tag : const {},
      _$data.containsKey('favorite') ? l$favorite : const {},
      _$data.containsKey('image') ? l$image : const {},
      _$data.containsKey('parent_ids')
          ? l$parent_ids == null
              ? null
              : Object.hashAll(l$parent_ids.map((v) => v))
          : const {},
      _$data.containsKey('child_ids')
          ? l$child_ids == null
              ? null
              : Object.hashAll(l$child_ids.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$TagCreateInput<TRes> {
  factory CopyWith$Input$TagCreateInput(
    Input$TagCreateInput instance,
    TRes Function(Input$TagCreateInput) then,
  ) = _CopyWithImpl$Input$TagCreateInput;

  factory CopyWith$Input$TagCreateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$TagCreateInput;

  TRes call({
    String? name,
    String? description,
    List<String>? aliases,
    bool? ignore_auto_tag,
    bool? favorite,
    String? image,
    List<String>? parent_ids,
    List<String>? child_ids,
  });
}

class _CopyWithImpl$Input$TagCreateInput<TRes>
    implements CopyWith$Input$TagCreateInput<TRes> {
  _CopyWithImpl$Input$TagCreateInput(
    this._instance,
    this._then,
  );

  final Input$TagCreateInput _instance;

  final TRes Function(Input$TagCreateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? description = _undefined,
    Object? aliases = _undefined,
    Object? ignore_auto_tag = _undefined,
    Object? favorite = _undefined,
    Object? image = _undefined,
    Object? parent_ids = _undefined,
    Object? child_ids = _undefined,
  }) =>
      _then(Input$TagCreateInput._({
        ..._instance._$data,
        if (name != _undefined && name != null) 'name': (name as String),
        if (description != _undefined) 'description': (description as String?),
        if (aliases != _undefined) 'aliases': (aliases as List<String>?),
        if (ignore_auto_tag != _undefined)
          'ignore_auto_tag': (ignore_auto_tag as bool?),
        if (favorite != _undefined) 'favorite': (favorite as bool?),
        if (image != _undefined) 'image': (image as String?),
        if (parent_ids != _undefined)
          'parent_ids': (parent_ids as List<String>?),
        if (child_ids != _undefined) 'child_ids': (child_ids as List<String>?),
      }));
}

class _CopyWithStubImpl$Input$TagCreateInput<TRes>
    implements CopyWith$Input$TagCreateInput<TRes> {
  _CopyWithStubImpl$Input$TagCreateInput(this._res);

  TRes _res;

  call({
    String? name,
    String? description,
    List<String>? aliases,
    bool? ignore_auto_tag,
    bool? favorite,
    String? image,
    List<String>? parent_ids,
    List<String>? child_ids,
  }) =>
      _res;
}

class Input$TagUpdateInput {
  factory Input$TagUpdateInput({
    required String id,
    String? name,
    String? description,
    List<String>? aliases,
    bool? ignore_auto_tag,
    bool? favorite,
    String? image,
    List<String>? parent_ids,
    List<String>? child_ids,
  }) =>
      Input$TagUpdateInput._({
        r'id': id,
        if (name != null) r'name': name,
        if (description != null) r'description': description,
        if (aliases != null) r'aliases': aliases,
        if (ignore_auto_tag != null) r'ignore_auto_tag': ignore_auto_tag,
        if (favorite != null) r'favorite': favorite,
        if (image != null) r'image': image,
        if (parent_ids != null) r'parent_ids': parent_ids,
        if (child_ids != null) r'child_ids': child_ids,
      });

  Input$TagUpdateInput._(this._$data);

  factory Input$TagUpdateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('name')) {
      final l$name = data['name'];
      result$data['name'] = (l$name as String?);
    }
    if (data.containsKey('description')) {
      final l$description = data['description'];
      result$data['description'] = (l$description as String?);
    }
    if (data.containsKey('aliases')) {
      final l$aliases = data['aliases'];
      result$data['aliases'] =
          (l$aliases as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = data['ignore_auto_tag'];
      result$data['ignore_auto_tag'] = (l$ignore_auto_tag as bool?);
    }
    if (data.containsKey('favorite')) {
      final l$favorite = data['favorite'];
      result$data['favorite'] = (l$favorite as bool?);
    }
    if (data.containsKey('image')) {
      final l$image = data['image'];
      result$data['image'] = (l$image as String?);
    }
    if (data.containsKey('parent_ids')) {
      final l$parent_ids = data['parent_ids'];
      result$data['parent_ids'] =
          (l$parent_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('child_ids')) {
      final l$child_ids = data['child_ids'];
      result$data['child_ids'] =
          (l$child_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    return Input$TagUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  String? get name => (_$data['name'] as String?);

  String? get description => (_$data['description'] as String?);

  List<String>? get aliases => (_$data['aliases'] as List<String>?);

  bool? get ignore_auto_tag => (_$data['ignore_auto_tag'] as bool?);

  bool? get favorite => (_$data['favorite'] as bool?);

  String? get image => (_$data['image'] as String?);

  List<String>? get parent_ids => (_$data['parent_ids'] as List<String>?);

  List<String>? get child_ids => (_$data['child_ids'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('name')) {
      final l$name = name;
      result$data['name'] = l$name;
    }
    if (_$data.containsKey('description')) {
      final l$description = description;
      result$data['description'] = l$description;
    }
    if (_$data.containsKey('aliases')) {
      final l$aliases = aliases;
      result$data['aliases'] = l$aliases?.map((e) => e).toList();
    }
    if (_$data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = ignore_auto_tag;
      result$data['ignore_auto_tag'] = l$ignore_auto_tag;
    }
    if (_$data.containsKey('favorite')) {
      final l$favorite = favorite;
      result$data['favorite'] = l$favorite;
    }
    if (_$data.containsKey('image')) {
      final l$image = image;
      result$data['image'] = l$image;
    }
    if (_$data.containsKey('parent_ids')) {
      final l$parent_ids = parent_ids;
      result$data['parent_ids'] = l$parent_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('child_ids')) {
      final l$child_ids = child_ids;
      result$data['child_ids'] = l$child_ids?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Input$TagUpdateInput<Input$TagUpdateInput> get copyWith =>
      CopyWith$Input$TagUpdateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$TagUpdateInput) || runtimeType != other.runtimeType) {
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
    final l$description = description;
    final lOther$description = other.description;
    if (_$data.containsKey('description') !=
        other._$data.containsKey('description')) {
      return false;
    }
    if (l$description != lOther$description) {
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
    final l$ignore_auto_tag = ignore_auto_tag;
    final lOther$ignore_auto_tag = other.ignore_auto_tag;
    if (_$data.containsKey('ignore_auto_tag') !=
        other._$data.containsKey('ignore_auto_tag')) {
      return false;
    }
    if (l$ignore_auto_tag != lOther$ignore_auto_tag) {
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
    final l$image = image;
    final lOther$image = other.image;
    if (_$data.containsKey('image') != other._$data.containsKey('image')) {
      return false;
    }
    if (l$image != lOther$image) {
      return false;
    }
    final l$parent_ids = parent_ids;
    final lOther$parent_ids = other.parent_ids;
    if (_$data.containsKey('parent_ids') !=
        other._$data.containsKey('parent_ids')) {
      return false;
    }
    if (l$parent_ids != null && lOther$parent_ids != null) {
      if (l$parent_ids.length != lOther$parent_ids.length) {
        return false;
      }
      for (int i = 0; i < l$parent_ids.length; i++) {
        final l$parent_ids$entry = l$parent_ids[i];
        final lOther$parent_ids$entry = lOther$parent_ids[i];
        if (l$parent_ids$entry != lOther$parent_ids$entry) {
          return false;
        }
      }
    } else if (l$parent_ids != lOther$parent_ids) {
      return false;
    }
    final l$child_ids = child_ids;
    final lOther$child_ids = other.child_ids;
    if (_$data.containsKey('child_ids') !=
        other._$data.containsKey('child_ids')) {
      return false;
    }
    if (l$child_ids != null && lOther$child_ids != null) {
      if (l$child_ids.length != lOther$child_ids.length) {
        return false;
      }
      for (int i = 0; i < l$child_ids.length; i++) {
        final l$child_ids$entry = l$child_ids[i];
        final lOther$child_ids$entry = lOther$child_ids[i];
        if (l$child_ids$entry != lOther$child_ids$entry) {
          return false;
        }
      }
    } else if (l$child_ids != lOther$child_ids) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$description = description;
    final l$aliases = aliases;
    final l$ignore_auto_tag = ignore_auto_tag;
    final l$favorite = favorite;
    final l$image = image;
    final l$parent_ids = parent_ids;
    final l$child_ids = child_ids;
    return Object.hashAll([
      l$id,
      _$data.containsKey('name') ? l$name : const {},
      _$data.containsKey('description') ? l$description : const {},
      _$data.containsKey('aliases')
          ? l$aliases == null
              ? null
              : Object.hashAll(l$aliases.map((v) => v))
          : const {},
      _$data.containsKey('ignore_auto_tag') ? l$ignore_auto_tag : const {},
      _$data.containsKey('favorite') ? l$favorite : const {},
      _$data.containsKey('image') ? l$image : const {},
      _$data.containsKey('parent_ids')
          ? l$parent_ids == null
              ? null
              : Object.hashAll(l$parent_ids.map((v) => v))
          : const {},
      _$data.containsKey('child_ids')
          ? l$child_ids == null
              ? null
              : Object.hashAll(l$child_ids.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$TagUpdateInput<TRes> {
  factory CopyWith$Input$TagUpdateInput(
    Input$TagUpdateInput instance,
    TRes Function(Input$TagUpdateInput) then,
  ) = _CopyWithImpl$Input$TagUpdateInput;

  factory CopyWith$Input$TagUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$TagUpdateInput;

  TRes call({
    String? id,
    String? name,
    String? description,
    List<String>? aliases,
    bool? ignore_auto_tag,
    bool? favorite,
    String? image,
    List<String>? parent_ids,
    List<String>? child_ids,
  });
}

class _CopyWithImpl$Input$TagUpdateInput<TRes>
    implements CopyWith$Input$TagUpdateInput<TRes> {
  _CopyWithImpl$Input$TagUpdateInput(
    this._instance,
    this._then,
  );

  final Input$TagUpdateInput _instance;

  final TRes Function(Input$TagUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? description = _undefined,
    Object? aliases = _undefined,
    Object? ignore_auto_tag = _undefined,
    Object? favorite = _undefined,
    Object? image = _undefined,
    Object? parent_ids = _undefined,
    Object? child_ids = _undefined,
  }) =>
      _then(Input$TagUpdateInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (name != _undefined) 'name': (name as String?),
        if (description != _undefined) 'description': (description as String?),
        if (aliases != _undefined) 'aliases': (aliases as List<String>?),
        if (ignore_auto_tag != _undefined)
          'ignore_auto_tag': (ignore_auto_tag as bool?),
        if (favorite != _undefined) 'favorite': (favorite as bool?),
        if (image != _undefined) 'image': (image as String?),
        if (parent_ids != _undefined)
          'parent_ids': (parent_ids as List<String>?),
        if (child_ids != _undefined) 'child_ids': (child_ids as List<String>?),
      }));
}

class _CopyWithStubImpl$Input$TagUpdateInput<TRes>
    implements CopyWith$Input$TagUpdateInput<TRes> {
  _CopyWithStubImpl$Input$TagUpdateInput(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? description,
    List<String>? aliases,
    bool? ignore_auto_tag,
    bool? favorite,
    String? image,
    List<String>? parent_ids,
    List<String>? child_ids,
  }) =>
      _res;
}

class Input$TagDestroyInput {
  factory Input$TagDestroyInput({required String id}) =>
      Input$TagDestroyInput._({
        r'id': id,
      });

  Input$TagDestroyInput._(this._$data);

  factory Input$TagDestroyInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Input$TagDestroyInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Input$TagDestroyInput<Input$TagDestroyInput> get copyWith =>
      CopyWith$Input$TagDestroyInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$TagDestroyInput) || runtimeType != other.runtimeType) {
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

abstract class CopyWith$Input$TagDestroyInput<TRes> {
  factory CopyWith$Input$TagDestroyInput(
    Input$TagDestroyInput instance,
    TRes Function(Input$TagDestroyInput) then,
  ) = _CopyWithImpl$Input$TagDestroyInput;

  factory CopyWith$Input$TagDestroyInput.stub(TRes res) =
      _CopyWithStubImpl$Input$TagDestroyInput;

  TRes call({String? id});
}

class _CopyWithImpl$Input$TagDestroyInput<TRes>
    implements CopyWith$Input$TagDestroyInput<TRes> {
  _CopyWithImpl$Input$TagDestroyInput(
    this._instance,
    this._then,
  );

  final Input$TagDestroyInput _instance;

  final TRes Function(Input$TagDestroyInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(Input$TagDestroyInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
      }));
}

class _CopyWithStubImpl$Input$TagDestroyInput<TRes>
    implements CopyWith$Input$TagDestroyInput<TRes> {
  _CopyWithStubImpl$Input$TagDestroyInput(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Input$TagsMergeInput {
  factory Input$TagsMergeInput({
    required List<String> source,
    required String destination,
  }) =>
      Input$TagsMergeInput._({
        r'source': source,
        r'destination': destination,
      });

  Input$TagsMergeInput._(this._$data);

  factory Input$TagsMergeInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$source = data['source'];
    result$data['source'] =
        (l$source as List<dynamic>).map((e) => (e as String)).toList();
    final l$destination = data['destination'];
    result$data['destination'] = (l$destination as String);
    return Input$TagsMergeInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String> get source => (_$data['source'] as List<String>);

  String get destination => (_$data['destination'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$source = source;
    result$data['source'] = l$source.map((e) => e).toList();
    final l$destination = destination;
    result$data['destination'] = l$destination;
    return result$data;
  }

  CopyWith$Input$TagsMergeInput<Input$TagsMergeInput> get copyWith =>
      CopyWith$Input$TagsMergeInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$TagsMergeInput) || runtimeType != other.runtimeType) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$source = source;
    final l$destination = destination;
    return Object.hashAll([
      Object.hashAll(l$source.map((v) => v)),
      l$destination,
    ]);
  }
}

abstract class CopyWith$Input$TagsMergeInput<TRes> {
  factory CopyWith$Input$TagsMergeInput(
    Input$TagsMergeInput instance,
    TRes Function(Input$TagsMergeInput) then,
  ) = _CopyWithImpl$Input$TagsMergeInput;

  factory CopyWith$Input$TagsMergeInput.stub(TRes res) =
      _CopyWithStubImpl$Input$TagsMergeInput;

  TRes call({
    List<String>? source,
    String? destination,
  });
}

class _CopyWithImpl$Input$TagsMergeInput<TRes>
    implements CopyWith$Input$TagsMergeInput<TRes> {
  _CopyWithImpl$Input$TagsMergeInput(
    this._instance,
    this._then,
  );

  final Input$TagsMergeInput _instance;

  final TRes Function(Input$TagsMergeInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? source = _undefined,
    Object? destination = _undefined,
  }) =>
      _then(Input$TagsMergeInput._({
        ..._instance._$data,
        if (source != _undefined && source != null)
          'source': (source as List<String>),
        if (destination != _undefined && destination != null)
          'destination': (destination as String),
      }));
}

class _CopyWithStubImpl$Input$TagsMergeInput<TRes>
    implements CopyWith$Input$TagsMergeInput<TRes> {
  _CopyWithStubImpl$Input$TagsMergeInput(this._res);

  TRes _res;

  call({
    List<String>? source,
    String? destination,
  }) =>
      _res;
}

class Input$BulkTagUpdateInput {
  factory Input$BulkTagUpdateInput({
    List<String>? ids,
    String? description,
    Input$BulkUpdateStrings? aliases,
    bool? ignore_auto_tag,
    bool? favorite,
    Input$BulkUpdateIds? parent_ids,
    Input$BulkUpdateIds? child_ids,
  }) =>
      Input$BulkTagUpdateInput._({
        if (ids != null) r'ids': ids,
        if (description != null) r'description': description,
        if (aliases != null) r'aliases': aliases,
        if (ignore_auto_tag != null) r'ignore_auto_tag': ignore_auto_tag,
        if (favorite != null) r'favorite': favorite,
        if (parent_ids != null) r'parent_ids': parent_ids,
        if (child_ids != null) r'child_ids': child_ids,
      });

  Input$BulkTagUpdateInput._(this._$data);

  factory Input$BulkTagUpdateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('ids')) {
      final l$ids = data['ids'];
      result$data['ids'] =
          (l$ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('description')) {
      final l$description = data['description'];
      result$data['description'] = (l$description as String?);
    }
    if (data.containsKey('aliases')) {
      final l$aliases = data['aliases'];
      result$data['aliases'] = l$aliases == null
          ? null
          : Input$BulkUpdateStrings.fromJson(
              (l$aliases as Map<String, dynamic>));
    }
    if (data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = data['ignore_auto_tag'];
      result$data['ignore_auto_tag'] = (l$ignore_auto_tag as bool?);
    }
    if (data.containsKey('favorite')) {
      final l$favorite = data['favorite'];
      result$data['favorite'] = (l$favorite as bool?);
    }
    if (data.containsKey('parent_ids')) {
      final l$parent_ids = data['parent_ids'];
      result$data['parent_ids'] = l$parent_ids == null
          ? null
          : Input$BulkUpdateIds.fromJson(
              (l$parent_ids as Map<String, dynamic>));
    }
    if (data.containsKey('child_ids')) {
      final l$child_ids = data['child_ids'];
      result$data['child_ids'] = l$child_ids == null
          ? null
          : Input$BulkUpdateIds.fromJson((l$child_ids as Map<String, dynamic>));
    }
    return Input$BulkTagUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String>? get ids => (_$data['ids'] as List<String>?);

  String? get description => (_$data['description'] as String?);

  Input$BulkUpdateStrings? get aliases =>
      (_$data['aliases'] as Input$BulkUpdateStrings?);

  bool? get ignore_auto_tag => (_$data['ignore_auto_tag'] as bool?);

  bool? get favorite => (_$data['favorite'] as bool?);

  Input$BulkUpdateIds? get parent_ids =>
      (_$data['parent_ids'] as Input$BulkUpdateIds?);

  Input$BulkUpdateIds? get child_ids =>
      (_$data['child_ids'] as Input$BulkUpdateIds?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('ids')) {
      final l$ids = ids;
      result$data['ids'] = l$ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('description')) {
      final l$description = description;
      result$data['description'] = l$description;
    }
    if (_$data.containsKey('aliases')) {
      final l$aliases = aliases;
      result$data['aliases'] = l$aliases?.toJson();
    }
    if (_$data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = ignore_auto_tag;
      result$data['ignore_auto_tag'] = l$ignore_auto_tag;
    }
    if (_$data.containsKey('favorite')) {
      final l$favorite = favorite;
      result$data['favorite'] = l$favorite;
    }
    if (_$data.containsKey('parent_ids')) {
      final l$parent_ids = parent_ids;
      result$data['parent_ids'] = l$parent_ids?.toJson();
    }
    if (_$data.containsKey('child_ids')) {
      final l$child_ids = child_ids;
      result$data['child_ids'] = l$child_ids?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$BulkTagUpdateInput<Input$BulkTagUpdateInput> get copyWith =>
      CopyWith$Input$BulkTagUpdateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$BulkTagUpdateInput) ||
        runtimeType != other.runtimeType) {
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
    final l$description = description;
    final lOther$description = other.description;
    if (_$data.containsKey('description') !=
        other._$data.containsKey('description')) {
      return false;
    }
    if (l$description != lOther$description) {
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
    final l$ignore_auto_tag = ignore_auto_tag;
    final lOther$ignore_auto_tag = other.ignore_auto_tag;
    if (_$data.containsKey('ignore_auto_tag') !=
        other._$data.containsKey('ignore_auto_tag')) {
      return false;
    }
    if (l$ignore_auto_tag != lOther$ignore_auto_tag) {
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
    final l$parent_ids = parent_ids;
    final lOther$parent_ids = other.parent_ids;
    if (_$data.containsKey('parent_ids') !=
        other._$data.containsKey('parent_ids')) {
      return false;
    }
    if (l$parent_ids != lOther$parent_ids) {
      return false;
    }
    final l$child_ids = child_ids;
    final lOther$child_ids = other.child_ids;
    if (_$data.containsKey('child_ids') !=
        other._$data.containsKey('child_ids')) {
      return false;
    }
    if (l$child_ids != lOther$child_ids) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$ids = ids;
    final l$description = description;
    final l$aliases = aliases;
    final l$ignore_auto_tag = ignore_auto_tag;
    final l$favorite = favorite;
    final l$parent_ids = parent_ids;
    final l$child_ids = child_ids;
    return Object.hashAll([
      _$data.containsKey('ids')
          ? l$ids == null
              ? null
              : Object.hashAll(l$ids.map((v) => v))
          : const {},
      _$data.containsKey('description') ? l$description : const {},
      _$data.containsKey('aliases') ? l$aliases : const {},
      _$data.containsKey('ignore_auto_tag') ? l$ignore_auto_tag : const {},
      _$data.containsKey('favorite') ? l$favorite : const {},
      _$data.containsKey('parent_ids') ? l$parent_ids : const {},
      _$data.containsKey('child_ids') ? l$child_ids : const {},
    ]);
  }
}

abstract class CopyWith$Input$BulkTagUpdateInput<TRes> {
  factory CopyWith$Input$BulkTagUpdateInput(
    Input$BulkTagUpdateInput instance,
    TRes Function(Input$BulkTagUpdateInput) then,
  ) = _CopyWithImpl$Input$BulkTagUpdateInput;

  factory CopyWith$Input$BulkTagUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$BulkTagUpdateInput;

  TRes call({
    List<String>? ids,
    String? description,
    Input$BulkUpdateStrings? aliases,
    bool? ignore_auto_tag,
    bool? favorite,
    Input$BulkUpdateIds? parent_ids,
    Input$BulkUpdateIds? child_ids,
  });
}

class _CopyWithImpl$Input$BulkTagUpdateInput<TRes>
    implements CopyWith$Input$BulkTagUpdateInput<TRes> {
  _CopyWithImpl$Input$BulkTagUpdateInput(
    this._instance,
    this._then,
  );

  final Input$BulkTagUpdateInput _instance;

  final TRes Function(Input$BulkTagUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ids = _undefined,
    Object? description = _undefined,
    Object? aliases = _undefined,
    Object? ignore_auto_tag = _undefined,
    Object? favorite = _undefined,
    Object? parent_ids = _undefined,
    Object? child_ids = _undefined,
  }) =>
      _then(Input$BulkTagUpdateInput._({
        ..._instance._$data,
        if (ids != _undefined) 'ids': (ids as List<String>?),
        if (description != _undefined) 'description': (description as String?),
        if (aliases != _undefined)
          'aliases': (aliases as Input$BulkUpdateStrings?),
        if (ignore_auto_tag != _undefined)
          'ignore_auto_tag': (ignore_auto_tag as bool?),
        if (favorite != _undefined) 'favorite': (favorite as bool?),
        if (parent_ids != _undefined)
          'parent_ids': (parent_ids as Input$BulkUpdateIds?),
        if (child_ids != _undefined)
          'child_ids': (child_ids as Input$BulkUpdateIds?),
      }));
}

class _CopyWithStubImpl$Input$BulkTagUpdateInput<TRes>
    implements CopyWith$Input$BulkTagUpdateInput<TRes> {
  _CopyWithStubImpl$Input$BulkTagUpdateInput(this._res);

  TRes _res;

  call({
    List<String>? ids,
    String? description,
    Input$BulkUpdateStrings? aliases,
    bool? ignore_auto_tag,
    bool? favorite,
    Input$BulkUpdateIds? parent_ids,
    Input$BulkUpdateIds? child_ids,
  }) =>
      _res;
}
