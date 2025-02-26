@echo off
setlocal enabledelayedexpansion

:: Determine the directory where this script resides
set "SCRIPT_DIR=%~dp0"

:: Set the terraform stack directory relative to the script directory
set "STACK_DIR=%SCRIPT_DIR%..\terraform\job"

:: Check if the stack directory exists
if not exist "%STACK_DIR%" (
    echo Stack directory does not exist: %STACK_DIR%
    exit /b 1
)

:: Iterate over each first-level directory in the stack directory
for /d %%D in ("%STACK_DIR%\*") do (
    echo Refreshing hard links in directory: %%~fD
    call "%SCRIPT_DIR%create_hardlink.bat" "%%~fD"
    if errorlevel 1 (
        echo Error processing directory: %%~fD
    )
)

echo All hard links refreshed successfully.
exit /b 0
