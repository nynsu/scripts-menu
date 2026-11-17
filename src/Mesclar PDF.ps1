param(
    [string]$RaizArg
)

$ErrorActionPreference = "Stop"

# Carrega PdfSharp.dll da mesma pasta do script
$dllPath = Join-Path $PSScriptRoot "PdfSharp.dll"
if (-not (Test-Path $dllPath)) {
    throw "Biblioteca PdfSharp.dll nao encontrada em: $dllPath"
}
Add-Type -Path $dllPath

function Find-UniqueFile {
    param(
        [string]$Pasta,
        [string]$Extensao
    )
    $arquivos = @(Get-ChildItem -Path $Pasta -File | Where-Object {
        $_.Extension -ieq $Extensao -and -not $_.Name.StartsWith("~$")
    })
    if ($arquivos.Count -eq 0) {
        throw "Nenhum arquivo $Extensao encontrado em: $Pasta"
    }
    if ($arquivos.Count -gt 1) {
        $nomes = ($arquivos | ForEach-Object { $_.Name }) -join ", "
        throw "Mais de um arquivo $Extensao encontrado em ${Pasta}: $nomes"
    }
    return $arquivos[0].FullName
}

function Confirm-Generation {
    param([string]$ArquivoSaida)
    if (-not (Test-Path $ArquivoSaida)) {
        return $true
    }
    $nome = Split-Path $ArquivoSaida -Leaf
    while ($true) {
        $resp = (Read-Host "O arquivo '$nome' ja existe. Sobrescrever (S) ou pular (N)? [S/N]").Trim().ToLower()
        if ($resp -in @("s", "sim")) { return $true }
        if ($resp -in @("n", "nao", "não")) {
            Write-Host "Pulando $nome.`n"
            return $false
        }
        Write-Host "Resposta invalida. Digite S para sobrescrever ou N para pular."
    }
}

function Convert-DocxToPdf {
    param(
        $WordApp,
        [string]$DocxPath,
        [string]$PdfPath
    )
    $doc = $null
    try {
        # ReadOnly = $true (3o parametro)
        $doc = $WordApp.Documents.Open($DocxPath, $false, $true)
        # 17 = wdFormatPDF
        $doc.SaveAs2([ref]$PdfPath, [ref]17)
    } finally {
        if ($null -ne $doc) {
            $doc.Close($false) | Out-Null
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($doc) | Out-Null
        }
    }
}

function Merge-Pdfs {
    param(
        [string[]]$OrdemPdfs,
        [string]$ArquivoSaida
    )
    $outputDoc = New-Object PdfSharp.Pdf.PdfDocument
    try {
        foreach ($pdfPath in $OrdemPdfs) {
            Write-Host "Adicionando: $(Split-Path $pdfPath -Leaf)"
            $inputDoc = [PdfSharp.Pdf.IO.PdfReader]::Open($pdfPath, [PdfSharp.Pdf.IO.PdfDocumentOpenMode]::Import)
            try {
                for ($i = 0; $i -lt $inputDoc.PageCount; $i++) {
                    $outputDoc.AddPage($inputDoc.Pages[$i]) | Out-Null
                }
            } finally {
                $inputDoc.Dispose()
            }
        }
        $outputDoc.Save($ArquivoSaida)
        Write-Host "Salvo em: $ArquivoSaida`n"
    } finally {
        $outputDoc.Dispose()
    }
}

function Main {
    if ($RaizArg) {
        $raiz = (Resolve-Path $RaizArg).Path
    } else {
        $raiz = (Get-Location).Path
    }

    $pastaEle = Join-Path $raiz "Instalações Elétricas"
    $pastaSpda = Join-Path $raiz "SPDA"
    $pastaRef = Join-Path $raiz "REF"
    $pastaSaida = Join-Path $raiz "Arquivos enviados (PDF)"

    foreach ($p in @($pastaEle, $pastaSpda, $pastaRef)) {
        if (-not (Test-Path $p -PathType Container)) {
            throw "Pasta nao encontrada: $p"
        }
    }

    # Arquivos de Instalacoes Eletricas + REF
    $pdfEle = Find-UniqueFile -Pasta $pastaEle -Extensao ".pdf"
    $docxEle = Find-UniqueFile -Pasta $pastaEle -Extensao ".docx"

    $mcaPdf = Join-Path $pastaRef "MCA.pdf"
    $bPdf = Join-Path $pastaRef "B.pdf"
    $cPdf = Join-Path $pastaRef "C.pdf"

    foreach ($f in @($mcaPdf, $bPdf, $cPdf)) {
        if (-not (Test-Path $f -PathType Leaf)) {
            throw "Arquivo nao encontrado em REF: $f"
        }
    }

    # Arquivos de SPDA
    $pdfSpda = Find-UniqueFile -Pasta $pastaSpda -Extensao ".pdf"
    $docxSpda = Find-UniqueFile -Pasta $pastaSpda -Extensao ".docx"

    if (-not (Test-Path $pastaSaida)) {
        New-Item -ItemType Directory -Path $pastaSaida -Force | Out-Null
    }

    $saidaEle = Join-Path $pastaSaida "ELE.pdf"
    $saidaSpd = Join-Path $pastaSaida "SPD.pdf"

    $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ("mesclar_pdf_" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null

    $wordApp = $null
    try {
        Write-Host "=== ELE.pdf ==="
        if (Confirm-Generation -ArquivoSaida $saidaEle) {
            if ($null -eq $wordApp) {
                $wordApp = New-Object -ComObject Word.Application
                $wordApp.Visible = $false
                $wordApp.DisplayAlerts = 0
            }
            $docxEleNome = [System.IO.Path]::GetFileNameWithoutExtension($docxEle)
            $docxElePdf = Join-Path $tmpDir "ele_$docxEleNome.pdf"
            Write-Host "Convertendo DOCX -> PDF: $(Split-Path $docxEle -Leaf)"
            Convert-DocxToPdf -WordApp $wordApp -DocxPath $docxEle -PdfPath $docxElePdf
            Merge-Pdfs -OrdemPdfs @($pdfEle, $docxElePdf, $mcaPdf, $bPdf, $cPdf) -ArquivoSaida $saidaEle
        }

        Write-Host "=== SPD.pdf ==="
        if (Confirm-Generation -ArquivoSaida $saidaSpd) {
            if ($null -eq $wordApp) {
                $wordApp = New-Object -ComObject Word.Application
                $wordApp.Visible = $false
                $wordApp.DisplayAlerts = 0
            }
            $docxSpdaNome = [System.IO.Path]::GetFileNameWithoutExtension($docxSpda)
            $docxSpdaPdf = Join-Path $tmpDir "spda_$docxSpdaNome.pdf"
            Write-Host "Convertendo DOCX -> PDF: $(Split-Path $docxSpda -Leaf)"
            Convert-DocxToPdf -WordApp $wordApp -DocxPath $docxSpda -PdfPath $docxSpdaPdf
            Merge-Pdfs -OrdemPdfs @($pdfSpda, $docxSpdaPdf) -ArquivoSaida $saidaSpd
        }

        Write-Host "Concluido!"
    } finally {
        if ($null -ne $wordApp) {
            $wordApp.Quit() | Out-Null
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($wordApp) | Out-Null
        }
        if (Test-Path $tmpDir) {
            Remove-Item -Path $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

try {
    Main
} catch {
    Write-Host "`nErro: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    Read-Host "`nPressione ENTER para sair"
}
