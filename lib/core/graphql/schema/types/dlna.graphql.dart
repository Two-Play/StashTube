class Input$EnableDLNAInput {
  factory Input$EnableDLNAInput({int? duration}) => Input$EnableDLNAInput._({
        if (duration != null) r'duration': duration,
      });

  Input$EnableDLNAInput._(this._$data);

  factory Input$EnableDLNAInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('duration')) {
      final l$duration = data['duration'];
      result$data['duration'] = (l$duration as int?);
    }
    return Input$EnableDLNAInput._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get duration => (_$data['duration'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('duration')) {
      final l$duration = duration;
      result$data['duration'] = l$duration;
    }
    return result$data;
  }

  CopyWith$Input$EnableDLNAInput<Input$EnableDLNAInput> get copyWith =>
      CopyWith$Input$EnableDLNAInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$EnableDLNAInput) || runtimeType != other.runtimeType) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$duration = duration;
    return Object.hashAll(
        [_$data.containsKey('duration') ? l$duration : const {}]);
  }
}

abstract class CopyWith$Input$EnableDLNAInput<TRes> {
  factory CopyWith$Input$EnableDLNAInput(
    Input$EnableDLNAInput instance,
    TRes Function(Input$EnableDLNAInput) then,
  ) = _CopyWithImpl$Input$EnableDLNAInput;

  factory CopyWith$Input$EnableDLNAInput.stub(TRes res) =
      _CopyWithStubImpl$Input$EnableDLNAInput;

  TRes call({int? duration});
}

class _CopyWithImpl$Input$EnableDLNAInput<TRes>
    implements CopyWith$Input$EnableDLNAInput<TRes> {
  _CopyWithImpl$Input$EnableDLNAInput(
    this._instance,
    this._then,
  );

  final Input$EnableDLNAInput _instance;

  final TRes Function(Input$EnableDLNAInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? duration = _undefined}) => _then(Input$EnableDLNAInput._({
        ..._instance._$data,
        if (duration != _undefined) 'duration': (duration as int?),
      }));
}

class _CopyWithStubImpl$Input$EnableDLNAInput<TRes>
    implements CopyWith$Input$EnableDLNAInput<TRes> {
  _CopyWithStubImpl$Input$EnableDLNAInput(this._res);

  TRes _res;

  call({int? duration}) => _res;
}

class Input$DisableDLNAInput {
  factory Input$DisableDLNAInput({int? duration}) => Input$DisableDLNAInput._({
        if (duration != null) r'duration': duration,
      });

  Input$DisableDLNAInput._(this._$data);

  factory Input$DisableDLNAInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('duration')) {
      final l$duration = data['duration'];
      result$data['duration'] = (l$duration as int?);
    }
    return Input$DisableDLNAInput._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get duration => (_$data['duration'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('duration')) {
      final l$duration = duration;
      result$data['duration'] = l$duration;
    }
    return result$data;
  }

  CopyWith$Input$DisableDLNAInput<Input$DisableDLNAInput> get copyWith =>
      CopyWith$Input$DisableDLNAInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$DisableDLNAInput) ||
        runtimeType != other.runtimeType) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$duration = duration;
    return Object.hashAll(
        [_$data.containsKey('duration') ? l$duration : const {}]);
  }
}

abstract class CopyWith$Input$DisableDLNAInput<TRes> {
  factory CopyWith$Input$DisableDLNAInput(
    Input$DisableDLNAInput instance,
    TRes Function(Input$DisableDLNAInput) then,
  ) = _CopyWithImpl$Input$DisableDLNAInput;

  factory CopyWith$Input$DisableDLNAInput.stub(TRes res) =
      _CopyWithStubImpl$Input$DisableDLNAInput;

  TRes call({int? duration});
}

class _CopyWithImpl$Input$DisableDLNAInput<TRes>
    implements CopyWith$Input$DisableDLNAInput<TRes> {
  _CopyWithImpl$Input$DisableDLNAInput(
    this._instance,
    this._then,
  );

  final Input$DisableDLNAInput _instance;

  final TRes Function(Input$DisableDLNAInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? duration = _undefined}) => _then(Input$DisableDLNAInput._({
        ..._instance._$data,
        if (duration != _undefined) 'duration': (duration as int?),
      }));
}

class _CopyWithStubImpl$Input$DisableDLNAInput<TRes>
    implements CopyWith$Input$DisableDLNAInput<TRes> {
  _CopyWithStubImpl$Input$DisableDLNAInput(this._res);

  TRes _res;

  call({int? duration}) => _res;
}

class Input$AddTempDLNAIPInput {
  factory Input$AddTempDLNAIPInput({
    required String address,
    int? duration,
  }) =>
      Input$AddTempDLNAIPInput._({
        r'address': address,
        if (duration != null) r'duration': duration,
      });

  Input$AddTempDLNAIPInput._(this._$data);

  factory Input$AddTempDLNAIPInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$address = data['address'];
    result$data['address'] = (l$address as String);
    if (data.containsKey('duration')) {
      final l$duration = data['duration'];
      result$data['duration'] = (l$duration as int?);
    }
    return Input$AddTempDLNAIPInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get address => (_$data['address'] as String);

  int? get duration => (_$data['duration'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$address = address;
    result$data['address'] = l$address;
    if (_$data.containsKey('duration')) {
      final l$duration = duration;
      result$data['duration'] = l$duration;
    }
    return result$data;
  }

  CopyWith$Input$AddTempDLNAIPInput<Input$AddTempDLNAIPInput> get copyWith =>
      CopyWith$Input$AddTempDLNAIPInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$AddTempDLNAIPInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$address = address;
    final lOther$address = other.address;
    if (l$address != lOther$address) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$address = address;
    final l$duration = duration;
    return Object.hashAll([
      l$address,
      _$data.containsKey('duration') ? l$duration : const {},
    ]);
  }
}

abstract class CopyWith$Input$AddTempDLNAIPInput<TRes> {
  factory CopyWith$Input$AddTempDLNAIPInput(
    Input$AddTempDLNAIPInput instance,
    TRes Function(Input$AddTempDLNAIPInput) then,
  ) = _CopyWithImpl$Input$AddTempDLNAIPInput;

  factory CopyWith$Input$AddTempDLNAIPInput.stub(TRes res) =
      _CopyWithStubImpl$Input$AddTempDLNAIPInput;

  TRes call({
    String? address,
    int? duration,
  });
}

class _CopyWithImpl$Input$AddTempDLNAIPInput<TRes>
    implements CopyWith$Input$AddTempDLNAIPInput<TRes> {
  _CopyWithImpl$Input$AddTempDLNAIPInput(
    this._instance,
    this._then,
  );

  final Input$AddTempDLNAIPInput _instance;

  final TRes Function(Input$AddTempDLNAIPInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? address = _undefined,
    Object? duration = _undefined,
  }) =>
      _then(Input$AddTempDLNAIPInput._({
        ..._instance._$data,
        if (address != _undefined && address != null)
          'address': (address as String),
        if (duration != _undefined) 'duration': (duration as int?),
      }));
}

class _CopyWithStubImpl$Input$AddTempDLNAIPInput<TRes>
    implements CopyWith$Input$AddTempDLNAIPInput<TRes> {
  _CopyWithStubImpl$Input$AddTempDLNAIPInput(this._res);

  TRes _res;

  call({
    String? address,
    int? duration,
  }) =>
      _res;
}

class Input$RemoveTempDLNAIPInput {
  factory Input$RemoveTempDLNAIPInput({required String address}) =>
      Input$RemoveTempDLNAIPInput._({
        r'address': address,
      });

  Input$RemoveTempDLNAIPInput._(this._$data);

  factory Input$RemoveTempDLNAIPInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$address = data['address'];
    result$data['address'] = (l$address as String);
    return Input$RemoveTempDLNAIPInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get address => (_$data['address'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$address = address;
    result$data['address'] = l$address;
    return result$data;
  }

  CopyWith$Input$RemoveTempDLNAIPInput<Input$RemoveTempDLNAIPInput>
      get copyWith => CopyWith$Input$RemoveTempDLNAIPInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$RemoveTempDLNAIPInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$address = address;
    final lOther$address = other.address;
    if (l$address != lOther$address) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$address = address;
    return Object.hashAll([l$address]);
  }
}

abstract class CopyWith$Input$RemoveTempDLNAIPInput<TRes> {
  factory CopyWith$Input$RemoveTempDLNAIPInput(
    Input$RemoveTempDLNAIPInput instance,
    TRes Function(Input$RemoveTempDLNAIPInput) then,
  ) = _CopyWithImpl$Input$RemoveTempDLNAIPInput;

  factory CopyWith$Input$RemoveTempDLNAIPInput.stub(TRes res) =
      _CopyWithStubImpl$Input$RemoveTempDLNAIPInput;

  TRes call({String? address});
}

class _CopyWithImpl$Input$RemoveTempDLNAIPInput<TRes>
    implements CopyWith$Input$RemoveTempDLNAIPInput<TRes> {
  _CopyWithImpl$Input$RemoveTempDLNAIPInput(
    this._instance,
    this._then,
  );

  final Input$RemoveTempDLNAIPInput _instance;

  final TRes Function(Input$RemoveTempDLNAIPInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? address = _undefined}) =>
      _then(Input$RemoveTempDLNAIPInput._({
        ..._instance._$data,
        if (address != _undefined && address != null)
          'address': (address as String),
      }));
}

class _CopyWithStubImpl$Input$RemoveTempDLNAIPInput<TRes>
    implements CopyWith$Input$RemoveTempDLNAIPInput<TRes> {
  _CopyWithStubImpl$Input$RemoveTempDLNAIPInput(this._res);

  TRes _res;

  call({String? address}) => _res;
}
