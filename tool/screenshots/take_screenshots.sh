#!/usr/bin/env bash
# Takes the README screenshots (docs/images/screenshots/) on an iOS simulator
# against the demo Stash from demo_server.sh, which must be running.
#
#   tool/screenshots/take_screenshots.sh ["iPhone 15 Pro"]
set -euo pipefail

device=${1:-iPhone 15 Pro}
cd "$(dirname "$0")/../.."
curl -sf http://localhost:9999/graphql -H 'Content-Type: application/json' \
  -d '{"query":"{ systemStatus { status } }"}' >/dev/null || { echo "Start the demo server first (demo_server.sh)."; exit 1; }

# The same watch history every time (a run plays scenes).
python3 tool/screenshots/seed_demo.py http://localhost:9999 >/dev/null

id=$(xcrun simctl list devices available | grep -m1 "    $device (" | sed -E 's/.*\(([0-9A-F-]{36})\).*/\1/')
xcrun simctl boot "$id" 2>/dev/null || true
xcrun simctl bootstatus "$id" >/dev/null
# A clean status bar, and a fresh app: the run signs in from the start.
xcrun simctl status_bar "$id" override --time 9:41 --batteryState charged --batteryLevel 100 \
  --cellularMode active --cellularBars 4 --wifiBars 3 --dataNetwork wifi
xcrun simctl ui "$id" appearance dark
xcrun simctl uninstall "$id" io.github.two-play.stashtube 2>/dev/null || true

flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshots_test.dart -d "$id"

# Half the device size is plenty for the README.
rm -f docs/images/screenshots/failed.png
for image in docs/images/screenshots/*.png; do sips -Z 1300 "$image" >/dev/null; done
