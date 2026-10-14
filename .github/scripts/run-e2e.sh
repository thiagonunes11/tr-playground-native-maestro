#!/usr/bin/env bash
# Runs inside android-emulator-runner, which executes each `script:` line in a separate shell,
# so the whole sequence lives in this file.
set -euo pipefail

adb install -r app.apk
adb push assets/test.mp4 /sdcard/Download/

maestro test . --format junit --output report.xml
