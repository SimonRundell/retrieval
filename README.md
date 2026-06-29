# Retrieval Quiz

A classroom quiz tool built for 16-19 year old Further Education students. Teachers create quizzes and launch timed live sessions; students join with just a name and a quiz code -- no account needed.

Two quiz formats are supported:

- **Match Definitions** -- drag-and-drop answers onto question slots
- **Multiple Choice** -- four-button answer selection with immediate feedback

A projector-friendly **Watch** view lets the teacher display a live leaderboard while the quiz is in progress.

---

## Tech Stack

| Layer | Technology |
| --- | --- |
| Frontend | React 18 + Vite 6 |
| Routing | React Router v7 |
| Drag and drop | @dnd-kit/core |
| HTTP client | Axios |
| Backend | PHP (no framework) |
| Database | MariaDB / MySQL |
| Auth | JWT (HS256, pure PHP -- no Composer needed) |
| Dev server | Laragon (Apache + MariaDB on Windows) |

---

## Project Structure

```text
/
├── api/                        PHP REST API endpoints
│   ├── .config.json            Local config (not committed -- see .config.example.json)
│   ├── .config.example.json    Template for the above
│   ├── .htaccess               Passes Authorization header through Apache
│   ├── setup.php               Shared bootstrap: DB, JWT helpers, response utilities
│   ├── getLogin.php            Teacher login, returns JWT
│   ├── getAllQuizzes.php        List all quizzes (teacher dashboard)
│   ├── getQuiz.php             Fetch a single quiz by code
│   ├── insertQuiz.php          Create a new quiz (JWT required)
│   ├── updateQuiz.php          Edit an existing quiz (JWT required)
│   ├── createSession.php       Start a timed session (JWT required)
│   ├── getSession.php          Fetch the current active session for a quiz code
│   ├── updateStatus.php        Record a student score event
│   └── watchStatus.php         Live leaderboard data for the Watch view
│
├── data/
│   ├── schema.sql              Fresh installation schema
│   └── migrate_v2.sql          Upgrade script from the v1 schema
│
├── public/
│   └── .config.json            Frontend config (appName, strapline, api path)
│
└── src/
    ├── App.jsx                 Root component
    ├── App.css                 Full stylesheet (light theme, CSS custom properties)
    ├── main.jsx                Entry point
    ├── styles/
    │   └── variables.css       CSS custom property definitions
    ├── contexts/
    │   ├── AuthContext.jsx     JWT auth state (login, logout, isAuthenticated)
    │   └── ToastContext.jsx    Global toast notification queue
    ├── hooks/
    │   └── useApi.js           Axios instance with automatic Bearer token injection
    ├── router/
    │   ├── AppRouter.jsx       All route definitions
    │   └── ProtectedRoute.jsx  Redirects unauthenticated users to /teacher/login
    ├── components/
    │   ├── ui/                 Reusable UI components (Button, Modal, Spinner, etc.)
    │   └── quiz/               Quiz-specific components (boards, timer, score modal)
    └── pages/
        ├── student/            StudentEntry, QuizPlayer
        └── teacher/            Login, Dashboard, quiz editors, WatchQuiz
```

---

## Installation

### Prerequisites

- [Laragon](https://laragon.org/) (or any Apache + PHP 8.x + MariaDB stack)
- Node.js 20+
- npm 10+

### 1. Clone the repository

```bash
git clone https://github.com/SimonRundell/retrieval.git
cd retrieval
```

### 2. Install JavaScript dependencies

```bash
npm install
```

### 3. Configure the API

Copy the example config and fill in your database credentials:

```bash
cp api/.config.example.json api/.config.json
```

Edit `api/.config.json`:

```json
{
    "servername": "localhost",
    "dbname": "retrieval",
    "username": "your_db_user",
    "password": "your_db_password",
    "jwtSecret": "a_long_random_secret_string"
}
```

The `jwtSecret` can be any long random string -- it signs all teacher authentication tokens.

### 4. Create the database

Import `data/schema.sql` into MariaDB. This creates the `retrieval` database and all four tables, and inserts a default teacher account.

Using the Laragon terminal:

```bash
mysql -u root < data/schema.sql
```

Or import the file via phpMyAdmin or HeidiSQL.

The default teacher account is:

| Field | Value |
| --- | --- |
| Email | `name@school.ac.uk` |
| Password | `1234` |

**Change both the email and password** immediately after first login (update the `passwordHash` column with the MD5 of your new password).

### 5. Vite dev proxy

`vite.config.js` already proxies `/api/*` requests to Apache during development:

```js
server: {
    proxy: {
        '/api': { target: 'http://localhost', changeOrigin: true }
    }
}
```

Make sure Laragon's document root points to the project folder.

### 6. Start the development server

```bash
npm run dev
```

The app will be at `http://localhost:5173`.

---

## Database Schema

Four tables:

| Table | Purpose |
| --- | --- |
| `tbluser` | Teacher accounts. Students are anonymous and have no rows here. |
| `tblquiz` | Quiz definitions. `quizData` is stored as JSON; structure depends on `quizType`. |
| `tblstatus` | One row per student progress event. `watchStatus.php` aggregates by student name. |
| `tblsession` | Timed session records. Students poll `getSession.php` to sync their countdown timer. |

### quizData JSON structure

#### quizType 1 -- Match Definitions

```json
{
    "QuestionSets": [
        {
            "Header": "Set title",
            "QuestionAnswerPairs": [
                { "Question": "...", "Answer": "..." }
            ]
        }
    ]
}
```

Each set contains up to four question/answer pairs. The player works through one set at a time before moving to the next.

#### quizType 2 -- Multiple Choice

```json
[
    {
        "question": "Question text",
        "answers": ["Option A", "Option B", "Option C", "Option D"],
        "correctAnswer": 0
    }
]
```

`correctAnswer` is the zero-based index of the correct option.

---

## Routes

### Student routes (public)

| Path | Description |
| --- | --- |
| `/` | Entry screen -- student enters their name and a quiz code |
| `/quiz/:quizCode` | Quiz player -- renders the correct board for the quiz type |

### Teacher routes (JWT protected)

| Path | Description |
| --- | --- |
| `/teacher/login` | Login form |
| `/teacher` | Dashboard -- list of all quizzes with edit and launch actions |
| `/teacher/quiz/new` | Choose quiz type |
| `/teacher/quiz/new/match` | Create a Match Definitions quiz |
| `/teacher/quiz/new/mc` | Create a Multiple Choice quiz |
| `/teacher/quiz/edit/:quizCode` | Edit an existing quiz (type resolved automatically) |
| `/teacher/quiz/watch/:quizCode` | Projector-friendly live leaderboard |

---

## API Endpoints

All endpoints accept `Content-Type: application/json` via POST. Protected endpoints require an `Authorization: Bearer <token>` header.

| Endpoint | Auth | Description |
| --- | --- | --- |
| `POST /api/getLogin.php` | None | Returns a JWT on successful teacher login |
| `POST /api/getAllQuizzes.php` | None | Returns all quizzes as a JSON array |
| `POST /api/getQuiz.php` | None | Returns one quiz by `quizCode` |
| `POST /api/insertQuiz.php` | Teacher JWT | Creates a new quiz |
| `POST /api/updateQuiz.php` | Teacher JWT | Updates an existing quiz |
| `POST /api/createSession.php` | Teacher JWT | Starts a timed session |
| `POST /api/getSession.php` | None | Returns the active session for a code (404 if none or expired) |
| `POST /api/updateStatus.php` | None | Records a student progress event |
| `POST /api/watchStatus.php` | None | Returns the leaderboard for a quiz code |

---

## Live Session Flow

1. The teacher opens the dashboard and clicks **Launch live session** on a quiz.
2. A modal prompts for the duration (in minutes). On submit, `createSession.php` inserts a row into `tblsession` and the teacher is taken to the Watch view.
3. The Watch view displays a countdown timer and polls `watchStatus.php` every 3 seconds.
4. Students visit the site, enter a name and the quiz code, and start playing.
5. `getSession.php` returns the active session (including server-calculated remaining seconds) to each student. The `QuizTimer` component counts down from that value.
6. When time expires, the student's quiz auto-submits their current score. The leaderboard on the teacher's screen updates within the next poll cycle.

---

## Authentication

Teachers log in with email and password (stored as MD5 hashes in `tbluser.passwordHash`). On success, `getLogin.php` issues a JWT signed with HS256, valid for 24 hours. The token is stored in `localStorage` and injected as a `Bearer` header on every Axios request by `src/hooks/useApi.js`.

JWT verification is handled in `api/setup.php` using PHP's built-in `hash_hmac()` function. No Composer or external library is required.

Students are fully anonymous. They supply a display name and a quiz code only. No row is created in `tbluser`.

---

## Development Notes

- **Vite proxy** -- during development, `/api/*` requests are proxied to Laragon. In production, deploy `api/` alongside the built `dist/` output under the same Apache virtual host so the proxy is not needed.
- **CSS** -- all styles are in `src/App.css`, with design tokens defined in `src/styles/variables.css`. The palette is based on the Exeter College brand colour (`--primary: #0078C2`). No CSS framework is used.
- **`api/.htaccess`** -- required on Apache to prevent the server from stripping the `Authorization` header before PHP can read it.
- **`api/.config.json`** -- excluded from version control. Never commit database credentials or the JWT secret.

---

## Building for Production

```bash
npm run build
```

Upload the contents of `dist/` and the entire `api/` directory to your web host. Ensure `api/.config.json` is present on the server but not publicly accessible -- consider placing it above the web root and updating the path in `setup.php` accordingly.

---

## License

Copyright (c) 2026 Simon Rundell

Released under the [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/).

You are free to share and adapt this material for non-commercial purposes, provided you give appropriate credit and distribute any adaptations under the same license.

[![CC BY-NC-SA 4.0](https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc-sa/4.0/)
