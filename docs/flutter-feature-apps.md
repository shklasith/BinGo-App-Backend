# Flutter Feature Apps

This repository contains multiple Flutter app roots. The canonical integrated mobile app is `bingo-mobile/`; the other Flutter projects are standalone feature apps or UI references.

## App Roots

| Feature | Path | Notes |
| --- | --- | --- |
| Main mobile app | `bingo-mobile/` | Integrated Flutter app with backend API support |
| Register | `register/flutter_projects/bingo_app/` | Standalone register flow app |
| Scan | `scan/flutter_project11/bingo_app/` | Standalone scan flow app |
| Session | `session/flutter-projects/bingo_mobile_app/` | Standalone session/auth-related app |
| Map | `map/flutter_project10/bingo_app/` | Standalone map/navigation reference |
| Leaderboard | `leaderboard/bingo/leaderboard/` | Standalone leaderboard app |
| Profile | `profile/Flutter_tharaa/bingo_app/` | Standalone profile app |
| Settings | `settings_page/settings_page/settings_page/` | Standalone settings page app |
| Home page | `home_page/home_page_bingo 1/home_page_bingo/home_page/` | Standalone home page app |
| Bingo | `bingo/` | Additional Flutter project root |

Each listed app has its own `pubspec.yaml` and should be treated as a separate Flutter project when running `flutter pub get`, `flutter run`, or `flutter build`.

## Local Merged App

`bingo-android-app/` is the merged Flutter app for Android-focused testing and is wired to the local backend by default.

Use `bingo-mobile/` for the separate integrated mobile app unless a task explicitly targets `bingo-android-app/`.

## Working With Feature Apps

To run a standalone app:

```bash
cd register/flutter_projects/bingo_app
flutter pub get
flutter run
```

Replace the path with the specific feature app root.

When copying ideas from a standalone feature app into `bingo-mobile/`, verify:

- route names and navigation behavior
- API integration expectations
- state-management pattern
- package dependencies in `pubspec.yaml`
- Android/iOS platform configuration if the feature needs native permissions
