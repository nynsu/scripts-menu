import sys
import tempfile
from pathlib import Path
from docx2pdf import convert
from pypdf import PdfWriter


def encontrar_arquivo_unico(pasta: Path, extensao: str) -> Path:
    arquivos = [
        f for f in pasta.iterdir()
        if f.is_file()
        and f.suffix.lower() == extensao.lower()
        and not f.name.startswith("~$")  # ignora arquivos temporários do Word
    ]
    if not arquivos:
        raise FileNotFoundError(f"Nenhum arquivo {extensao} encontrado em: {pasta}")
    if len(arquivos) > 1:
        nomes = ", ".join(f.name for f in arquivos)
        raise ValueError(f"Mais de um arquivo {extensao} encontrado em {pasta}: {nomes}")
    return arquivos[0]


def confirmar_geracao(arquivo_saida: Path) -> bool:
    if not arquivo_saida.exists():
        return True
    while True:
        resp = input(
            f"O arquivo '{arquivo_saida.name}' já existe. "
            "Sobrescrever (S) ou pular (N)? [S/N]: "
        ).strip().lower()
        if resp in ("s", "sim"):
            return True
        if resp in ("n", "nao", "não"):
            print(f"Pulando {arquivo_saida.name}.\n")
            return False
        print("Resposta inválida. Digite S para sobrescrever ou N para pular.")


def mesclar_pdfs(ordem_pdfs: list[Path], arquivo_saida: Path) -> None:
    writer = PdfWriter()
    for pdf in ordem_pdfs:
        print(f"Adicionando: {pdf.name}")
        writer.append(str(pdf))

    with open(arquivo_saida, "wb") as f_out:
        writer.write(f_out)
    print(f"Salvo em: {arquivo_saida}\n")


def main():
    raiz = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path.cwd()

    pasta_ele = raiz / "Instalações Elétricas"
    pasta_spda = raiz / "SPDA"
    pasta_ref = raiz / "REF"
    pasta_saida = raiz / "Arquivos enviados (PDF)"

    for p in (pasta_ele, pasta_spda, pasta_ref):
        if not p.is_dir():
            raise FileNotFoundError(f"Pasta não encontrada: {p}")

    # Arquivos de Instalações Elétricas + REF
    pdf_ele = encontrar_arquivo_unico(pasta_ele, ".pdf")
    docx_ele = encontrar_arquivo_unico(pasta_ele, ".docx")

    mca_pdf = pasta_ref / "MCA.pdf"
    b_pdf = pasta_ref / "B.pdf"
    c_pdf = pasta_ref / "C.pdf"

    for f in (mca_pdf, b_pdf, c_pdf):
        if not f.is_file():
            raise FileNotFoundError(f"Arquivo não encontrado em REF: {f}")

    # Arquivos de SPDA
    pdf_spda = encontrar_arquivo_unico(pasta_spda, ".pdf")
    docx_spda = encontrar_arquivo_unico(pasta_spda, ".docx")

    pasta_saida.mkdir(parents=True, exist_ok=True)

    saida_ele = pasta_saida / "ELE.pdf"
    saida_spd = pasta_saida / "SPD.pdf"

    with tempfile.TemporaryDirectory() as tmp_dir:
        tmp_path = Path(tmp_dir)

        print("=== ELE.pdf ===")
        if confirmar_geracao(saida_ele):
            docx_ele_pdf = tmp_path / f"ele_{docx_ele.stem}.pdf"
            print(f"Convertendo DOCX -> PDF: {docx_ele.name}")
            convert(str(docx_ele), str(docx_ele_pdf))
            mesclar_pdfs(
                [pdf_ele, docx_ele_pdf, mca_pdf, b_pdf, c_pdf],
                saida_ele,
            )

        print("=== SPD.pdf ===")
        if confirmar_geracao(saida_spd):
            docx_spda_pdf = tmp_path / f"spda_{docx_spda.stem}.pdf"
            print(f"Convertendo DOCX -> PDF: {docx_spda.name}")
            convert(str(docx_spda), str(docx_spda_pdf))
            mesclar_pdfs(
                [pdf_spda, docx_spda_pdf],
                saida_spd,
            )

    print("Concluído!")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"\nErro: {e}")
    finally:
        input("\nPressione ENTER para sair...")