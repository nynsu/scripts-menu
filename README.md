# Scripts de Produtividade para Windows (Menu de Contexto)

Conjunto de scripts utilitários integrados ao menu de contexto do Windows (botão direito do mouse na Área de Trabalho ou em qualquer pasta):
- **Script - Criar Pasta**: Cria automaticamente a estrutura padrão de pastas para projetos.
- **Script - Renomear**: Renomeia e padroniza arquivos conforme o fluxo de trabalho.

---

## 🚀 Como Instalar

1. Baixe a versão mais recente em Releases (arquivo `.zip`).
2. Extraia o conteúdo do `.zip` em qualquer pasta.
3. Dê dois cliques no arquivo **`INSTALAR.bat`**.
4. Pronto! Ao clicar com o botão direito no fundo de qualquer pasta ou na Área de Trabalho, as opções estarão disponíveis.

> **Nota:** Não é necessário executar como Administrador, pois o script instala apenas para o seu usuário (`HKEY_CURRENT_USER`).

---

## 🗑️ Como Desinstalar

1. Abra a pasta onde você extraiu os arquivos.
2. Dê dois cliques em **`Desinstalar.bat`**.
3. O atalho será removido do menu de contexto e os arquivos copiados serão excluídos.

---

## 📁 Estrutura do Repositório

```text
├── .gitattributes         # Garante que os arquivos .bat mantenham quebra de linha CRLF
├── .gitignore             # Ignora arquivos temporários e compactados
├── README.md              # Documentação e instruções de uso
├── INSTALAR.bat           # Instalador do menu de contexto
├── Desinstalar.bat        # Desinstalador
└── src/                   # Scripts executados pelas opções do menu
    ├── Criar Pastas.bat
    └── Renomear.bat
```
