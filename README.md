# MarkView

A fully offline macOS markdown editor with mermaid diagram support,
live preview, PDF export, and syntax-highlighted code blocks.
Everything runs locally on your Mac. Nothing leaves your machine.

The web version is at [markdown.kuberscan.com](https://markdown.kuberscan.com).
This repo just ships the macOS `.dmg`. The source code lives at
[enderphan94/markdown](https://github.com/enderphan94/markdown).

---

## Download

Grab the latest build from the **[Releases](https://github.com/enderphan94/markdown-app/releases)** page:

> [**MarkView-1.0.0.dmg**](https://github.com/enderphan94/markdown-app/releases/latest)

| | |
|---|---|
| Size | ~13 MB |
| Requires | macOS 11 (Big Sur) or newer |
| Architecture | Universal (Intel + Apple Silicon, x86_64) |
| Network | Works fully offline. No telemetry, no analytics, no accounts. |

---

## Install

1. Double-click `MarkView-1.0.0.dmg` to mount it.
2. Drag **MarkView.app** into the **Applications** folder shortcut in the same window.
3. Eject the mounted disk.
4. **First launch** (one-time only): open Finder → Applications, then
   **right-click MarkView → Open** → click **Open** in the dialog.
   This is needed because the app is unsigned. macOS only asks once;
   every launch afterwards works normally from the Dock or Spotlight.

If you double-click MarkView and macOS says "cannot be opened because
Apple cannot check it for malicious software", that's the same Gatekeeper
warning. Right-click → Open bypasses it.

---

## Features

- **Live preview** as you type, with syntax-highlighted code blocks
  (Python, JavaScript, Bash, and 180+ other languages via highlight.js).
- **Mermaid diagrams** rendered inline: flowcharts, sequence diagrams,
  pie charts, state diagrams, class diagrams, Gantt charts, mindmaps,
  ER diagrams, user journeys, git graphs. See [mermaid.js.org](https://mermaid.js.org)
  for the full catalog of what works inside fenced ` ```mermaid ` blocks.
- **Export PDF** in two modes via a chooser dialog:
  - *Default* — pure black & white, mermaid diagrams forced to grayscale.
  - *Styled* — preview colors preserved, including syntax highlighting
    and colored mermaid SVGs.
  Tall mermaid charts auto-scale to fit one page so they never overlap
  text or create blank trailing pages.
- **Download .md** — save the current editor content to a file anywhere
  on disk. Cmd-S also triggers this.
- **Draggable splitter** between the Markdown and Preview panes.
  Position persists across launches. Double-click to reset; arrow keys
  to nudge.
- **Dark and light themes** with a one-tap toggle. Mermaid diagrams
  re-render with the matching palette.
- **Welcome sample on first launch** showing every markdown feature
  plus four mermaid diagram types, so you can see what's possible
  immediately.

---

## Data

- The SQLite database (currently unused in offline mode but kept for
  future features) lives at:

      ~/Library/Application Support/MarkView/markdown.db

- The split-pane position and dark/light preference are stored in
  the embedded browser's localStorage, inside the same Application
  Support directory.

- Nothing is uploaded anywhere. There is no `/api/save` endpoint —
  the only network calls in the app are to `127.0.0.1`.

---

## Uninstall

1. Drag **MarkView.app** from Applications to the Trash.
2. Optional, removes settings + DB:

   ```bash
   rm -rf ~/Library/Application\ Support/MarkView
   ```

---

## Source code

The Python + Flask + Jinja + JS source is at
[enderphan94/markdown](https://github.com/enderphan94/markdown). The
desktop build pipeline (PyInstaller spec, pywebview entry point, .dmg
script) lives in the `desktop/` directory of that repo.

---

## Author

Built by [enderphan94](https://github.com/enderphan94). Issues and
feature requests welcome.

<enderlocphan@gmail.com>
