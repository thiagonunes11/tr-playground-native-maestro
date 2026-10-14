# tr-playground — Maestro tests

End-to-end tests written with [Maestro](https://maestro.dev) for the Android app `com.thiagonunes11.trplayground`.

## Flows

| Flow | What it tests |
|---|---|
| `date-picker.yaml` | Picks a dynamic date (today + 92 days) in the calendar and checks the displayed value |
| `file-download.yaml` | Downloads a PDF, a TXT and a JSON file to `Documents`, checks each file's destination and size, and deletes them at the end |
| `file-upload.yaml` | Uploads `test.mp4` through the file picker and checks its name, size and type |
| `form-inputs.yaml` | Fills the form with random data and checks the Enter counter, the dropdown and the registration message |
| `geo-location.yaml` | Mocks the device location to São Paulo and checks the returned address |

Support folders (not standalone flows):

- `subflows/` — steps reused by other flows; they receive parameters through `env`, so don't run them on their own
- `scripts/` — JavaScript used by `runScript`
- `assets/` — files used by the tests

## Prerequisites

- [Maestro CLI](https://docs.maestro.dev/getting-started/installing-maestro) (tested with 2.10.0)
- An Android 11+ emulator or device connected (`adb devices`) with the system language set to **English** — the flows rely on system texts (`USE THIS FOLDER`, `ALLOW`, month names)
- The app installed (the APK is not in this repository):
  ```sh
  adb install tr-playground-mobile-<version>.apk
  ```
- The upload test file on the device:
  ```sh
  adb push assets/test.mp4 /sdcard/Download/
  ```

## Running

```sh
# all flows
maestro test .

# a single flow
maestro test file-download.yaml
```

Close Maestro Studio before running from the CLI — both compete for the device driver.

## CI

`.github/workflows/e2e.yml` runs every flow on an Android 14 emulator (Pixel 7 profile) on each push to `main`, on pull requests and on demand. The APK is downloaded from the latest [`tr-playground-native` release](https://github.com/thiagonunes11/tr-playground-native/releases) (pre-releases and drafts are skipped), so new app versions are picked up automatically; the tested version is shown in the run summary. To test a specific build, run the workflow manually and set `app_tag`. The JUnit report and Maestro debug output are uploaded as the `maestro-results` artifact.

## Notes

- `file-download.yaml` deletes the downloaded files in `onFlowComplete`, even when the flow fails. Files left behind by an interrupted run make the app save `name (1).ext`, and the destination check fails; in that case run `adb shell rm /sdcard/Documents/sample-*`.
- On Android 11+ the folder picker blocks the storage root and the root of `Download/`, which is why the download flow uses `Documents`.
