Write-Host "`n===============================" -ForegroundColor Cyan
Write-Host "   SEMPERFIX OMP — FULL DIAGNOSTIC MODE" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

# ------------------------------------------------------------
# 1. Environment Identity
# ------------------------------------------------------------
Write-Host "`n[1] Environment Identity" -ForegroundColor Yellow
Write-Host "Terminal: Windows Terminal"
Write-Host "FontFace (RawUI): $($Host.UI.RawUI.FontFamily)"
Write-Host "Execution Host: $([System.Environment]::UserInteractive)"
Write-Host "MSIX Sandbox: $([System.Environment]::GetEnvironmentVariable('WT_SESSION'))"

# ------------------------------------------------------------
# 2. OMP Theme Load Check
# ------------------------------------------------------------
Write-Host "`n[2] Oh My Posh Theme Load Check" -ForegroundColor Yellow
try {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\semperfix.omp.json" | Out-Null
    Write-Host "OMP Theme Loaded Successfully" -ForegroundColor Green
} catch {
    Write-Host "OMP Theme FAILED to load" -ForegroundColor Red
}

# ------------------------------------------------------------
# 3. Powerline Separators
# ------------------------------------------------------------
Write-Host "`n[3] Powerline Separators" -ForegroundColor Yellow
"         "

# ------------------------------------------------------------
# 4. Nerd Font Icons
# ------------------------------------------------------------
Write-Host "`n[4] Nerd Font Icons" -ForegroundColor Yellow
"            "

# ------------------------------------------------------------
# 5. Devicons
# ------------------------------------------------------------
Write-Host "`n[5] Devicons" -ForegroundColor Yellow
"          "

# ------------------------------------------------------------
# 6. Codicons
# ------------------------------------------------------------
Write-Host "`n[6] Codicons" -ForegroundColor Yellow
"          "

# ------------------------------------------------------------
# 7. Private Use Area Glyphs
# ------------------------------------------------------------
Write-Host "`n[7] Private Use Area Glyphs" -ForegroundColor Yellow
"          "

# ------------------------------------------------------------
# 8. Box Drawing Characters
# ------------------------------------------------------------
Write-Host "`n[8] Box Drawing Characters" -ForegroundColor Yellow
"┌ ┬ ┐"
"├ ┼ ┤"
"└ ┴ ┘"

# ------------------------------------------------------------
# 9. Arrows
# ------------------------------------------------------------
Write-Host "`n[9] Arrows" -ForegroundColor Yellow
"← ↑ → ↓ ↔ ↕ ↖ ↗ ↘ ↙"

# ------------------------------------------------------------
# 10. Unicode Blocks
# ------------------------------------------------------------
Write-Host "`n[10] Unicode Blocks" -ForegroundColor Yellow
"░ ▒ ▓ █ ▉ ▊ ▋ ▌ ▍ ▎ ▏"

# ------------------------------------------------------------
# 11. OMP Segment Transitions
# ------------------------------------------------------------
Write-Host "`n[11] OMP Segment Transitions" -ForegroundColor Yellow
"    "

# ------------------------------------------------------------
# 12. Color Scheme Verification
# ------------------------------------------------------------
Write-Host "`n[12] Color Scheme Verification" -ForegroundColor Yellow
Write-Host "Foreground: #F2F2F2"
Write-Host "Background: #0C0C0C"
Write-Host "If colors differ, WT is not using SemperFix scheme." -ForegroundColor DarkGray

# ------------------------------------------------------------
# 13. Padding Check
# ------------------------------------------------------------
Write-Host "`n[13] Padding Check" -ForegroundColor Yellow
Write-Host "Padding should be: 6, 8" -ForegroundColor DarkGray

# ------------------------------------------------------------
# 14. Final Verdict
# ------------------------------------------------------------
Write-Host "`n===============================" -ForegroundColor Cyan
Write-Host "   DIAGNOSTIC COMPLETE" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

Write-Host "`nIf ALL glyphs above render cleanly:" -ForegroundColor Green
Write-Host "→ SemperFix OMP is fully operational." -ForegroundColor Green
Write-Host "→ Windows Terminal is using the correct font." -ForegroundColor Green
Write-Host "→ DirectWrite is stable." -ForegroundColor Green
Write-Host "→ No fallback glyphs detected." -ForegroundColor Green
