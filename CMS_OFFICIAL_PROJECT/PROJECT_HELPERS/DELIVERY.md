SINGLE COMMAND
"Set-Location D:\CMS\CMS\Construction-Management-System"
"powershell -ExecutionPolicy Bypass -File D:\CMS\CMS\Construction-Management-System\build_executable.ps1"

# Delivery Guide

Follow these Windows Command Prompt steps from the project root unless noted.

## 1. Environment setup
```cmd
cd /d D:\CMS\CMS\Construction-Management-System
```
```cmd
python -m venv .venv
```
```cmd
.\.venv\Scripts\activate
```
```cmd
python -m pip install --upgrade pip
```
```cmd
python -m pip install -r construction_management\requirements.txt
```

## 2. Configure secrets
Create (or edit) `.env` in the repository root with values like:
```text
SECRET_KEY=replace-me
ALLOWED_HOSTS=127.0.0.1,localhost
DEBUG=True
APP_HOST=127.0.0.1
APP_PORT=8000
CMS_DATA_DIR=
```
`CMS_DATA_DIR` can be left blank (defaults near the EXE) or pointed to another writable folder.

## 3. Prepare the database & smoke test
```cmd
python manage.py migrate
```
(Optional) create an admin:
```cmd
python manage.py createsuperuser
```
Run the app:
```cmd
python manage.py runserver
```
Browse to `http://127.0.0.1:8000/`, confirm the UI, then stop with `Ctrl+C`.

## 4. Build the packaged executable
```cmd
pyinstaller --clean --noconfirm cms_app.spec
```
Outputs:
- Executable: `dist\ConstructionManager.exe`
- Build cache: `build\ConstructionManager\` (safe to delete later)

## 5. Launch the packaged app
```cmd
cd dist
```
```cmd
ConstructionManager.exe
```
First run creates `cms_data\` next to the EXE, applies migrations, runs `collectstatic`, and starts the server on 
`http://127.0.0.1:8000/`. Stop with `Ctrl+C`.

## 6. Ship to client
Copy `dist\ConstructionManager.exe`, `.env` (without secrets), and this guide into a delivery folder. If the client needs the EXE somewhere else, move both the binary and its `cms_data\` directory together.

