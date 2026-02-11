# run_original_stack.ps1
# Launches the ORIGINAL React Frontend and Go Backend for reference.

write-host "Starting Original CMS Stack..." -ForegroundColor Cyan

$root = $PSScriptRoot
$backendPath = Join-Path $root "go-backend"
$frontendPath = Join-Path $root "frontend"

# 0. Setup Environment
$env:CMS_SQLITE_PATH = Join-Path $backendPath "source_data.db"
write-host "Set Database Path to: $env:CMS_SQLITE_PATH" -ForegroundColor Cyan

# Create empty DB if missing
if (!(Test-Path $env:CMS_SQLITE_PATH)) {
    write-host "Database file missing. Creating empty file..." -ForegroundColor Yellow
    New-Item -Path $env:CMS_SQLITE_PATH -ItemType File -Force | Out-Null
}

# Check for Node.js
if (!(Get-Command npm -ErrorAction SilentlyContinue)) {
    $nodePath = "C:\Program Files\nodejs"
    if (Test-Path $nodePath) {
        $env:Path += ";$nodePath"
        write-host "Added Node.js to PATH." -ForegroundColor Green
    }
}

# 1. Start Go Backend
write-host "[1/2] Launching Go Backend..." -ForegroundColor Yellow
if (Test-Path $backendPath) {
    # Using pure-Go SQLite (no CGO required)
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backendPath'; `$env:CGO_ENABLED='0'; `$env:CMS_SQLITE_PATH='$env:CMS_SQLITE_PATH'; echo 'Starting Go Backend...'; go run main.go"
    write-host "Backend started in new window." -ForegroundColor Green
} else {
    write-host "Error: Backend folder not found at $backendPath" -ForegroundColor Red
}

# 2. Start React Frontend
write-host "[2/2] Launching React Frontend..." -ForegroundColor Yellow
if (Test-Path $frontendPath) {
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$frontendPath'; echo 'Starting React Frontend...'; if (!(Test-Path node_modules)) { npm install }; npm run dev"
        write-host "Frontend started in new window." -ForegroundColor Green
    } else {
        write-host "SKIPPING Frontend: npm not found." -ForegroundColor Red
    }
} else {
    write-host "Error: Frontend folder not found at $frontendPath" -ForegroundColor Red
}

write-host "`nBoth services are starting..." -ForegroundColor Cyan
write-host "1. Backend running on default port (usually 8080)"
write-host "2. Frontend running on default Vite port (usually 5173)"
write-host "You can now compare the original app with the new Flutter version."
write-host "Press Enter to exit this launcher (services will keep running)."
Read-Host
