#!/bin/sh
# Screenshot estilo "Recortes" de Windows (Snip & Sketch)
# 1. Selecciona un area con el raton
# 2. Copia la captura al portapapeles
# 3. Notifica: click para editar -> abre swappy
# 4. Si se ignora, limpia el archivo temporal

TMP="$(mktemp /tmp/snip_XXXXXX.png)"

# Seleccionar area (si se cancela con ESC, salir sin error)
GEOM="$(slurp)" || { rm -f "$TMP"; exit 0; }

# Capturar y guardar al temporal
grim -g "$GEOM" "$TMP" || { rm -f "$TMP"; exit 1; }

# Copiar al portapapeles de inmediato
wl-copy < "$TMP"

# Notificar con accion por defecto: al hacer click en el cuerpo de la
# notificacion (o en el boton "Editar") swaync devuelve "default" por stdout.
# notify-send -A bloquea hasta cerrar/clic.
ACTION="$(notify-send -A "default=Editar" -i "$TMP" \
    "Captura copiada" "Click para editar en swappy")"

if [ "$ACTION" = "default" ]; then
    # swappy guarda el resultado anotado en su carpeta configurada
    swappy -f "$TMP"
fi

# Limpiar temporal (la copia ya esta en el portapapeles / la guardo swappy)
rm -f "$TMP"
