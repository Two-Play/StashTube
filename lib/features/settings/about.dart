import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// The native libraries media_kit embeds for playback (libmpv with FFmpeg
/// and what they use), with their license texts in `assets/licenses/`. Their
/// Flutter packages only ship media_kit's own MIT license, so the license
/// page wouldn't list them. Android and iOS embed the first nine; iOS also
/// the last three.
const nativeLibraries = [
  (name: 'mpv', license: 'LGPL-2.1-or-later', files: ['mpv-LGPL-2.1.txt'], source: 'https://github.com/mpv-player/mpv'),
  (
    name: 'FFmpeg',
    license: 'LGPL-3.0-or-later (built without GPL parts)',
    // The LGPL v3 builds on the GPL v3, so both texts belong to it.
    files: ['ffmpeg-LGPL-3.0.txt', 'ffmpeg-GPL-3.0.txt'],
    source: 'https://ffmpeg.org',
  ),
  (name: 'libass', license: 'ISC', files: ['libass.txt'], source: 'https://github.com/libass/libass'),
  (name: 'FreeType', license: 'FreeType License', files: ['freetype-FTL.txt'], source: 'https://freetype.org'),
  (name: 'FriBidi', license: 'LGPL-2.1-or-later', files: ['fribidi.txt'], source: 'https://github.com/fribidi/fribidi'),
  (name: 'HarfBuzz', license: 'MIT', files: ['harfbuzz.txt'], source: 'https://github.com/harfbuzz/harfbuzz'),
  (name: 'dav1d', license: 'BSD-2-Clause', files: ['dav1d.txt'], source: 'https://code.videolan.org/videolan/dav1d'),
  (name: 'Mbed TLS', license: 'Apache-2.0', files: ['mbedtls.txt'], source: 'https://github.com/Mbed-TLS/mbedtls'),
  (name: 'libxml2', license: 'MIT', files: ['libxml2.txt'], source: 'https://gitlab.gnome.org/GNOME/libxml2'),
  (name: 'libpng', license: 'libpng License', files: ['libpng.txt'], source: 'https://github.com/pnggroup/libpng'),
  (
    name: 'uchardet',
    license: 'MPL-1.1, GPL-2.0-or-later or LGPL-2.1-or-later',
    files: ['uchardet.txt'],
    source: 'https://gitlab.freedesktop.org/uchardet/uchardet',
  ),
  (
    name: 'Protocol Buffers',
    license: 'BSD-3-Clause',
    files: ['protobuf.txt'],
    source: 'https://github.com/protocolbuffers/protobuf',
  ),
];

/// Adds what the license page can't find in the Dart packages: Stashy's own
/// license and the [nativeLibraries]. Called once in `main`.
void registerAppLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(['Stashy'], await rootBundle.loadString('LICENSE'));
    for (final library in nativeLibraries) {
      final texts = [for (final file in library.files) await rootBundle.loadString('assets/licenses/$file')];
      yield LicenseEntryWithLineBreaks(
        [library.name],
        '${library.name} (${library.license}) is part of the video player (media_kit\'s libmpv build) '
        'and linked dynamically. Source code: ${library.source}\n\n${texts.join('\n\n')}',
      );
    }
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
                child: Image.asset('assets/icons/stashy.png', width: 64, height: 64),
              ),
            ),
            applicationLegalese: l.aboutLegalese,
          ),
        ),
      ],
    );
  }
}
