@echo off
chcp 65001 > nul
echo Instalando Menu de Contexto...

:: 1. Cria a pasta Scripts dentro de Documentos do usuario se nao existir
if not exist "%USERPROFILE%\Documents\Scripts" (
    mkdir "%USERPROFILE%\Documents\Scripts"
)

:: 2. Copia os arquivos da pasta src para o local correto
copy /y "%~dp0src\Criar Pastas.bat" "%USERPROFILE%\Documents\Scripts\Criar Pastas.bat"
copy /y "%~dp0src\Renomear.bat" "%USERPROFILE%\Documents\Scripts\Renomear.bat"

:: 3. Registra as opcoes no Registro
reg add "HKCU\Software\Classes\Directory\Background\shell\CriarPastas" /ve /d "Script - Criar Pasta" /f > nul
reg add "HKCU\Software\Classes\Directory\Background\shell\CriarPastas\command" /ve /d "cmd.exe /c cd /d \"%%V\" && \"%USERPROFILE%\Documents\Scripts\Criar Pastas.bat\"" /f > nul

reg add "HKCU\Software\Classes\Directory\Background\shell\Renomear" /ve /d "Script - Renomear" /f > nul
reg add "HKCU\Software\Classes\Directory\Background\shell\Renomear\command" /ve /d "cmd.exe /c cd /d \"%%V\" && \"%USERPROFILE%\Documents\Scripts\Renomear.bat\"" /f > nul

echo.
echo Instalacao concluida com sucesso!
pause