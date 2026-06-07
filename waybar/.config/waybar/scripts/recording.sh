#!/bin/sh
# Indicador de grabacion para Waybar.
# Cuando wf-recorder esta activo muestra un punto rojo; si no, queda oculto.
if pgrep -x wf-recorder >/dev/null 2>&1; then
    printf '{"text":"● REC","tooltip":"Grabando — click para detener","class":"recording"}\n'
else
    printf '{"text":"","tooltip":"","class":"idle"}\n'
fi
