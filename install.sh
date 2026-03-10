#!/usr/bin/env bash
set -euo pipefail

# Install system packages
sudo apt install -y rsync htop

# Install Rust via rustup (non-interactive)
if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# Make cargo/rustup available for the rest of this script
source "$HOME/.cargo/env"

# Ensure rust-analyzer component is present
rustup component add rust-analyzer

# Symlink dotfiles to home directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for file in "$DOTFILES_DIR"/.[!.]*; do
    name="$(basename "$file")"
    [[ "$name" == ".git" ]] && continue
    # For .config, mirror its subdirectory structure
    if [[ "$name" == ".config" ]]; then
        find "$file" -type f | while read -r src; do
            rel="${src#$file/}"
            dest="$HOME/.config/$rel"
            mkdir -p "$(dirname "$dest")"
            ln -sf "$src" "$dest"
        done
    else
        ln -sf "$file" "$HOME/$name"
    fi
done
