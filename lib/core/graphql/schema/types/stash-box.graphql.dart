class Input$StashBoxInput {
  factory Input$StashBoxInput({
    required String endpoint,
    required String api_key,
    required String name,
  }) =>
      Input$StashBoxInput._({
        r'endpoint': endpoint,
        r'api_key': api_key,
        r'name': name,
      });

  Input$StashBoxInput._(this._$data);

  factory Input$StashBoxInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$endpoint = data['endpoint'];
    result$data['endpoint'] = (l$endpoint as String);
    final l$api_key = data['api_key'];
    result$data['api_key'] = (l$api_key as String);
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    return Input$StashBoxInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get endpoint => (_$data['endpoint'] as String);

  String get api_key => (_$data['api_key'] as String);

  String get name => (_$data['name'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$endpoint = endpoint;
    result$data['endpoint'] = l$endpoint;
    final l$api_key = api_key;
    result$data['api_key'] = l$api_key;
    final l$name = name;
    result$data['name'] = l$name;
    return result$data;
  }

  CopyWith$Input$StashBoxInput<Input$StashBoxInput> get copyWith =>
      CopyWith$Input$StashBoxInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$StashBoxInput) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$endpoint = endpoint;
    final lOther$endpoint = other.endpoint;
    if (l$endpoint != lOther$endpoint) {
      return false;
    }
    final l$api_key = api_key;
    final lOther$api_key = other.api_key;
    if (l$api_key != lOther$api_key) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$endpoint = endpoint;
    final l$api_key = api_key;
    final l$name = name;
    return Object.hashAll([
      l$endpoint,
      l$api_key,
      l$name,
    ]);
  }
}

abstract class CopyWith$Input$StashBoxInput<TRes> {
  factory CopyWith$Input$StashBoxInput(
    Input$StashBoxInput instance,
    TRes Function(Input$StashBoxInput) then,
  ) = _CopyWithImpl$Input$StashBoxInput;

  factory CopyWith$Input$StashBoxInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StashBoxInput;

  TRes call({
    String? endpoint,
    String? api_key,
    String? name,
  });
}

class _CopyWithImpl$Input$StashBoxInput<TRes>
    implements CopyWith$Input$StashBoxInput<TRes> {
  _CopyWithImpl$Input$StashBoxInput(
    this._instance,
    this._then,
  );

  final Input$StashBoxInput _instance;

  final TRes Function(Input$StashBoxInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? endpoint = _undefined,
    Object? api_key = _undefined,
    Object? name = _undefined,
  }) =>
      _then(Input$StashBoxInput._({
        ..._instance._$data,
        if (endpoint != _undefined && endpoint != null)
          'endpoint': (endpoint as String),
        if (api_key != _undefined && api_key != null)
          'api_key': (api_key as String),
        if (name != _undefined && name != null) 'name': (name as String),
      }));
}

class _CopyWithStubImpl$Input$StashBoxInput<TRes>
    implements CopyWith$Input$StashBoxInput<TRes> {
  _CopyWithStubImpl$Input$StashBoxInput(this._res);

  TRes _res;

  call({
    String? endpoint,
    String? api_key,
    String? name,
  }) =>
      _res;
}

class Input$StashIDInput {
  factory Input$StashIDInput({
    required String endpoint,
    required String stash_id,
  }) =>
      Input$StashIDInput._({
        r'endpoint': endpoint,
        r'stash_id': stash_id,
      });

  Input$StashIDInput._(this._$data);

  factory Input$StashIDInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$endpoint = data['endpoint'];
    result$data['endpoint'] = (l$endpoint as String);
    final l$stash_id = data['stash_id'];
    result$data['stash_id'] = (l$stash_id as String);
    return Input$StashIDInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get endpoint => (_$data['endpoint'] as String);

  String get stash_id => (_$data['stash_id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$endpoint = endpoint;
    result$data['endpoint'] = l$endpoint;
    final l$stash_id = stash_id;
    result$data['stash_id'] = l$stash_id;
    return result$data;
  }

  CopyWith$Input$StashIDInput<Input$StashIDInput> get copyWith =>
      CopyWith$Input$StashIDInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$StashIDInput) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$endpoint = endpoint;
    final lOther$endpoint = other.endpoint;
    if (l$endpoint != lOther$endpoint) {
      return false;
    }
    final l$stash_id = stash_id;
    final lOther$stash_id = other.stash_id;
    if (l$stash_id != lOther$stash_id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$endpoint = endpoint;
    final l$stash_id = stash_id;
    return Object.hashAll([
      l$endpoint,
      l$stash_id,
    ]);
  }
}

abstract class CopyWith$Input$StashIDInput<TRes> {
  factory CopyWith$Input$StashIDInput(
    Input$StashIDInput instance,
    TRes Function(Input$StashIDInput) then,
  ) = _CopyWithImpl$Input$StashIDInput;

  factory CopyWith$Input$StashIDInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StashIDInput;

  TRes call({
    String? endpoint,
    String? stash_id,
  });
}

class _CopyWithImpl$Input$StashIDInput<TRes>
    implements CopyWith$Input$StashIDInput<TRes> {
  _CopyWithImpl$Input$StashIDInput(
    this._instance,
    this._then,
  );

  final Input$StashIDInput _instance;

  final TRes Function(Input$StashIDInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? endpoint = _undefined,
    Object? stash_id = _undefined,
  }) =>
      _then(Input$StashIDInput._({
        ..._instance._$data,
        if (endpoint != _undefined && endpoint != null)
          'endpoint': (endpoint as String),
        if (stash_id != _undefined && stash_id != null)
          'stash_id': (stash_id as String),
      }));
}

class _CopyWithStubImpl$Input$StashIDInput<TRes>
    implements CopyWith$Input$StashIDInput<TRes> {
  _CopyWithStubImpl$Input$StashIDInput(this._res);

  TRes _res;

  call({
    String? endpoint,
    String? stash_id,
  }) =>
      _res;
}

class Input$StashBoxFingerprintSubmissionInput {
  factory Input$StashBoxFingerprintSubmissionInput({
    required List<String> scene_ids,
    int? stash_box_index,
    String? stash_box_endpoint,
  }) =>
      Input$StashBoxFingerprintSubmissionInput._({
        r'scene_ids': scene_ids,
        if (stash_box_index != null) r'stash_box_index': stash_box_index,
        if (stash_box_endpoint != null)
          r'stash_box_endpoint': stash_box_endpoint,
      });

  Input$StashBoxFingerprintSubmissionInput._(this._$data);

  factory Input$StashBoxFingerprintSubmissionInput.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$scene_ids = data['scene_ids'];
    result$data['scene_ids'] =
        (l$scene_ids as List<dynamic>).map((e) => (e as String)).toList();
    if (data.containsKey('stash_box_index')) {
      final l$stash_box_index = data['stash_box_index'];
      result$data['stash_box_index'] = (l$stash_box_index as int?);
    }
    if (data.containsKey('stash_box_endpoint')) {
      final l$stash_box_endpoint = data['stash_box_endpoint'];
      result$data['stash_box_endpoint'] = (l$stash_box_endpoint as String?);
    }
    return Input$StashBoxFingerprintSubmissionInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String> get scene_ids => (_$data['scene_ids'] as List<String>);

  int? get stash_box_index => (_$data['stash_box_index'] as int?);

  String? get stash_box_endpoint => (_$data['stash_box_endpoint'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$scene_ids = scene_ids;
    result$data['scene_ids'] = l$scene_ids.map((e) => e).toList();
    if (_$data.containsKey('stash_box_index')) {
      final l$stash_box_index = stash_box_index;
      result$data['stash_box_index'] = l$stash_box_index;
    }
    if (_$data.containsKey('stash_box_endpoint')) {
      final l$stash_box_endpoint = stash_box_endpoint;
      result$data['stash_box_endpoint'] = l$stash_box_endpoint;
    }
    return result$data;
  }

  CopyWith$Input$StashBoxFingerprintSubmissionInput<
          Input$StashBoxFingerprintSubmissionInput>
      get copyWith => CopyWith$Input$StashBoxFingerprintSubmissionInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$StashBoxFingerprintSubmissionInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$scene_ids = scene_ids;
    final lOther$scene_ids = other.scene_ids;
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
    final l$stash_box_index = stash_box_index;
    final lOther$stash_box_index = other.stash_box_index;
    if (_$data.containsKey('stash_box_index') !=
        other._$data.containsKey('stash_box_index')) {
      return false;
    }
    if (l$stash_box_index != lOther$stash_box_index) {
      return false;
    }
    final l$stash_box_endpoint = stash_box_endpoint;
    final lOther$stash_box_endpoint = other.stash_box_endpoint;
    if (_$data.containsKey('stash_box_endpoint') !=
        other._$data.containsKey('stash_box_endpoint')) {
      return false;
    }
    if (l$stash_box_endpoint != lOther$stash_box_endpoint) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$scene_ids = scene_ids;
    final l$stash_box_index = stash_box_index;
    final l$stash_box_endpoint = stash_box_endpoint;
    return Object.hashAll([
      Object.hashAll(l$scene_ids.map((v) => v)),
      _$data.containsKey('stash_box_index') ? l$stash_box_index : const {},
      _$data.containsKey('stash_box_endpoint')
          ? l$stash_box_endpoint
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$StashBoxFingerprintSubmissionInput<TRes> {
  factory CopyWith$Input$StashBoxFingerprintSubmissionInput(
    Input$StashBoxFingerprintSubmissionInput instance,
    TRes Function(Input$StashBoxFingerprintSubmissionInput) then,
  ) = _CopyWithImpl$Input$StashBoxFingerprintSubmissionInput;

  factory CopyWith$Input$StashBoxFingerprintSubmissionInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StashBoxFingerprintSubmissionInput;

  TRes call({
    List<String>? scene_ids,
    int? stash_box_index,
    String? stash_box_endpoint,
  });
}

class _CopyWithImpl$Input$StashBoxFingerprintSubmissionInput<TRes>
    implements CopyWith$Input$StashBoxFingerprintSubmissionInput<TRes> {
  _CopyWithImpl$Input$StashBoxFingerprintSubmissionInput(
    this._instance,
    this._then,
  );

  final Input$StashBoxFingerprintSubmissionInput _instance;

  final TRes Function(Input$StashBoxFingerprintSubmissionInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? scene_ids = _undefined,
    Object? stash_box_index = _undefined,
    Object? stash_box_endpoint = _undefined,
  }) =>
      _then(Input$StashBoxFingerprintSubmissionInput._({
        ..._instance._$data,
        if (scene_ids != _undefined && scene_ids != null)
          'scene_ids': (scene_ids as List<String>),
        if (stash_box_index != _undefined)
          'stash_box_index': (stash_box_index as int?),
        if (stash_box_endpoint != _undefined)
          'stash_box_endpoint': (stash_box_endpoint as String?),
      }));
}

class _CopyWithStubImpl$Input$StashBoxFingerprintSubmissionInput<TRes>
    implements CopyWith$Input$StashBoxFingerprintSubmissionInput<TRes> {
  _CopyWithStubImpl$Input$StashBoxFingerprintSubmissionInput(this._res);

  TRes _res;

  call({
    List<String>? scene_ids,
    int? stash_box_index,
    String? stash_box_endpoint,
  }) =>
      _res;
}

class Input$StashBoxDraftSubmissionInput {
  factory Input$StashBoxDraftSubmissionInput({
    required String id,
    int? stash_box_index,
    String? stash_box_endpoint,
  }) =>
      Input$StashBoxDraftSubmissionInput._({
        r'id': id,
        if (stash_box_index != null) r'stash_box_index': stash_box_index,
        if (stash_box_endpoint != null)
          r'stash_box_endpoint': stash_box_endpoint,
      });

  Input$StashBoxDraftSubmissionInput._(this._$data);

  factory Input$StashBoxDraftSubmissionInput.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('stash_box_index')) {
      final l$stash_box_index = data['stash_box_index'];
      result$data['stash_box_index'] = (l$stash_box_index as int?);
    }
    if (data.containsKey('stash_box_endpoint')) {
      final l$stash_box_endpoint = data['stash_box_endpoint'];
      result$data['stash_box_endpoint'] = (l$stash_box_endpoint as String?);
    }
    return Input$StashBoxDraftSubmissionInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  int? get stash_box_index => (_$data['stash_box_index'] as int?);

  String? get stash_box_endpoint => (_$data['stash_box_endpoint'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('stash_box_index')) {
      final l$stash_box_index = stash_box_index;
      result$data['stash_box_index'] = l$stash_box_index;
    }
    if (_$data.containsKey('stash_box_endpoint')) {
      final l$stash_box_endpoint = stash_box_endpoint;
      result$data['stash_box_endpoint'] = l$stash_box_endpoint;
    }
    return result$data;
  }

  CopyWith$Input$StashBoxDraftSubmissionInput<
          Input$StashBoxDraftSubmissionInput>
      get copyWith => CopyWith$Input$StashBoxDraftSubmissionInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$StashBoxDraftSubmissionInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$stash_box_index = stash_box_index;
    final lOther$stash_box_index = other.stash_box_index;
    if (_$data.containsKey('stash_box_index') !=
        other._$data.containsKey('stash_box_index')) {
      return false;
    }
    if (l$stash_box_index != lOther$stash_box_index) {
      return false;
    }
    final l$stash_box_endpoint = stash_box_endpoint;
    final lOther$stash_box_endpoint = other.stash_box_endpoint;
    if (_$data.containsKey('stash_box_endpoint') !=
        other._$data.containsKey('stash_box_endpoint')) {
      return false;
    }
    if (l$stash_box_endpoint != lOther$stash_box_endpoint) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$stash_box_index = stash_box_index;
    final l$stash_box_endpoint = stash_box_endpoint;
    return Object.hashAll([
      l$id,
      _$data.containsKey('stash_box_index') ? l$stash_box_index : const {},
      _$data.containsKey('stash_box_endpoint')
          ? l$stash_box_endpoint
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$StashBoxDraftSubmissionInput<TRes> {
  factory CopyWith$Input$StashBoxDraftSubmissionInput(
    Input$StashBoxDraftSubmissionInput instance,
    TRes Function(Input$StashBoxDraftSubmissionInput) then,
  ) = _CopyWithImpl$Input$StashBoxDraftSubmissionInput;

  factory CopyWith$Input$StashBoxDraftSubmissionInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StashBoxDraftSubmissionInput;

  TRes call({
    String? id,
    int? stash_box_index,
    String? stash_box_endpoint,
  });
}

class _CopyWithImpl$Input$StashBoxDraftSubmissionInput<TRes>
    implements CopyWith$Input$StashBoxDraftSubmissionInput<TRes> {
  _CopyWithImpl$Input$StashBoxDraftSubmissionInput(
    this._instance,
    this._then,
  );

  final Input$StashBoxDraftSubmissionInput _instance;

  final TRes Function(Input$StashBoxDraftSubmissionInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? stash_box_index = _undefined,
    Object? stash_box_endpoint = _undefined,
  }) =>
      _then(Input$StashBoxDraftSubmissionInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (stash_box_index != _undefined)
          'stash_box_index': (stash_box_index as int?),
        if (stash_box_endpoint != _undefined)
          'stash_box_endpoint': (stash_box_endpoint as String?),
      }));
}

class _CopyWithStubImpl$Input$StashBoxDraftSubmissionInput<TRes>
    implements CopyWith$Input$StashBoxDraftSubmissionInput<TRes> {
  _CopyWithStubImpl$Input$StashBoxDraftSubmissionInput(this._res);

  TRes _res;

  call({
    String? id,
    int? stash_box_index,
    String? stash_box_endpoint,
  }) =>
      _res;
}
