# SemperFix OMP Bring-Up Package v1.0.0
A deterministic, repo-backed installation workflow for Oh-My-Posh (OMP) across all SemperFix machines: MASTERZERO, SECONDARY, and OFFSITE. This package standardizes the terminal environment using a pinned OMP binary, JetBrainsMono Nerd Font, and the SemperFix Standard Paradox Theme.

---

## 📦 Package Contents

SemperFix-OMP-Bringup/
│
├── bin/
│   └── oh-my-posh.exe
│
├── themes/
│   └── paradox.omp.json
│
├── fonts/
│   ├── JetBrainsMonoNerdFont-Regular.ttf
│   ├── JetBrainsMonoNerdFont-Bold.ttf
│   └── JetBrainsMonoNerdFontMono-Regular.ttf
│
├── installer/
│   └── install_semperfix_omp.ps1
│
├── docs/
│   ├── SemperFix-OMP-Bringup-Card.pdf
│   └── SemperFix-Certification-Checklist_v1.0.0.md
│
└── manifest.json

Code

All components are pinned, versioned, and controlled for multi-machine repeatability.

---

## 🎯 Purpose

This package provides a stable, drift-free method of installing Oh-My-Posh without relying on winget or the Microsoft Store. It eliminates:

- WindowsApps shadowing
- Store-origin symlink conflicts
- Theme path drift
- Font inconsistencies
- Profile fragmentation

The result is a consistent operator experience across all SemperFix systems.

---

## 🔧 Installation

Clone the repository:

```powershell
git clone https://github.com/SemperFix/SemperFix-OMP-Bringup
cd SemperFix-OMP-Bringup\installer
Run the installer:

powershell
.\install_semperfix_omp.ps1
Restart Windows Terminal to apply changes.

✔ Verification
After restart:

powershell
Get-Command oh-my-posh
Expected:

Code
C:\Users\<User>\AppData\Local\Programs\oh-my-posh\oh-my-posh.exe
Check theme and glyphs:

powershell
oh-my-posh --version
Get-PoshThemes
Prompt should display the SemperFix Standard Paradox Theme with JetBrainsMono Nerd Font glyphs.

📝 Font Standardization
Delugia Nerd Font was removed from the Nerd Fonts project during the v3.0 cleanup.
This package standardizes on JetBrainsMono Nerd Font, which provides:

Full Nerd Font glyph coverage

Clean terminal rendering

Active upstream maintenance

Consistent behavior across Windows Terminal

Future-proof compatibility with Oh-My-Posh

All required font files are included in the fonts/ directory.

🎨 SemperFix Standard Theme
The included theme:

Code
themes/paradox.omp.json
is a tuned Paradox variant with:

Clean glyphs

Stable segments

SemperFix color palette

JetBrainsMono NF alignment

The installer script applies this theme automatically.

📄 Documentation
SemperFix-OMP-Bringup-Card.pdf — Full bring-up instructions

SemperFix-Certification-Checklist_v1.0.0.md — Operator certification workflow

manifest.json — Package metadata and component list

RELEASE_NOTES_v1.0.0.md — Version highlights and certification details

🔖 Versioning
Package: SemperFix OMP Bring-Up
Version: 1.0.0
Release Date: August 4, 2026
Maintainer: Bruce (SemperFix)
Location: Ventura, CA

This is the first official SemperFix Package and establishes the baseline for all future terminal environment releases.

🛡 Certification
This package has been certified for deployment on:

MASTERZERO

SECONDARY

OFFSITE

Certification details are included in:

Code
docs/SemperFix-Certification-Checklist_v1.0.0.md
🚀 Future Versions
Planned enhancements:

SemperFix Standard Theme v1.1

Installer logging and diagnostics

Automatic OMP version updates

Multi-machine sync automation

Package signing guidelines

© SemperFix · 2026
This repository is part of the SemperFix Bring-Up Suite.