#!/usr/bin/env bash
# MarkView one-line installer.
#
#   curl -fsSL https://markdown.kuberscan.com/install.sh | bash
#
# What this does:
#   1. Checks you're on macOS.
#   2. Asks GitHub for the latest MarkView .dmg release URL.
#   3. Downloads it to a temp dir.
#   4. Mounts it.
#   5. Copies MarkView.app into /Applications (overwriting any older copy).
#   6. Strips the com.apple.quarantine attribute so Gatekeeper doesn't
#      reprompt — same trick the Homebrew Cask uses + what MarkView's
#      own in-app updater does. The first launch is clean: no
#      "developer cannot be verified" warning, no right-click → Open.
#   7. Detaches the DMG and removes the temp file.
#
# What this does NOT do:
#   - Touch your vault (your notes live in iCloud / ~/Documents /
#     wherever you picked at first launch; that's untouched).
#   - Require sudo (so long as /Applications is writable by your user,
#     which is the macOS default).
#   - Phone home — only HTTPS requests are GitHub for the release
#     metadata + DMG download.

set -euo pipefail

# ── Pretty output ───────────────────────────────────────────────────
BOLD=$(printf '\033[1m')
DIM=$(printf '\033[2m')
GREEN=$(printf '\033[32m')
RED=$(printf '\033[31m')
RESET=$(printf '\033[0m')

say()  { printf '%s→%s %s\n'    "$BOLD"  "$RESET" "$*"; }
ok()   { printf '%s✓%s %s\n'    "$GREEN" "$RESET" "$*"; }
die()  { printf '%s✗ %s%s\n' "$RED"   "$*" "$RESET" >&2; exit 1; }

# ── Preflight ──────────────────────────────────────────────────────
if [[ "$(uname -s)" != "Darwin" ]]; then
    die "MarkView is macOS-only. (uname says $(uname -s))"
fi
if ! command -v curl >/dev/null; then
    die "curl is required but not installed."
fi

REPO="enderphan94/markdown-app"
API="https://api.github.com/repos/${REPO}/releases/latest"

say "Fetching latest release info from GitHub"
RELEASE_JSON="$(curl -fsSL -H 'Accept: application/vnd.github+json' "$API" \
                || die 'GitHub API request failed (offline?)')"

DMG_URL="$(printf '%s' "$RELEASE_JSON" \
    | grep -oE '"browser_download_url"[[:space:]]*:[[:space:]]*"[^"]+\.dmg"' \
    | head -1 \
    | sed -E 's/.*"(https:\/\/[^"]+\.dmg)"/\1/')"
TAG="$(printf '%s' "$RELEASE_JSON" \
    | grep -oE '"tag_name"[[:space:]]*:[[:space:]]*"[^"]+"' \
    | head -1 | sed -E 's/.*"([^"]+)"$/\1/')"

[[ -n "$DMG_URL" ]] || die "Could not find a .dmg asset in the latest release."

say "Installing MarkView ${TAG:-latest}"
printf '%s  %s%s\n' "$DIM" "$DMG_URL" "$RESET"

# ── Stop any running copy so we can replace the bundle ────────────
if pgrep -fl "/Applications/MarkView.app/Contents/MacOS/MarkView" >/dev/null 2>&1; then
    say "MarkView is running — closing it"
    osascript -e 'tell application "MarkView" to quit' 2>/dev/null || true
    # Give it a moment to actually exit.
    for _ in 1 2 3 4 5 6 7 8 9 10; do
        pgrep -fl "/Applications/MarkView.app" >/dev/null 2>&1 || break
        sleep 0.5
    done
fi

# ── Download to a private temp dir ─────────────────────────────────
TMPDIR="$(mktemp -d -t markview-install)"
DMG_PATH="$TMPDIR/MarkView.dmg"
MOUNT_POINT=""
cleanup() {
    [[ -n "$MOUNT_POINT" && -d "$MOUNT_POINT" ]] \
        && hdiutil detach "$MOUNT_POINT" -quiet 2>/dev/null || true
    rm -rf "$TMPDIR" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

say "Downloading $(basename "$DMG_URL")"
curl -fL --progress-bar -o "$DMG_PATH" "$DMG_URL" \
    || die "Download failed."

# ── Mount + locate the .app ────────────────────────────────────────
say "Mounting DMG"
MOUNT_INFO="$(hdiutil attach "$DMG_PATH" -nobrowse -readonly -plist 2>/dev/null \
              || die 'Could not mount DMG.')"
# Parse the plist-ish output for the /Volumes/ mount-point. plist
# parsing in bash is gross; this regex grabs the first /Volumes/ path
# from the XML output.
MOUNT_POINT="$(printf '%s' "$MOUNT_INFO" \
    | grep -oE '/Volumes/[^<]+' | head -1)"
[[ -n "$MOUNT_POINT" && -d "$MOUNT_POINT" ]] \
    || die "Could not determine mount point."

SRC_APP="$MOUNT_POINT/MarkView.app"
[[ -d "$SRC_APP" ]] || die "MarkView.app not found in DMG."

# ── Install into /Applications ─────────────────────────────────────
DEST="/Applications/MarkView.app"
say "Copying MarkView.app to /Applications"
if ! rm -rf "$DEST" 2>/dev/null; then
    die "Couldn't remove existing $DEST. Try: sudo rm -rf $DEST"
fi
if ! cp -R "$SRC_APP" "$DEST" 2>/dev/null; then
    die "Couldn't write to /Applications. Try running with sudo if your install needs admin rights."
fi

# ── Strip quarantine so Gatekeeper doesn't reprompt ───────────────
# The DMG was downloaded from the internet, so macOS tagged it with
# com.apple.quarantine — that's what triggers the "developer cannot
# be verified" warning. Stripping it on install is what makes the
# rest of the install path clean. The Homebrew Cask does the same.
say "Removing quarantine attribute"
xattr -dr com.apple.quarantine "$DEST" 2>/dev/null || true

# ── Done ───────────────────────────────────────────────────────────
ok "MarkView ${TAG:-} installed at $DEST"
echo
echo "Launch it from Spotlight (⌘+Space → MarkView) or:"
echo "    open /Applications/MarkView.app"
echo
echo "Updates: MarkView checks GitHub on launch and prompts to update."
echo "         You can also re-run this installer at any time."
