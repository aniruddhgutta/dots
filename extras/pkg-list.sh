#!/bin/sh
# Package list for arch/artix and void linux

# Common packages
shell="foot fzf zsh bash-completion man less lf chafa zoxide neovim tree fastfetch htop btop xdg-utils unzip"
extras="android-tools ps_mem"
utils="wbg playerctl mako libnotify grim slurp kanshi stow"
clipboard="wl-clip-persist wl-clipboard cliphist"
system_utils="polkit-gnome dash xdg-desktop-portal-wlr xdg-desktop-portal-gtk"
printing="cups system-config-printer hplip"

# Arch/Artix packages
if command -v pacman > /dev/null; then
  fonts="noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-mononoki-nerd ttf-ubuntu-nerd ttf-font-awesome"

  wlroots_deps="seatd elogind libliftoff vulkan-icd-loader xorg-xhost"
  wlroots_compile_deps="vulkan-headers meson ninja"
  xwayland_deps="xcb-util xcb-util-errors xcb-util-renderutil xcb-util-wm libxcb xorg-xwayland"
  dwl_deps="wlroots0.19 wayland wayland-protocols libinput libxkbcommon pkg-config fcft tllist"

  nvidia="nvidia-open linux-firmware-nvidia nvidia-utils egl-wayland mesa mesa-dri"
  pipewire="pipewire pipewire-pulse wireplumber"
  dinit="turnstile-dinit pipewire-dinit pipewire-pulse-dinit wireplumber-dinit cups-dinit"

  music="mpd mpc ncmpcpp rmpc ffmpeg ffmpeg4.4 opus-tools yt-dlp spotdl python-syncedlyrics picard easyeffects"
  kvantum="kvantum qt6ct qt5ct kvantum-qt5 qt5-wayland qt6-wayland"
  thunar="thunar thunar-volman thunar-archive-plugin thunar-media-tags-plugin gvfs gvfs-mtp file-roller tumbler ffmpegthumbnailer" 
  themeing="papirus-icon-theme papirus-folders-catppuccin-git bibata-cursor-theme nwg-look python-pywal16"
  personal="librewolf zathura zathura-pdf-poppler spotify-player spotify-launcher spotify-player spicetify-cli obsidian mpv swayimg" # syncthing gnome-text-editor gnome-calculator

  export packages="$fonts $wlroots_deps $dwl_deps $shell $extras $utils $clipboard $system_utils $printing $nvidia $pipewire $dinit $music $thunar $themeing $personal downgrade"
  yay -Syu --removemake --noconfirm $packages

# Void packages
elif command -v xbps-install > /dev/null; then
  fonts="noto-fonts-ttf noto-fonts-emoji ttf-ubuntu-font-family font-awesome" # noto-fonts-cjk ttf-mononoki-nerd

  wlroots_deps="seatd elogind libliftoff vulkan-loader xhost xdg-user-dirs xdg-utils"
  wlroots_compile_deps="Vulkan-Headers meson ninja libliftoff-devel"
  xwayland_deps="xcb-util xcb-util-errors xcb-util-renderutil xcb-util-wm libxcb xorg-server-xwayland"
  xwayland_deps_devel="xcb-util-devel xcb-util-errors-devel xcb-util-renderutil-devel xcb-util-wm-devel libxcb-devel"
  dwl_deps="wlroots0.19 wayland wayland-protocols libinput libxkbcommon pkg-config fcft tllist"
  dwl_devel_deps="base-devel wlroots0.19-devel wayland-devel libinput-devel libxkbcommon-devel fcft-devel"

  nvidia="nvidia linux-firmware-nvidia mesa mesa-dri" # nvidia-utils egl-wayland
  pipewire="pipewire wireplumber alsa-pipewire libspa-bluetooth"

  music="mpd mpc ncmpcpp rmpc ffmpeg opus-tools yt-dlp picard" # ffmpeg4.4 spotdl python-syncedlyrics # easyeffects
  kvantum="kvantum qt6ct qt5ct qt5-wayland qt6-wayland" # kvantum-qt5
  thunar="Thunar thunar-volman thunar-archive-plugin thunar-media-tags-plugin gvfs gvfs-mtp file-roller tumbler ffmpegthumbnailer"
  themeing="papirus-icon-theme papirus-folders nwg-look"
  personal="chromium zathura zathura-pdf-poppler mpv swayimg ImageMagick" # librewolf

  export packages="$fonts $wlroots_deps $dwl_deps $dwl_devel_deps $shell $extras $utils $clipboard $system_utils $pipewire $music $thunar $themeing $personal xmirror" # $printing $nvidia
  sudo xbps-install -Syu $packages
fi
