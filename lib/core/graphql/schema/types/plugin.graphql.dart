class Input$PluginArgInput {
  factory Input$PluginArgInput({
    required String key,
    Input$PluginValueInput? value,
  }) =>
      Input$PluginArgInput._({
        r'key': key,
        if (value != null) r'value': value,
      });

  Input$PluginArgInput._(this._$data);

  factory Input$PluginArgInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$key = data['key'];
    result$data['key'] = (l$key as String);
    if (data.containsKey('value')) {
      final l$value = data['value'];
      result$data['value'] = l$value == null
          ? null
          : Input$PluginValueInput.fromJson((l$value as Map<String, dynamic>));
    }
    return Input$PluginArgInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get key => (_$data['key'] as String);

  Input$PluginValueInput? get value =>
      (_$data['value'] as Input$PluginValueInput?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$key = key;
    result$data['key'] = l$key;
    if (_$data.containsKey('value')) {
      final l$value = value;
      result$data['value'] = l$value?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$PluginArgInput<Input$PluginArgInput> get copyWith =>
      CopyWith$Input$PluginArgInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$PluginArgInput) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$key = key;
    final lOther$key = other.key;
    if (l$key != lOther$key) {
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
    final l$key = key;
    final l$value = value;
    return Object.hashAll([
      l$key,
      _$data.containsKey('value') ? l$value : const {},
    ]);
  }
}

abstract class CopyWith$Input$PluginArgInput<TRes> {
  factory CopyWith$Input$PluginArgInput(
    Input$PluginArgInput instance,
    TRes Function(Input$PluginArgInput) then,
  ) = _CopyWithImpl$Input$PluginArgInput;

  factory CopyWith$Input$PluginArgInput.stub(TRes res) =
      _CopyWithStubImpl$Input$PluginArgInput;

  TRes call({
    String? key,
    Input$PluginValueInput? value,
  });
  CopyWith$Input$PluginValueInput<TRes> get value;
}

class _CopyWithImpl$Input$PluginArgInput<TRes>
    implements CopyWith$Input$PluginArgInput<TRes> {
  _CopyWithImpl$Input$PluginArgInput(
    this._instance,
    this._then,
  );

  final Input$PluginArgInput _instance;

  final TRes Function(Input$PluginArgInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? key = _undefined,
    Object? value = _undefined,
  }) =>
      _then(Input$PluginArgInput._({
        ..._instance._$data,
        if (key != _undefined && key != null) 'key': (key as String),
        if (value != _undefined) 'value': (value as Input$PluginValueInput?),
      }));

  CopyWith$Input$PluginValueInput<TRes> get value {
    final local$value = _instance.value;
    return local$value == null
        ? CopyWith$Input$PluginValueInput.stub(_then(_instance))
        : CopyWith$Input$PluginValueInput(local$value, (e) => call(value: e));
  }
}

class _CopyWithStubImpl$Input$PluginArgInput<TRes>
    implements CopyWith$Input$PluginArgInput<TRes> {
  _CopyWithStubImpl$Input$PluginArgInput(this._res);

  TRes _res;

  call({
    String? key,
    Input$PluginValueInput? value,
  }) =>
      _res;

  CopyWith$Input$PluginValueInput<TRes> get value =>
      CopyWith$Input$PluginValueInput.stub(_res);
}

class Input$PluginValueInput {
  factory Input$PluginValueInput({
    String? str,
    int? i,
    bool? b,
    double? f,
    List<Input$PluginArgInput>? o,
    List<Input$PluginValueInput>? a,
  }) =>
      Input$PluginValueInput._({
        if (str != null) r'str': str,
        if (i != null) r'i': i,
        if (b != null) r'b': b,
        if (f != null) r'f': f,
        if (o != null) r'o': o,
        if (a != null) r'a': a,
      });

  Input$PluginValueInput._(this._$data);

  factory Input$PluginValueInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('str')) {
      final l$str = data['str'];
      result$data['str'] = (l$str as String?);
    }
    if (data.containsKey('i')) {
      final l$i = data['i'];
      result$data['i'] = (l$i as int?);
    }
    if (data.containsKey('b')) {
      final l$b = data['b'];
      result$data['b'] = (l$b as bool?);
    }
    if (data.containsKey('f')) {
      final l$f = data['f'];
      result$data['f'] = (l$f as num?)?.toDouble();
    }
    if (data.containsKey('o')) {
      final l$o = data['o'];
      result$data['o'] = (l$o as List<dynamic>?)
          ?.map(
              (e) => Input$PluginArgInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('a')) {
      final l$a = data['a'];
      result$data['a'] = (l$a as List<dynamic>?)
          ?.map((e) =>
              Input$PluginValueInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    return Input$PluginValueInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get str => (_$data['str'] as String?);

  int? get i => (_$data['i'] as int?);

  bool? get b => (_$data['b'] as bool?);

  double? get f => (_$data['f'] as double?);

  List<Input$PluginArgInput>? get o =>
      (_$data['o'] as List<Input$PluginArgInput>?);

  List<Input$PluginValueInput>? get a =>
      (_$data['a'] as List<Input$PluginValueInput>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('str')) {
      final l$str = str;
      result$data['str'] = l$str;
    }
    if (_$data.containsKey('i')) {
      final l$i = i;
      result$data['i'] = l$i;
    }
    if (_$data.containsKey('b')) {
      final l$b = b;
      result$data['b'] = l$b;
    }
    if (_$data.containsKey('f')) {
      final l$f = f;
      result$data['f'] = l$f;
    }
    if (_$data.containsKey('o')) {
      final l$o = o;
      result$data['o'] = l$o?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('a')) {
      final l$a = a;
      result$data['a'] = l$a?.map((e) => e.toJson()).toList();
    }
    return result$data;
  }

  CopyWith$Input$PluginValueInput<Input$PluginValueInput> get copyWith =>
      CopyWith$Input$PluginValueInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$PluginValueInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$str = str;
    final lOther$str = other.str;
    if (_$data.containsKey('str') != other._$data.containsKey('str')) {
      return false;
    }
    if (l$str != lOther$str) {
      return false;
    }
    final l$i = i;
    final lOther$i = other.i;
    if (_$data.containsKey('i') != other._$data.containsKey('i')) {
      return false;
    }
    if (l$i != lOther$i) {
      return false;
    }
    final l$b = b;
    final lOther$b = other.b;
    if (_$data.containsKey('b') != other._$data.containsKey('b')) {
      return false;
    }
    if (l$b != lOther$b) {
      return false;
    }
    final l$f = f;
    final lOther$f = other.f;
    if (_$data.containsKey('f') != other._$data.containsKey('f')) {
      return false;
    }
    if (l$f != lOther$f) {
      return false;
    }
    final l$o = o;
    final lOther$o = other.o;
    if (_$data.containsKey('o') != other._$data.containsKey('o')) {
      return false;
    }
    if (l$o != null && lOther$o != null) {
      if (l$o.length != lOther$o.length) {
        return false;
      }
      for (int i = 0; i < l$o.length; i++) {
        final l$o$entry = l$o[i];
        final lOther$o$entry = lOther$o[i];
        if (l$o$entry != lOther$o$entry) {
          return false;
        }
      }
    } else if (l$o != lOther$o) {
      return false;
    }
    final l$a = a;
    final lOther$a = other.a;
    if (_$data.containsKey('a') != other._$data.containsKey('a')) {
      return false;
    }
    if (l$a != null && lOther$a != null) {
      if (l$a.length != lOther$a.length) {
        return false;
      }
      for (int i = 0; i < l$a.length; i++) {
        final l$a$entry = l$a[i];
        final lOther$a$entry = lOther$a[i];
        if (l$a$entry != lOther$a$entry) {
          return false;
        }
      }
    } else if (l$a != lOther$a) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$str = str;
    final l$i = i;
    final l$b = b;
    final l$f = f;
    final l$o = o;
    final l$a = a;
    return Object.hashAll([
      _$data.containsKey('str') ? l$str : const {},
      _$data.containsKey('i') ? l$i : const {},
      _$data.containsKey('b') ? l$b : const {},
      _$data.containsKey('f') ? l$f : const {},
      _$data.containsKey('o')
          ? l$o == null
              ? null
              : Object.hashAll(l$o.map((v) => v))
          : const {},
      _$data.containsKey('a')
          ? l$a == null
              ? null
              : Object.hashAll(l$a.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$PluginValueInput<TRes> {
  factory CopyWith$Input$PluginValueInput(
    Input$PluginValueInput instance,
    TRes Function(Input$PluginValueInput) then,
  ) = _CopyWithImpl$Input$PluginValueInput;

  factory CopyWith$Input$PluginValueInput.stub(TRes res) =
      _CopyWithStubImpl$Input$PluginValueInput;

  TRes call({
    String? str,
    int? i,
    bool? b,
    double? f,
    List<Input$PluginArgInput>? o,
    List<Input$PluginValueInput>? a,
  });
  TRes o(
      Iterable<Input$PluginArgInput>? Function(
              Iterable<CopyWith$Input$PluginArgInput<Input$PluginArgInput>>?)
          _fn);
  TRes a(
      Iterable<Input$PluginValueInput>? Function(
              Iterable<
                  CopyWith$Input$PluginValueInput<Input$PluginValueInput>>?)
          _fn);
}

class _CopyWithImpl$Input$PluginValueInput<TRes>
    implements CopyWith$Input$PluginValueInput<TRes> {
  _CopyWithImpl$Input$PluginValueInput(
    this._instance,
    this._then,
  );

  final Input$PluginValueInput _instance;

  final TRes Function(Input$PluginValueInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? str = _undefined,
    Object? i = _undefined,
    Object? b = _undefined,
    Object? f = _undefined,
    Object? o = _undefined,
    Object? a = _undefined,
  }) =>
      _then(Input$PluginValueInput._({
        ..._instance._$data,
        if (str != _undefined) 'str': (str as String?),
        if (i != _undefined) 'i': (i as int?),
        if (b != _undefined) 'b': (b as bool?),
        if (f != _undefined) 'f': (f as double?),
        if (o != _undefined) 'o': (o as List<Input$PluginArgInput>?),
        if (a != _undefined) 'a': (a as List<Input$PluginValueInput>?),
      }));

  TRes o(
          Iterable<Input$PluginArgInput>? Function(
                  Iterable<
                      CopyWith$Input$PluginArgInput<Input$PluginArgInput>>?)
              _fn) =>
      call(
          o: _fn(_instance.o?.map((e) => CopyWith$Input$PluginArgInput(
                e,
                (i) => i,
              )))?.toList());

  TRes a(
          Iterable<Input$PluginValueInput>? Function(
                  Iterable<
                      CopyWith$Input$PluginValueInput<Input$PluginValueInput>>?)
              _fn) =>
      call(
          a: _fn(_instance.a?.map((e) => CopyWith$Input$PluginValueInput(
                e,
                (i) => i,
              )))?.toList());
}

class _CopyWithStubImpl$Input$PluginValueInput<TRes>
    implements CopyWith$Input$PluginValueInput<TRes> {
  _CopyWithStubImpl$Input$PluginValueInput(this._res);

  TRes _res;

  call({
    String? str,
    int? i,
    bool? b,
    double? f,
    List<Input$PluginArgInput>? o,
    List<Input$PluginValueInput>? a,
  }) =>
      _res;

  o(_fn) => _res;

  a(_fn) => _res;
}

enum Enum$PluginSettingTypeEnum {
  STRING,
  NUMBER,
  BOOLEAN,
  $unknown;

  factory Enum$PluginSettingTypeEnum.fromJson(String value) =>
      fromJson$Enum$PluginSettingTypeEnum(value);

  String toJson() => toJson$Enum$PluginSettingTypeEnum(this);
}

String toJson$Enum$PluginSettingTypeEnum(Enum$PluginSettingTypeEnum e) {
  switch (e) {
    case Enum$PluginSettingTypeEnum.STRING:
      return r'STRING';
    case Enum$PluginSettingTypeEnum.NUMBER:
      return r'NUMBER';
    case Enum$PluginSettingTypeEnum.BOOLEAN:
      return r'BOOLEAN';
    case Enum$PluginSettingTypeEnum.$unknown:
      return r'$unknown';
  }
}

Enum$PluginSettingTypeEnum fromJson$Enum$PluginSettingTypeEnum(String value) {
  switch (value) {
    case r'STRING':
      return Enum$PluginSettingTypeEnum.STRING;
    case r'NUMBER':
      return Enum$PluginSettingTypeEnum.NUMBER;
    case r'BOOLEAN':
      return Enum$PluginSettingTypeEnum.BOOLEAN;
    default:
      return Enum$PluginSettingTypeEnum.$unknown;
  }
}
