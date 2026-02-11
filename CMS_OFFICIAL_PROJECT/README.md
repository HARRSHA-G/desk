# CMS Official Project - QuickGeo

## 🚀 Overview
QuickGeo is a professional Construction Management System (CMS) designed for high-efficiency project tracking and resource management.

## 🏗️ Technical Stack
- **Frontend**: React (Vite), MUI Joy UI.
- **Backend**: Django (REST Framework).
- **Standards**: Follows 160+ coding and accessibility rules (see `GEMINI.md`).

## 📁 Project Structure
- `/frontend`: React application logic and UI.
- `/backend`: Django project handles data and business logic.
- `/Project_Documentation`: Detailed manuals and help files.

## 🔄 Data Flow
1. **Frontend Request**: Built using Axios in `src/api.js`, targeting `/api/v1/`.
2. **Backend Routing**: `urls.py` directs requests to specific app views.
3. **Database**: SQLite handles persistence with Django ORM.
4. **Response**: Standardized JSON response format `{ "data": [], "message": "" }`.

## 🛠️ How to Run
### Windows
Run the PowerShell script:
```powershell
./run_project.ps1
```

### Linux / Mac
Run the shell script:
```bash
chmod +x run_project.sh
./run_project.sh
```

## 🛡️ Security & Quality
- **CORS**: Restricted whitelist in `settings.py`.
- **Versioning**: API v1 prefixing.
- **Health**: `/health/` endpoint for monitoring.
- **A11y**: Semantic HTML for WCAG 2.2 compliance.
