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
│   ├── watchStatus.php         Live leaderboard data for the Watch view
│   ├── getLookups.php          Fetch the standardised Subject/Topic/Year/Unit lists (JWT required)
│   ├── addLookup.php           Add a new standardised value (JWT required)
│   ├── renameLookup.php        Rename a value, cascading into existing quizzes (JWT required)
│   └── deleteLookup.php        Delete a value, refused if still in use (JWT required)
│
├── data/
│   ├── schema.sql              Fresh installation schema
│   ├── migrate_v2.sql          Upgrade script from the v1 schema
│   └── migrate_v3.sql          Adds and seeds tblLookup for existing v2 installs
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
    │   ├── useApi.js           Axios instance with automatic Bearer token injection
    │   └── useLookups.js       Loads the Subject/Topic/Year/Unit lookup lists
    ├── router/
    │   ├── AppRouter.jsx       All route definitions
    │   └── ProtectedRoute.jsx  Redirects unauthenticated users to /teacher/login
    ├── components/
    │   ├── ui/                 Reusable UI components (Button, Modal, Spinner, etc.)
    │   └── quiz/               Quiz-specific components (boards, timer, score modal, LookupSelect)
    └── pages/
        ├── student/            StudentEntry, QuizPlayer
        └── teacher/            Login, Dashboard, quiz editors, WatchQuiz, ManageLookupsModal
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

Import `data/schema.sql` into MariaDB. This creates the `retrieval` database and all five tables, and inserts a default teacher account.

Upgrading an existing v2 database? Run `data/migrate_v3.sql` to add the `tblLookup` table -- it auto-seeds itself from whatever Subject/Topic/Year/Unit values are already in use, so existing quizzes are unaffected.

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

Five tables:

| Table | Purpose |
| --- | --- |
| `tbluser` | Teacher accounts. Students are anonymous and have no rows here. |
| `tblquiz` | Quiz definitions. `quizData` is stored as JSON; structure depends on `quizType`. |
| `tblstatus` | One row per student progress event. `watchStatus.php` aggregates by student name. |
| `tblsession` | Timed session records. Students poll `getSession.php` to sync their countdown timer. |
| `tblLookup` | Standardised Subject/Topic/Year/Unit values, shared across all teachers. `tblquiz` still stores these as plain text; the lookup table just constrains which strings are offered. |

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
| `POST /api/getLookups.php` | Teacher JWT | Returns the Subject/Topic/Year/Unit lookup lists |
| `POST /api/addLookup.php` | Teacher JWT | Adds a new value to a lookup category |
| `POST /api/renameLookup.php` | Teacher JWT | Renames a lookup value, cascading into any quizzes using it |
| `POST /api/deleteLookup.php` | Teacher JWT | Deletes a lookup value (refused with 409 if any quiz still uses it) |

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

## Bulk CSV Import

Teachers can import questions in bulk from an Excel-exported CSV file. The **Import CSV** button appears on the edit page for both quiz types, after the quiz has been saved. The import replaces all existing questions; a preview table with per-row validation is shown before anything is committed.

Save from Excel as **CSV UTF-8 (Comma delimited) (.csv)**. The first row must be the column headings shown below (column name matching is case-insensitive).

### Match Definitions CSV format

| Term | Definition |
| --- | --- |
| Mitosis | Cell division producing two identical daughter cells |
| Meiosis | Cell division producing four genetically unique gametes |

Imported pairs form a flat list. The editor auto-groups them into sets of four.

### Multiple Choice CSV format

| Question | A | B | C | D | Correct |
| --- | --- | --- | --- | --- | --- |
| What is the capital of France? | London | Paris | Berlin | Madrid | B |
| What is H2O? | Salt | Sugar | Water | Oxygen | C |

`Correct` must contain the letter A, B, C, or D corresponding to the correct answer.

---

## Answer Review

After a student completes a quiz, the score modal displays a full question review below the score and feedback message.

**Multiple Choice** — every question is listed in order. A green left border and ✓ mark indicates a correct answer; red and ✗ marks an incorrect one. For wrong answers, the student's choice is shown in red above the correct answer, so they can identify exactly where they went wrong.

**Match Definitions** — all term → definition pairs from every set are listed as a two-column revision reference. Because the game requires every pair to be matched correctly before moving on, all entries are always shown; the hint "Cover one column and test yourself" encourages active recall after the quiz.

---

## Standardised Quiz Metadata & Dashboard Filters

Subject, Topic, Year and Unit are no longer free-text fields. Each is backed by a shared `tblLookup` list, so values stay consistent across every teacher's quizzes instead of drifting ("Yr 12" vs "Year 12" vs "12").

- In the quiz editor, each field is a dropdown populated from the shared list, with a **+ Add new…** option at the bottom -- any teacher can extend the list inline without leaving the editor.
- A **Manage lists** button on the dashboard opens a modal where any teacher can rename or delete values for each category. Renaming cascades into every quiz already using that value; deleting is refused (409) if any quiz still uses it, so metadata never silently disappears from existing quizzes.
- The **My Quizzes** dashboard has a filter bar above the quiz list: a title search box plus a dropdown for each of Subject/Topic/Year/Unit. Filters combine (AND), the quiz count updates to "X of Y quizzes", and a **Clear filters** button resets everything.
- Existing quizzes are unaffected -- `data/migrate_v3.sql` seeds the lookup lists from whatever text values were already saved, so nothing needs re-entering.

---

## Changelog

### 0.1.3 — 2026-07-05

- **Standardised Subject/Topic/Year/Unit lists.** These fields are now dropdowns backed by a shared `tblLookup` table instead of free text, keeping quiz metadata consistent across teachers. See [Standardised Quiz Metadata & Dashboard Filters](#standardised-quiz-metadata--dashboard-filters) above. New endpoints: `getLookups.php`, `addLookup.php`, `renameLookup.php`, `deleteLookup.php`. New migration: `data/migrate_v3.sql`.
- **Dashboard filter bar.** The "My Quizzes" list can now be filtered by title (text search) and by Subject/Topic/Year/Unit (dropdowns), with a live "X of Y" count and a Clear filters button.
- **Manage lists modal.** Any teacher can add, rename or delete standardised values from the dashboard; renames cascade to existing quizzes, deletes are blocked while a value is still in use.
- **Inline CSS removed.** All `style={{ ... }}` props that held static values have been moved into `src/App.css` as reusable classes (utility classes plus a handful of component-specific ones). Only genuinely runtime-computed styles (drag progress-bar widths, the `CMFloatAd` banner's configurable colours) remain inline.

### 0.1.2 — 2026-06-30

- **Answer review on score screen.** After completing a quiz, students see a full question review below their score. Multiple Choice: each question listed with a ✓ or ✗, the student's wrong answer highlighted in red, and the correct answer shown. Match Definitions: all term → definition pairs displayed as a revision reference. The modal widens automatically when review items are present.
- **Leaderboard clear option.** The launch session dialog now offers two choices: *Start fresh* (deletes all existing scores for the quiz before the session begins, the default) or *Keep existing scores* (new results are appended to the current leaderboard — useful when teaching the same quiz to multiple groups). `createSession.php` handles the `clearScores` flag and performs the delete server-side.
- **Prominent quiz code on the Watch screen.** The code is now displayed in large monospace type in the centre of the leaderboard header, with the prompt "Enter this code in the Retrieval app:", making it readable from the back of a classroom.
- **Clipboard error handling.** The copy-code chip on the dashboard now shows an error toast if the Clipboard API is unavailable (e.g. on plain HTTP), rather than failing silently.

### 0.1.1 — 2026-06-29

- Added `CsvImportModal` component: RFC-4180 CSV parser, column format guide with example rows, scrollable preview table with per-row error reporting, and error-count badge.
- Wired **Import CSV** button into `EditMatchQuiz` (card header) and `EditMCQuiz` (editor toolbar).
- Match import: flat list of Term/Definition pairs, auto-grouped into sets of four in the editor.
- Multiple Choice import: Question, A, B, C, D, Correct columns; `Correct` letter mapped to zero-based `correctAnswer` index.

### 0.1.0 — 2026-06-29

Initial release.

- Teacher authentication (JWT, 24-hour expiry, MD5-hashed passwords).
- Teacher dashboard: list all quizzes, copy quiz code, launch timed live session.
- Create and edit Match Definitions quizzes (drag-and-drop, sets of four pairs).
- Create and edit Multiple Choice quizzes (four options, letter-keyed correct answer).
- Student entry page (name + quiz code) and quiz player with server-synced countdown timer.
- Live projector/leaderboard view (WatchQuiz), polling every three seconds.
- Score modal on quiz completion.

---

## License

Copyright (c) 2026 Simon Rundell

Released under the [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/).

You are free to share and adapt this material for non-commercial purposes, provided you give appropriate credit and distribute any adaptations under the same license.

[![CC BY-NC-SA 4.0](https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc-sa/4.0/)
