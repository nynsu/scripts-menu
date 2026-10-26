# Notas de Lançamento (Release Notes)

## Versão: `v2.0.0`
**Título da Release:** `v2.0.0 - Adição do Script de Renomear e Estruturação de Instalação`

---

### 📝 Descrição (Changelog):

#### ✨ Novidades:
- **Novo Script no Menu de Contexto:** Adicionado o script **"Script - Renomear"** diretamente ao menu de contexto do Windows.
- **Instalador Integrado (`INSTALAR.bat`):** Agora configura automaticamente ambos os scripts (`Criar Pastas.bat` e `Renomear.bat`) em uma única execução.
- **Desinstalador Completo (`Desinstalar.bat`):** Limpa ambas as entradas do Registro e remove os arquivos da pasta do usuário de forma limpa.
- **Nova Estrutura do Projeto:** Códigos organizados na pasta `src/`, facilitando a manutenção e futuras versões.
- **Suporte ao Git:** Inclusão de `.gitattributes` para forçar quebras de linha `CRLF` (evitando falhas de execução no prompt de comando do Windows).

---

### 📦 Arquivo para Download:
- `distribuicao-scripts-v2.0.0.zip`
