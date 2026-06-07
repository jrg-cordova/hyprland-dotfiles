#!/bin/sh
# Captura de la ventana activa (como Alt+PrintScreen en Windows)
DIR="$HOME/pictures/screenshots"
mkdir -p "$DIR"
FILE="$DIR/ventana_$(date +%Y-%m-%d_%H-%M-%S).png"

# Geometria de la ventana activa (sin depender de jq)
GEOM="$(hyprctl activewindow | awk '
    /^[[:space:]]*at:/   { split($2, a, ","); ax = a[1]; ay = a[2] }
    /^[[:space:]]*size:/ { split($2, s, ","); sx = s[1]; sy = s[2] }
    END                  { printf "%d,%d %dx%d", ax, ay, sx, sy }')"

[ -z "$GEOM" ] && exit 1

grim -g "$GEOM" - | tee "$FILE" | wl-copy
notify-send "Captura de ventana" "Guardada en $FILE y copiada al portapapeles" -i "$FILE"
