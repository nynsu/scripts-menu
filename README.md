# Scripts de Produtividade para Windows (Menu de Contexto)

Conjunto de scripts utilitários integrados de forma elegante ao menu de contexto do Windows Explorer (ao clicar com o botão direito na Área de Trabalho, no fundo de qualquer pasta aberta ou diretamente sobre uma pasta de projeto):

- 📁 **Script - Criar Pasta**: Cria automaticamente a estrutura padrão de pastas para novos projetos.
- 📝 **Script - Renomear**: Renomeia e padroniza pastas de projetos conforme o fluxo de trabalho.

As opções são instaladas com ícones nativos e agrupadas em uma seção exclusiva com linhas separadoras para fácil visualização.

---

## 🚀 Como Instalar

1. Baixe o executável mais recente na aba **Releases** (ex: `scripts-menu-setup-v2.2.0.exe`).
2. Dê dois cliques no arquivo baixado e clique em **Instalar**.
3. Pronto! Ao clicar com o botão direito na Área de Trabalho ou sobre uma pasta, as opções estarão disponíveis imediatamente.

> **Nota:** Não é necessário executar como Administrador, pois o instalador opera no perfil do usuário (`HKEY_CURRENT_USER`), instalando os scripts em `%LOCALAPPDATA%\ScriptsMenu`.

---

## 🗑️ Como Desinstalar

1. Abra as **Configurações do Windows** (`Win + I`).
2. Acesse **Aplicativos** > **Aplicativos Instalados** (ou *Painel de Controle > Desinstalar um Programa*).
3. Localize **Scripts de Produtividade (Menu de Contexto)** na lista.
4. Clique em **Desinstalar**.
5. Todos os scripts e atalhos do menu de contexto serão removidos de forma 100% limpa.

---

## 📁 Estrutura do Repositório

```text
├── .gitattributes         # Garante que os arquivos mantenham quebra de linha CRLF
├── .gitignore             # Ignora temporários, pacotes e executáveis compilados
├── README.md              # Documentação e instruções de uso
├── install/               # Receita de empacotamento do instalador Windows (NSIS)
│   └── installer.nsi
└── src/                   # Scripts executados pelas opções do menu
    ├── Criar Pastas.bat
    └── Renomear.bat
```
