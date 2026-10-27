# Notas de Lançamento (Release Notes)

## Versão: `v2.1.0`
**Título da Release:** `v2.1.0 - Refresh Automático, Suporte a Clique sobre Pastas e Correções de Execução`

---

### 📝 Descrição (Changelog):

## 🚀 O que há de novo na v2.1.0

### ✨ Novas Funcionalidades
- **Refresh Automático do Explorer:** Ao executar o *Script - Criar Pasta*, o Windows Explorer agora atualiza a exibição em tempo real automaticamente, sem necessidade de pressionar F5 ou recarregar manualmente.
- **Suporte ao Clique Direto sobre Pastas:** Agora é possível clicar com o botão direito tanto no fundo vazio da pasta quanto diretamente sobre o ícone de uma pasta para executar os scripts.

### 🐛 Correções e Melhorias
- **Correção do Diretório de Execução no Renomear:** Corrigido o bug onde o `Renomear.bat` forçava a navegação para a pasta interna de scripts (`Documents\Scripts`) em vez de atuar no diretório do projeto clicado.
- **Estabilidade do Terminal:** Resolvido o fechamento precoce do terminal no `Renomear.bat`, garantindo que os prompts interativos (Aldeia, Volume, Altura, Rede) aguardem corretamente a entrada do usuário e fiquem pausados ao final.
- **Compatibilidade de Caracteres:** A busca pelas pastas de projetos (como `Instalações Elétricas`) agora usa máscaras universais, garantindo compatibilidade em qualquer padrão de codificação do Windows.

---

### 📦 Arquivo para Download:
- `scripts-menu-v2.1.0.zip`

---

### 🚀 Como Instalar / Atualizar
1. Baixe o arquivo **`scripts-menu-v2.1.0.zip`** em Releases.
2. Extraia o conteúdo em qualquer pasta.
3. Dê dois cliques em **`INSTALAR.bat`**.
