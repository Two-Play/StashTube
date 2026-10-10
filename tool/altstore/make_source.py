#!/usr/bin/env python3
"""Build StashTube's AltStore source from the GitHub releases.

    gh api repos/Two-Play/StashTube/releases --paginate > releases.json
    python3 tool/altstore/make_source.py releases.json > altstore.json

Every release with an .ipa asset becomes a version, newest first. The IPA
must have been built with the release's version and run number (see
release.yml): AltStore checks both against the app's Info.plist.
"""

import json
import re
import sys

REPO = 'Two-Play/StashTube'
RAW = f'https://raw.githubusercontent.com/{REPO}/main'
TINT = '3A8DFF'

# The usage descriptions from ios/Runner/Info.plist; AltStore shows them
# before installing and refuses an app whose permissions differ.
PRIVACY = {
    'NSFaceIDUsageDescription': 'Unlock Stash with Face ID.',
    'NSLocalNetworkUsageDescription':
        'Stash connects to your media server and finds Chromecast devices '
        'on the local network.',
    'NSPhotoLibraryUsageDescription':
        'Choose photos to use as covers and images in Stash.',
}

DESCRIPTION = (
    'StashTube is a client for your own Stash server. It shows your library '
    'like a video app: a home feed, channels for performers and studios, '
    'search with filters, shorts, markers, galleries and a player with '
    'chapters, picture-in-picture and background playback.\n\n'
    'It connects only to the server you enter and has no analytics. An '
    'optional app lock with PIN or Face ID, a cover in the app switcher and '
    'a disguised app icon keep it discreet.'
)

SCREENSHOTS = ['home', 'player', 'shorts', 'channel', 'markers', 'theme']


def build_number(version):
    """Return the build number of a release's IPA, from its file name."""
    match = re.search(r'-(\d+)\.ipa$', version['name'])
    return match.group(1) if match else None


def versions(releases):
    """Return AltStore versions for the releases that have an IPA."""
    result = []
    for release in releases:
        if release.get('draft'):
            continue
        ipa = next((a for a in release.get('assets', [])
                    if a['name'].endswith('.ipa')), None)
        if ipa is None or build_number(ipa) is None:
            continue
        result.append({
            'version': release['tag_name'].removeprefix('v'),
            'buildVersion': build_number(ipa),
            'date': release['published_at'],
            'localizedDescription': (release.get('body') or '').strip()
            or release['tag_name'],
            'downloadURL': ipa['browser_download_url'],
            'size': ipa['size'],
            'minOSVersion': '15.0',
        })
    result.sort(key=lambda v: v['date'], reverse=True)
    return result


def source(releases):
    """Return the AltStore source as a dict."""
    icon = f'{RAW}/assets/icons/stashtube.png'
    apps = []
    found = versions(releases)
    if found:
        apps.append({
            'name': 'StashTube',
            'bundleIdentifier': 'io.github.twoplay.stashtube',
            'developerName': 'Two-Play',
            'subtitle': 'A video app for your own Stash server.',
            'localizedDescription': DESCRIPTION,
            'iconURL': icon,
            'tintColor': TINT,
            'category': 'entertainment',
            'screenshots': [f'{RAW}/docs/images/screenshots/{name}.png'
                            for name in SCREENSHOTS],
            'versions': found,
            'appPermissions': {'entitlements': [], 'privacy': PRIVACY},
        })
    return {
        'name': 'StashTube',
        'identifier': 'io.github.twoplay.stashtube.source',
        'subtitle': 'StashTube releases for AltStore and SideStore.',
        'description': DESCRIPTION,
        'iconURL': icon,
        'website': f'https://github.com/{REPO}',
        'tintColor': TINT,
        'featuredApps': ['io.github.twoplay.stashtube'] if apps else [],
        'apps': apps,
        'news': [],
    }


def main():
    """Read the releases JSON and print the source."""
    with open(sys.argv[1], encoding='utf-8') as file:
        releases = json.load(file)
    # gh api --paginate prints one array per page.
    if releases and isinstance(releases[0], list):
        releases = [r for page in releases for r in page]
    json.dump(source(releases), sys.stdout, indent=2, ensure_ascii=False)
    print()


if __name__ == '__main__':
    main()
