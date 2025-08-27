#!/bin/sh
# Install script for my dotfiles (minidots)

# Text color variables for styling
CR='\033[0;31m'; CG='\033[0;32m'; CY='\033[0;36m'; CB='\033[0;34m'; CRE='\033[0m'

# Exit if script is ran as root
[ "$(id -u)" -ne 0 ] || {
  printf "${CR}Do not run this script with root privileges! Exiting...${CRE}\n"
  exit 1
}

# Alias sudo to installed sudo util
command -v sudo >/dev/null\
  || { command -v ssu >/dev/null && alias sudo="ssu -p --"; }\
  || { command -v doas >/dev/null && alias sudo="doas --"; }

# Modify system configs
printf "${CB}Editing /etc/sudoers, /etc/doas.conf, /etc/dinit.d/tty1 (if using\
 dinit), /etc/default/grub and /etc/makepkg.conf.${CRE}\n"
{
  command -v doas >/dev/null && sudo sh -c "printf '# permit persist :wheel\npermit nopass :wheel\n' > /etc/doas.conf"
  command -v dinictl >/dev/null && sudo sed -i "s|^\(command[[:space:]]*=[[:space:]]*/usr/lib/dinit/agetty-default\)|\1 -a $USER|" /etc/dinit.d/tty1
  command -v runit >/dev/null && sudo sed -i "s|GETTY_ARGS=.*|GETTY_ARGS=\"--autologin $USER --noclear\"|" /etc/sv/agetty-tty1/conf
  command -v sudo >/dev/null && sudo sed -i 's/^#\s*\(%wheel ALL=(ALL:ALL) ALL\)/\1/; s/^#\s*\(%wheel ALL=(ALL:ALL) NOPASSWD: ALL\)/\1/' /etc/sudoers
  command -v grub-mkconfig >/dev/null && sudo sed -i 's/^GRUB_TIMEOUT=[0-9]\+/GRUB_TIMEOUT=1/; s/^GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/; s/^#\s*\(GRUB_SAVEDEFAULT=true\)/\1/' /etc/default/grub
  command -v pacman >/dev/null && sudo tee -a /etc/makepkg.conf <<EOF >/dev/null

# Makeflags
COMMON_FLAGS="-O2 -march=native -pipe -flto"
export CFLAGS="$COMMON_FLAGS"
export CXXFLAGS="$COMMON_FLAGS"
export LDFLAGS="$COMMON_FLAGS"
export FCFLAGS="$COMMON_FLAGS"
export FFLAGS="$COMMON_FLAGS"
export MAKEFLAGS="-j$(nproc)"
EOF
} && printf "${CG}Succesfully edited ${CY}system configs${CRE}\n"

# Arch/Artix specific setup
command -v pacman >/dev/null && {
  
  # Enable arch mirrors (for artix)
  grep -q "Artix" /etc/os-release && {
    printf "${CB}Setting up ${CY}arch-mirrors${CB} for pacman...${CRE}\n"
    sudo pacman -Syu --noconfirm artix-archlinux-support
    grep -q "mirrorlist-arch" /etc/pacman.conf\
      || sudo tee -a /etc/pacman.conf <<EOF >/dev/null

# Arch
[extra]
Include = /etc/pacman.d/mirrorlist-arch

[multilib]
Include = /etc/pacman.d/mirrorlist-arch
EOF
  } && printf "${CG}Succesfully setup ${CY}arch-mirrors${CG} for pacman${CRE}\n"

  # Install yay
  command -v yay >/dev/null || {
    printf "${CB}Installing ${CY}yay${CB} (aur helper)...${CRE}\n"
    sudo pacman -S --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay-bin
    (cd yay-bin/ && makepkg -si --noconfirm)
    rm -rf yay-bin
  } && printf "${CG}Succesfully installed ${CY}yay${CG} (aur helper)${CRE}\n"

} && printf "${CG}Succesfully completed arch/artix specific setup${CRE}\n"

# Install packages
printf "${CB}Installing all packages...${CRE}\n"
sh ./pkg-list.sh && printf "${CG}Succesfully installed all packages${CRE}\n"

# Enable services (dinit, systemd)
if command -v dinitctl >/dev/null; then
  
  printf "${CB}Enabling ${CY}dinit${CB} services...${CRE}\n"
  {
    for service in NetworkManager bluetoothd dbus turnstiled; do # cupsd
      sudo dinitctl enable $service
    done
    
    for service in mpd syncthing easyeffects; do
      sudo cp ./services/$service /etc/dinit.d/user/
    done
  } && printf "${CB}Succesfully enabled ${CY}dinit${CB} services${CRE}\n"

elif command -v systemctl >/dev/null; then
  
  printf "${CB}Enabling ${CY}systemd${CB} services...${CRE}\n"
  {
    for service in NetworkManager bluetoothd ; do # cupsd
      sudo systemctl enable $service
    done
  } && printf "${CB}Succesfully enabled ${CY}systemd${CB} services${CRE}\n"

elif command -v runit >/dev/null; then
  
  printf "${CB}Copying ${CY}rfkill-unblock${CB} runit service...${CRE}\n"
  {
    sudo cp -r ./services/rfkill-unblock/ /etc/sv/rfkill-unblock/
    sudo chmod +x /etc/sv/rfkill-unblock/run
  } && printf "${CB}Succesfully copied ${CY}rfkill-unblock${CB} runit service${CRE}\n"
  
  printf "${CB}Copying ${CY}backlight${CB} runit service...${CRE}\n"
  {
    sudo cp -r ./services/backlight/ /etc/sv/backlight/
    sudo chmod +x /etc/sv/backlight/run
  } && printf "${CB}Succesfully copied ${CY}rfkill-unblock${CB} runit service${CRE}\n"

  printf "${CB}Enabling ${CY}runit${CB} services...${CRE}\n"
  {
    for service in iwd dhcpcd dbus polkitd seatd rfkill-unblock backlight; do
      sudo ln -s "/etc/sv/$service" /etc/runit/runsvdir/default/
    done
  } && printf "${CB}Succesfully enabled ${CY}runit${CB} services${CRE}\n"

fi

# Install gtk and cursor themes
printf "${CB}Installing ${CY}gtk and cursor themes${CB}...${CRE}\n"
{
  rm -rf ~/.config/gtk-4.0/
  mkdir -p ~/.config
  sudo cp -r ./minidark /usr/share/themes
  ln -s /usr/share/themes/minidark/gtk-4.0/ ~/.config/
  papirus-folders -C nordic

  sudo mkdir -p /usr/share/icons/default/
  sudo tee /usr/share/icons/default/index.theme <<EOF >/dev/null
[Icon Theme]
Inherits=Bibata-Modern-Ice
EOF
} && printf "${CG}Succesfully installed ${CY}gtk and cursor themes${CRE}\n"

# Stow dotfiles
printf "${CB}Linking ${CY}dotfiles${CB}...${CRE}\n"
{
  dir_list=".local/src .local/share/mpd/playlists .config/spicetify .config/ncmpcpp .cache/wal .cache/script-cache"
  for i in $dir_list; do
    dir="$HOME/$i"
    mkdir -p "$dir" && printf "${CB}Created $dir${CRE}\n"
  done
  rm ~/.bash* ~/.inputrc
  (cd .. && stow -t "$HOME" .)
} && printf "${CG}Succesfully linked ${CY}dotfiles${CRE}\n"

# Configure script-cache files
printf "${CB}Configuring ${CY}script-cache${CB} files...${CRE}\n"
{
  # Graphic configuration
  printf "${CB}Configuring ${CY}graphic-command${CB} script (uses nouveau by\
 default, modify if needed)...${CRE}\n"
  {
    tee ~/.cache/script-cache/graphic-command <<EOF >/dev/null
#!/bin/sh
# Using nouveau
# sudo modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
# sudo modprobe nouveau
EOF
    printf "Nouveau\ncustom" > ~/.cache/script-cache/graphic-info
  } && printf "${CG}Succesfully configured ${CY}graphic-command${CG} script${CRE}\n"

  # Wallpaper details
  printf "${CB}Adding ${CY}wallpaper${CB} and ${CY}colorscheme${CB} details...${CRE}\n"
  {
    tee ~/.cache/script-cache/wallpaper <<EOF >/dev/null
export previous_wallpaper="$HOME/minidots/extras/wall.png"
export wallpaper="$HOME/minidots/extras/wall.png"
EOF
    printf "export colorscheme=custom-metal" > ~/.cache/script-cache/colorscheme
  } && printf "${CG}Succesfully added ${CY}wallpaper${CG} and ${CY}colorscheme${CG} details${CRE}\n"

  # Make scripts executable
  for i in graphic-command graphic-info wallpaper colorscheme; do
    chmod +x "$HOME/.cache/script-cache/$i"
  done

} && printf "${CG}Succesfully configured ${CY}script-cache${CG} files${CRE}\n"

# Clone programs/configs
clone () { 
  { 
    [ -n "$2" ] && git clone --depth=1 "$1" "$2" || git clone --depth=1 "$1"
  } && printf "${CG}Succesfully cloned ${CY}$1${CRE}\n"\
    || { printf "${CR}Failed to clone ${CY}$1${CRE}\n"; return 1; }
}

printf "${CB}Cloning programs...${CRE}\n"
clone https://codeberg.org/oceanicc/comfynvim "$HOME/.config/nvim"
clone https://github.com/romkatv/powerlevel10k.git "$HOME/.config/shell/plugins/powerlevel10k"

cd "$HOME/.local/src/" || exit 1
for i in oceanicc/dwl oceanicc/minibar oceanicc/mew sewn/wlock sewn/widle sewn/wfreeze; do
  clone "https://codeberg.org/$i.git"
done

# Compile programs
printf "${CB}Compiling programs...${CRE}\n"
for dir in dwl minibar mew wlock widle wfreeze; do
  printf "${CB}Compiling ${CY}$dir${CB}...${CRE}\n"
  (
    cd "$dir"
    CFLAGS="-O2 -march=native -pipe -flto" sudo make clean install
    make clean
  ) && printf "${CG}Compiled ${CY}$dir${CRE}\n" || \
    printf "${CR}Failed to compile ${CY}$dir${CRE}\n"
done && printf "${CG}Succesfully compiled programs${CRE}\n"

# Void Linux xbps-src setup
grep -q Void /etc/os-release && {
  printf "${CB}Building ${CY}xbps-src packages${CB}...${CRE}\n"
  clone https://github.com/void-linux/void-packages.git
  (
    cd "$HOME/.local/src/void-packages"
    echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf
    ./xbps-src binary-bootstrap
    clone https://codeberg.org/oceanicc/xbps-repo personal-srcpkgs
    
    for pkg in ssu ttf-jetbrainsmono-nerd bibata-cursors spotify-player pywal16 obsidian; do
      printf "${CB}Building ${CY}$pkg...${CRE}\n"
      cp -r "personal-srcpkgs/$pkg" ./srcpkgs
      ./xbps-src pkg "$pkg" && printf "${CG}Succesfully built ${CY}$pkg${CRE}\n"
      sudo xbps-install -Syu --repository hostdir/binpkgs "$pkg"
      ./xbps-src clean "$pkg"
    done
  )
} && printf "${CG}Succesfully built ${CY}xbps-src packages${CRE}\n"

# Void Linux pipewire setup
grep -q Void /etc/os-release && {
  printf "${CB}Setting up ${CY}pipewire${CB}...${CRE}\n"
  sudo mkdir -p /etc/pipewire/pipewire.conf.d
  sudo mkdir -p /etc/alsa/conf.d
  sudo ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
  sudo ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
  sudo ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
  sudo ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d
} && printf "${CG}Succesfully setup ${CY}pipewire${CRE}\n"

# Final steps
printf "${CB}Changing /bin/sh to ${CY}dash${CB}...${CRE}\n"
command -v dash >/dev/null && \
  sudo ln -sfT /usr/bin/dash /bin/sh && printf "${CG}Done${CRE}\n"

printf "${CB}Do you want to change the user shell to zsh? yes (y): ${CRE}"; read shell
[ "$shell" = "y" ] && {
  printf "${CB}Changing user shell to ${CY}zsh${CB}...${CRE}\n"
  command -v zsh >/dev/null && chsh -s /bin/zsh && printf "${CG}Done${CRE}\n"
}

printf "${CB}Adding $USER to video group...${CRE}\n"
command -v usermod >/dev/null && \
  for grp in _seatd audio video; do
    sudo usermod -aG $grp $USER 
  done && printf "${CG}Done${CRE}\n"

printf "${CB}Regenerating grub config...${CRE}\n"
command -v grub-mkconfig >/dev/null && \
  sudo grub-mkconfig -o /boot/grub/grub.cfg && printf "${CG}Done${CRE}\n"

printf "${CB}Reconfiguring system using xbps-reconfigure...${CRE}\n"
command -v xbps-reconfigure>/dev/null && \
  sudo xbps-reconfigure -fa && printf "${CG}Done${CRE}\n"

# Print success message and quit
printf "${CB}Please run the post-install script after rebooting and\
 logging into your window manager${CRE}\n"
printf "${CG}Done! Reboot to apply changes${CRE}\n"
exit 0

# OPTIONAL
# Compile wlroots
# git clone --depth=1 https://gitlab.freedesktop.org/wlroots/wlroots.git -b 0.19
# (
#   cd wlroots
#   meson setup build/ --prefix /usr/
#   sudo ninja -C build/ install
#   ninja -C build/ clean
# ) && printf "${CG}Succesfully compiled ${CY}wlroots${CRE}"

# Compile dulcepan
# git clone --depth=1 https://codeberg.org/vyivel/dulcepan
# (
#   cd dulcepan
#   meson setup build/
#   sudo ninja -C build/ install
#   ninja -C build/ clean
# ) && printf "${CG}Succesfully compiled ${CY}dulcepan${CRE}"
