#!/usr/bin/env bash
# Symlink these dotfiles into $HOME using GNU stow.
#
#   ./install.sh            # link everything
#   ./install.sh hypr       # link only selected packages
#   ./install.sh -D         # UNlink everything (delete symlinks)
#
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

if ! command -v stow >/dev/null 2>&1; then
    echo "GNU stow is required:  sudo pacman -S stow" >&2
    exit 1
fi

ALL=(hypr waybar swappy bin)

# Support an unstow flag
ACTION="--restow"
ARGS=()
for a in "$@"; do
    case "$a" in
        -D|--delete) ACTION="--delete" ;;
        *) ARGS+=("$a") ;;
    esac
done
[ ${#ARGS[@]} -eq 0 ] && ARGS=("${ALL[@]}")

stow --target="$HOME" --verbose "$ACTION" "${ARGS[@]}"
echo "Done."
