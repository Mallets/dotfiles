#!/usr/bin/env bash
set -euo pipefail

# Install system packages
sudo apt install -y rsync

# Install Rust via rustup (non-interactive)
if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# Make cargo/rustup available for the rest of this script
source "$HOME/.cargo/env"

# Ensure rust-analyzer component is present
rustup component add rust-analyzer

# Symlink dotfiles to home directory (stow-style manual fallback)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for file in "$DOTFILES_DIR"/.[!.]*; do
    name="$(basename "$file")"
    # Skip .git
    [[ "$name" == ".git" ]] && continue
    ln -sf "$file" "$HOME/$name"
done
