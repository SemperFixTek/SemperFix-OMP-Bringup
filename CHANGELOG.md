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
- Using standard theme from designer to resolve for now before customising.