# API

The backend API is mounted under `/api`. Most responses follow:

```json
{
  "success": true,
  "data": {}
}
```

Errors usually return:

```json
{
  "success": false,
  "message": "Error message"
}
```

Protected endpoints require a bearer token:

```http
Authorization: Bearer <token>
```

## Users

| Method | Path | Auth | Purpose |
| --- | --- | --- | --- |
| `POST` | `/api/users/register` | No | Create a user and return user data with JWT |
| `POST` | `/api/users/login` | No | Authenticate with email/password and return JWT |
| `GET` | `/api/users/leaderboard` | No | Return top 10 users sorted by points |
| `GET` | `/api/users/profile` | Yes | Return the authenticated user's profile |
| `GET` | `/api/users/settings` | Yes | Return the authenticated user's settings |
| `PATCH` | `/api/users/settings` | Yes | Update settings booleans |
| `GET` | `/api/users/:userId` | Yes | Return a user profile by MongoDB ObjectId |

Register body:

```json
{
  "username": "greenHero",
  "email": "hero@example.com",
  "password": "MyStr0ngP@ss"
}
```

Login body:

```json
{
  "email": "hero@example.com",
  "password": "MyStr0ngP@ss"
}
```

Settings keys:

```json
{
  "darkMode": false,
  "scanReminders": true,
  "recyclingTips": true
}
```

`PATCH /api/users/settings` rejects unknown fields and non-boolean values.

## Scan

| Method | Path | Auth | Purpose |
| --- | --- | --- | --- |
| `POST` | `/api/scan` | Yes | Upload and classify a waste image |

Request format:

- `multipart/form-data`
- Required file field: `image`

Response data includes:

- `classification`
- `pointsEarned`
- `scanId`
- `newTotalPoints`

Classification categories are `Recyclable`, `Compost`, `E-Waste`, `Landfill`, `Special`, and `Unknown`.

## Centers

| Method | Path | Auth | Purpose |
| --- | --- | --- | --- |
| `GET` | `/api/centers/nearby?lat=6.9271&lng=79.8612&radius=5000` | No | Find nearby recycling centers |
| `POST` | `/api/centers/seed` | No | Testing helper that replaces centers with dummy Colombo data |

`lat` and `lng` are required. `radius` is optional and defaults to `5000` meters.

## Education

| Method | Path | Auth | Purpose |
| --- | --- | --- | --- |
| `GET` | `/api/education/daily-tip` | No | Return a random recycling tip |
| `GET` | `/api/education/search?q=recycling` | No | Search tip titles and content |

## Docs

| Method | Path | Purpose |
| --- | --- | --- |
| `GET` | `/api/docs` | Swagger UI |
| `GET` | `/api/docs.json` | OpenAPI JSON |

Use the Swagger UI for the most detailed route-level schemas.
