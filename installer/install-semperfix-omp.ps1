<#
SemperFix OMP Standard Installer
Version: $scriptVersion
Maintainer: Bruce (SemperFix)
Purpose: Deterministic Oh-My-Posh installation for Windows 10/11
#>

$scriptVersion = "1.0.2"

Write-Host "=== SemperFix OMP Installer v$scriptVersion ===" -ForegroundColor Cyan

# Resolve repo root explicitly
$repoRoot = Split-Path $PSScriptRoot -Parent

$binDir    = Join-Path $repoRoot "bin"
$themesDir = Join-Path $repoRoot "themes"
$fontsDir  = Join-Path $repoRoot "fonts"

# Target directory
$ompDir = "$env:LOCALAPPDATA\Programs\oh-my-posh"

# ------------------------------------------------------------
# 1. Remove Microsoft Store remnants
# ------------------------------------------------------------
Write-Host "[1/8] Removing Microsoft Store remnants..."
Get-AppxPackage *ohmyposh* | Remove-AppxPackage -ErrorAction SilentlyContinue

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
Copy-Item $themesDir "$ompDir\themes" -Recurse -Force

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
$regPath = "HKCU:\Environment"

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

$profileBlock = @"
`$env:POSH_THEMES_PATH = "`$env:LOCALAPPDATA\Programs\oh-my-posh\themes"
oh-my-posh init pwsh --config "`$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
"@

Add-Content -Path $PROFILE -Value $profileBlock

# ------------------------------------------------------------
# Verification
# ------------------------------------------------------------
Write-Host ""
Write-Host "=== Verifying SemperFix OMP Package v$scriptVersion ===" -ForegroundColor Yellow

if (-not (Test-Path "$ompDir\oh-my-posh.exe")) {
    Write-Host "ERROR: Missing binary." -ForegroundColor Red
}

if (-not (Test-Path "$ompDir\themes\paradox.omp.json")) {
    Write-Host "ERROR: Missing theme." -ForegroundColor Red
}

Write-Host "Verification complete." -ForegroundColor Green
Write-Host "SemperFix OMP Package Version: $scriptVersion" -ForegroundColor Yellow
Write-Host "Restart Windows Terminal to apply changes." -ForegroundColor Cyan
