import '../data/repositories/stash_repository.dart';
import 'gen/app_localizations.dart';

/// [error] as shown to the user, in the current language where the app
/// knows the error; the server's own messages stay as they are.
String errorText(AppLocalizations l, Object error) => switch (error) {
      StashApiException(kind: StashErrorKind.unreachable, :final detail) => l.errorUnreachable(detail ?? ''),
      StashApiException(kind: StashErrorKind.unauthorized) => l.errorUnauthorized,
      StashApiException(kind: StashErrorKind.invalidCredentials) => l.errorInvalidCredentials,
      StashApiException(kind: StashErrorKind.notReady, :final detail) => l.errorNotReady(detail ?? ''),
      StashApiException(kind: StashErrorKind.notFound) => l.errorNotFound,
      StashApiException(kind: StashErrorKind.notSaved) => l.errorNotSaved,
      // Validation errors of the forms carry a message meant for the user.
      StateError(:final message) => message,
      _ => '$error',
    };
