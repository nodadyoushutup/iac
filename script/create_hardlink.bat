@echo off
setlocal enabledelayedexpansion

:: Set the source directory to a fixed relative path 
set "SCRIPT_DIR=%~dp0"
set "SRC_DIR=%SCRIPT_DIR%..\terraform\hardlink"

:: Check if the destination directory argument is provided 
if "%~1"=="" (
    echo Usage: %~nx0 ^<destination_directory^>
    exit /b 1
)

set "DEST_DIR=%~1"

:: Check if source directory exists 
if not exist "%SRC_DIR%" (
    echo Source directory does not exist: %SRC_DIR%
    exit /b 1
)

:: Check if destination directory exists, if not, create it 
if not exist "%DEST_DIR%" mkdir "%DEST_DIR%"

:: Loop through files in source directory and create hard links in destination
for %%F in ("%SRC_DIR%\*") do (
    set "FILENAME=%%~nxF"
    
    :: Remove the existing file if it exists
    if exist "%DEST_DIR%\!FILENAME!" (
        del /f "%DEST_DIR%\!FILENAME!"
    )
    
    :: Create a new hard link for the file
    mklink /H "%DEST_DIR%\!FILENAME!" "%%F"
)

echo Hard links created successfully.
exit /b 0
