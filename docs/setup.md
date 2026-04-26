# Setup

This guide starts each runnable part of the BinGo project locally.

## Prerequisites

- Git
- Node.js and npm
- MongoDB database connection string
- Flutter SDK for mobile and standalone Flutter apps
- Google Gemini API key for image classification

The backend README mentions Bun as a recommended package manager, but the checked-in scripts and existing installs work with npm.

## Environment Variables

Create `bingo-backend/.env` for local backend development.

```bash
PORT=5000
MONGODB_URI=mongodb+srv://USER:PASSWORD@HOST/DATABASE
JWT_SECRET=replace-with-a-long-secret
GEMINI_API_KEY=replace-with-gemini-key
```

Important variables:

| Variable | Used by | Required | Notes |
| --- | --- | --- | --- |
| `PORT` | Backend | No | Defaults to `5000` |
| `MONGODB_URI` | Backend | Yes | Backend exits if it is missing |
| `JWT_SECRET` | Backend | Yes | Used when generating and validating JWTs |
| `GEMINI_API_KEY` | Backend | Yes for scan | Required by image classification |
| `API_BASE_URL` | Flutter build/runtime | No | Defaults to `https://qlony.com` in `bingo-mobile/lib/core/env/app_env.dart` |

Do not commit real secrets.

## Install Dependencies

```bash
cd bingo-backend
npm install

cd ../bingo-frontend
npm install

cd ../bingo-mobile
flutter pub get
```

For standalone Flutter apps, run `flutter pub get` inside the specific app root that contains `pubspec.yaml`.

## Run Locally

Start the backend:

```bash
cd bingo-backend
npm run dev
```

Start the web frontend:

```bash
cd bingo-frontend
npm run dev
```

Start the Flutter mobile app against a local backend:

```bash
cd bingo-mobile
flutter run --dart-define=API_BASE_URL=http://localhost:5000
```

For Android emulator networking, use the host address that can reach your machine. Commonly that is `http://10.0.2.2:5000` for the default Android emulator.

## Useful Local URLs

| URL | Purpose |
| --- | --- |
| `http://localhost:5000/api/docs` | Swagger UI |
| `http://localhost:5000/api/docs.json` | OpenAPI JSON |
| `http://localhost:5000/api/...` | REST API base |
| Vite dev URL from terminal | React web app |

The production web app is built into `bingo-frontend/dist` and served by the backend static middleware.
