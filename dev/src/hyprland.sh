#!/bin/bash

LOG_FILE="$HOME/hyprland_setup.log"
DATE=$(date +%Y-%m-%d_%H-%M-%S)

# Function to log messages
log() {
  echo "[$(date +%Y-%m-%d %H:%M:%S)] $1" >> "$LOG_FILE"
  echo "$1" # Also print to the terminal
}

log "Starting Hyprland setup..."

# Install base packages
log "Installing base packages: hyprland hyprlock hypridle kitty matugen waybar rustup eww"
sudo pacman -S --noconfirm hyprland hyprlock hypridle kitty matugen waybar rustup eww
if [ $? -ne 0 ]; then
  log "Error installing base packages. Exiting."
  exit 1
else
  log "Base packages installed successfully."
fi

# Install pyprland if paru is available
if ! command -v paru &> /dev/null; then
  log "paru not found. Skipping pyprland installation."
else
  log "paru found. Installing pyprland."
  paru -S --noconfirm pyprland
  if [ $? -ne 0 ]; then
    log "Error installing pyprland."
  else
    log "pyprland installed successfully."
  fi
fi

# Backup and remove existing configurations
log "Backing up and removing existing Hyprland configurations."
if [ -d ~/.config/hypr ]; then
  mv ~/.config/hypr ~/.config/hypr.backup."$DATE"
  log "Backed up ~/.config/hypr to ~/.config/hypr.backup.\"$DATE\""
fi
if [ -d ~/.config/eww-which-key ]; then
  mv ~/.config/eww-which-key ~/.config/eww-which-key.backup."$DATE"
  log "Backed up ~/.config/eww-which-key to ~/.config/eww-which-key.backup.\"$DATE\""
fi
if [ -d ~/.config/kitty ]; then
  mv ~/.config/kitty ~/.config/kitty.backup."$DATE"
  log "Backed up ~/.config/kitty to ~/.config/kitty.backup.\"$DATE\""
fi
if [ -d ~/.config/matugen ]; then
  mv ~/.config/matugen ~/.config/matugen.backup."$DATE"
  log "Backed up ~/.config/matugen to ~/.config/matugen.backup.\"$DATE\""
fi
if [ -d ~/.config/waybar ]; then
  mv ~/.config/waybar ~/.config/waybar.backup."$DATE"
  log "Backed up ~/.config/waybar to ~/.config/waybar.backup.\"$DATE\""
fi
rm -rf ~/.config/hypr ~/.config/eww-which-key ~/.config/kitty ~/.config/matugen ~/.config/waybar
log "Removed existing Hyprland configurations."

# Move new configurations
log "Moving new Hyprland configurations from ~/.clones/hyprvim/.config."
mv ~/.clones/hyprvim/.config/hypr ~/.config
log "Moved ~/.clones/hyprvim/.config/hypr to ~/.config."
mv ~/.clones/hyprvim/.config/eww-which-key ~/.config
log "Moved ~/.clones/hyprvim/.config/eww-which-key to ~/.config."
mv ~/.clones/hyprvim/.config/kitty ~/.config
log "Moved ~/.clones/hyprvim/.config/kitty to ~/.config."
mv ~/.clones/hyprvim/.config/matugen ~/.config
log "Moved ~/.clones/hyprvim/.config/matugen to ~/.config."
mv ~/.clones/hyprvim/.config/waybar ~/.config
log "Moved ~/.clones/hyprvim/.config/waybar to ~/.config."

# TODO: hyprmodes rust shit
log "Skipping hyprmodes rust shit (TODO)."

# Move Wallpapers directory and generate wallpaper
if [ ! -d "$HOME/Wallpapers" ]; then
  log "Wallpapers directory not found in $HOME. Moving from ~/.clones/hyprvim."
  mv ~/.clones/hyprvim/Wallpapers "$HOME/Wallpapers"
  if [ $? -ne 0 ]; then
    log "Error moving Wallpapers directory."
  else
    log "Wallpapers directory moved to $HOME/Wallpapers."
  fi
fi
log "Generating wallpaper using matugen."
matugen image ~/Wallpapers/lukeSmith.jpg
if [ $? -ne 0 ]; then
  log "Error generating wallpaper with matugen."
else
  log "Wallpaper generated successfully."
fi

log "Hyprland setup complete. Log output saved to $LOG_FILE"

exit 0
