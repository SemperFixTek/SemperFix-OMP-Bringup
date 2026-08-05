📁 README — Font Selection & Delugia Deprecation
Why Delugia Was Removed
The Delugia Nerd Font family (Delugia Complete, Delugia Mono, etc.) was originally a patched version of Cascadia Code with Nerd Font glyphs added. It was widely used in terminal environments and was a common recommendation for Oh‑My‑Posh setups.

However, during the Nerd Fonts v3.0 cleanup and consolidation, the maintainers removed several older or redundant patched fonts — including Delugia — for the following reasons:

Cascadia Code changed its packaging and licensing, making Delugia harder to maintain.

Nerd Fonts consolidated patching pipelines, removing fonts that duplicated functionality.

JetBrainsMono Nerd Font became the recommended terminal font, replacing older patched sets.

Delugia became redundant with newer Cascadia variants and modern NF patching.

Repository size reduction: Delugia was one of many fonts removed to streamline the project.

As of Nerd Fonts v3.0+, Delugia is no longer available in the official repository and is not maintained upstream.

What We Use Instead
The SemperFix OMP Bring‑Up Kit standardizes on:

JetBrainsMono Nerd Font
This is the actively maintained, modern, stable replacement for Delugia. It provides:

Full Nerd Font glyph coverage

Clean, readable terminal typography

Excellent alignment for Oh‑My‑Posh segments

Active upstream maintenance

Consistent behavior across Windows Terminal, PowerShell 7, and WSL2

Future‑proof compatibility with OMP themes

JetBrainsMono NF is now the recommended font for Oh‑My‑Posh by both the community and the Nerd Fonts maintainers.

Included Font Files
The repo includes the following JetBrainsMono Nerd Font variants:

Code
fonts/
│
├── JetBrainsMonoNerdFont-Regular.ttf
├── JetBrainsMonoNerdFont-Bold.ttf
└── JetBrainsMonoNerdFontMono-Regular.ttf
These provide full glyph support and clean monospace alignment for all SemperFix OMP themes.

Why JetBrainsMono NF Is the SemperFix Standard
Actively maintained (unlike Delugia)

Full glyph coverage for Oh‑My‑Posh

Better readability than Cascadia‑based fonts

Consistent rendering across Windows Terminal

No dependency on deprecated patched fonts

Stable multi‑machine deployment for MASTERZERO → SECONDARY → OFFSITE

JetBrainsMono NF eliminates the drift, breakage, and upstream deprecation issues that Delugia introduced.

Operator Note
If you previously used Delugia on older machines, switch to JetBrainsMono NF for all new deployments. The SemperFix installer script automatically installs the correct font files and updates the PowerShell profile accordingly.