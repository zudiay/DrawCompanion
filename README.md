# MODY AI – Flutter Mobile App

MODY AI is a **local-first Flutter mobile application** developed as part of a university project.  
The app helps users reflect on their drawing practice through uploads, inspiration, and feedback.

This repository contains the **current functional prototype** (UI + navigation + local SQLite database).

---

## Tech Stack

- **Flutter** (UI + application logic)
- **GoRouter** (navigation)
- **SQLite** via **Drift** (local database)
- **Local file storage** for images (paths stored in DB)

No backend is required for the current version.

---

## Project Structure

```

lib/
├── main.dart                 # App entry point
│
├── app/
│   ├── app_router.dart       # Central navigation (GoRouter)
│   └── app_theme.dart        # Global theme configuration
│
├── screens/
│   ├── landing/              # Landing / Home screen
│   ├── progress/             # Progress page
│   └── inspiration/          # Inspiration page
│
├── widgets/
│   └── action_button.dart    # Reusable UI components
│
├── data/
│   └── local/
│       ├── tables.dart       # Drift table definitions
│       ├── app_database.dart # Database setup + queries
│       └── app_database.g.dart (generated)
│
assets/
└── images/                   # App images (e.g. mascot)

````

---

## Navigation

Navigation is handled via **GoRouter**.

- Use `context.push()` for pages that should allow back navigation
- Use `context.go()` for root-level navigation

Defined routes (see `app_router.dart`):

- `/` → Landing screen
- `/upload` → Upload flow (currently placeholder / handled by another team member)
- `/progress` → Progress page
- `/inspiration` → Inspiration page

---

## Local Database (SQLite)

The app uses **Drift** as a typed ORM on top of SQLite.

### Tables

#### `drawing`
| Field        | Type      | Notes                                  |
|-------------|-----------|----------------------------------------|
| id          | int       | Primary key (auto increment)            |
| name        | text      | Drawing name                            |
| description | text?     | Optional description                   |
| category    | text?     | Optional category                      |
| date        | datetime  | Creation date                          |
| image_data  | text      | Path to image stored on device         |

#### `inspo_image`
| Field       | Type | Notes |
|------------|------|-------|
| id         | int  | Primary key |
| name       | text | |
| level      | text | e.g. Beginner, Intermediate |
| technique  | text | e.g. Shading, Perspective |
| description| text?| Optional |

#### `feedback`
| Field          | Type      | Notes |
|---------------|-----------|-------|
| id            | int       | Primary key |
| drawing_id    | int       | References drawing.id |
| creation_date | datetime  | |
| feedbackText  | text?     | Nullable by design |

**Images are NOT stored in the database**  
Only the file path is saved. Image picking and storage are handled elsewhere.

---

## Setup Instructions

### 1) Install dependencies
```bash
flutter pub get
````

### 2) Generate Drift files

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

> Required whenever `tables.dart` changes.

### 3) Run the app

```bash
flutter run
```


## Seed Data (Testing)

The app includes a seed data feature for testing purposes. This automatically populates the database with dummy drawings when enabled.

### Enable Seed Data

1. Open `lib/data/local/seed_data.dart`
2. Change `enabled` from `false` to `true`:
   ```dart
   static const bool enabled = true; // Enable seed data
   ```
3. Run the app - it will automatically create 12 sample drawings with different categories

### Disable Seed Data

Set `enabled` back to `false`:
```dart
static const bool enabled = false; // Disable seed data
```

### Clearing Seed Data

Seed data is automatically skipped if drawings already exist. To clear seed data manually, you can use the `clearSeedData()` method or delete the app data.

**Note:** Seed data uses the brush mascot image as a placeholder. In production, you would want to use actual sample drawings.


---

## Notes

* Upload flow (Camera / Gallery) currently only shows a selection popup
  → Actual image handling left to be handled
* Feedback generation is currently **local / placeholder-ready**

---

## Development Conventions

* Do NOT store large binaries (images) in SQLite
