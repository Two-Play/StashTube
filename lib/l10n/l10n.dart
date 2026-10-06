import 'package:flutter/widgets.dart';

import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';
export 'errors.dart';
export 'labels.dart';

/// Texts of the app in the current language (13.3). The English texts in
/// `app_en.arb` are the template; `app_de.arb` has the German ones.
extension L10nContext on BuildContext {
  /// English where no app localizations are set up (e.g. widget tests that
  /// pump a bare MaterialApp).
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ?? lookupAppLocalizations(const Locale('en'));
}
