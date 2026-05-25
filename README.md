# MarkView

MarkView is a markdown editor with live preview, Mermaid diagram support, and an offline-first macOS app for taking notes in a real filesystem vault that syncs through iCloud Drive.

## Overview

MarkView comes in two versions built on the same editor engine and visual style:

- **Web app** — Use it in any browser at [markdown.kuberscan.com](https://markdown.kuberscan.com). The **Save & share** feature generates a temporary 48-hour URL that anyone can open.
- **macOS app** — A native desktop app for offline note-taking. It adds an Obsidian-style workspace sidebar with nestable folders and notes, stores content as real `.md` files on disk, and syncs automatically through iCloud Drive or any other sync service. Notes can also be opened in Obsidian, VS Code, vim, or any other markdown editor.

The web app source code lives in [enderphan94/markdown](https://github.com/enderphan94/markdown). This repository contains the macOS `.dmg` releases and project documentation.
## Installation

### Option 1: One-line installer

```bash
curl -fsSL https://markdown.kuberscan.com/install.sh | bash
```

This installs the latest `.dmg`, copies MarkView to `/Applications`, removes the quarantine attribute, and ejects the disk image automatically.

### Option 2: Homebrew

```bash
brew install --cask enderphan94/tap/markview
```

To update later:

```bash
brew upgrade --cask markview
```

### Option 3: Direct download

Download the latest release `.dmg` from the [Releases page](https://github.com/enderphan94/markdown-app/releases/latest), then:

1. Open the `.dmg`.
2. Drag **MarkView.app** into **Applications**.
3. Eject the mounted disk image.
4. On first launch only, right-click the app and choose **Open** if macOS shows a warning.
## Features

### Shared editor experience

- Live preview while you type.
- GitHub-flavored markdown support, including headings, lists, task lists, tables, blockquotes, code blocks, links, images, and horizontal rules.
- Syntax highlighting for 180+ languages via highlight.js.
- Inline Mermaid support for flowcharts, sequence diagrams, pie charts, state diagrams, class diagrams, gantt charts, mindmaps, ER diagrams, journey diagrams, and git graphs.
- PDF export in two modes:
  - **Default**: black-and-white output optimized for small file size.
  - **Styled**: preserves preview colors, syntax highlighting, and Mermaid colors.
- Draggable splitters between panes, with saved layout positions.
- Light and dark themes with one-tap switching.
- Save & share support for temporary 48-hour public links.
- Cmd/Ctrl + S to save.

### macOS app only

#### Real filesystem vault

- Folders are directories and notes are `.md` files on disk.
- First-launch vault picker with a recommended iCloud Drive default for cross-Mac sync.
- Vault location can be changed later from Settings.
- Existing v2.1 notes are imported to the new file-based vault on first launch of v2.2+.

#### Workspace sidebar

- Nestable folders and notes with drag-and-drop.
- Right-click actions for new note, new folder, rename, duplicate, copy & share URL, and delete.
- Double-click to rename, matching common file-manager behavior.
- Expand-all and collapse-all controls in the sidebar header.
- Multiple sort modes by filename, modified date, or created date.
- Auto-save every 500 ms while typing, plus a forced flush on Cmd/Ctrl + S.

#### Import and sharing

- Import notes from URLs, including:
  - `markdown.kuberscan.com/<id>` or raw share IDs.
  - GitHub blob, edit, and raw URLs.
  - `raw.githubusercontent.com` URLs.
- Save & share from the toolbar to publish the current note as a 48-hour URL.
- Copy & Share URL from the context menu for one-click sharing.

#### Auto-update

- On-launch update checks against GitHub releases.
- One-click update flow that downloads the latest `.dmg`, replaces the app, strips quarantine attributes, and relaunches automatically.
- Manual update check from Settings.

#### Polish

- English and Vietnamese UI.
- Settings panel for language, theme, vault location, version, and update checks.
- Welcome sample on first launch with markdown and Mermaid examples.
- Keyboard guard to prevent accidental reload or close actions.
- Web Inspector disabled in shipped builds, with a debug override available for troubleshooting.

## Requirements

- macOS 11 (Big Sur) or newer.
- Universal build for Intel and Apple Silicon Macs.
- Network access is only needed for Save & share, Import, Copy Share URL, and auto-update features.


## Data storage

MarkView stores data in two locations:

```text
~/Library/Application Support/MarkView/config.json   # per-Mac configuration
<your vault folder>/                                 # your notes as real .md files
```

Reinstalling MarkView does not remove either location. To back up your notes, copy the vault folder.


## Inspiration

MarkView was shaped by ideas and code from the following projects:

- [mermaid-js/mermaid](https://github.com/mermaid-js/mermaid) — diagram rendering.
- [tanabe/markdown-live-preview](https://github.com/tanabe/markdown-live-preview) — live-preview layout and splitter UX.
- [Obsidian](https://obsidian.md) — vault-based note organization and sidebar conventions.

## Project links

- Web app: [markdown.kuberscan.com](https://markdown.kuberscan.com)
- Web source code: [enderphan94/markdown](https://github.com/enderphan94/markdown)
- macOS releases: [enderphan94/markdown-app/releases](https://github.com/enderphan94/markdown-app/releases)
- Issues: [enderphan94/markdown-app/issues](https://github.com/enderphan94/markdown-app/issues)

## Author

Built by [enderphan94](https://github.com/enderphan94).

Contact: enderlocphan@gmail.com