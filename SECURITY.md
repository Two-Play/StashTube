# Security policy

Stashy handles access to your own media server: server addresses, API keys, passwords and, with the app lock, a PIN. Reports about weaknesses are very welcome.

## Supported versions

Stashy is in beta. Security fixes go into the next release; older releases are not patched.

| Version | Supported |
| --- | --- |
| Latest release or pre-release | Yes |
| Anything older | No, please update |

## Reporting a vulnerability

> [!IMPORTANT]
> Please don't open a public issue for a security problem.

Report it privately through GitHub instead:

1. Open the repository's [**Security** tab](https://github.com/Two-Play/StashAppMobile/security).
2. Choose [**Report a vulnerability**](https://github.com/Two-Play/StashAppMobile/security/advisories/new).
3. Describe the problem, how to reproduce it, the app version and platform (Android or iOS), and what an attacker could do with it.

Stashy is maintained in spare time. You'll usually get an answer within a week; a fix and a release follow as soon as possible, depending on how serious the problem is. Once it is fixed, the advisory is published and you are credited, unless you'd rather not be.

## Scope

In scope:

- the Stashy app for Android and iOS (this repository)
- how it stores and sends credentials: API keys, passwords, session cookies, the app lock PIN
- the app lock, the app switcher cover and the other privacy features
- the release builds, their signing and the release workflow

Not in scope:

- the Stash server itself: please report those to the [Stash project](https://github.com/stashapp/stash/security)
- problems that need an unlocked phone with the app already open, or root/jailbreak access
- builds that were not downloaded from this repository's releases

## How Stashy protects your data

This is how it is meant to work; reports that show otherwise are exactly what we're looking for.

- **Credentials:** API keys and passwords are stored in the system's secure storage (Keychain on iOS, Keystore-backed storage on Android), not in the app's regular settings.
- **App lock PIN:** only a salted SHA-256 hash is stored, never the PIN.
- **App switcher and lock:** with the app lock or "Hide in app switcher" on, the app is covered while inactive and in the app switcher; on Android, FLAG_SECURE also blocks screenshots.
- **Network:** Stashy connects only to the server you enter. It has no analytics and uses no other services.
- **Releases:** every APK is signed with the same key (certificate fingerprint starting `F0:19:71:FF:8A:13:80:A8`) and listed with its checksum in `SHA256SUMS`.

> [!WARNING]
> Some things are by design and not vulnerabilities, but good to know:
>
> - Plain `http://` is allowed, for servers on the home network. Making Stash reachable from the internet is not recommended; use a VPN to reach it from outside. If you expose it anyway, use `https://`, or your API key or password travels unencrypted.
> - Casting to a Chromecast or AirPlay device puts the API key into the stream URL, because these devices can't send headers.
> - With a server that needs no login, anyone who can reach the server can use it, with or without Stashy.
