#!/bin/sh

hyprland(){
  cat ~/.config/hypr/mode.txt
}

niri(){
  echo "Niri"
}

if [ "$XDG_SESSION_DESKTOP" = "Hyprland" ];then
  hyprland
elif [ "$XDG_SESSION_DESKTOP" = "niri" ];then
  niri
else
  echo "unknown session $SESSION_TYPE"
fi
