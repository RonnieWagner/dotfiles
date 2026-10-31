#!/bin/bash

# Update the SketchyBar clock using local system time.
sketchybar --set clock label="$(date '+%I:%M %p')"
