#!/bin/sh
# Grabacion de pantalla para YouTube: video + microfono + audio del sistema
# Mezcla mic y sistema en un null-sink temporal y graba con wf-recorder.
# Primera pulsacion: empieza. Segunda pulsacion: detiene y guarda.

STATE="/tmp/hypr-record.modules"
DIR="$HOME/videos/recordings"

# ---------- DETENER ----------
if pgrep -x wf-recorder >/dev/null 2>&1; then
    pkill -INT -x wf-recorder          # SIGINT para que finalice el archivo
    while pgrep -x wf-recorder >/dev/null 2>&1; do sleep 0.2; done

    # Descargar modulos de audio (loopbacks primero, luego el null-sink)
    if [ -f "$STATE" ]; then
        tac "$STATE" 2>/dev/null | while read -r mod; do
            pactl unload-module "$mod" 2>/dev/null
        done
        rm -f "$STATE"
    fi
    notify-send "Grabacion detenida ⏹" "Guardada en $DIR"
    exit 0
fi

# ---------- INICIAR ----------
mkdir -p "$DIR"
FILE="$DIR/rec_$(date +%Y-%m-%d_%H-%M-%S).mp4"
: > "$STATE"

# null-sink donde se mezcla todo
SINK_MOD=$(pactl load-module module-null-sink sink_name=recmix \
    sink_properties=device.description=recmix)
echo "$SINK_MOD" >> "$STATE"

# audio del sistema (monitor del sink por defecto) -> recmix
MON="$(pactl get-default-sink).monitor"
LB1=$(pactl load-module module-loopback source="$MON" sink=recmix latency_msec=1)
echo "$LB1" >> "$STATE"

# microfono (source por defecto) -> recmix
MIC="$(pactl get-default-source)"
LB2=$(pactl load-module module-loopback source="$MIC" sink=recmix latency_msec=1)
echo "$LB2" >> "$STATE"

# grabar pantalla + la mezcla de audio
wf-recorder -f "$FILE" --audio=recmix.monitor >/tmp/wf-recorder.log 2>&1 &

notify-send "Grabando 🔴" "Pantalla + mic + sistema\n$FILE"
