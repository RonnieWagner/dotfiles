#!/bin/bash

# Volume indicator for SketchyBar — Catppuccin Mocha

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

# Read current output volume and mute status
VOLUME="$(osascript -e 'output volume of (get volume settings)')"
MUTED="$(osascript -e 'output muted of (get volume settings)')"

# Stop if we couldn't retrieve valid volume data
[[ ! "$VOLUME" =~ ^[0-9]+$ ]] && exit 0

# Determine label and color
COLOR="$MAUVE"

if [[ "$MUTED" == "true" ]]; then
  LABEL="🔇 Muted"
  COLOR="$SUBTEXT"
elif (( VOLUME == 0 )); then
  LABEL="🔈 0%"
elif (( VOLUME < 50 )); then
  LABEL="🔉 ${VOLUME}%"
else
  LABEL="🔊 ${VOLUME}%"
fi

# Update SketchyBar
sketchybar --set volume \
  label="$LABEL" \
  label.color="$COLOR"
