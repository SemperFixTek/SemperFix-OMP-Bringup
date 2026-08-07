<#
SemperFix OMP Standard Installer
Version: $scriptVersion
Maintainer: Bruce (SemperFix)
Purpose: Deterministic Oh-My-Posh installation for Windows 10/11
#>

$scriptVersion = "1.0.7"
$themeFileName = "microverse-power.omp.json"

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
# 6. Install fonts (admin-free)
# ------------------------------------------------------------
Write-Host "[6/8] Installing JetBrainsMono Nerd Fonts..."

Add-Type -Namespace Win32 -Name FontStuff -MemberDefinition @"
    [DllImport("gdi32.dll", SetLastError=true)]
    public static extern int AddFontResource(string lpFileName);
"@

Get-ChildItem -Path $fontsDir -Filter *.ttf | ForEach-Object {
    $fontFile = $_.FullName
    Write-Host "Installing font: $($_.Name)"

    $result = [Win32.FontStuff]::AddFontResource($fontFile)

    if ($result -gt 0) {
        Write-Host "Font installed successfully: $($_.Name)"
    } else {
        Write-Host "WARNING: Font may already be installed or registration failed: $($_.Name)" -ForegroundColor Yellow
    }
}

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
# SemperFix OMP Profile Block v1.0.6
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
Write-Host "Verification complete." -ForegroundColor Green
Write-Host "SemperFix OMP Package Version: $scriptVersion" -ForegroundColor Yellow
Write-Host "Restart Windows Terminal to apply changes." -ForegroundColor Cyan
