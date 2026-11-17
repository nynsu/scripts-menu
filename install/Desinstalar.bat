@echo off
chcp 65001 > nul
echo ==================================================
echo  Desinstalador Portatil - Scripts Menu de Contexto
echo ==================================================
echo.

set "DEST=%LOCALAPPDATA%\ScriptsMenu"

:: 1. Remove os atalhos atuais e legados do Registro
reg delete "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_1_Criar" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_2_Renomear" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_3_MesclarPDF" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\shell\ScriptsMenu_1_Criar" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\shell\ScriptsMenu_2_Renomear" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\shell\ScriptsMenu_3_MesclarPDF" /f > nul 2>&1

reg delete "HKCU\Software\Classes\Directory\Background\shell\CriarPastas" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\Background\shell\Renomear" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\shell\CriarPastas" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\shell\Renomear" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\shell\ScriptsMenu" /f > nul 2>&1

:: 2. Remove os scripts copiados
del /q "%DEST%\Criar Pastas.bat" > nul 2>&1
del /q "%DEST%\Renomear.bat" > nul 2>&1
del /q "%DEST%\Mesclar PDF.bat" > nul 2>&1
del /q "%DEST%\Mesclar PDF.py" > nul 2>&1
del /q "%DEST%\Mesclar PDF.ps1" > nul 2>&1
del /q "%DEST%\PdfSharp.dll" > nul 2>&1

:: Remove a pasta se estiver vazia
rmdir "%DEST%" > nul 2>&1

:: 3. Notifica o Windows Explorer
powershell -NoProfile -Command "$s='[DllImport(\"shell32.dll\")]public static extern void SHChangeNotify(int a,int b,IntPtr c,IntPtr d);';$t=Add-Type -MemberDefinition $s -Name N -Namespace W -PassThru;$t::SHChangeNotify(0x08000000,0,[IntPtr]::Zero,[IntPtr]::Zero)" > nul 2>&1

echo Removido com sucesso!
echo.
pause
