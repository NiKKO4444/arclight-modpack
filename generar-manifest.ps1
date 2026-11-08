param(
    [string]$Version = (Get-Date -Format "yyyy.MM.dd-HHmm")
)

$ErrorActionPreference = "Stop"

$repoRoot = $PSScriptRoot
$filesDir = Join-Path $repoRoot "files"

if (-not (Test-Path -LiteralPath $filesDir)) {
    Write-Host "No existe la carpeta 'files'. Creala y pone adentro los archivos del cliente." -ForegroundColor Red
    exit 1
}

$filesDirFull = (Resolve-Path -LiteralPath $filesDir).Path
$entries = @()

$files = Get-ChildItem -LiteralPath $filesDirFull -Recurse -File | Sort-Object FullName

foreach ($f in $files) {
    $relative = $f.FullName.Substring($filesDirFull.Length).TrimStart('\', '/') -replace '\\', '/'
    $hash = (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash.ToLower()

    $entries += [ordered]@{
        path   = $relative
        sha256 = $hash
        size   = $f.Length
    }
}

$manifest = [ordered]@{
    name      = "Arclight Modpack"
    version   = $Version
    minecraft = "1.21.1"
    neoforge  = "21.1.264"
    files     = @($entries)
}

$json = $manifest | ConvertTo-Json -Depth 5
$outPath = Join-Path $repoRoot "manifest.json"
[System.IO.File]::WriteAllText($outPath, $json, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Host "Listo: manifest.json generado." -ForegroundColor Green
Write-Host "Version:  $Version"
Write-Host "Archivos: $($entries.Count)"
