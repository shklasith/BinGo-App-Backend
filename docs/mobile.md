# Mobile App

The main Flutter mobile app lives in `bingo-mobile/`. It is the Android-capable Flutter app used for the integrated BinGo mobile experience.

## Tech Stack

- Flutter SDK `^3.10.7`
- Riverpod for state management
- GoRouter for routing
- Dio for HTTP
- Flutter secure storage for tokens/settings cache
- Image picker, permission handler, and geolocator for scan/location workflows
- Logger for network logging

## Main Structure

| Path | Purpose |
| --- | --- |
| `lib/main.dart` | App entry point |
| `lib/app/app.dart` | Root app widget |
| `lib/app/router.dart` | GoRouter route table |
| `lib/core/env/app_env.dart` | `API_BASE_URL` dart define |
| `lib/core/network/dio_client.dart` | Dio client, token injection, error mapping |
| `lib/data/models/` | API DTOs |
| `lib/data/repositories/` | Repository implementations |
| `lib/domain/entities/` | App domain entities |
| `lib/domain/repositories/` | Repository interfaces |
| `lib/presentation/` | Screens and controllers |

## Routes

| Path | Screen |
| --- | --- |
| `/` | Splash/session screen |
| `/login` | Login |
| `/signup` | Signup |
| `/home` | Home |
| `/scan` | Scan |
| `/scan-result` | Scan result, expects result and image path in route extra |
| `/centers` | Recycling centers |
| `/leaderboard` | Leaderboard |
| `/profile` | Profile |
| `/settings` | Settings |

## API Configuration

`AppEnv.apiBaseUrl` reads:

```dart
String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://qlony.com',
)
```

Run against local backend:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:5000
```

For Android emulator:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000
```

## Session and Networking

The Dio provider:

- uses `AppEnv.apiBaseUrl`
- reads the secure-storage token from `sessionTokenKey`
- adds `Authorization: Bearer <token>` when available
- logs requests, responses, and errors
- maps Dio errors into `ApiException`

## Settings Sync

The mobile settings flow uses:

- `lib/domain/entities/app_settings.dart`
- `lib/domain/repositories/settings_repository.dart`
- `lib/data/repositories/settings_repository_impl.dart`
- `lib/presentation/settings/settings_controller.dart`
- `lib/presentation/settings/settings_screen.dart`

The backend is the source of truth for:

- `darkMode`
- `scanReminders`
- `recyclingTips`

Authenticated users sync through `GET /api/users/settings` and `PATCH /api/users/settings`.

## Android Build

Build a release APK:

```bash
cd bingo-mobile
flutter pub get
flutter build apk --release
```

The release artifact is:

```text
bingo-mobile/build/app/outputs/flutter-apk/app-release.apk
```
