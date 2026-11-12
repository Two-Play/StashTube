# StashTube 1.0.0-beta.8

Pre-release. The pipeline picks the version (next beta after `v1.0.0-beta.7`).

## What's new

- **Subtitles** – pick the captions your Stash has for a video from the new button in the player's top bar. The language is remembered for the next videos. The built-in demo has English and German subtitles to try it.
- **Zoom without black bars** – spread two fingers to fill the whole screen. The zoom grows continuously (up to 4×) and snaps at the fitted size and at full width/height, the position snaps to the center and the edges, each with a light haptic tick. Works inline, in fullscreen and after turning the phone.
- **Double tap to skip** – a half disc over the tapped side (like YouTube) with the total jump, fading in and out.
- **Playback** – videos can buffer fully before playing, position and picture are kept when you return to the app, the position is saved at once, a countdown runs before the next video of a queue, and the current frame can be saved.
- **Feedback and bugs** – Settings → About opens the GitHub issue forms.

## Fixes and internals

- CI: generated l10n files regenerated with the CI's Flutter version (the generated-files check failed on `develop`).
- The pinch zoom is drawn by Flutter instead of mpv (`video-zoom` stays inside the video's rectangle); the controls keep their size.

## Issues

Closes #57 (subtitles) and #58 (zoom/crop).

## Not tested on a device yet

Pinch snapping and haptics (inline, fullscreen, turning), the skip half disc, subtitles on a real server, buffering and the queue countdown.
