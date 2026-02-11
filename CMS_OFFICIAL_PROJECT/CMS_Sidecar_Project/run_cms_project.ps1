# CMS Edge Core - Final Launcher v8.0
# "Soft-coded" + Process Cleanup (Fixes locked file errors)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   CMS Edge Core: Robust Launcher 8.0     " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# ---------------------------------------------------------
# 1. Advanced Discovery Function
# ---------------------------------------------------------
function Find-Tool {
    param([string]$Name, [string]$ExeName, [string[]]$SearchRoots)
    if (Get-Command $ExeName -ErrorAction SilentlyContinue) { return (Get-Command $ExeName).Source }
    Write-Host "Searching for $Name..." -NoNewline
    foreach ($Root in $SearchRoots) {
        if (Test-Path $Root) {
            $Found = Get-ChildItem -Path $Root -Recurse -Filter $ExeName -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
            if ($Found) { Write-Host " Found: $Found" -ForegroundColor Green; return $Found }
        }
    }
    Write-Host " NOT FOUND." -ForegroundColor Red; return $null
}

# ---------------------------------------------------------
# 2. Locate Tools & Patch Env
# ---------------------------------------------------------
$GitExe = Find-Tool "Git" "git.exe" @("C:\src\flutter", "C:\flutter", "$env:USERPROFILE\flutter", "C:\Program Files\Git", "$env:LOCALAPPDATA\Programs\Git")
$FlutterBat = Find-Tool "Flutter" "flutter.bat" @("C:\src\flutter\bin", "C:\flutter\bin", "$env:USERPROFILE\flutter\bin", "D:\src\flutter\bin")
$PowerShellExe = Find-Tool "PowerShell" "powershell.exe" @("C:\Windows\System32\WindowsPowerShell\v1.0")

if ($FlutterBat) { $env:Path = "$(Split-Path -Parent $FlutterBat);" + $env:Path }
if ($GitExe) { $env:Path = "$(Split-Path -Parent $GitExe);" + $env:Path }
if ($PowerShellExe) { $env:Path = "$(Split-Path -Parent $PowerShellExe);" + $env:Path }

# ---------------------------------------------------------
# 3. PRE-FLIGHT CHECK: Kill Locked Processes
# ---------------------------------------------------------
Write-Host "`n[0/4] Cleaning Processes..." -ForegroundColor Yellow
Stop-Process -Name "engine" -ErrorAction SilentlyContinue
Stop-Process -Name "flutter" -ErrorAction SilentlyContinue
Stop-Process -Name "dart" -ErrorAction SilentlyContinue
Write-Host "Cleanup Complete." -ForegroundColor Green

# ---------------------------------------------------------
# 4. Build Backend
# ---------------------------------------------------------
$projectRoot = $PSScriptRoot
$backendDir = Join-Path $projectRoot "backend"
$assetsDir = Join-Path $projectRoot "assets\bin"
$goOut = Join-Path $assetsDir "engine.exe"

Write-Host "`n[1/4] Building Backend..." -ForegroundColor Yellow
if (-not (Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }
Push-Location $backendDir
try {
    if ($GitExe) { go mod tidy }
    $env:CGO_ENABLED = "0"
    go build -o $goOut ./cmd/server/main.go
    if ($LASTEXITCODE -eq 0) { Write-Host "SUCCESS: Backend Compiled." -ForegroundColor Green }
}
finally { Pop-Location }

# ---------------------------------------------------------
# 5. Launch Frontend
# ---------------------------------------------------------
Set-Location $projectRoot
Write-Host "`n[2/4] Configuring Platform Support..." -ForegroundColor Yellow
if (-not (Test-Path "$projectRoot\windows")) {
    & $FlutterBat config --enable-windows-desktop
    & $FlutterBat create . --platforms=windows
}

# Only run clean if previous build failed (simple check for build folder)
# Or force clean every time to be safe? Let's be safe for now since files changed.
Write-Host "`n[3/4] Cleaning & Fetching Dependencies..." -ForegroundColor Yellow
& $FlutterBat clean 
& $FlutterBat pub get

Write-Host "`n[4/4] Launching App..." -ForegroundColor Yellow
& $FlutterBat run -d windows
