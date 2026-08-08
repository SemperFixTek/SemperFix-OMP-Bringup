# Changelog — SemperFix OMP Bring-Up Package

## [0.9.0] — 2026-08-04 (Pre-Release)
### Added
- Initial SemperFix OMP Bring-Up Package
- Deterministic Oh-My-Posh installer script
- JetBrainsMono Nerd Font pack (Delugia deprecated upstream)
- SemperFix Standard Paradox Theme
- Full bring-up card (PDF-ready)
- Package manifest (manifest.json)
- Certification checklist
- Release notes
- Repo-level README
- Version metadata baked into installer
- WindowsApps shadowing mitigation
- PowerShell profile auto-configuration
- Multi-machine repeatability workflow

### Notes
This is the first SemperFix pre-release.  
Used for testing installer behavior, release mechanics, certification workflow, and multi-machine deployment.

---

## [1.0.0] — Pending Certification
### Planned
- Certified stable release after v0.9.0 validation
- No changes expected unless issues discovered during pre-release testing

---

## [1.0.1] - Running debugging 
### Problems
- Powerline glyfs are in fallback mode, not conforming to desired state
- seems to be happening with MSIX buids sandboxing

---

## [1.0.2] - Theme errors found
### solutions
- Buildup automation build theme mission $schema headers.
- Using standard theme from designer to resolve for now before\n
  customizing and modifying.

---

## [1.9.0] - Installer improvements
### Added / Fixed
- Updated `installer\install-semperfix-omp.ps1` to version `1.9.0`
- Improved JetBrainsMono Nerd Font installation feedback
- Hardened persistent user `PATH` update for OMP install directory
- Ensured PowerShell profile auto-configuration writes the correct theme path

---

## [1.0.4] - Installer hardening and MSIX compatibility
### Added / Fixed
- Updated `installer\install-semperfix-omp.ps1` to version `1.0.4`
- Added PowerShell engine detection for MSIX vs system-installed PowerShell
- Added cleanup for Microsoft Store Oh-My-Posh remnants before reinstall
- Added WindowsApps symlink rename mitigation for conflicting Store installations
- Improved SemperFix OMP install directory creation and binary/theme deployment flow
- Hardened persistent user PATH updates and PowerShell profile initialization
- Added clearer verification output for installed binary, theme, and profile state

---

## [1.0.7] - Installer version and theme configuration update
### Added / Fixed
- Updated `installer\install-semperfix-omp.ps1` to version `1.0.7`
- Hardened theme deployment by removing stale theme folders and copying the current theme set deterministically
- Centralized the selected theme filename in a configurable variable at the top of `installer\install-semperfix-omp.ps1`
- Switched the installer to use the `microverse-power.omp.json` theme via a configurable `$themeFileName` variable
- Updated the PowerShell profile initialization and verification logic to use the shared theme variable
- Improved installer maintainability by reducing hard-coded theme references to a single definition
- Ensured the profile initialization and verification steps reference the same theme definition
- Kept the installer behavior aligned with the current SemperFix theme package layout
- Added complete font package for Jetbrains fonts

---

## [2.0.0] — 2026-08-07
### Added / Fixed
- Updated `installer\install-semperfix-omp.ps1` to version `2.0.0` and aligned the installer flow with the current SemperFix deployment workflow for Windows 10/11.
- Strengthened PowerShell engine detection for MSIX and system-installed `pwsh` environments so the script uses the correct runtime path.
- Improved cleanup of Microsoft Store and WindowsApps remnants before reinstalling Oh-My-Posh to reduce conflicts and stale shortcuts.
- Standardized theme deployment by removing stale theme folders and copying the SemperFix theme bundle deterministically from the repo.
- Added deterministic JetBrainsMono Nerd Font installation, including cleanup of conflicting system fonts, registration of the authoritative font, and DirectWrite cache refresh.
- Hardened persistent user PATH updates and PowerShell profile initialization so the installed binary, theme path, and startup block remain consistent.
- Expanded verification output to confirm the installed binary, theme file, and PowerShell profile state after setup.

---

## [2.1.0] — 2026-08-07
### Added
- Added diagnostics/omp-full-diag.ps1 to provide a full Oh My Posh environment diagnostic flow for glyph rendering, font support, Powerline separators, theme loading, and overall terminal readiness.
- Included a structured verification checklist for color scheme, padding, and final operational status in the new diagnostic script.