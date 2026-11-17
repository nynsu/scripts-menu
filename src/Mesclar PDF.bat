@echo off
chcp 65001 > nul

set "TARGET=%~1"
if "%TARGET%"=="" set "TARGET=%CD%"

:: Tenta executar via Python (se Python + docx2pdf + pypdf estiverem instalados)
python -c "import docx2pdf, pypdf" > nul 2>&1
if %ERRORLEVEL% equ 0 (
    python "%~dp0Mesclar PDF.py" "%TARGET%"
    exit /b %ERRORLEVEL%
)

:: Fallback automatico: PowerShell nativo + Word COM + PdfSharp.dll (sem Python)
echo [Info] Python ou pacotes (docx2pdf/pypdf) nao detectados.
echo [Info] Executando via modo nativo Windows (PowerShell + Word + PdfSharp)...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Mesclar PDF.ps1" "%TARGET%"
