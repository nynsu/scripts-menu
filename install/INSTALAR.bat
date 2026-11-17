@echo off
chcp 65001 > nul
echo ==================================================
echo  Instalador Portatil - Scripts Menu de Contexto
echo ==================================================
echo.

set "DEST=%LOCALAPPDATA%\ScriptsMenu"

:: 1. Cria a pasta de destino em AppData Local
if not exist "%DEST%" (
    mkdir "%DEST%"
)

:: 2. Copia todos os arquivos da pasta src
copy /y "%~dp0..\src\Criar Pastas.bat" "%DEST%\Criar Pastas.bat" > nul
copy /y "%~dp0..\src\Renomear.bat" "%DEST%\Renomear.bat" > nul
copy /y "%~dp0..\src\Mesclar PDF.bat" "%DEST%\Mesclar PDF.bat" > nul
copy /y "%~dp0..\src\Mesclar PDF.py" "%DEST%\Mesclar PDF.py" > nul
copy /y "%~dp0..\src\Mesclar PDF.ps1" "%DEST%\Mesclar PDF.ps1" > nul
copy /y "%~dp0..\src\PdfSharp.dll" "%DEST%\PdfSharp.dll" > nul

:: 3. Limpa registros legados ou de versoes anteriores
reg delete "HKCU\Software\Classes\Directory\Background\shell\CriarPastas" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\Background\shell\Renomear" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_2_Renomear" /v "SeparatorAfter" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\shell\CriarPastas" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\shell\Renomear" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\shell\ScriptsMenu" /f > nul 2>&1
reg delete "HKCU\Software\Classes\Directory\shell\ScriptsMenu_2_Renomear" /v "SeparatorAfter" /f > nul 2>&1

:: 4. Registra os atalhos agrupados com icones e separadores (HKCU)
:: 4.1 Fundo de pasta ou Area de Trabalho (Directory\Background)
reg add "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_1_Criar" /ve /d "Script - Criar Pasta" /f > nul
reg add "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_1_Criar" /v "Icon" /t REG_SZ /d "shell32.dll,3" /f > nul
reg add "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_1_Criar" /v "SeparatorBefore" /t REG_SZ /d "" /f > nul
reg add "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_1_Criar\command" /ve /d "cmd.exe /c cd /d \"%%V\" && \"%DEST%\Criar Pastas.bat\"" /f > nul

reg add "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_2_Renomear" /ve /d "Script - Renomear" /f > nul
reg add "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_2_Renomear" /v "Icon" /t REG_SZ /d "shell32.dll,133" /f > nul
reg add "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_2_Renomear\command" /ve /d "cmd.exe /c cd /d \"%%V\" && \"%DEST%\Renomear.bat\"" /f > nul

reg add "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_3_MesclarPDF" /ve /d "Script - Mesclar PDF" /f > nul
reg add "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_3_MesclarPDF" /v "Icon" /t REG_SZ /d "shell32.dll,134" /f > nul
reg add "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_3_MesclarPDF" /v "SeparatorAfter" /t REG_SZ /d "" /f > nul
reg add "HKCU\Software\Classes\Directory\Background\shell\ScriptsMenu_3_MesclarPDF\command" /ve /d "cmd.exe /c cd /d \"%%V\" && \"%DEST%\Mesclar PDF.bat\" \"%%V\"" /f > nul

:: 4.2 Clique direto SOBRE uma pasta (Directory)
reg add "HKCU\Software\Classes\Directory\shell\ScriptsMenu_1_Criar" /ve /d "Script - Criar Pasta" /f > nul
reg add "HKCU\Software\Classes\Directory\shell\ScriptsMenu_1_Criar" /v "Icon" /t REG_SZ /d "shell32.dll,3" /f > nul
reg add "HKCU\Software\Classes\Directory\shell\ScriptsMenu_1_Criar" /v "SeparatorBefore" /t REG_SZ /d "" /f > nul
reg add "HKCU\Software\Classes\Directory\shell\ScriptsMenu_1_Criar\command" /ve /d "cmd.exe /c cd /d \"%%1\" && \"%DEST%\Criar Pastas.bat\"" /f > nul

reg add "HKCU\Software\Classes\Directory\shell\ScriptsMenu_2_Renomear" /ve /d "Script - Renomear" /f > nul
reg add "HKCU\Software\Classes\Directory\shell\ScriptsMenu_2_Renomear" /v "Icon" /t REG_SZ /d "shell32.dll,133" /f > nul
reg add "HKCU\Software\Classes\Directory\shell\ScriptsMenu_2_Renomear\command" /ve /d "cmd.exe /c cd /d \"%%1\" && \"%DEST%\Renomear.bat\"" /f > nul

reg add "HKCU\Software\Classes\Directory\shell\ScriptsMenu_3_MesclarPDF" /ve /d "Script - Mesclar PDF" /f > nul
reg add "HKCU\Software\Classes\Directory\shell\ScriptsMenu_3_MesclarPDF" /v "Icon" /t REG_SZ /d "shell32.dll,134" /f > nul
reg add "HKCU\Software\Classes\Directory\shell\ScriptsMenu_3_MesclarPDF" /v "SeparatorAfter" /t REG_SZ /d "" /f > nul
reg add "HKCU\Software\Classes\Directory\shell\ScriptsMenu_3_MesclarPDF\command" /ve /d "cmd.exe /c cd /d \"%%1\" && \"%DEST%\Mesclar PDF.bat\" \"%%1\"" /f > nul

:: 5. Se Python estiver instalado, garante os pacotes pypdf e docx2pdf (sem falhar caso esteja offline)
python --version > nul 2>&1
if %ERRORLEVEL% equ 0 (
    python -c "import docx2pdf, pypdf" > nul 2>&1
    if %ERRORLEVEL% neq 0 (
        echo Python detectado. Instalando dependencias pypdf e docx2pdf...
        python -m pip install --user pypdf docx2pdf
        echo.
    )
)

:: 6. Notifica o Windows Explorer para atualizar o menu imediatamente
powershell -NoProfile -Command "$s='[DllImport(\"shell32.dll\")]public static extern void SHChangeNotify(int a,int b,IntPtr c,IntPtr d);';$t=Add-Type -MemberDefinition $s -Name N -Namespace W -PassThru;$t::SHChangeNotify(0x08000000,0,[IntPtr]::Zero,[IntPtr]::Zero)" > nul 2>&1

echo Instalacao concluida com sucesso em:
echo %DEST%
echo.
pause
