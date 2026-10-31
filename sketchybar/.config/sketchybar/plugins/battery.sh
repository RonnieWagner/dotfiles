#!/bin/bash

# Battery status for SketchyBar — Catppuccin Mocha

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

# Retrieve battery information
BATTERY_INFO="$(pmset -g batt)"

# Extract battery percentage and charging state
PERCENT="$(printf '%s\n' "$BATTERY_INFO" | grep -oE '[0-9]+%' | head -1)"
STATE="$(printf '%s\n' "$BATTERY_INFO" | awk -F';' '/InternalBattery/ {gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2); print $2}')"

# Stop if no battery was detected
[[ -z "$PERCENT" ]] && exit 0

LEVEL="${PERCENT%\%}"
LABEL="$PERCENT"
COLOR="$MAUVE"

# Select display color based on battery state
if [[ "$BATTERY_INFO" == *"Now drawing from 'AC Power'"* ]]; then
  LABEL="$PERCENT ⚡"
  COLOR="$GREEN"
elif (( LEVEL <= 10 )); then
  COLOR="$RED"
elif (( LEVEL <= 20 )); then
  COLOR="$PEACH"
fi

# Update SketchyBar
sketchybar --set battery \
  label="$LABEL" \
  label.color="$COLOR"
