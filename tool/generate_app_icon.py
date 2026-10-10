#!/usr/bin/env python3
# The mark is a stack of cards with a play button. Needs rsvg-convert
# (`brew install librsvg`) and Pillow. Run from the project root:
#
#     python3 tool/generate_app_icon.py
#
# Writes the iOS AppIcon set, the Android legacy and adaptive launcher icons
# (background, foreground, monochrome for Android 13 themed icons), the in-app preview
# `assets/icons/stashy.png` and the full icon as `tool/app_icon.svg`. For the splash
# screen it writes the mark on its own (`launch_logo` on Android up to 11 and the iOS
# LaunchImage) and the Android 12+ splash icon; the background color (BACKGROUND) is
# set in `res/values/colors.xml` and `LaunchScreen.storyboard`.

"""Generate the app icon and the splash screen for iOS and Android."""

import io
import subprocess  # nosec B404: only runs rsvg-convert with fixed arguments
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
# Top and bottom of the background gradient (both rgb(17, 17, 17): solid).
BACKGROUND = ('#111111', '#111111')
CARD = '#3A8DFF'

# The mark in a 100×100 box: two cards behind a front card with a play button.
MARK = '''
<defs>
  <mask id="play" maskUnits="userSpaceOnUse" x="0" y="0" width="100" height="100">
    <rect width="100" height="100" fill="#fff"/>
    <polygon points="44,51 44,69 59,60" fill="#000" stroke="#000" stroke-width="5" stroke-linejoin="round"/>
  </mask>
  <!-- Each card hides the one behind it, with a small gap, so the translucent cards don't overlap. -->
  <mask id="behindMid" maskUnits="userSpaceOnUse" x="0" y="0" width="100" height="100">
    <rect width="100" height="100" fill="#fff"/>
    <rect x="21" y="28" width="58" height="10" rx="5" fill="#000" stroke="#000" stroke-width="3"/>
  </mask>
  <mask id="behindFront" maskUnits="userSpaceOnUse" x="0" y="0" width="100" height="100">
    <rect width="100" height="100" fill="#fff"/>
    <rect x="14" y="36" width="72" height="48" rx="10" fill="#000" stroke="#000" stroke-width="3"/>
  </mask>
</defs>
<rect x="28" y="20" width="44" height="12" rx="4" fill="{card}" fill-opacity=".45" mask="url(#behindMid)"/>
<rect x="21" y="28" width="58" height="12" rx="5" fill="{card}" fill-opacity=".75" mask="url(#behindFront)"/>
{front}
'''

# The front card: filled with the card color and a white play button, or (for
# the monochrome icon) with the play button cut out.
FRONT_COLOR = '''
<rect x="14" y="36" width="72" height="48" rx="10" fill="{card}"/>
<polygon points="44,51 44,69 59,60" fill="#fff" stroke="#fff" stroke-width="5" stroke-linejoin="round"/>
'''
FRONT_CUTOUT = '<rect x="14" y="36" width="72" height="48" rx="10" fill="#fff" mask="url(#play)"/>'


def background(size):
    return (
        f'<linearGradient id="bg" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="0" y2="{size}">'
        f'<stop offset="0" stop-color="{BACKGROUND[0]}"/><stop offset="1" stop-color="{BACKGROUND[1]}"/>'
        f'</linearGradient><rect width="{size}" height="{size}" fill="url(#bg)"/>'
    )


def svg(size, transform=None, with_background=False, monochrome=False):
    card = '#fff' if monochrome else CARD
    front = FRONT_CUTOUT if monochrome else FRONT_COLOR.format(card=card)
    mark = MARK.format(card=card, front=front)
    bg = background(size) if with_background else ''
    content = f'<g transform="{transform}">{mark}</g>' if transform else ''
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {size} {size}">{bg}{content}</svg>'


# Full icon: the mark centered (its box is 72×64 at y 20–84).
FULL = svg(100, 'translate(0 -2)', with_background=True)
# Adaptive layers are 108 dp with a 66 dp safe zone in the middle.
ADAPTIVE = 'translate(54 54) scale(.62) translate(-50 -52)'
BACKGROUND_LAYER = svg(108, with_background=True)
FOREGROUND = svg(108, ADAPTIVE)
MONOCHROME = svg(108, ADAPTIVE, monochrome=True)
# Splash: the mark without background, 128 dp/pt wide.
SPLASH_LOGO = svg(100, 'translate(0 -2)')
SPLASH_LOGO_SIZE = 128
# Android 12+ splash icon: 288 dp, the visible part a circle of 192 dp in the middle.
SPLASH_ICON = svg(288, 'translate(144 144) scale(1.6) translate(-50 -52)')


def render(source, px, opaque=False):
    # A fixed command; the input is this script's own SVG.
    png = subprocess.run(  # nosec B603
        ['rsvg-convert', '-w', str(px), '-h', str(px)],
        input=source.encode(),
        capture_output=True,
        check=True,
    ).stdout
    image = Image.open(io.BytesIO(png))
    # The App Store rejects icons with an alpha channel.
    return image.convert('RGB') if opaque else image


def save(source, px, path, opaque=False):
    path.parent.mkdir(parents=True, exist_ok=True)
    render(source, px, opaque).save(path, optimize=True)


def main():
    (ROOT / 'tool/app_icon.svg').write_text(FULL + '\n')

    ios = ROOT / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
    for file in ios.glob('Icon-App-*.png'):
        # Icon-App-83.5x83.5@2x.png -> 83.5 * 2
        points, scale = file.stem.removeprefix('Icon-App-').split('@')
        px = round(float(points.split('x')[0]) * int(scale.removesuffix('x')))
        save(FULL, px, file, opaque=True)

    res = ROOT / 'android/app/src/main/res'
    densities = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}
    for density, factor in densities.items():
        folder = res / f'mipmap-{density}'
        save(FULL, round(48 * factor), folder / 'ic_launcher.png', opaque=True)
        save(BACKGROUND_LAYER, round(108 * factor), folder / 'ic_launcher_background.png', opaque=True)
        save(FOREGROUND, round(108 * factor), folder / 'ic_launcher_foreground.png')
        save(MONOCHROME, round(108 * factor), folder / 'ic_launcher_monochrome.png')

    save(FULL, 192, ROOT / 'assets/icons/stashy.png', opaque=True)

    # Splash screen.
    for density, factor in densities.items():
        folder = res / f'drawable-{density}'
        save(SPLASH_LOGO, round(SPLASH_LOGO_SIZE * factor), folder / 'launch_logo.png')
        save(SPLASH_ICON, round(288 * factor), folder / 'splash_icon.png')
    launch = ROOT / 'ios/Runner/Assets.xcassets/LaunchImage.imageset'
    for suffix, scale in (('', 1), ('@2x', 2), ('@3x', 3)):
        save(SPLASH_LOGO, SPLASH_LOGO_SIZE * scale, launch / f'LaunchImage{suffix}.png')


if __name__ == '__main__':
    main()
