# Frontend

The web frontend lives in `bingo-frontend/`. It is a React 19 and Vite app with React Router routes, Axios API calls, and localStorage-backed session handling.

## Scripts

Run these inside `bingo-frontend/`.

```bash
npm run dev       # Vite dev server
npm run build     # TypeScript check and production build
npm run lint      # ESLint
npm run preview   # Preview production build
```

## App Structure

| Path | Purpose |
| --- | --- |
| `src/App.tsx` | Router setup and auth guards |
| `src/components/layout/AppLayout.tsx` | Authenticated app shell |
| `src/lib/api.ts` | Axios client and auth/error interceptors |
| `src/lib/session.ts` | localStorage session helpers |
| `src/pages/` | Main route pages |
| `src/pages/auth/` | Login and signup screens |

## Routes

The app uses `BrowserRouter` with `basename="/apphome"`.

| Route | Page | Auth |
| --- | --- | --- |
| `/login` | Login | Public, redirects away if session exists |
| `/signup` | Signup | Public, redirects away if session exists |
| `/` | Home | Protected |
| `/scan` | Scan | Protected |
| `/scan/result` | Scan result | Protected |
| `/map` | Map | Protected |
| `/leaderboard` | Leaderboard | Protected |
| `/profile` | Profile | Protected |

Unknown routes redirect to `/`.

## API Client

`src/lib/api.ts` creates an Axios client with:

- `baseURL: "https://qlony.com"`
- 20 second timeout
- bearer token injection from localStorage session
- `401` handling that clears the local session and redirects to login

The session shape is:

```ts
interface UserSession {
  userId: string;
  token: string;
}
```

It is stored in localStorage under `bingo_web_session`.

## Production Serving

Run:

```bash
cd bingo-frontend
npm run build
```

The output goes to `bingo-frontend/dist`. The backend serves this directory through static middleware and falls back to `index.html` for non-API routes.
