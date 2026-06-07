#!/bin/sh
# Camara flotante estilo streamer: abre/cierra una vista previa de la webcam
# El title "webcam-float" lo usa una windowrule en hyprland.conf para flotar/anclar

DEVICE="${1:-/dev/video0}"

if pgrep -f "mpv --title=webcam-float" >/dev/null 2>&1; then
    pkill -f "mpv --title=webcam-float"
    exit 0
fi

mpv --title=webcam-float \
    --profile=low-latency \
    --untimed \
    --no-audio \
    --no-osc \
    --no-osd-bar \
    --no-input-default-bindings \
    --really-quiet \
    "av://v4l2:$DEVICE"
