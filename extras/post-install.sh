#!/bin/sh
# Post-install script, part of install.sh
# To be run once you've rebooted and logged into window manager

# Text color variables for styling
CR='\033[0;31m'; CG='\033[0;32m'; CY='\033[0;36m'; CB='\033[0;34m'; CRE='\033[0m'

# Enable dinit user services (only if using dinit)
command -v dinitctl >/dev/null && {
  printf "${CB}Enabling dinit user services...${CRE}\n"
  services="wireplumber pipewire pipewire-pulse dbus mpd syncthing"
  for user_service in $services; do
    dinitctl -u enable $user_service
  done && printf "${CG}Succesfully enabled dinit user services.${CRE}\n"
} 

# Set GTK settings
printf "${CB}Setting theme through gettings...${CRE}\n"
{
  gsettings set org.gnome.desktop.interface gtk-theme 'minidark'
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.desktop.interface font-name 'Sans Regular 11'
  gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
  gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
  gsettings set org.gnome.desktop.interface cursor-size 18
} && printf "${CG}Succesfully set theme through gsettings.${CRE}\n"

# Recompile dwl
command -v dwl >/dev/null && (
  printf "${CB}Recompiling dwl...${CRE}\n"
  cd ~/.local/src/dwl/
  sudo make clean install
  make clean && printf "${CG}Succesfully recompiled dwl.${CRE}\n"
)

# Exit script
printf "${CG}Succesfully completed post-install script.${CRE}\n"
exit 0
