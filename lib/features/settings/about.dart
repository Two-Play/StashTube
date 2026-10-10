import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../l10n/l10n.dart';

/// The app's version and build number; null where the platform doesn't
/// tell (tests).
final appInfoProvider = FutureProvider<PackageInfo?>((ref) async {
  try {
    return await PackageInfo.fromPlatform();
  } catch (_) {
    return null;
  }
});

/// Adds what the license page can't find in the packages: the Stash logo
/// and colors, which come from the Stash project. Called once in `main`.
void registerAppLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield const LicenseEntryWithLineBreaks(
      ['Stash (logo and colors)'],
      'The Stash logo (the open box) and its colors come from the Stash project, '
      'https://github.com/stashapp/stash, which is licensed under the GNU Affero '
      'General Public License v3.0 (AGPL-3.0).\n\n'
      'Stashy is not affiliated with the Stash project.',
    );
  });
}

/// "About" in the settings: the version and the open source licenses of
/// every package the app uses.
class AboutSettings extends ConsumerWidget {
  const AboutSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final info = ref.watch(appInfoProvider).value;
    final version = info == null ? null : l.appVersionValue(info.version, info.buildNumber);
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(l.appVersion),
          subtitle: version == null ? null : Text(version),
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: Text(l.openSourceLicenses),
          subtitle: Text(l.openSourceLicensesSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => showLicensePage(
            context: context,
            applicationName: l.appTitle,
            applicationVersion: version,
            applicationIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset('assets/icons/stash.png', width: 64, height: 64),
              ),
            ),
            applicationLegalese: l.aboutLegalese,
          ),
        ),
      ],
    );
  }
}
