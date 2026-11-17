# Scripts de Produtividade para Windows (Menu de Contexto)

Conjunto de scripts utilitários integrados de forma elegante ao menu de contexto do Windows Explorer (ao clicar com o botão direito na Área de Trabalho, no fundo de qualquer pasta aberta ou diretamente sobre uma pasta de projeto):

- 📁 **Script - Criar Pasta**: Cria automaticamente a estrutura padrão de pastas para novos projetos.
- 📝 **Script - Renomear**: Renomeia e padroniza pastas de projetos conforme o fluxo de trabalho.
- 📄 **Script - Mesclar PDF**: Converte arquivos `.docx` para PDF (via Microsoft Word) e mescla os documentos do projeto gerando `ELE.pdf` e `SPD.pdf`.
  - *Execução inteligente:* Usa Python (`docx2pdf` + `pypdf`) se disponível; caso contrário, executa automaticamente em modo nativo do Windows via PowerShell + Word COM + `PdfSharp.dll` (sem precisar instalar Python). Requer Microsoft Word instalado para converter os `.docx`.

As opções são instaladas com ícones nativos e agrupadas em uma seção exclusiva com linhas separadoras para fácil visualização.

---

## 🚀 Como Instalar

### Opção 1: Instalador Executável (Recomendado para PCs pessoais)
1. Baixe o executável mais recente na aba **Releases** (ex: `scripts-menu-setup-v2.3.0.exe`).
2. Dê dois cliques no arquivo baixado e clique em **Instalar**.
3. Pronto!

### Opção 2: Instalação Portátil via `.bat` (Para PCs corporativos que bloqueiam `.exe`)
1. Baixe o código-fonte (`.zip`) do repositório e extraia em qualquer pasta.
2. Abra a pasta `install/` e dê dois cliques em **`INSTALAR.bat`**.
3. Pronto! Os arquivos serão copiados para `%LOCALAPPDATA%\ScriptsMenu` com exatamente os mesmos ícones e agrupamento do instalador `.exe`.

> **Notas importantes:**
> - **Sem privilégios de Administrador:** Nenhuma das duas opções exige Admin, pois tudo é instalado no perfil do usuário atual (`HKEY_CURRENT_USER` e `%LOCALAPPDATA%\ScriptsMenu`).
> - **Dependências Python:** Caso Python esteja instalado na máquina, ambos os instaladores verificam e instalam automaticamente `pypdf` e `docx2pdf` (e, se não houver Python/internet, o script usa o modo nativo via PowerShell automaticamente).
> - **Atualizações:** Para atualizar uma versão já instalada, basta rodar o novo `.exe` ou `INSTALAR.bat` por cima — os arquivos e chaves de registro são sobrescritos automaticamente.
> - **O que levar para outro PC:**
>   - *Via `.exe`:* Apenas **1 único arquivo** (`scripts-menu-setup-vX.X.X.exe`), pois todos os scripts e a `PdfSharp.dll` já estão embutidos nele.
>   - *Via `.bat` portátil:* As pastas **`install/`** e **`src/`** juntas no mesmo diretório (ou o `.zip` completo baixado do GitHub), para que o `INSTALAR.bat` encontre os scripts em `..\src\`.

---

## 🗑️ Como Desinstalar

- **Se instalou via `.exe`:** Abra as **Configurações do Windows** (`Win + I`) > **Aplicativos** > **Aplicativos Instalados**, localize **Scripts de Produtividade (Menu de Contexto)** e clique em **Desinstalar**.
- **Se instalou via `.bat`:** Dê dois cliques em **`install\Desinstalar.bat`**.

---

## 📁 Estrutura do Repositório

```text
├── .gitattributes         # Garante que os arquivos mantenham quebra de linha CRLF
├── .gitignore             # Ignora temporários, pacotes e executáveis compilados
├── README.md              # Documentação e instruções de uso
├── install/               # Instaladores (NSIS .exe e scripts portáteis .bat)
│   ├── Desinstalar.bat    # Desinstalador portátil (sem .exe)
│   ├── INSTALAR.bat       # Instalador portátil (alternativa para PCs que bloqueiam .exe)
│   └── installer.nsi      # Receita de empacotamento do instalador Windows (NSIS)
└── src/                   # Scripts executados pelas opções do menu
    ├── Criar Pastas.bat
    ├── Mesclar PDF.bat    # Lançador inteligente (Python -> fallback PowerShell)
    ├── Mesclar PDF.ps1    # Versão nativa Windows (PowerShell + Word + PdfSharp)
    ├── Mesclar PDF.py     # Versão Python (docx2pdf + pypdf)
    ├── PdfSharp.dll       # Biblioteca .NET leve para mesclagem de PDF sem Python
    └── Renomear.bat
```
