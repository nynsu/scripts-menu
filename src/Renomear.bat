@echo off
setlocal enabledelayedexpansion
if "%~1" neq "" cd /d "%~1"

echo ==================================================
echo   RENOMEADOR AUTOMATICO DE PROJETOS
echo ==================================================
echo by: Nynsu + Bard
echo.
echo                       #####
echo                      #####
echo                     #####
echo                    ##########
echo                   ##########
echo                          #####
echo                         #####
echo                        #####
echo                       ###
echo                        #
echo.
echo ==================================================
echo SUPPLIED BY: SESAI ELE TEAM
echo HIGH VOLTAGE AUTOMATION // ZERO GROUNDING ERRORS
echo ==================================================
echo Diretorio de execucao: %CD%
echo.

:: Solicitando o nome da ALDEIA
:ASK_ALDEIA
set "ALDEIA="
set /p ALDEIA=">Digite o nome/codigo da ALDEIA: "
if "!ALDEIA!"=="" (
    echo [ERRO] O nome/codigo da ALDEIA nao pode ficar em branco!
    echo.
    goto ASK_ALDEIA
)

:: Solicitando o VOLUME (Apenas numeros)
:ASK_VOLUME
set "VOLUME="
set /p VOLUME=">Digite o VOLUME (ex: 15): "
if "!VOLUME!"=="" (
    echo [ERRO] O VOLUME nao pode ficar em branco!
    echo.
    goto ASK_VOLUME
)
set "CHECK_NUM="
for /f "delims=0123456789" %%A in ("!VOLUME!") do set "CHECK_NUM=%%A"
if defined CHECK_NUM (
    echo [ERRO] Entrada invalida! Digite apenas NUMEROS para o VOLUME.
    echo.
    goto ASK_VOLUME
)

:: Solicitando a ALTURA (Apenas numeros)
:ASK_ALTURA
set "ALTURA="
set /p ALTURA=">Digite a ALTURA (ex: 6): "
if "!ALTURA!"=="" (
    echo [ERRO] A ALTURA nao pode ficar em branco!
    echo.
    goto ASK_ALTURA
)
set "CHECK_NUM="
for /f "delims=0123456789" %%A in ("!ALTURA!") do set "CHECK_NUM=%%A"
if defined CHECK_NUM (
    echo [ERRO] Entrada invalida! Digite apenas NUMEROS para a ALTURA.
    echo.
    goto ASK_ALTURA
)

:: Solicitando o TIPO DE SISTEMA (Apenas RED ou SFV)
:ASK_REDE
set "REDE="
set /p REDE=">Digite o tipo de sistema (ex: RED ou SFV): "
if /i "!REDE!"=="RED" set "REDE=RED" & goto REDE_OK
if /i "!REDE!"=="SFV" set "REDE=SFV" & goto REDE_OK

echo [ERRO] Entrada invalida! Digite estritamente RED ou SFV.
echo.
goto ASK_REDE

:REDE_OK

echo.
echo --------------------------------------------------
echo Parametros definidos:
echo - ALDEIA: !ALDEIA!
echo - VOLUME: !VOLUME!
echo - ALTURA: !ALTURA!
echo - REDE: !REDE!
echo --------------------------------------------------
echo.

:: ====================================================
:: 1. PASTA "Instalações Elétricas" (Busca por padrão)
:: ====================================================
set "PASTA_ELE="
for /d %%D in ("Instala*es El*tricas" "Instalacoes Eletricas" "*El*tricas*") do set "PASTA_ELE=%%D"

if defined PASTA_ELE (
    echo Processando pasta "!PASTA_ELE!"...
    pushd "!PASTA_ELE!"
    
    for %%F in (*.rvt *.docx *.ifc *.dwg *.pdf *.xlsx) do (
        if exist "%%~F" (
            set "FILENAME=%%~nxF"
            set "EXT=%%~xF"
            set "PROCESSAR=1"

            set "EXT_LABEL="
            if /i "!EXT!"==".rvt" set "EXT_LABEL=RVT"
            if /i "!EXT!"==".docx" set "EXT_LABEL=DOCX"
            if /i "!EXT!"==".ifc" set "EXT_LABEL=IFC"
            if /i "!EXT!"==".dwg" set "EXT_LABEL=DWG"
            if /i "!EXT!"==".pdf" set "EXT_LABEL=PDF"
            if /i "!EXT!"==".xlsx" set "EXT_LABEL=XLSX"

            REM Excecoes para ELE
            if /i "!EXT!"==".pdf" (
                if /i "!FILENAME!"=="B.pdf" set "PROCESSAR=0"
                if /i "!FILENAME!"=="MCA.pdf" set "PROCESSAR=0"
                if /i "!FILENAME!"=="C.pdf" set "PROCESSAR=0"
            )
            if /i "!EXT!"==".xlsx" (
                if /i "!FILENAME!"=="CalculaSolar 2.2.xlsx" set "PROCESSAR=0"
            )

            if "!PROCESSAR!"=="1" (
                if defined EXT_LABEL (
                    set "NOME_NOVO=!ALDEIA!_RES_!VOLUME!_!ALTURA!_ELE_!REDE!_!EXT_LABEL!_R00!EXT!"
                    ren "%%~F" "!NOME_NOVO!"
                    echo   [OK - ELE] "%%~nxF -> !NOME_NOVO!"
                )
            )
        )
    )
    popd
    echo.
) else (
    echo [AVISO] A pasta "Instalacoes Eletricas" nao foi encontrada em "%CD%".
    echo.
)

:: ====================================================
:: 2. PASTA "SPDA"
:: ====================================================
if exist "SPDA\" (
    echo Processando pasta "SPDA"...
    pushd "SPDA"
    
    for %%F in (*.rvt *.docx *.ifc *.dwg *.pdf *.xlsx) do (
        if exist "%%~F" (
            set "FILENAME=%%~nxF"
            set "EXT=%%~xF"

            set "EXT_LABEL="
            if /i "!EXT!"==".rvt" set "EXT_LABEL=RVT"
            if /i "!EXT!"==".docx" set "EXT_LABEL=DOCX"
            if /i "!EXT!"==".ifc" set "EXT_LABEL=IFC"
            if /i "!EXT!"==".dwg" set "EXT_LABEL=DWG"
            if /i "!EXT!"==".pdf" set "EXT_LABEL=PDF"
            if /i "!EXT!"==".xlsx" set "EXT_LABEL=XLSX"

            if defined EXT_LABEL (
                set "NOME_NOVO=!ALDEIA!_RES_!VOLUME!_!ALTURA!_SPD_!EXT_LABEL!_R00!EXT!"
                ren "%%~F" "!NOME_NOVO!"
                echo   [OK - SPD] "%%~nxF -> !NOME_NOVO!"
            )
        )
    )
    popd
    echo.
) else (
    echo [AVISO] A pasta "SPDA" nao foi encontrada em "%CD%".
    echo.
)

:: ====================================================
:: 3. PASTA "Arquivos enviados (PDF)" (Cadernos Finais)
:: ====================================================
if exist "Arquivos enviados (PDF)\" (
    echo Processando pasta "Arquivos enviados (PDF)"...
    pushd "Arquivos enviados (PDF)"
    
    for %%F in (*.pdf) do (
        if exist "%%~F" (
            set "FILENAME=%%~nxF"
            set "TRATADO=0"
            
            REM Caderno ELE
            if /i "!FILENAME:ELE=!" neq "!FILENAME!" (
                set "NOME_NOVO=!ALDEIA!_CAD_DEF_ELE_R00.pdf"
                ren "%%~F" "!NOME_NOVO!"
                echo   [OK - CADERNO ELE] "%%~nxF -> !NOME_NOVO!"
                set "TRATADO=1"
            )
            
            REM Caderno SPD
            if "!TRATADO!"=="0" (
                if /i "!FILENAME:SPD=!" neq "!FILENAME!" (
                    set "NOME_NOVO=!ALDEIA!_CAD_DEF_SPD_R00.pdf"
                    ren "%%~F" "!NOME_NOVO!"
                    echo   [OK - CADERNO SPD] "%%~nxF -> !NOME_NOVO!"
                )
            )
        )
    )
    popd
    echo.
) else (
    echo [AVISO] A pasta "Arquivos enviados (PDF)" nao foi encontrada em "%CD%".
    echo.
)

:: Atualiza as janelas do Windows Explorer para refletir os novos nomes
powershell -NoProfile -Command "$s = New-Object -ComObject Shell.Application; foreach ($w in $s.Windows()) { try { $w.Refresh() } catch {} }" > nul 2>&1

echo ==================================================
echo                 Processo concluido
echo ==================================================
echo.
pause
