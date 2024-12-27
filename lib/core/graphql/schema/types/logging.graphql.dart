enum Enum$LogLevel {
  Trace,
  Debug,
  Info,
  Progress,
  Warning,
  Error,
  $unknown;

  factory Enum$LogLevel.fromJson(String value) => fromJson$Enum$LogLevel(value);

  String toJson() => toJson$Enum$LogLevel(this);
}

String toJson$Enum$LogLevel(Enum$LogLevel e) {
  switch (e) {
    case Enum$LogLevel.Trace:
      return r'Trace';
    case Enum$LogLevel.Debug:
      return r'Debug';
    case Enum$LogLevel.Info:
      return r'Info';
    case Enum$LogLevel.Progress:
      return r'Progress';
    case Enum$LogLevel.Warning:
      return r'Warning';
    case Enum$LogLevel.Error:
      return r'Error';
    case Enum$LogLevel.$unknown:
      return r'$unknown';
  }
}

Enum$LogLevel fromJson$Enum$LogLevel(String value) {
  switch (value) {
    case r'Trace':
      return Enum$LogLevel.Trace;
    case r'Debug':
      return Enum$LogLevel.Debug;
    case r'Info':
      return Enum$LogLevel.Info;
    case r'Progress':
      return Enum$LogLevel.Progress;
    case r'Warning':
      return Enum$LogLevel.Warning;
    case r'Error':
      return Enum$LogLevel.Error;
    default:
      return Enum$LogLevel.$unknown;
  }
}
