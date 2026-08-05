# SemperFix Release Checklist — v0.9.0 Pre-Release

## 1. Repository Preparation
- [ ] All components present (binary, fonts, themes, installer)
- [ ] manifest.json updated with correct version
- [ ] README.md updated
- [ ] CHANGELOG.md updated
- [ ] Release notes prepared
- [ ] Bring-up card PDF exported
- [ ] Certification checklist included

## 2. GitHub Release Preparation
- [ ] Create tag: v0.9.0
- [ ] Upload release assets
- [ ] Paste release description
- [ ] Mark release as "Pre-release"
- [ ] Verify asset integrity

## 3. Installer Validation
- [ ] Run installer on clean Windows 11 Pro machine
- [ ] Verify fonts install correctly
- [ ] Verify theme installs correctly
- [ ] Verify binary resolves correctly
- [ ] Verify PATH precedence
- [ ] Verify profile block
- [ ] Verify WindowsApps shadowing mitigation

## 4. Multi-Machine Testing
- [ ] MASTERZERO test
- [ ] SECONDARY test
- [ ] OFFSITE test
- [ ] Hyper-V VM test
- [ ] Spare laptop test

## 5. Certification
- [ ] Complete certification checklist
- [ ] Mark package as certified
- [ ] Prepare v1.0.0 release notes

## 6. Promotion to v1.0.0
- [ ] Create tag: v1.0.0
- [ ] Mark release as "Latest"
- [ ] Publish stable release
