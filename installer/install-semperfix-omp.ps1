<#
SemperFix OMP Standard Installer
Version: 1.0.0
Release Date: 2026-08-04
Maintainer: Bruce (SemperFix)
Purpose: Deterministic Oh-My-Posh installation for Windows 11 Pro
#>

$SemperFixOMPVersion = "1.0.0"

Write-Host "=== SemperFix OMP Installer v$SemperFixOMPVersion ===" -ForegroundColor Cyan

# 1. Remove Microsoft Store remnants
Write-Host "[1/8] Removing Microsoft Store remnants..."
Get-AppxPackage *ohmyposh* | Remove-AppxPackage -ErrorAction SilentlyContinue

# 2. Rename WindowsApps symlinks
Write-Host "[2/8] Renaming WindowsApps symlinks..."
$winApps = "$env:LOCALAPPDATA\Microsoft\WindowsApps"
Rename-Item "$winApps\oh-my-posh.exe" "oh-my-posh.exe.bak" -ErrorAction SilentlyContinue
Rename-Item "$winApps\oh-my-posh.ps1" "oh-my-posh.ps1.bak" -ErrorAction SilentlyContinue

# 3. Create SemperFix OMP directory
Write-Host "[3/8] Creating SemperFix OMP directory..."
$ompDir = "$env:LOCALALAPPDATA\Programs\oh-my-posh"
New-Item -ItemType Directory -Path $ompDir -Force | Out-Null

# 4. Copy binary
Write-Host "[4/8] Installing oh-my-posh.exe..."
Copy-Item "$PSScriptRoot\..\bin\oh-my-posh.exe" "$ompDir\oh-my-posh.exe" -Force

# 5. Copy themes
Write-Host "[5/8] Installing themes..."
Copy-Item "$PSScriptRoot\..\themes" "$ompDir\themes" -Recurse -Force

# 6. Install fonts
Write-Host "[6/8] Installing JetBrainsMono Nerd Fonts..."

$fontSource = "$PSScriptRoot\..\fonts"
$fontTarget = "$env:WINDIR\Fonts"

# COM object for proper font registration
$Shell = New-Object -ComObject Shell.Application
$FontsFolder = $Shell.NameSpace($fontTarget)

Get-ChildItem -Path $fontSource -Filter *.ttf | ForEach-Object {
    $fontFile = $_.FullName
    Write-Host "Installing font: $($_.Name)"

    # Copy the file into the Fonts folder
    Copy-Item $fontFile $fontTarget -Force

    # Register the font with Windows
    $FontsFolder.CopyHere($fontFile, 0x10)
}

# 7. Fix PATH precedence
Write-Host "[7/8] Updating PATH..."
$correctPath = "$env:LOCALAPPDATA\Programs\oh-my-posh"
if (-not ($env:Path -split ";" | Where-Object { $_ -eq $correctPath })) {
    $env:Path = "$correctPath;" + $env:Path
}

# 8. Update PowerShell profile
Write-Host "[8/8] Updating PowerShell profile..."
$profileDir = Split-Path $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$profileBlock = @"
`$env:POSH_THEMES_PATH = "`$env:LOCALAPPDATA\Programs\oh-my-posh\themes"
oh-my-posh init pwsh --config "`$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
"@

Add-Content -Path $PROFILE -Value $profileBlock

# Verification
Write-Host ""
Write-Host "=== Verifying SemperFix OMP Package v$SemperFixOMPVersion ===" -ForegroundColor Yellow

if (-not (Test-Path "$ompDir\oh-my-posh.exe")) {
    Write-Host "ERROR: Missing binary." -ForegroundColor Red
}

if (-not (Test-Path "$ompDir\themes\paradox.omp.json")) {
    Write-Host "ERROR: Missing theme." -ForegroundColor Red
}

if (-not (Get-ChildItem "$env:WINDIR\Fonts" | Where-Object { $_.Name -like "*JetBrainsMono*" })) {
    Write-Host "ERROR: Fonts not installed." -ForegroundColor Red
}

Write-Host "Verification complete." -ForegroundColor Green
Write-Host "SemperFix OMP Package Version: $SemperFixOMPVersion" -ForegroundColor Yellow
Write-Host "Restart Windows Terminal to apply changes." -ForegroundColor Cyan
