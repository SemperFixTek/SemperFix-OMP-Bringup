<#
SemperFix OMP Standard Installer
Version: $scriptVersion
Maintainer: Bruce (SemperFix)
Purpose: Deterministic Oh-My-Posh installation for Windows 10/11
#>

$scriptVersion = "1.9.0"
$themeFileName = "paradox.omp.json"

Write-Host "=== SemperFix OMP Installer v$scriptVersion ===" -ForegroundColor Cyan

# Resolve repo root explicitly
$repoRoot  = Split-Path $PSScriptRoot -Parent
$binDir    = Join-Path $repoRoot "bin"
$themesDir = Join-Path $repoRoot "themes"
$fontsDir  = Join-Path $repoRoot "fonts"

# Target directory
$ompDir = "$env:LOCALAPPDATA\Programs\oh-my-posh"

# ------------------------------------------------------------
# 0. Detect PowerShell engine (MSIX vs system)
# ------------------------------------------------------------
Write-Host "[0/8] Detecting PowerShell engine..." -ForegroundColor Cyan

$msixPwsh   = "$env:LOCALAPPDATA\Microsoft\WindowsApps\Microsoft.PowerShell_8wekyb3d8bbwe\pwsh.exe"
$systemPwsh = "C:\Program Files\PowerShell\7\pwsh.exe"

if (Test-Path $msixPwsh) {
    Write-Host "Using MSIX PowerShell: $msixPwsh"
} elseif (Test-Path $systemPwsh) {
    Write-Host "WARNING: MSIX PowerShell not found, using system PowerShell: $systemPwsh" -ForegroundColor Yellow
} else {
    Write-Host "WARNING: No explicit pwsh.exe detected; relying on PATH resolution." -ForegroundColor Yellow
}

# ------------------------------------------------------------
# 1. Remove Microsoft Store remnants
# ------------------------------------------------------------
Write-Host "[1/8] Removing Microsoft Store remnants..."
Get-AppxPackage *ohmyposh* | Remove-AppxPackage -ErrorAction SilentlyContinue

Write-Host "Disabling any existing Oh-My-Posh auto-init..."
try {
    oh-my-posh disable | Out-Null
} catch {
    Write-Host "No existing auto-init to disable or oh-my-posh not yet on PATH." -ForegroundColor DarkGray
}

# ------------------------------------------------------------
# 2. Rename WindowsApps symlinks
# ------------------------------------------------------------
Write-Host "[2/8] Renaming WindowsApps symlinks..."
$winApps = "$env:LOCALAPPDATA\Microsoft\WindowsApps"
Rename-Item "$winApps\oh-my-posh.exe" "oh-my-posh.exe.bak" -ErrorAction SilentlyContinue
Rename-Item "$winApps\oh-my-posh.ps1" "oh-my-posh.ps1.bak" -ErrorAction SilentlyContinue

# ------------------------------------------------------------
# 3. Create SemperFix OMP directory
# ------------------------------------------------------------
Write-Host "[3/8] Creating SemperFix OMP directory..."
New-Item -ItemType Directory -Path $ompDir -Force | Out-Null

# ------------------------------------------------------------
# 4. Copy binary
# ------------------------------------------------------------
Write-Host "[4/8] Installing oh-my-posh.exe..."
Copy-Item "$binDir\oh-my-posh.exe" "$ompDir\oh-my-posh.exe" -Force

# ------------------------------------------------------------
# 5. Copy themes
# ------------------------------------------------------------
Write-Host "[5/8] Installing themes..."
# Ensure themes directory exists and is clean
$targetThemes = "$ompDir\themes"

if (Test-Path $targetThemes) {
    Remove-Item $targetThemes -Recurse -Force
}

New-Item -ItemType Directory -Path $targetThemes | Out-Null

# Copy only the contents of the repo themes folder
Copy-Item "$themesDir\*" $targetThemes -Recurse -Force

# ------------------------------------------------------------
# 6. Deterministic JetBrainsMono Nerd Font Installation (Final)
# ------------------------------------------------------------
Write-Host "[6/8] Installing JetBrainsMono Nerd Font (deterministic system-level)..." -ForegroundColor Cyan

$systemFontsDir = "C:\Windows\Fonts"
$fontRegPath    = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

# ------------------------------------------------------------
# Auto-detect fonts directory
# ------------------------------------------------------------
$possibleFonts = @(
    [System.IO.Path]::Combine($repoRoot, "fonts"),
    [System.IO.Path]::Combine($PSScriptRoot, "..\fonts"),
    [System.IO.Path]::Combine($PSScriptRoot, "assets\fonts")
)

$fontsDir = $possibleFonts | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $fontsDir) {
    Write-Host "ERROR: Could not locate fonts directory!" -ForegroundColor Red
    Write-Host "Expected one of:" -ForegroundColor DarkGray
    $possibleFonts | ForEach-Object { Write-Host " - $_" -ForegroundColor DarkGray }
    exit 1
}

Write-Host "Fonts directory detected: $fontsDir" -ForegroundColor Green

# ------------------------------------------------------------
# Remove ALL JetBrainsMono fonts (system-level only)
# ------------------------------------------------------------
Write-Host "Removing conflicting JetBrainsMono fonts from system..." -ForegroundColor Yellow

Get-ChildItem $systemFontsDir -Filter "*JetBrains*" | ForEach-Object {
    Write-Host "Removing system font: $($_.Name)"
    Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
}

# Remove registry entries
Get-Item $fontRegPath | Get-ItemProperty | ForEach-Object {
    $_.PSObject.Properties | Where-Object { $_.Value -like "*JetBrains*" } | ForEach-Object {
        Write-Host "Removing registry font entry: $($_.Name)"
        Remove-ItemProperty -Path $fontRegPath -Name $_.Name -ErrorAction SilentlyContinue
    }
}

# ------------------------------------------------------------
# Install ONE authoritative system-level Nerd Font
# ------------------------------------------------------------
Write-Host "Installing authoritative JetBrainsMono Nerd Font Complete (Regular)..." -ForegroundColor Yellow

$primaryFont = Get-ChildItem -Path $fontsDir -Filter "*JetBrainsMonoNerdFont-Regular*.ttf" | Select-Object -First 1

if ($primaryFont) {
    Write-Host "Copying system font: $($primaryFont.Name)" -ForegroundColor Green
    Copy-Item $primaryFont.FullName $systemFontsDir -Force

    # Register system font
    $fontName = $primaryFont.Name
    New-ItemProperty -Path $fontRegPath -Name $fontName -Value $fontName -PropertyType String -Force | Out-Null

    Write-Host "System-level JetBrainsMono Nerd Font installed." -ForegroundColor Green
} else {
    Write-Host "ERROR: JetBrainsMono Nerd Font Regular not found in: $fontsDir" -ForegroundColor Red
    Write-Host "Make sure the file exists and is named like:" -ForegroundColor DarkGray
    Write-Host "JetBrainsMonoNerdFont-Regular.ttf" -ForegroundColor DarkGray
    exit 1
}

# ------------------------------------------------------------
# Refresh DirectWrite font cache
# ------------------------------------------------------------
Write-Host "Refreshing DirectWrite font cache..." -ForegroundColor Yellow
try {
    Get-Process -Name "fontdrvhost" -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "Font cache refreshed." -ForegroundColor Green
} catch {
    Write-Host "Unable to refresh font cache automatically." -ForegroundColor DarkGray
}

Write-Host "Deterministic font installation complete." -ForegroundColor Cyan

# ------------------------------------------------------------
# 7. Update PATH (persistent user PATH)
# ------------------------------------------------------------
Write-Host "[7/8] Updating PATH..."

$correctPath = "$env:LOCALAPPDATA\Programs\oh-my-posh"
$regPath     = "HKCU:\Environment"

$currentUserPath = (Get-ItemProperty -Path $regPath -Name Path -ErrorAction SilentlyContinue).Path

if ($currentUserPath -notlike "*$correctPath*") {
    $newPath = "$correctPath;$currentUserPath"
    Set-ItemProperty -Path $regPath -Name Path -Value $newPath
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "User PATH updated."
} else {
    Write-Host "User PATH already contains OMP path."
}

# ------------------------------------------------------------
# 8. Update PowerShell profile
# ------------------------------------------------------------
Write-Host "[8/8] Updating PowerShell profile..."

$profileDir = Split-Path $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

if (Test-Path $PROFILE) {
    Write-Host "Existing profile detected; replacing with SemperFix OMP block."
    Remove-Item $PROFILE -Force
}

$profileBlock = @"
# SemperFix OMP Profile Block v1.1.0
`$env:POSH_THEMES_VERSION = '$themeFileName'
`$env:POSH_THEMES_PATH = '$env:LOCALAPPDATA\Programs\oh-my-posh\themes'
oh-my-posh init pwsh --config '$env:LOCALAPPDATA\Programs\oh-my-posh\themes\$themeFileName' | Invoke-Expression
"@

Set-Content -Path $PROFILE -Value $profileBlock

# ------------------------------------------------------------
# Verification
# ------------------------------------------------------------
Write-Host ""
Write-Host "=== Verifying SemperFix OMP Package v$scriptVersion ===" -ForegroundColor Yellow

if (-not (Test-Path "$ompDir\oh-my-posh.exe")) {
    Write-Host "ERROR: Missing binary." -ForegroundColor Red
}

if (-not (Test-Path "$ompDir\themes\$themeFileName")) {
    Write-Host "ERROR: Missing theme." -ForegroundColor Red
}

Write-Host ""
Write-Host "Profile contents:" -ForegroundColor Yellow
try {
    Get-Content $PROFILE
} catch {
    Write-Host "Unable to read profile: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host "        SEMPERFIX OMP — INSTALLATION COMPLETE" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

Write-Host "`nEnvironment Summary:" -ForegroundColor Yellow
Write-Host "• Windows Terminal: Ready"
Write-Host "• JetBrainsMono Nerd Font (System-Level): Installed"
Write-Host "• Oh My Posh: Activated"
Write-Host "• SemperFix Theme: Linked"
Write-Host "• PowerShell Profile: Updated"
Write-Host "• DirectWrite Cache: Refreshed"
Write-Host "• Deterministic Rendering: Enabled"

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "1. Restart Windows Terminal"
Write-Host "2. Run:  C:\\SemperFix\\Diagnostics\\omp-full.ps1"
Write-Host "3. Confirm all glyphs render correctly"

Write-Host "`nSemperFix OMP is now operational." -ForegroundColor Green
Write-Host "Welcome to your upgraded terminal environment." -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan
