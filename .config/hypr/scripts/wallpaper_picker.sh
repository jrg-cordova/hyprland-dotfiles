#!/bin/bash

WALLPAPER_DIR="$HOME/pictures/wal"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"

cd "$WALLPAPER_DIR" || exit 1

IFS=$'\n'

SELECTE_WALL=$(for a in $(ls -t *.jpg *.png *.gif *.jpeg 2>/dev/null); do echo -en "$a\0icon\x1f$a\n"; done | rofi -dmenu -p "")

SELECTED_PATH="$WALLPAPER_DIR/$SELECTED_WALL"

matugen image "$SELECTED_PATH"

mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"
