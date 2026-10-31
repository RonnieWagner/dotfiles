#!/bin/bash

# Focused application indicator — AeroSpace + SketchyBar

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

# Get the focused application's name
APP_NAME="$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)"

# Use a fallback when no managed window has focus
[[ -z "$APP_NAME" ]] && APP_NAME="Desktop"

# Update the indicator
sketchybar --set front_app \
  label="$APP_NAME" \
  label.color="$MAUVE"
