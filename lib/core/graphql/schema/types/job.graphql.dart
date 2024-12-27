class Input$FindJobInput {
  factory Input$FindJobInput({required String id}) => Input$FindJobInput._({
        r'id': id,
      });

  Input$FindJobInput._(this._$data);

  factory Input$FindJobInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Input$FindJobInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Input$FindJobInput<Input$FindJobInput> get copyWith =>
      CopyWith$Input$FindJobInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$FindJobInput) || runtimeType != other.runtimeType) {
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

abstract class CopyWith$Input$FindJobInput<TRes> {
  factory CopyWith$Input$FindJobInput(
    Input$FindJobInput instance,
    TRes Function(Input$FindJobInput) then,
  ) = _CopyWithImpl$Input$FindJobInput;

  factory CopyWith$Input$FindJobInput.stub(TRes res) =
      _CopyWithStubImpl$Input$FindJobInput;

  TRes call({String? id});
}

class _CopyWithImpl$Input$FindJobInput<TRes>
    implements CopyWith$Input$FindJobInput<TRes> {
  _CopyWithImpl$Input$FindJobInput(
    this._instance,
    this._then,
  );

  final Input$FindJobInput _instance;

  final TRes Function(Input$FindJobInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(Input$FindJobInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
      }));
}

class _CopyWithStubImpl$Input$FindJobInput<TRes>
    implements CopyWith$Input$FindJobInput<TRes> {
  _CopyWithStubImpl$Input$FindJobInput(this._res);

  TRes _res;

  call({String? id}) => _res;
}

enum Enum$JobStatus {
  READY,
  RUNNING,
  FINISHED,
  STOPPING,
  CANCELLED,
  FAILED,
  $unknown;

  factory Enum$JobStatus.fromJson(String value) =>
      fromJson$Enum$JobStatus(value);

  String toJson() => toJson$Enum$JobStatus(this);
}

String toJson$Enum$JobStatus(Enum$JobStatus e) {
  switch (e) {
    case Enum$JobStatus.READY:
      return r'READY';
    case Enum$JobStatus.RUNNING:
      return r'RUNNING';
    case Enum$JobStatus.FINISHED:
      return r'FINISHED';
    case Enum$JobStatus.STOPPING:
      return r'STOPPING';
    case Enum$JobStatus.CANCELLED:
      return r'CANCELLED';
    case Enum$JobStatus.FAILED:
      return r'FAILED';
    case Enum$JobStatus.$unknown:
      return r'$unknown';
  }
}

Enum$JobStatus fromJson$Enum$JobStatus(String value) {
  switch (value) {
    case r'READY':
      return Enum$JobStatus.READY;
    case r'RUNNING':
      return Enum$JobStatus.RUNNING;
    case r'FINISHED':
      return Enum$JobStatus.FINISHED;
    case r'STOPPING':
      return Enum$JobStatus.STOPPING;
    case r'CANCELLED':
      return Enum$JobStatus.CANCELLED;
    case r'FAILED':
      return Enum$JobStatus.FAILED;
    default:
      return Enum$JobStatus.$unknown;
  }
}

enum Enum$JobStatusUpdateType {
  ADD,
  REMOVE,
  UPDATE,
  $unknown;

  factory Enum$JobStatusUpdateType.fromJson(String value) =>
      fromJson$Enum$JobStatusUpdateType(value);

  String toJson() => toJson$Enum$JobStatusUpdateType(this);
}

String toJson$Enum$JobStatusUpdateType(Enum$JobStatusUpdateType e) {
  switch (e) {
    case Enum$JobStatusUpdateType.ADD:
      return r'ADD';
    case Enum$JobStatusUpdateType.REMOVE:
      return r'REMOVE';
    case Enum$JobStatusUpdateType.UPDATE:
      return r'UPDATE';
    case Enum$JobStatusUpdateType.$unknown:
      return r'$unknown';
  }
}

Enum$JobStatusUpdateType fromJson$Enum$JobStatusUpdateType(String value) {
  switch (value) {
    case r'ADD':
      return Enum$JobStatusUpdateType.ADD;
    case r'REMOVE':
      return Enum$JobStatusUpdateType.REMOVE;
    case r'UPDATE':
      return Enum$JobStatusUpdateType.UPDATE;
    default:
      return Enum$JobStatusUpdateType.$unknown;
  }
}
