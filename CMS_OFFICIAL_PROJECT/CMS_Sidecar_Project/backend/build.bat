@echo off
echo Building Go Sidecar...
go build -o ../../assets/bin/engine.exe ./cmd/server/main.go
if %errorlevel% neq 0 (
    echo Compilation Failed!
    exit /b %errorlevel%
)
echo Go Engine Compiled Successfully to assets/bin/engine.exe!
