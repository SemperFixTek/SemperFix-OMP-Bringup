<#
SemperFix OMP Standard Installer
Version: 1.0.0
Author: Bruce (SemperFix)
Purpose: Deterministic Oh-My-Posh installation for Windows 11 Pro
#>

Write-Host "=== SemperFix OMP Installer ===" -ForegroundColor Cyan

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
$ompDir = "$env:LOCALAPPDATA\Programs\oh-my-posh"
New-Item -ItemType Directory -Path $ompDir -Force | Out-Null

# 4. Copy binary
Write-Host "[4/8] Installing oh-my-posh.exe..."
Copy-Item "$PSScriptRoot\..\bin\oh-my-posh.exe" "$ompDir\oh-my-posh.exe" -Force

# 5. Copy themes
Write-Host "[5/8] Installing themes..."
Copy-Item "$PSScriptRoot\..\themes" "$ompDir\themes" -Recurse -Force

# 6. Install fonts
Write-Host "[6/8] Installing Nerd Fonts..."
$fontDir = "$env:WINDIR\Fonts"
Copy-Item "$PSScriptRoot\..\fonts\*.ttf" $fontDir -Force

# 7. Fix PATH precedence
Write-Host "[7/8] Updating PATH..."
$correctPath = "$env:LOCALAPPDATA\Programs\oh-my-posh"
if (-not ($env:Path -split ";" | Select-String $correctPath)) {
    $env:Path = "$correctPath;" + $env:Path
}

# 8. Update PowerShell profile
Write-Host "[8/8] Updating PowerShell profile..."
$profileBlock = @"
`$env:POSH_THEMES_PATH = "`$env:LOCALAPPDATA\Programs\oh-my-posh\themes"
oh-my-posh init pwsh --config "`$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
"@

Add-Content -Path $PROFILE -Value $profileBlock

Write-Host "=== SemperFix OMP Installation Complete ===" -ForegroundColor Green
Write-Host "Restart Windows Terminal to apply changes."
