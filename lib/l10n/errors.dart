import '../data/repositories/stash_repository.dart';
import 'gen/app_localizations.dart';

/// [error] as shown to the user, in the current language where the app
/// knows the error; the server's own messages stay as they are.
String errorText(AppLocalizations l, Object error) => switch (error) {
      StashApiException(kind: StashErrorKind.unreachable, :final detail) => l.errorUnreachable(detail ?? ''),
      StashApiException(kind: StashErrorKind.localNetworkDenied) => l.errorLocalNetworkDenied,
      StashApiException(kind: StashErrorKind.unauthorized) => l.errorUnauthorized,
      StashApiException(kind: StashErrorKind.invalidCredentials) => l.errorInvalidCredentials,
      StashApiException(kind: StashErrorKind.notReady, :final detail) => l.errorNotReady(detail ?? ''),
      StashApiException(kind: StashErrorKind.notFound) => l.errorNotFound,
      StashApiException(kind: StashErrorKind.notSaved) => l.errorNotSaved,
      // Validation errors of the forms carry a message meant for the user.
      StateError(:final message) => message,
      _ => '$error',
    };

/// A short headline for [error] (STATE-2), e.g. "Can't reach the server".
String errorHeadline(AppLocalizations l, Object error) => switch (error) {
      StashApiException(kind: StashErrorKind.unreachable) => l.errorUnreachableTitle,
      StashApiException(kind: StashErrorKind.localNetworkDenied) => l.errorLocalNetworkTitle,
      StashApiException(kind: StashErrorKind.unauthorized) => l.errorUnauthorizedTitle,
      StashApiException(kind: StashErrorKind.invalidCredentials) => l.errorInvalidCredentialsTitle,
      StashApiException(kind: StashErrorKind.notReady) => l.errorNotReadyTitle,
      StashApiException(kind: StashErrorKind.notFound) => l.errorNotFoundTitle,
      _ => l.errorTitle,
    };

/// One plain sentence under [errorHeadline]: what it means and what to do.
/// The technical text is [errorDetails].
String errorExplanation(AppLocalizations l, Object error) => switch (error) {
      StashApiException(kind: StashErrorKind.unreachable) => l.errorUnreachableHint,
      StashApiException(kind: StashErrorKind.localNetworkDenied) => l.errorLocalNetworkDenied,
      StashApiException(kind: StashErrorKind.unauthorized) => l.errorUnauthorizedHint,
      StashApiException(kind: StashErrorKind.invalidCredentials) => l.errorInvalidCredentials,
      StashApiException(kind: StashErrorKind.notReady) => l.errorNotReadyHint,
      StashApiException(kind: StashErrorKind.notFound) => l.errorNotFoundHint,
      StashApiException(kind: StashErrorKind.notSaved) => l.errorNotSaved,
      StashApiException(kind: StashErrorKind.server) => l.errorServerHint,
      StateError(:final message) => message,
      _ => l.errorUnexpectedHint,
    };

/// The technical message behind [error] (English, as logged), for the
/// "Details" of an error view; null when there is nothing more to say than
/// the explanation.
String? errorDetails(Object error) {
  final text = switch (error) {
    StashApiException(:final message) => message,
    StateError() => null,
    _ => '$error',
  };
  return text == null || text.trim().isEmpty ? null : text.trim();
}
