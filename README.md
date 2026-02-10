# MODY AI – Flutter Mobile App

MODY AI is a **local-first Flutter application** developed as part of a university project.  
The app helps users reflect on their drawing practice through uploads, inspiration, progress tracking, and feedback.

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
├── main.dart                   # App entry point
│
├── app/
│   ├── app_router.dart         # Central navigation (GoRouter)
│   └── app_theme.dart          # Global theme configuration
│
├── screens/
│   ├── landing/                # Landing / Home screen
│   ├── upload/                 # Upload flow (selection + future camera/gallery)
│   ├── progress/               # Progress page(s)
│   ├── inspiration/            # Inspiration browsing page(s)
│   ├── feedback/               # Feedback screen(s)
│   └── drawing_details/        # Drawing detail view(s)
│
├── widgets/                    # Reusable UI components
│
├── data/
│   └── local/
│       ├── tables.dart         # Drift table definitions
│       ├── app_database.dart   # Database setup + queries
│       ├── seed_data.dart      # Optional seed data for testing
│       └── app_database.g.dart # Generated (build_runner)
│
assets/
└── images/
├── backgrounds/            # Background assets
├── inspiration/            # Inspiration images
│   ├── abstract/
│   ├── nature/
│   └── portraits/
├── modern/                 # Additional UI/illustration assets
└── progress_seed/          # Placeholder/seed images for progress testing

android/                        # Android platform project
ios/                            # iOS platform project
macos/                          # macOS platform project
linux/                          # Linux platform project
windows/                        # Windows platform project
web/                            # Web platform project (icons, etc.)
test/                           # Unit/widget tests

````

---

## Navigation

Navigation is handled via **GoRouter**.

- Use `context.push()` for pages that should allow back navigation
- Use `context.go()` for root-level navigation

Routes are defined in `lib/app/app_router.dart`.

---

## Local Database (SQLite)

The app uses **Drift** as a typed ORM on top of SQLite.

### Tables

#### `drawing`
| Field        | Type      | Notes                          |
|-------------|-----------|--------------------------------|
| id          | int       | Primary key (auto increment)   |
| name        | text      | Drawing name                   |
| description | text?     | Optional description           |
| category    | text?     | Optional category              |
| date        | datetime  | Creation date                  |
| image_data  | text      | Path to image stored on device |

#### `inspo_image`
| Field        | Type | Notes |
|-------------|------|-------|
| id          | int  | Primary key |
| name        | text | |
| level       | text | e.g. Beginner, Intermediate |
| technique   | text | e.g. Shading, Perspective |
| description | text?| Optional |

#### `feedback`
| Field          | Type      | Notes |
|---------------|-----------|-------|
| id            | int       | Primary key |
| drawing_id    | int       | References drawing.id |
| creation_date | datetime  | |
| feedbackText  | text?     | Nullable by design |

**Images are NOT stored in the database**  
Only the file path is saved. Image picking and storage are handled separately.

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

> Run this whenever `tables.dart` changes.

### 3) Run the app

```bash
flutter run
```

---

## Seed Data (Testing)

The app includes an optional seed feature for testing purposes (dummy drawings / placeholder data).

### Enable Seed Data

1. Open `lib/data/local/seed_data.dart`
2. Set:

   ```dart
   static const bool enabled = true;
   ```
3. Run the app — it will populate the DB with sample entries (only if none exist).

### Disable Seed Data

```dart
static const bool enabled = false;
```

### Clearing Seed Data

Seed data is skipped if drawings already exist. To reset:

* uninstall the app / clear app storage, **or**
* delete the local database file (platform-dependent).

---

## Notes

* Feedback generation is currently local / placeholder-ready
* Asset folders under `assets/images/` contain backgrounds and inspiration images used by the UI
