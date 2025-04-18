#!/bin/bash

hyprland-workspaces() {
  workspace=$(hyprctl activeworkspace -j | jq '.id')
  windows=$(hyprctl activeworkspace -j | jq -r .windows)
  echo "${workspace}:${windows}"
}

niri-workspaces() {
  niri msg focused-window | sed -n '/App ID:/s/.*App ID: "\([^"]*\)".*/\1/p' | tail -n1
}

if [ "$XDG_SESSION_DESKTOP" = "Hyprland" ];then
  hyprland-workspaces
elif [ "$XDG_SESSION_DESKTOP" = "niri" ];then
  niri-workspaces
else
  echo "unknown session $SESSION_TYPE"
fi
