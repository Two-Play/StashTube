# StashTube 1.0.0-beta.9

Pre-release. The pipeline picks the version (next beta after `v1.0.0-beta.8`).

## What's new

- **Back where you were** – lists keep their place when you turn the phone for fullscreen and come back to them.
- **Favorites** – the avatars at the top pick "All" or one performer (a long press opens the channel), with a header and "View channel".
- **Zoom snap feedback** – "Original" and "Fill" show when the pinch zoom snaps, and guide lines where the picture snaps to the center or an edge.
- **PIN with biometrics** – changing the PIN or turning the app lock off also accepts Face ID or the fingerprint, so a forgotten PIN can be replaced.
- **Proxy warning** – a banner names both addresses when the server hands out media URLs on another address than the one StashTube connects to (a reverse proxy without `Host` / `X-Forwarded-Proto`), and how to fix it.

## Security

- The API key and the session cookie only go to the server's own address (scheme, host and port): never to media URLs pointing elsewhere, and not along a redirect that leaves the server.
- The PIN is stored as PBKDF2-HMAC-SHA256. PINs of earlier versions keep working and are converted after the next correct entry.
- If the PIN can't be read (e.g. after restoring a backup), the app stays locked instead of opening: biometrics lead to a new PIN, otherwise the app can be reset.
- A password in a server address (`https://user:pass@host`) is kept in the secure storage instead of the settings; existing servers move on the first start.

## Fixes and internals

- GraphQL responses are no longer written into a cache that was never read.
- The preview check stops after the status instead of downloading whole files from servers that ignore `Range`.
- The password login gives up after 20 s instead of waiting forever.

## Not tested on a device yet

Proxy warning on a misconfigured server, the lost-PIN screen, and upgrading a PIN set by beta.8 or earlier.
