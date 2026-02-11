# CMS Edge Core (Sidecar Architecture)

This project contains a **Flutter Frontend (`lib/`)** and a **Go Backend (`backend/`)** in a single repository.

## Project Structure

- **`backend/`**: The Go source code.
  - `cmd/server/main.go`: The entry point for the backend server.
  - `build.bat`: A script to compile the Go code into an executable.
- **`lib/`**: The Flutter source code.
  - `main.dart`: The Flutter entry point that launches the Go backend.
- **`assets/bin/`**: The destination folder for the compiled Go binary (`engine.exe`).

## Setup Instructions

### 1. Initialize Flutter
Since this project was generated manually, you might need to fetch dependencies:
```bash
flutter pub get
```

### 2. Compile the Backend
You must compile the Go backend before running the app, as Flutter expects the `engine.exe` file in assets.
1. Open a terminal in `backend/`.
2. Run:
   ```bash
   go mod tidy
   build.bat
   ```
   This will create `assets/bin/engine.exe`.

### 3. Run the App
Now you can run the Flutter app:
```bash
flutter run
```

## How it Works
1. **Startup**: When Flutter starts, `main.dart` locates the `engine.exe` file.
2. **Launch**: It spawns `engine.exe` as a background process.
3. **Connect**: The Flutter app connects to `http://localhost:8080` to talk to the backend.
