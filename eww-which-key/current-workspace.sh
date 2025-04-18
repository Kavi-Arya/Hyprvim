#!/bin/sh
CURRENTWORKSPCE=$(hyprctl monitors -j | jq '.[].activeWorkspace.id')
echo "$CURRENTWORKSPCE"
