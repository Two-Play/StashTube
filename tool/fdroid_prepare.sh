#!/usr/bin/env bash
# Prepares a checkout for the F-Droid build: without Google Cast, which needs
# Google Play Services (not free software, so not allowed on F-Droid).
#
#   tool/fdroid_prepare.sh [path to flutter]
#
# Changes the working tree (F-Droid builds from a fresh checkout; don't
# commit the result):
# - drops flutter_chrome_cast (the google-cast block) from pubspec.yaml and
#   resolves pubspec.lock again
# - replaces lib/features/cast/google_cast_service.dart with the stub in
#   tool/fdroid/, which reports casting as unsupported
# - removes the google-cast blocks from the Android manifest
# - builds release APKs unsigned (F-Droid signs them itself)
set -euo pipefail

flutter=${1:-flutter}
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

sed -i.bak '/# google-cast:start/,/# google-cast:end/d' pubspec.yaml
sed -i.bak '/<!-- google-cast:start -->/,/<!-- google-cast:end -->/d' android/app/src/main/AndroidManifest.xml
sed -i.bak '/signingConfig = signingConfigs/d' android/app/build.gradle.kts
rm -f pubspec.yaml.bak android/app/src/main/AndroidManifest.xml.bak android/app/build.gradle.kts.bak
cp tool/fdroid/google_cast_service.dart lib/features/cast/google_cast_service.dart

if grep -rq "^ *flutter_chrome_cast:\|package:flutter_chrome_cast\|com.google.android.gms" pubspec.yaml lib android/app/src/main/AndroidManifest.xml; then
  echo "Google Cast is still referenced:" >&2
  grep -rn "^ *flutter_chrome_cast:\|package:flutter_chrome_cast\|com.google.android.gms" pubspec.yaml lib android/app/src/main/AndroidManifest.xml >&2
  exit 1
fi

"$flutter" pub get
echo "Prepared for F-Droid: no Google Cast."
