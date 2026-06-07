#!/usr/bin/env bash

# Opciones con iconos (Nerd Fonts)
op_lock="  Bloquear"
op_logout="󰍃  Cerrar Sesión"
op_reboot="󰜉  Reiniciar"
op_poweroff="  Apagar"

# Juntar todas las opciones
options="$op_lock\n$op_logout\n$op_reboot\n$op_poweroff"

# Ejecutar rofi en modo dmenu con el estilo de tu config.rasi
chosen="$(echo -e "$options" | rofi -dmenu -i -p "Sistema:" -config ~/.config/rofi/config.rasi)"

case "$chosen" in
    "$op_lock")
        # Cambia por swaylock o hyprlock según lo que uses
        hyprlock || swaylock || xdg-screensaver lock
        ;;
    "$op_logout")
        # Comando para cerrar sesión en Wayland
        loginctl terminate-user $USER
        ;;
    "$op_reboot")
        systemctl reboot
        ;;
    "$op_poweroff")
        systemctl poweroff
        ;;
esac
