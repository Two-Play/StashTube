# F-Droid build

F-Droid only ships free software, and Google Cast needs Google Play Services. So the F-Droid build leaves Chromecast out; everything else is the same app. Every GitHub release also has this variant, signed with the release key, as `stashtube-<tag>-foss.apk` (for IzzyOnDroid and people without Play Services).

> [!WARNING]
> Not submittable yet: `media_kit_libs_android_video` downloads prebuilt libmpv libraries (`.jar`s from `media-kit/libmpv-android-video-build`) during the build, and F-Droid builds everything from source without network access. The recipe would need to build libmpv from source first (for example as a srclib with that repository's build scripts).

- `tool/fdroid_prepare.sh [flutter]` turns a checkout into that build: it drops `flutter_chrome_cast` (the `google-cast` blocks in `pubspec.yaml` and the Android manifest), puts `google_cast_service.dart` from this folder in place of the real one, so casting reports itself as unsupported and the cast button doesn't show, removes the release signing (F-Droid signs itself) and runs `flutter pub get`. Don't commit the result.
- `io.github.two_play.stashappmobile.yml` is a template for the recipe in [fdroiddata](https://gitlab.com/fdroid/fdroiddata), which runs the script in `prebuild`.

## Trying it locally

```bash
git worktree add ../stashtube-fdroid HEAD
cd ../stashtube-fdroid
tool/fdroid_prepare.sh
flutter build apk --release
# No Google classes may be left:
unzip -p build/app/outputs/flutter-apk/app-release.apk 'classes*.dex' \
  | LC_ALL=C grep -a -o 'Lcom/google/android/gms/[a-z/]*\|Lcom/felnanuke[a-z/]*' | sort -u
```

The last command should print nothing; the same check on a normal build lists `com/google/android/gms/cast/…`.

## Submitting

1. Fork fdroiddata, copy the template to `metadata/io.github.two_play.stashappmobile.yml` and set the build entry to the newest tag (`versionName`, `versionCode` = the number after `+` in `pubspec.yaml`, `commit`).
2. Check it with fdroidserver: `fdroid readmeta`, `fdroid lint io.github.two_play.stashappmobile`, `fdroid build -v -l io.github.two_play.stashappmobile`.
3. Open a merge request; the F-Droid maintainers review it.

F-Droid signs the app with its own key, so the F-Droid version and the GitHub releases (Obtainium) can't update each other: switching means uninstalling first. When the code changes, keep `tool/fdroid/google_cast_service.dart` in step with the public API of `lib/features/cast/google_cast_service.dart`.
