#!/bin/sh

TITLEFOCUS=$(hyprctl activewindow -j | jq -r '.title' )
CLASSFOCUS=$(hyprctl activewindow -j | jq -r '.class' )
# notify-send "$CLASSFOCUS: $TITLEFOCUS"
hyprctl notify -1 3000 "rgb(FFFFFF)" "$CLASSFOCUS: $TITLEFOCUS"
