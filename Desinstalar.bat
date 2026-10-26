@echo off
echo Removendo Menu de Contexto...

:: Exclui as chaves do Registro
reg delete "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\CriarPastas" /f > nul 2>&1
reg delete "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\Renomear" /f > nul 2>&1

:: Deleta os arquivos da pasta Scripts
if exist "%USERPROFILE%\Documents\Scripts\Criar Pastas.bat" (
    del /q "%USERPROFILE%\Documents\Scripts\Criar Pastas.bat"
)
if exist "%USERPROFILE%\Documents\Scripts\Renomear.bat" (
    del /q "%USERPROFILE%\Documents\Scripts\Renomear.bat"
)

echo.
echo Removido com sucesso!
pause