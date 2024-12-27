class Input$PackageSpecInput {
  factory Input$PackageSpecInput({
    required String id,
    required String sourceURL,
  }) =>
      Input$PackageSpecInput._({
        r'id': id,
        r'sourceURL': sourceURL,
      });

  Input$PackageSpecInput._(this._$data);

  factory Input$PackageSpecInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    final l$sourceURL = data['sourceURL'];
    result$data['sourceURL'] = (l$sourceURL as String);
    return Input$PackageSpecInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  String get sourceURL => (_$data['sourceURL'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    final l$sourceURL = sourceURL;
    result$data['sourceURL'] = l$sourceURL;
    return result$data;
  }

  CopyWith$Input$PackageSpecInput<Input$PackageSpecInput> get copyWith =>
      CopyWith$Input$PackageSpecInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$PackageSpecInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$sourceURL = sourceURL;
    final lOther$sourceURL = other.sourceURL;
    if (l$sourceURL != lOther$sourceURL) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$sourceURL = sourceURL;
    return Object.hashAll([
      l$id,
      l$sourceURL,
    ]);
  }
}

abstract class CopyWith$Input$PackageSpecInput<TRes> {
  factory CopyWith$Input$PackageSpecInput(
    Input$PackageSpecInput instance,
    TRes Function(Input$PackageSpecInput) then,
  ) = _CopyWithImpl$Input$PackageSpecInput;

  factory CopyWith$Input$PackageSpecInput.stub(TRes res) =
      _CopyWithStubImpl$Input$PackageSpecInput;

  TRes call({
    String? id,
    String? sourceURL,
  });
}

class _CopyWithImpl$Input$PackageSpecInput<TRes>
    implements CopyWith$Input$PackageSpecInput<TRes> {
  _CopyWithImpl$Input$PackageSpecInput(
    this._instance,
    this._then,
  );

  final Input$PackageSpecInput _instance;

  final TRes Function(Input$PackageSpecInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? sourceURL = _undefined,
  }) =>
      _then(Input$PackageSpecInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (sourceURL != _undefined && sourceURL != null)
          'sourceURL': (sourceURL as String),
      }));
}

class _CopyWithStubImpl$Input$PackageSpecInput<TRes>
    implements CopyWith$Input$PackageSpecInput<TRes> {
  _CopyWithStubImpl$Input$PackageSpecInput(this._res);

  TRes _res;

  call({
    String? id,
    String? sourceURL,
  }) =>
      _res;
}

class Input$PackageSourceInput {
  factory Input$PackageSourceInput({
    String? name,
    required String url,
    String? local_path,
  }) =>
      Input$PackageSourceInput._({
        if (name != null) r'name': name,
        r'url': url,
        if (local_path != null) r'local_path': local_path,
      });

  Input$PackageSourceInput._(this._$data);

  factory Input$PackageSourceInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('name')) {
      final l$name = data['name'];
      result$data['name'] = (l$name as String?);
    }
    final l$url = data['url'];
    result$data['url'] = (l$url as String);
    if (data.containsKey('local_path')) {
      final l$local_path = data['local_path'];
      result$data['local_path'] = (l$local_path as String?);
    }
    return Input$PackageSourceInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get name => (_$data['name'] as String?);

  String get url => (_$data['url'] as String);

  String? get local_path => (_$data['local_path'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('name')) {
      final l$name = name;
      result$data['name'] = l$name;
    }
    final l$url = url;
    result$data['url'] = l$url;
    if (_$data.containsKey('local_path')) {
      final l$local_path = local_path;
      result$data['local_path'] = l$local_path;
    }
    return result$data;
  }

  CopyWith$Input$PackageSourceInput<Input$PackageSourceInput> get copyWith =>
      CopyWith$Input$PackageSourceInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$PackageSourceInput) ||
        runtimeType != other.runtimeType) {
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
    if (l$url != lOther$url) {
      return false;
    }
    final l$local_path = local_path;
    final lOther$local_path = other.local_path;
    if (_$data.containsKey('local_path') !=
        other._$data.containsKey('local_path')) {
      return false;
    }
    if (l$local_path != lOther$local_path) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$url = url;
    final l$local_path = local_path;
    return Object.hashAll([
      _$data.containsKey('name') ? l$name : const {},
      l$url,
      _$data.containsKey('local_path') ? l$local_path : const {},
    ]);
  }
}

abstract class CopyWith$Input$PackageSourceInput<TRes> {
  factory CopyWith$Input$PackageSourceInput(
    Input$PackageSourceInput instance,
    TRes Function(Input$PackageSourceInput) then,
  ) = _CopyWithImpl$Input$PackageSourceInput;

  factory CopyWith$Input$PackageSourceInput.stub(TRes res) =
      _CopyWithStubImpl$Input$PackageSourceInput;

  TRes call({
    String? name,
    String? url,
    String? local_path,
  });
}

class _CopyWithImpl$Input$PackageSourceInput<TRes>
    implements CopyWith$Input$PackageSourceInput<TRes> {
  _CopyWithImpl$Input$PackageSourceInput(
    this._instance,
    this._then,
  );

  final Input$PackageSourceInput _instance;

  final TRes Function(Input$PackageSourceInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? url = _undefined,
    Object? local_path = _undefined,
  }) =>
      _then(Input$PackageSourceInput._({
        ..._instance._$data,
        if (name != _undefined) 'name': (name as String?),
        if (url != _undefined && url != null) 'url': (url as String),
        if (local_path != _undefined) 'local_path': (local_path as String?),
      }));
}

class _CopyWithStubImpl$Input$PackageSourceInput<TRes>
    implements CopyWith$Input$PackageSourceInput<TRes> {
  _CopyWithStubImpl$Input$PackageSourceInput(this._res);

  TRes _res;

  call({
    String? name,
    String? url,
    String? local_path,
  }) =>
      _res;
}

enum Enum$PackageType {
  Scraper,
  Plugin,
  $unknown;

  factory Enum$PackageType.fromJson(String value) =>
      fromJson$Enum$PackageType(value);

  String toJson() => toJson$Enum$PackageType(this);
}

String toJson$Enum$PackageType(Enum$PackageType e) {
  switch (e) {
    case Enum$PackageType.Scraper:
      return r'Scraper';
    case Enum$PackageType.Plugin:
      return r'Plugin';
    case Enum$PackageType.$unknown:
      return r'$unknown';
  }
}

Enum$PackageType fromJson$Enum$PackageType(String value) {
  switch (value) {
    case r'Scraper':
      return Enum$PackageType.Scraper;
    case r'Plugin':
      return Enum$PackageType.Plugin;
    default:
      return Enum$PackageType.$unknown;
  }
}
