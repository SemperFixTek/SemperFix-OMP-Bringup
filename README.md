# SemperFix OMP Bring-Up Kit

This repository contains the deterministic Oh-My-Posh installation workflow used across the SemperFix architecture (MASTERZERO → SECONDARY → OFFSITE).

## Contents

- `bin/` — known-good oh-my-posh.exe
- `themes/` — SemperFix Standard Theme (Paradox base)
- `fonts/` — Nerd Fonts required for glyph rendering
- `installer/` — SemperFix OMP installer script
- `docs/` — bring-up card PDF

## Installation

```powershell
git clone https://github.com/SemperFix/SemperFix-OMP-Bringup
cd SemperFix-OMP-Bringup\installer
.\install_semperfix_omp.ps1
Restart Windows Terminal.

## Notes

1. Do NOT install Oh-My-Posh from the Microsoft Store.

2 This kit bypasses winget entirely.

3 WindowsApps shadowing is automatically mitigated.

4 Font Selection & Delugia Deprecation - Check out README in /fonts regarding font selection
  