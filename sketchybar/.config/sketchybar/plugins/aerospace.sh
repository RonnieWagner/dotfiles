#!/bin/bash
# Highlight the focused AeroSpace workspace in SketchyBar.

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

FOCUSED_WORKSPACE="$(aerospace list-workspaces --focused)"

for workspace in DEV LAB WEB MEDIA; do
  if [[ "$workspace" == "$FOCUSED_WORKSPACE" ]]; then
    LABEL_COLOR="$TEXT"
    BG_DRAWING="on"
    BG_COLOR="0x996c7086"
  else
    LABEL_COLOR="$SUBTEXT"
    BG_DRAWING="off"
    BG_COLOR="0x00000000"
  fi

  sketchybar --set "space.$workspace" \
    label.color="$LABEL_COLOR" \
    background.drawing="$BG_DRAWING" \
    background.color="$BG_COLOR"
done