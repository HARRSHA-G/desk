# Go Backend Reference

This Gin-based backend is a parallel implementation to the existing Django REST layer. The idea is to keep `backend/` untouched and use that Django project as reference material, while the Go service reads the same SQLite file so the sample data, migrations, and models stay intact.

## Setup
1. Ensure Go 1.25+ is installed and available on the `PATH`.
2. From `go-backend/`, run:
   ```shell
   go mod tidy
   ```
3. Point the service at the SQLite file (defaults to `../backend/db.sqlite3`):
   ```powershell
   $env:CMS_SQLITE_PATH='D:\CMS_OFFICIAL_PROJECT\backend\db.sqlite3'
   go run main.go
   ```
   or use `export CMS_SQLITE_PATH=...` on Linux/macOS.
4. By default it listens on `:8080`; change via `PORT` environment variable if needed.

## Mirrors
- `/api/v1/projects` and `/api/v1/projects/:id` return projects with blocks and units.
- `/api/v1/customers`, `/vendors`, `/supervisors`, `/channel-partners`, `/material-items` expose catalog data directly out of SQLite.
- `/api/v1/attendance` exposes the Django attendance flows (stats, batches, members, records, and create endpoints) plus the choice lists from `attendance_page_app.utils`.
- `/health` provides a lightweight health-check response.
- `/api/v1/expenses` serves the utilities/expenses page with labor types plus manpower, material, general, departmental, and administration entries.

## Model pages
- `internal/model/project_models.go`: projects, blocks, and units for the projects page.
- `internal/model/customer_models.go`, `vendor_models.go`, `supervisor_models.go`, `channel_partner_models.go`, and `material_item_models.go` keep each catalog slice separate instead of a single crowded file.
`internal/model/utilities_models.go`: labor work types, manpower, material, and general/departmental/administration expenses that back the utilities page.
`internal/model/attendance_models.go`: attendance batches, members, and records plus the status/mode helpers copied from Django.
`internal/utils/attendance_utils.go`: helpers used by the Go attendance handlers (chart entries, payload structs, time parsing) so the controller logic stays lean.

## Safety
- It never runs migrations or writes to the database; the connection is strictly read-only.
- Use the Django backend for writes or admin-level workflows, and treat this service as a Go-native read model to build Gin+React prototypes.
- `run_go_stack.ps1` reads `.env` inside `go-backend/` if present; copy `.env.example` there, fill secrets (DB path, ports, tokens) and they will be exported before the Go server runs.
