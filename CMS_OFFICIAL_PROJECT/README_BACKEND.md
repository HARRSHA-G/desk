# Backend - QuickGeo (Django)

## 🏗️ Architecture
The backend is a Django REST Framework application following Rule 31 (Versioning) and Rule 14 (Standardized Responses).

## 📁 Structure
- `projects_page_app`: Core logic for construction project management.
- `crm_page_app`: Customer and Sales management.
- `cms_project`: Project-level settings and configuration.

## 🔄 Data Flow
1. **Request**: Incoming requests are prefixed with `/api/v1/`.
2. **Security**: CORS is enforced via whitelist in `settings.py`.
3. **Validation**: All inputs are sanitized and validated.
4. **Response**: All views return a unified JSON structure:
   ```json
   {
     "success": true,
     "data": [...],
     "message": "Status message"
   }
   ```

## 🛡️ Key Standards Followed
- **Rule 10**: Centralized Exception Handling in `exceptions.py`.
- **Rule 22**: Soft Deletes implemented for Projects.
- **Rule 49**: `/health/` monitoring endpoint.
- **Rule 36**: No magic numbers; constants managed in `constants.py`.
