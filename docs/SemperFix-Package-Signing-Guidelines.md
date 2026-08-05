# SemperFix Package Signing Guidelines

## Purpose
To ensure authenticity, integrity, and traceability of SemperFix packages across MASTERZERO, SECONDARY, and OFFSITE.

## Signing Components
Each SemperFix package must include:
- Version metadata
- Maintainer identity
- Release date
- Location
- Certification status

## Required Files
- manifest.json
- RELEASE_NOTES_<version>.md
- SemperFix-Certification-Checklist_<version>.md
- Signed tag in GitHub

## GitHub Tag Signing
All official releases must use signed tags:

git tag -s v1.0.0 -m "SemperFix OMP Bring-Up Package v1.0.0"
git push --tags

Code

## Maintainer Identity
Current maintainer:
- **Bruce (SemperFix)**  
- Ventura, CA  
- August 2026

## Certification
A package is considered “signed” when:
- The certification checklist is complete
- The release notes are finalized
- The GitHub tag is signed
- The manifest.json version matches the release tag

## Future Enhancements
- GPG key rotation
- Multi-maintainer signatures
- Automated signing pipeline