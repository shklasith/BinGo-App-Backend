# Deployment and Build Workflow

This project can be deployed as a backend API that also serves the built React frontend. The Flutter mobile app is built separately as an APK or platform-specific artifact.

## Production Build Order

1. Build the web frontend.
2. Build the backend TypeScript output.
3. Start the backend server.

```bash
cd bingo-frontend
npm install
npm run build

cd ../bingo-backend
npm install
npm run build
npm start
```

The backend serves `../bingo-frontend/dist` as static files and falls back to `index.html` for non-API paths.

## Required Backend Environment

```bash
PORT=5000
MONGODB_URI=mongodb+srv://USER:PASSWORD@HOST/DATABASE
JWT_SECRET=replace-with-a-long-secret
GEMINI_API_KEY=replace-with-gemini-key
```

`PORT` can be changed by the hosting environment. `MONGODB_URI`, `JWT_SECRET`, and `GEMINI_API_KEY` should be configured as secrets.

## Runtime Checks

After starting the backend, verify:

```bash
curl http://localhost:5000/api/docs.json
```

Open:

```text
http://localhost:5000/api/docs
```

Then test core API flows:

- register user
- login user
- fetch profile with bearer token
- fetch leaderboard
- fetch daily tip
- scan an image with `multipart/form-data`

## Mobile Release Build

```bash
cd bingo-mobile
flutter pub get
flutter build apk --release
```

APK output:

```text
bingo-mobile/build/app/outputs/flutter-apk/app-release.apk
```

For a non-production API host, pass the API URL at build/run time:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://your-api-host.example.com
```

## Git Workflow For Tasks

The repo instruction for this project is:

1. Pull the latest changes from GitHub before starting work.
2. Make the requested changes.
3. Validate the changes.
4. Commit the task-specific changes.
5. Push the commit back to the repository.

Recommended commands:

```bash
git fetch --all --prune
git pull --ff-only origin main
git status --short

# after edits and validation
git diff --check
git add docs bingo-backend/README.md
git commit -m "docs: add full project documentation"
git push origin main
```

Before staging, check for unrelated untracked files. In the current checkout, `bingo-mobile/GEMINI.md` may exist locally and should not be staged unless it is intentionally part of the task.
