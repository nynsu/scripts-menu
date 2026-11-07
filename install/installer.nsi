; ==============================================================================
; Script de Instalação NSIS - Scripts Menu de Contexto
; ==============================================================================

Unicode true
RequestExecutionLevel user ; Instalação a nível de usuário (não requer admin / HKCU)

; ------------------------------------------------------------------------------
; Definições Gerais
; ------------------------------------------------------------------------------
!define PRODUCT_NAME "Scripts de Produtividade (Menu de Contexto)"
!define PRODUCT_VERSION "2.2.0"
!define PRODUCT_PUBLISHER "Nynsu"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScriptsMenu"
!define OUTPUT_EXE "scripts-menu-setup-v${PRODUCT_VERSION}.exe"

; Metadados do Executável para o Windows (Propriedades > Detalhes)
VIProductVersion "2.2.0.0"
VIFileVersion "2.2.0.0"
VIAddVersionKey "FileDescription" "Instalador - Scripts de Produtividade (Menu de Contexto)"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "ProductVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "FileVersion" "2.2.0.0"
VIAddVersionKey "LegalCopyright" "© Nynsu"
VIAddVersionKey "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey "OriginalFilename" "${OUTPUT_EXE}"

; Diretório padrão de instalação (no perfil do usuário - AppData Local)
InstallDir "$LOCALAPPDATA\ScriptsMenu"

Name "Scripts Menu v${PRODUCT_VERSION}"
OutFile "${OUTPUT_EXE}"
SetCompressor /SOLID lzma

; ------------------------------------------------------------------------------
; Interface Modern UI 2
; ------------------------------------------------------------------------------
!include "MUI2.nsh"

!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install-blue.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall-blue.ico"

; Páginas do Instalador
!define MUI_WELCOMEPAGE_TITLE "Bem-vindo ao Instalador do Scripts Menu"
!define MUI_WELCOMEPAGE_TEXT "Este assistente instalará os atalhos de produtividade no menu de contexto do Windows Explorer:$\r$\n$\r$\n• Script - Criar Pasta$\r$\n• Script - Renomear$\r$\n$\r$\nClique em 'Instalar' para prosseguir."
!insertmacro MUI_PAGE_WELCOME

!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_TITLE "Instalação Concluída"
!define MUI_FINISHPAGE_TEXT "Os scripts foram integrados com sucesso ao menu de contexto do Windows Explorer!$\r$\n$\r$\nPara usar, basta clicar com o botão direito na Área de Trabalho ou sobre qualquer pasta de projeto."
!insertmacro MUI_PAGE_FINISH

; Páginas do Desinstalador
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Idioma (Português do Brasil)
!insertmacro MUI_LANGUAGE "PortugueseBR"

; ------------------------------------------------------------------------------
; Seção de Instalação
; ------------------------------------------------------------------------------
Section "Instalar" SecInstall
    SetOutPath "$INSTDIR"

    ; 1. Extração dos scripts
    File "..\src\Criar Pastas.bat"
    File "..\src\Renomear.bat"

    ; 2. Gerar desinstalador
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    ; 3. Limpeza de registros legados ou de testes anteriores
    DeleteRegKey HKCU "Software\Classes\Directory\Background\shell\CriarPastas"
    DeleteRegKey HKCU "Software\Classes\Directory\Background\shell\Renomear"
    DeleteRegKey HKCU "Software\Classes\Directory\Background\shell\ScriptsMenu"
    DeleteRegKey HKCU "Software\Classes\Directory\shell\CriarPastas"
    DeleteRegKey HKCU "Software\Classes\Directory\shell\Renomear"
    DeleteRegKey HKCU "Software\Classes\Directory\shell\ScriptsMenu"

    ; 4. Registro dos Atalhos Agrupados com Separadores
    ; 4.1 No fundo de pasta aberta ou Área de Trabalho (Directory\Background)
    WriteRegStr HKCU "Software\Classes\Directory\Background\shell\ScriptsMenu_1_Criar" "" "Script - Criar Pasta"
    WriteRegStr HKCU "Software\Classes\Directory\Background\shell\ScriptsMenu_1_Criar" "Icon" "shell32.dll,3"
    WriteRegStr HKCU "Software\Classes\Directory\Background\shell\ScriptsMenu_1_Criar" "SeparatorBefore" ""
    WriteRegStr HKCU "Software\Classes\Directory\Background\shell\ScriptsMenu_1_Criar\command" "" 'cmd.exe /c cd /d "%V" && "$INSTDIR\Criar Pastas.bat"'

    WriteRegStr HKCU "Software\Classes\Directory\Background\shell\ScriptsMenu_2_Renomear" "" "Script - Renomear"
    WriteRegStr HKCU "Software\Classes\Directory\Background\shell\ScriptsMenu_2_Renomear" "Icon" "shell32.dll,133"
    WriteRegStr HKCU "Software\Classes\Directory\Background\shell\ScriptsMenu_2_Renomear" "SeparatorAfter" ""
    WriteRegStr HKCU "Software\Classes\Directory\Background\shell\ScriptsMenu_2_Renomear\command" "" 'cmd.exe /c cd /d "%V" && "$INSTDIR\Renomear.bat"'

    ; 4.2 Clicando diretamente SOBRE uma pasta (Directory)
    WriteRegStr HKCU "Software\Classes\Directory\shell\ScriptsMenu_1_Criar" "" "Script - Criar Pasta"
    WriteRegStr HKCU "Software\Classes\Directory\shell\ScriptsMenu_1_Criar" "Icon" "shell32.dll,3"
    WriteRegStr HKCU "Software\Classes\Directory\shell\ScriptsMenu_1_Criar" "SeparatorBefore" ""
    WriteRegStr HKCU "Software\Classes\Directory\shell\ScriptsMenu_1_Criar\command" "" 'cmd.exe /c cd /d "%1" && "$INSTDIR\Criar Pastas.bat"'

    WriteRegStr HKCU "Software\Classes\Directory\shell\ScriptsMenu_2_Renomear" "" "Script - Renomear"
    WriteRegStr HKCU "Software\Classes\Directory\shell\ScriptsMenu_2_Renomear" "Icon" "shell32.dll,133"
    WriteRegStr HKCU "Software\Classes\Directory\shell\ScriptsMenu_2_Renomear" "SeparatorAfter" ""
    WriteRegStr HKCU "Software\Classes\Directory\shell\ScriptsMenu_2_Renomear\command" "" 'cmd.exe /c cd /d "%1" && "$INSTDIR\Renomear.bat"'

    ; 5. Registro no "Adicionar ou Remover Programas" do Windows
    WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
    WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
    WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
    WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayIcon" '"$INSTDIR\Uninstall.exe",0'
    WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
    WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "QuietUninstallString" '"$INSTDIR\Uninstall.exe" /S'
    WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "InstallLocation" "$INSTDIR"
    WriteRegDWORD HKCU "${PRODUCT_UNINST_KEY}" "NoModify" 1
    WriteRegDWORD HKCU "${PRODUCT_UNINST_KEY}" "NoRepair" 1

    ; 6. Notifica o Windows Explorer para atualizar o cache dos menus imediatamente
    System::Call 'shell32::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)'
SectionEnd

; ------------------------------------------------------------------------------
; Seção de Desinstalação
; ------------------------------------------------------------------------------
Section "Uninstall"
    ; 1. Remove os atalhos atuais
    DeleteRegKey HKCU "Software\Classes\Directory\Background\shell\ScriptsMenu_1_Criar"
    DeleteRegKey HKCU "Software\Classes\Directory\Background\shell\ScriptsMenu_2_Renomear"
    DeleteRegKey HKCU "Software\Classes\Directory\shell\ScriptsMenu_1_Criar"
    DeleteRegKey HKCU "Software\Classes\Directory\shell\ScriptsMenu_2_Renomear"

    ; 2. Limpa resquícios de versões anteriores ou testes caso existam
    DeleteRegKey HKCU "Software\Classes\Directory\Background\shell\CriarPastas"
    DeleteRegKey HKCU "Software\Classes\Directory\Background\shell\Renomear"
    DeleteRegKey HKCU "Software\Classes\Directory\Background\shell\ScriptsMenu"
    DeleteRegKey HKCU "Software\Classes\Directory\shell\CriarPastas"
    DeleteRegKey HKCU "Software\Classes\Directory\shell\Renomear"
    DeleteRegKey HKCU "Software\Classes\Directory\shell\ScriptsMenu"

    ; 3. Remove registro no Painel de Controle
    DeleteRegKey HKCU "${PRODUCT_UNINST_KEY}"

    ; 4. Remove os arquivos instalados
    Delete "$INSTDIR\Criar Pastas.bat"
    Delete "$INSTDIR\Renomear.bat"
    Delete "$INSTDIR\Uninstall.exe"

    ; 5. Remove a pasta se estiver vazia
    RMDir "$INSTDIR"

    ; 6. Notifica o Windows Explorer para atualizar o cache dos menus imediatamente
    System::Call 'shell32::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)'
SectionEnd
