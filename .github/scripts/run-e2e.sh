#!/usr/bin/env bash
# Runs inside android-emulator-runner, which executes each `script:` line in a separate shell,
# so the whole sequence lives in this file.
set -euo pipefail

# On slow CI emulators system apps (e.g. Pixel Launcher) often ANR right after boot, and the
# "isn't responding" dialog covers the app under test. Hide system error/ANR dialogs and let
# the system settle before starting.
adb shell settings put global hide_error_dialogs 1
adb shell 'while [ "$(getprop init.svc.bootanim)" != "stopped" ]; do sleep 1; done'
adb shell 'for i in $(seq 1 60); do dumpsys activity activities | grep -q "mResumedActivity\|topResumedActivity" && break; sleep 1; done'
sleep 20

adb install -r app.apk
adb push assets/test.mp4 /sdcard/Download/

maestro test . --format junit --output report.xml
