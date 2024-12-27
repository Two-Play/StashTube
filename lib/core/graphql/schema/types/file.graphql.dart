class Input$MoveFilesInput {
  factory Input$MoveFilesInput({
    required List<String> ids,
    String? destination_folder,
    String? destination_folder_id,
    String? destination_basename,
  }) =>
      Input$MoveFilesInput._({
        r'ids': ids,
        if (destination_folder != null)
          r'destination_folder': destination_folder,
        if (destination_folder_id != null)
          r'destination_folder_id': destination_folder_id,
        if (destination_basename != null)
          r'destination_basename': destination_basename,
      });

  Input$MoveFilesInput._(this._$data);

  factory Input$MoveFilesInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$ids = data['ids'];
    result$data['ids'] =
        (l$ids as List<dynamic>).map((e) => (e as String)).toList();
    if (data.containsKey('destination_folder')) {
      final l$destination_folder = data['destination_folder'];
      result$data['destination_folder'] = (l$destination_folder as String?);
    }
    if (data.containsKey('destination_folder_id')) {
      final l$destination_folder_id = data['destination_folder_id'];
      result$data['destination_folder_id'] =
          (l$destination_folder_id as String?);
    }
    if (data.containsKey('destination_basename')) {
      final l$destination_basename = data['destination_basename'];
      result$data['destination_basename'] = (l$destination_basename as String?);
    }
    return Input$MoveFilesInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String> get ids => (_$data['ids'] as List<String>);

  String? get destination_folder => (_$data['destination_folder'] as String?);

  String? get destination_folder_id =>
      (_$data['destination_folder_id'] as String?);

  String? get destination_basename =>
      (_$data['destination_basename'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$ids = ids;
    result$data['ids'] = l$ids.map((e) => e).toList();
    if (_$data.containsKey('destination_folder')) {
      final l$destination_folder = destination_folder;
      result$data['destination_folder'] = l$destination_folder;
    }
    if (_$data.containsKey('destination_folder_id')) {
      final l$destination_folder_id = destination_folder_id;
      result$data['destination_folder_id'] = l$destination_folder_id;
    }
    if (_$data.containsKey('destination_basename')) {
      final l$destination_basename = destination_basename;
      result$data['destination_basename'] = l$destination_basename;
    }
    return result$data;
  }

  CopyWith$Input$MoveFilesInput<Input$MoveFilesInput> get copyWith =>
      CopyWith$Input$MoveFilesInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$MoveFilesInput) || runtimeType != other.runtimeType) {
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
    final l$destination_folder = destination_folder;
    final lOther$destination_folder = other.destination_folder;
    if (_$data.containsKey('destination_folder') !=
        other._$data.containsKey('destination_folder')) {
      return false;
    }
    if (l$destination_folder != lOther$destination_folder) {
      return false;
    }
    final l$destination_folder_id = destination_folder_id;
    final lOther$destination_folder_id = other.destination_folder_id;
    if (_$data.containsKey('destination_folder_id') !=
        other._$data.containsKey('destination_folder_id')) {
      return false;
    }
    if (l$destination_folder_id != lOther$destination_folder_id) {
      return false;
    }
    final l$destination_basename = destination_basename;
    final lOther$destination_basename = other.destination_basename;
    if (_$data.containsKey('destination_basename') !=
        other._$data.containsKey('destination_basename')) {
      return false;
    }
    if (l$destination_basename != lOther$destination_basename) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$ids = ids;
    final l$destination_folder = destination_folder;
    final l$destination_folder_id = destination_folder_id;
    final l$destination_basename = destination_basename;
    return Object.hashAll([
      Object.hashAll(l$ids.map((v) => v)),
      _$data.containsKey('destination_folder')
          ? l$destination_folder
          : const {},
      _$data.containsKey('destination_folder_id')
          ? l$destination_folder_id
          : const {},
      _$data.containsKey('destination_basename')
          ? l$destination_basename
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$MoveFilesInput<TRes> {
  factory CopyWith$Input$MoveFilesInput(
    Input$MoveFilesInput instance,
    TRes Function(Input$MoveFilesInput) then,
  ) = _CopyWithImpl$Input$MoveFilesInput;

  factory CopyWith$Input$MoveFilesInput.stub(TRes res) =
      _CopyWithStubImpl$Input$MoveFilesInput;

  TRes call({
    List<String>? ids,
    String? destination_folder,
    String? destination_folder_id,
    String? destination_basename,
  });
}

class _CopyWithImpl$Input$MoveFilesInput<TRes>
    implements CopyWith$Input$MoveFilesInput<TRes> {
  _CopyWithImpl$Input$MoveFilesInput(
    this._instance,
    this._then,
  );

  final Input$MoveFilesInput _instance;

  final TRes Function(Input$MoveFilesInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ids = _undefined,
    Object? destination_folder = _undefined,
    Object? destination_folder_id = _undefined,
    Object? destination_basename = _undefined,
  }) =>
      _then(Input$MoveFilesInput._({
        ..._instance._$data,
        if (ids != _undefined && ids != null) 'ids': (ids as List<String>),
        if (destination_folder != _undefined)
          'destination_folder': (destination_folder as String?),
        if (destination_folder_id != _undefined)
          'destination_folder_id': (destination_folder_id as String?),
        if (destination_basename != _undefined)
          'destination_basename': (destination_basename as String?),
      }));
}

class _CopyWithStubImpl$Input$MoveFilesInput<TRes>
    implements CopyWith$Input$MoveFilesInput<TRes> {
  _CopyWithStubImpl$Input$MoveFilesInput(this._res);

  TRes _res;

  call({
    List<String>? ids,
    String? destination_folder,
    String? destination_folder_id,
    String? destination_basename,
  }) =>
      _res;
}

class Input$SetFingerprintsInput {
  factory Input$SetFingerprintsInput({
    required String type,
    String? value,
  }) =>
      Input$SetFingerprintsInput._({
        r'type': type,
        if (value != null) r'value': value,
      });

  Input$SetFingerprintsInput._(this._$data);

  factory Input$SetFingerprintsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$type = data['type'];
    result$data['type'] = (l$type as String);
    if (data.containsKey('value')) {
      final l$value = data['value'];
      result$data['value'] = (l$value as String?);
    }
    return Input$SetFingerprintsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get type => (_$data['type'] as String);

  String? get value => (_$data['value'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$type = type;
    result$data['type'] = l$type;
    if (_$data.containsKey('value')) {
      final l$value = value;
      result$data['value'] = l$value;
    }
    return result$data;
  }

  CopyWith$Input$SetFingerprintsInput<Input$SetFingerprintsInput>
      get copyWith => CopyWith$Input$SetFingerprintsInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$SetFingerprintsInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$value = value;
    final lOther$value = other.value;
    if (_$data.containsKey('value') != other._$data.containsKey('value')) {
      return false;
    }
    if (l$value != lOther$value) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$type = type;
    final l$value = value;
    return Object.hashAll([
      l$type,
      _$data.containsKey('value') ? l$value : const {},
    ]);
  }
}

abstract class CopyWith$Input$SetFingerprintsInput<TRes> {
  factory CopyWith$Input$SetFingerprintsInput(
    Input$SetFingerprintsInput instance,
    TRes Function(Input$SetFingerprintsInput) then,
  ) = _CopyWithImpl$Input$SetFingerprintsInput;

  factory CopyWith$Input$SetFingerprintsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SetFingerprintsInput;

  TRes call({
    String? type,
    String? value,
  });
}

class _CopyWithImpl$Input$SetFingerprintsInput<TRes>
    implements CopyWith$Input$SetFingerprintsInput<TRes> {
  _CopyWithImpl$Input$SetFingerprintsInput(
    this._instance,
    this._then,
  );

  final Input$SetFingerprintsInput _instance;

  final TRes Function(Input$SetFingerprintsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? type = _undefined,
    Object? value = _undefined,
  }) =>
      _then(Input$SetFingerprintsInput._({
        ..._instance._$data,
        if (type != _undefined && type != null) 'type': (type as String),
        if (value != _undefined) 'value': (value as String?),
      }));
}

class _CopyWithStubImpl$Input$SetFingerprintsInput<TRes>
    implements CopyWith$Input$SetFingerprintsInput<TRes> {
  _CopyWithStubImpl$Input$SetFingerprintsInput(this._res);

  TRes _res;

  call({
    String? type,
    String? value,
  }) =>
      _res;
}

class Input$FileSetFingerprintsInput {
  factory Input$FileSetFingerprintsInput({
    required String id,
    required List<Input$SetFingerprintsInput> fingerprints,
  }) =>
      Input$FileSetFingerprintsInput._({
        r'id': id,
        r'fingerprints': fingerprints,
      });

  Input$FileSetFingerprintsInput._(this._$data);

  factory Input$FileSetFingerprintsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    final l$fingerprints = data['fingerprints'];
    result$data['fingerprints'] = (l$fingerprints as List<dynamic>)
        .map((e) =>
            Input$SetFingerprintsInput.fromJson((e as Map<String, dynamic>)))
        .toList();
    return Input$FileSetFingerprintsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  List<Input$SetFingerprintsInput> get fingerprints =>
      (_$data['fingerprints'] as List<Input$SetFingerprintsInput>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    final l$fingerprints = fingerprints;
    result$data['fingerprints'] =
        l$fingerprints.map((e) => e.toJson()).toList();
    return result$data;
  }

  CopyWith$Input$FileSetFingerprintsInput<Input$FileSetFingerprintsInput>
      get copyWith => CopyWith$Input$FileSetFingerprintsInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$FileSetFingerprintsInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$fingerprints = fingerprints;
    final lOther$fingerprints = other.fingerprints;
    if (l$fingerprints.length != lOther$fingerprints.length) {
      return false;
    }
    for (int i = 0; i < l$fingerprints.length; i++) {
      final l$fingerprints$entry = l$fingerprints[i];
      final lOther$fingerprints$entry = lOther$fingerprints[i];
      if (l$fingerprints$entry != lOther$fingerprints$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$fingerprints = fingerprints;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$fingerprints.map((v) => v)),
    ]);
  }
}

abstract class CopyWith$Input$FileSetFingerprintsInput<TRes> {
  factory CopyWith$Input$FileSetFingerprintsInput(
    Input$FileSetFingerprintsInput instance,
    TRes Function(Input$FileSetFingerprintsInput) then,
  ) = _CopyWithImpl$Input$FileSetFingerprintsInput;

  factory CopyWith$Input$FileSetFingerprintsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$FileSetFingerprintsInput;

  TRes call({
    String? id,
    List<Input$SetFingerprintsInput>? fingerprints,
  });
  TRes fingerprints(
      Iterable<Input$SetFingerprintsInput> Function(
              Iterable<
                  CopyWith$Input$SetFingerprintsInput<
                      Input$SetFingerprintsInput>>)
          _fn);
}

class _CopyWithImpl$Input$FileSetFingerprintsInput<TRes>
    implements CopyWith$Input$FileSetFingerprintsInput<TRes> {
  _CopyWithImpl$Input$FileSetFingerprintsInput(
    this._instance,
    this._then,
  );

  final Input$FileSetFingerprintsInput _instance;

  final TRes Function(Input$FileSetFingerprintsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? fingerprints = _undefined,
  }) =>
      _then(Input$FileSetFingerprintsInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (fingerprints != _undefined && fingerprints != null)
          'fingerprints': (fingerprints as List<Input$SetFingerprintsInput>),
      }));

  TRes fingerprints(
          Iterable<Input$SetFingerprintsInput> Function(
                  Iterable<
                      CopyWith$Input$SetFingerprintsInput<
                          Input$SetFingerprintsInput>>)
              _fn) =>
      call(
          fingerprints: _fn(_instance.fingerprints
              .map((e) => CopyWith$Input$SetFingerprintsInput(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Input$FileSetFingerprintsInput<TRes>
    implements CopyWith$Input$FileSetFingerprintsInput<TRes> {
  _CopyWithStubImpl$Input$FileSetFingerprintsInput(this._res);

  TRes _res;

  call({
    String? id,
    List<Input$SetFingerprintsInput>? fingerprints,
  }) =>
      _res;

  fingerprints(_fn) => _res;
}
