// F-Droid build: replaces lib/features/cast/google_cast_service.dart (see
// tool/fdroid_prepare.sh), so the app contains no Google Cast SDK and no
// Play Services. The cast button then doesn't show; AirPlay is iOS only.
import 'package:stash_app_mobile/features/cast/cast_service.dart';

/// Stands in for the Google Cast implementation with the same API.
class GoogleCastService {
  GoogleCastService._();

  static CastService create() => const UnsupportedCastService();
}
