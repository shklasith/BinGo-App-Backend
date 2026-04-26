# What BinGo Is and How to Use the App

## What This Project Is

BinGo is a recycling and waste-management app. Its main job is to help a user take a photo of an item, understand what type of waste it is, learn how to prepare it for disposal, find nearby recycling centers, and track recycling progress with points and leaderboard rankings.

The project has three main working parts:

| Part | What it does |
| --- | --- |
| Flutter mobile app | The main user app for login, scanning waste, viewing results, finding centers, checking leaderboard, and managing profile/settings |
| Express backend API | Stores users, handles login, awards points, talks to MongoDB, and sends scan images to Gemini AI for classification |
| React web frontend | Web version/admin-style frontend that uses the same backend API and session token pattern |

The repository also includes separate Flutter feature apps. Those are smaller app roots for individual screens or flows, such as register, scan, map, leaderboard, profile, settings, and home. The integrated app that should normally be used is `bingo-mobile/`.

## What Problem It Solves

Many users do not know whether an item is recyclable, compostable, e-waste, landfill waste, or a special disposal item. BinGo makes that easier by:

- letting the user scan or upload a photo of the item
- using AI to classify the item
- showing preparation steps, such as rinse, remove cap, or separate parts
- awarding points for responsible waste actions
- showing nearby recycling drop-off centers
- encouraging users through leaderboard and profile progress

## Main App Users

The app is mainly for people who want quick help with recycling decisions. A user can:

- create an account
- log in securely
- scan waste items
- see disposal instructions
- find recycling centers
- track points and impact
- compare progress on the leaderboard
- manage settings such as dark mode, scan reminders, and recycling tips

## How The App Works

```text
User opens mobile app
        |
        v
Login or sign up
        |
        v
Home screen shows tips, search, quick guide, and nearby center shortcut
        |
        v
User scans an item with camera or gallery
        |
        v
Backend sends image to Gemini AI
        |
        v
App shows category, confidence, preparation steps, and points
        |
        v
User can check centers, leaderboard, profile, and settings
```

## How To Use The Mobile App

### 1. Open The App

Run or install the Flutter app from `bingo-mobile/`. The app starts at the splash/session screen. If the user already has a saved token, the app can continue into the main experience. Otherwise the user goes to login or signup.

### 2. Create Account Or Login

Use signup to create a new account with username, email, and password. Use login for an existing account. After successful login, the app stores the session token securely and uses it for protected backend requests.

### 3. Use The Home Screen

The home screen gives the user:

- a daily recycling tip
- search for recycling advice
- a quick guide for common categories like plastic, glass, paper, and e-waste
- a nearby center shortcut

The home screen is the starting point for normal app usage.

### 4. Scan Waste

Open the scan screen and choose:

- camera button to take a new photo
- gallery button to select an existing image

The app sends the image to the backend. The backend requires the user to be logged in, then uses Gemini AI to classify the item.

### 5. Read Scan Result

After scanning, the result screen shows:

- waste category
- confidence percentage
- disposal label
- preparation steps
- points earned through the backend

Supported categories are:

- `Recyclable`
- `Compost`
- `E-Waste`
- `Landfill`
- `Special`
- `Unknown`

### 6. Find Nearby Centers

Open the centers screen and tap the location button. The app requests location permission, gets the current location, and calls the backend nearby-center API.

The screen can show:

- number of nearby centers
- center name
- address
- operating hours

### 7. Check Leaderboard

The leaderboard screen shows top recyclers sorted by points. This makes the app more engaging by letting users compare progress.

### 8. View Profile

The profile screen shows:

- username
- points-based progress
- scanned item count estimate
- badges
- profile actions

The profile screen also has the settings button.

### 9. Change Settings

Open settings from the profile screen. The settings are synced with the backend for logged-in users:

- dark mode
- scan reminders
- recycling tips

### 10. Logout

The profile screen includes logout. Logging out clears the saved local session and returns the user to login.

## How The Backend Supports The App

The backend is responsible for:

- registering users
- logging in users
- validating JWT bearer tokens
- storing user points, badges, settings, and impact stats
- receiving scan image uploads
- sending images to Gemini AI
- saving scan history
- awarding points based on scan category
- returning nearby recycling centers
- returning education tips
- returning leaderboard data

The backend API documentation is available at:

```text
http://localhost:5000/api/docs
```

when the backend runs on the default port.

## How To Run The App Locally

Start the backend:

```bash
cd bingo-backend
npm install
npm run dev
```

Start the mobile app:

```bash
cd bingo-mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:5000
```

For Android emulator, use:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000
```

The backend needs these environment variables:

```bash
PORT=5000
MONGODB_URI=your-mongodb-uri
JWT_SECRET=your-jwt-secret
GEMINI_API_KEY=your-gemini-api-key
```

## Simple Demo Flow

Use this flow to demonstrate the app:

1. Start backend with MongoDB and Gemini key configured.
2. Run the Flutter mobile app.
3. Sign up a new user.
4. Open Home and view the daily tip.
5. Open Scan and choose an item photo.
6. Wait for AI analysis.
7. Read the disposal category and preparation steps.
8. Open Leaderboard and confirm points were added.
9. Open Centers and load nearby recycling centers.
10. Open Profile, then Settings, and change a preference.

## Important Notes

- `bingo-mobile/` is the main integrated Flutter app.
- The web frontend lives in `bingo-frontend/`.
- The backend lives in `bingo-backend/`.
- Standalone Flutter app folders are useful references but should not be confused with the main mobile app.
- `bingo-merged/` is currently a local untracked generated app, so treat it as local work unless it is intentionally committed.
