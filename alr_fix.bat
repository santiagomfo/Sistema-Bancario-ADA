@echo off

@REM Changes code page to UTF-8 (code page 65001)
chcp 65001 >nul

@REM Clears the OneDrive and OneDriveCommercial environment variables
@REM Prevents GPRconfig from crashing with paths that have special characters
set OneDrive=
set OneDriveCommercial=

alr %*
