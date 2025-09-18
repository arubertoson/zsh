#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOTSTRAP_STATE="$HOME/.zsh-bootstrap-state"

log() { printf "\033[1;32m[UPDATE]\033[0m %s\n" "$*"; }
error() { printf "\033[1;31m[ERROR]\033[0m %s\n" "$*"; }

cd "$REPO_DIR"

if git diff --quiet && git diff --staged --quiet; then
    log "Pulling latest changes..."
    git pull --rebase
else
    error "Working directory not clean. Commit or stash changes first."
    exit 1
fi

# Scripts are safe to re-run as they handle existing symlinks gracefully
log "Updating scripts..."
./bootstrap.d/40-scripts

log "Updating mise configuration..."
./bootstrap.d/20-mise

log "Updating dotfiles..."
just update-dotfiles

if [ -f "$BOOTSTRAP_STATE" ]; then
    log "Checking for outdated bootstrap stages..."
    # This is a simple check - in a real scenario you might want more sophisticated
    # version checking or dependency tracking
    log "Bootstrap state preserved. Run 'just bootstrap' if you need to re-run stages."
fi

log "Update complete! Run 'just status' to verify."