# Backend

The backend lives in `bingo-backend/`. It is an Express 5 and TypeScript API using MongoDB through Mongoose. It handles authentication, user profile/settings, image scan classification, recycling center lookup, education tips, Swagger documentation, and serving the built React frontend.

## Main Files

| File | Purpose |
| --- | --- |
| `src/server.ts` | Loads env vars, connects to MongoDB, starts the server |
| `src/app.ts` | Express app, middleware, Swagger setup, API routes, static frontend serving |
| `src/config/database.ts` | Mongoose connection from `MONGODB_URI` |
| `src/middleware/auth.ts` | JWT bearer-token protection |
| `src/models/User.ts` | User, points, impact stats, settings, password hashing |
| `src/models/ScanHistory.ts` | Saved scan classification records |
| `src/models/Center.ts` | Recycling center data with `2dsphere` location index |
| `src/services/gemini.service.ts` | Gemini image analysis integration |

## Scripts

Run these inside `bingo-backend/`.

```bash
npm run dev     # ts-node src/server.ts
npm run build   # tsc
npm start       # node dist/server.js
```

## Runtime Behavior

The backend applies:

- `helmet()` for security headers.
- `cors()` for cross-origin requests.
- `express.json()` for JSON request bodies.
- `morgan("dev")` for request logging.
- Static `/uploads` serving from the backend uploads directory.
- Static serving for `../bingo-frontend/dist`.
- SPA fallback to `bingo-frontend/dist/index.html` for non-API routes.

Swagger is configured in `src/app.ts` and reads OpenAPI annotations from `src/routes/*.ts` or compiled `src/routes/*.js`.

## Database

MongoDB is required. `src/config/database.ts` reads `MONGODB_URI`; if the value is missing or connection fails, the backend logs the error and exits.

Models:

- `User`: `username`, `email`, `passwordHash`, `points`, `badges`, `settings`, and `impactStats`.
- `ScanHistory`: `userId`, `imageUrl`, `classificationResult`, optional `location`, and `pointsEarned`.
- `Center`: center name, address, GeoJSON point, accepted materials, operating hours, and contact number.

Passwords are stored in `passwordHash` and hashed through a Mongoose pre-save hook.

## Authentication

Registration and login return a JWT token. Protected endpoints require:

```http
Authorization: Bearer <token>
```

The auth middleware attaches the authenticated user to the request, and protected controllers use `req.user`.

## Image Scan Flow

1. `POST /api/scan` accepts one multipart image field named `image`.
2. `multer` writes a temporary file into the backend uploads directory.
3. `analyzeWasteImage()` sends the image to Gemini model `gemini-2.0-flash`.
4. The temporary file is deleted after analysis.
5. The backend awards points by category:
   - `Recyclable`, `Compost`, `E-Waste`: 10 points
   - `Special`: 15 points
   - `Landfill`: 2 points
   - `Unknown` or other categories: 0 points
6. A `ScanHistory` record is created and the user's points/impact stats are updated.

`GEMINI_API_KEY` must be configured before scan requests can succeed.

## API Documentation

When the backend runs on the default port:

- Swagger UI: `http://localhost:5000/api/docs`
- OpenAPI JSON: `http://localhost:5000/api/docs.json`

If `PORT` is changed, use that port instead.
