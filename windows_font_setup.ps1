# --- Força o uso do protocolo de segurança TLS 1.2 ---
# Esta linha é crucial em ambientes corporativos com proxies/firewalls.
[Net.ServicePointManager]::SecurityProtocol = 'Tls12'

# =================================================================================
# Script para baixar e INSTALAR AUTOMATICAMENTE as fontes MesloLGS Nerd Font.
# Execução: Clique com o botão direito no arquivo e escolha "Executar com PowerShell".
# =================================================================================

# --- Auto-Elevação para Administrador ---
# Verifica se o script está rodando com privilégios de administrador. Se não, tenta se relançar como admin.
if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Permissao de administrador necessaria. Tentando relancar..."
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# --- Configuração ---
Write-Host "Iniciando a instalacao das fontes MesloLGS NF..." -ForegroundColor Cyan

# URLs das fontes
$fontUrls = @(
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf",
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf",
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf",
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
)

# Diretórios
$fontDir = "$env:windir\Fonts"
$tempDir = "$env:TEMP\NerdFonts"

# Cria o diretório temporário se não existir
if (-Not (Test-Path $tempDir)) {
    New-Item -Path $tempDir -ItemType Directory | Out-Null
}

# --- Instalação ---
# Cria um objeto Shell para interagir com a pasta de fontes do sistema
$shell = New-Object -ComObject Shell.Application
$fontNamespace = $shell.Namespace($fontDir)

try {
    foreach ($url in $fontUrls) {
        $fileName = [System.IO.Path]::GetFileName($url).Replace("%20", " ")
        $destPath = Join-Path -Path $tempDir -ChildPath $fileName
        $finalFontPath = Join-Path -Path $fontDir -ChildPath $fileName

        if (Test-Path $finalFontPath) {
            Write-Host "Fonte '$fileName' ja esta instalada. Pulando." -ForegroundColor Yellow
            continue
        }

        Write-Host "Baixando '$fileName'..." -ForegroundColor Gray
        Invoke-WebRequest -Uri $url -OutFile $destPath -UseBasicParsing

        Write-Host "Instalando '$fileName'..." -ForegroundColor Green
        $fontNamespace.CopyHere($destPath)
        
        Start-Sleep -Seconds 1
    }
}
catch {
    Write-Error "Ocorreu um erro: $_"
}
finally {
    Write-Host "Limpando arquivos temporarios..." -ForegroundColor Gray
    if (Test-Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force
    }
}

Write-Host ""
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "  Instalacao concluida com sucesso!" -ForegroundColor Cyan
Write-Host "  Lembre-se de configurar o Windows Terminal (ou outro app)" -ForegroundColor Cyan
Write-Host "  para usar a fonte 'MesloLGS NF'." -ForegroundColor Cyan
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host ""
Start-Sleep -Seconds 10