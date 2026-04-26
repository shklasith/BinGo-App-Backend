# BinGo Project Documentation

BinGo is a waste-scanning and recycling companion project. The repository contains an Express/TypeScript API, a React/Vite web app, a Flutter mobile app, and several standalone Flutter feature apps that were built around individual screens or flows.

## Project Map

| Area | Path | Purpose |
| --- | --- | --- |
| Backend API | `bingo-backend/` | Express API, MongoDB models, JWT auth, Gemini image classification, Swagger docs |
| Web frontend | `bingo-frontend/` | React/Vite app served under `/apphome` and protected by local session storage |
| Mobile app | `bingo-mobile/` | Main Flutter app using Riverpod, GoRouter, Dio, and secure storage |
| Standalone Flutter apps | `register/`, `scan/`, `session/`, `map/`, `leaderboard/`, `profile/`, `settings_page/`, `home_page/`, `bingo/` | Feature-specific Flutter projects used as separate app roots or UI references |
| Local merged app | `bingo-merged/` | Current untracked/generated merged Flutter app. Treat it as local work unless it is intentionally committed |

## Architecture

```text
Flutter mobile app / React web app
        |
        | HTTPS REST API with bearer JWT
        v
Express TypeScript backend
        |
        | Mongoose
        v
MongoDB
        |
        | Image classification requests
        v
Google Gemini API
```

The backend also serves the production web frontend from `bingo-frontend/dist` and exposes Swagger documentation at `/api/docs`.

## Documentation Index

- [Setup](setup.md): prerequisites, environment variables, install steps, and local run commands.
- [What BinGo Is and How to Use the App](project-and-app-usage.md): plain-language project explanation and user walkthrough.
- [Backend](backend.md): backend architecture, scripts, database, auth, uploads, and Gemini scan flow.
- [API](api.md): endpoint summary and request/response behavior.
- [Frontend](frontend.md): React/Vite routes, API client, session handling, and build commands.
- [Mobile](mobile.md): Flutter app architecture, routes, repositories, settings sync, and APK build.
- [Flutter Feature Apps](flutter-feature-apps.md): standalone Flutter app roots and how they relate to the main app.
- [Deployment](deployment.md): production build order, runtime checks, and Git workflow.

## Quick Start

```bash
# Backend
cd bingo-backend
npm install
npm run dev

# Web frontend
cd ../bingo-frontend
npm install
npm run dev

# Flutter mobile app
cd ../bingo-mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:5000
```

Use `http://localhost:5000/api/docs` for the backend Swagger UI when the backend is running on its default port.
