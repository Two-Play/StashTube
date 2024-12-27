class Input$MigrateSceneScreenshotsInput {
  factory Input$MigrateSceneScreenshotsInput({
    bool? deleteFiles,
    bool? overwriteExisting,
  }) =>
      Input$MigrateSceneScreenshotsInput._({
        if (deleteFiles != null) r'deleteFiles': deleteFiles,
        if (overwriteExisting != null) r'overwriteExisting': overwriteExisting,
      });

  Input$MigrateSceneScreenshotsInput._(this._$data);

  factory Input$MigrateSceneScreenshotsInput.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('deleteFiles')) {
      final l$deleteFiles = data['deleteFiles'];
      result$data['deleteFiles'] = (l$deleteFiles as bool?);
    }
    if (data.containsKey('overwriteExisting')) {
      final l$overwriteExisting = data['overwriteExisting'];
      result$data['overwriteExisting'] = (l$overwriteExisting as bool?);
    }
    return Input$MigrateSceneScreenshotsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  bool? get deleteFiles => (_$data['deleteFiles'] as bool?);

  bool? get overwriteExisting => (_$data['overwriteExisting'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('deleteFiles')) {
      final l$deleteFiles = deleteFiles;
      result$data['deleteFiles'] = l$deleteFiles;
    }
    if (_$data.containsKey('overwriteExisting')) {
      final l$overwriteExisting = overwriteExisting;
      result$data['overwriteExisting'] = l$overwriteExisting;
    }
    return result$data;
  }

  CopyWith$Input$MigrateSceneScreenshotsInput<
          Input$MigrateSceneScreenshotsInput>
      get copyWith => CopyWith$Input$MigrateSceneScreenshotsInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$MigrateSceneScreenshotsInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deleteFiles = deleteFiles;
    final lOther$deleteFiles = other.deleteFiles;
    if (_$data.containsKey('deleteFiles') !=
        other._$data.containsKey('deleteFiles')) {
      return false;
    }
    if (l$deleteFiles != lOther$deleteFiles) {
      return false;
    }
    final l$overwriteExisting = overwriteExisting;
    final lOther$overwriteExisting = other.overwriteExisting;
    if (_$data.containsKey('overwriteExisting') !=
        other._$data.containsKey('overwriteExisting')) {
      return false;
    }
    if (l$overwriteExisting != lOther$overwriteExisting) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$deleteFiles = deleteFiles;
    final l$overwriteExisting = overwriteExisting;
    return Object.hashAll([
      _$data.containsKey('deleteFiles') ? l$deleteFiles : const {},
      _$data.containsKey('overwriteExisting') ? l$overwriteExisting : const {},
    ]);
  }
}

abstract class CopyWith$Input$MigrateSceneScreenshotsInput<TRes> {
  factory CopyWith$Input$MigrateSceneScreenshotsInput(
    Input$MigrateSceneScreenshotsInput instance,
    TRes Function(Input$MigrateSceneScreenshotsInput) then,
  ) = _CopyWithImpl$Input$MigrateSceneScreenshotsInput;

  factory CopyWith$Input$MigrateSceneScreenshotsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$MigrateSceneScreenshotsInput;

  TRes call({
    bool? deleteFiles,
    bool? overwriteExisting,
  });
}

class _CopyWithImpl$Input$MigrateSceneScreenshotsInput<TRes>
    implements CopyWith$Input$MigrateSceneScreenshotsInput<TRes> {
  _CopyWithImpl$Input$MigrateSceneScreenshotsInput(
    this._instance,
    this._then,
  );

  final Input$MigrateSceneScreenshotsInput _instance;

  final TRes Function(Input$MigrateSceneScreenshotsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? deleteFiles = _undefined,
    Object? overwriteExisting = _undefined,
  }) =>
      _then(Input$MigrateSceneScreenshotsInput._({
        ..._instance._$data,
        if (deleteFiles != _undefined) 'deleteFiles': (deleteFiles as bool?),
        if (overwriteExisting != _undefined)
          'overwriteExisting': (overwriteExisting as bool?),
      }));
}

class _CopyWithStubImpl$Input$MigrateSceneScreenshotsInput<TRes>
    implements CopyWith$Input$MigrateSceneScreenshotsInput<TRes> {
  _CopyWithStubImpl$Input$MigrateSceneScreenshotsInput(this._res);

  TRes _res;

  call({
    bool? deleteFiles,
    bool? overwriteExisting,
  }) =>
      _res;
}

class Input$MigrateBlobsInput {
  factory Input$MigrateBlobsInput({bool? deleteOld}) =>
      Input$MigrateBlobsInput._({
        if (deleteOld != null) r'deleteOld': deleteOld,
      });

  Input$MigrateBlobsInput._(this._$data);

  factory Input$MigrateBlobsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('deleteOld')) {
      final l$deleteOld = data['deleteOld'];
      result$data['deleteOld'] = (l$deleteOld as bool?);
    }
    return Input$MigrateBlobsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  bool? get deleteOld => (_$data['deleteOld'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('deleteOld')) {
      final l$deleteOld = deleteOld;
      result$data['deleteOld'] = l$deleteOld;
    }
    return result$data;
  }

  CopyWith$Input$MigrateBlobsInput<Input$MigrateBlobsInput> get copyWith =>
      CopyWith$Input$MigrateBlobsInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$MigrateBlobsInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deleteOld = deleteOld;
    final lOther$deleteOld = other.deleteOld;
    if (_$data.containsKey('deleteOld') !=
        other._$data.containsKey('deleteOld')) {
      return false;
    }
    if (l$deleteOld != lOther$deleteOld) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$deleteOld = deleteOld;
    return Object.hashAll(
        [_$data.containsKey('deleteOld') ? l$deleteOld : const {}]);
  }
}

abstract class CopyWith$Input$MigrateBlobsInput<TRes> {
  factory CopyWith$Input$MigrateBlobsInput(
    Input$MigrateBlobsInput instance,
    TRes Function(Input$MigrateBlobsInput) then,
  ) = _CopyWithImpl$Input$MigrateBlobsInput;

  factory CopyWith$Input$MigrateBlobsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$MigrateBlobsInput;

  TRes call({bool? deleteOld});
}

class _CopyWithImpl$Input$MigrateBlobsInput<TRes>
    implements CopyWith$Input$MigrateBlobsInput<TRes> {
  _CopyWithImpl$Input$MigrateBlobsInput(
    this._instance,
    this._then,
  );

  final Input$MigrateBlobsInput _instance;

  final TRes Function(Input$MigrateBlobsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deleteOld = _undefined}) =>
      _then(Input$MigrateBlobsInput._({
        ..._instance._$data,
        if (deleteOld != _undefined) 'deleteOld': (deleteOld as bool?),
      }));
}

class _CopyWithStubImpl$Input$MigrateBlobsInput<TRes>
    implements CopyWith$Input$MigrateBlobsInput<TRes> {
  _CopyWithStubImpl$Input$MigrateBlobsInput(this._res);

  TRes _res;

  call({bool? deleteOld}) => _res;
}
