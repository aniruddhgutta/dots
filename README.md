# dots

my minimal dotfiles

![Screenshots](./extras/screenshots/cli.png)

![Screenshots](./extras/screenshots/gui.png)


### configs
- **Status**: [ministat](https://codeberg.org/oceanicc/ministat)
- **Neovim**: [comfynvim](https://codeberg.org/oceanicc/comfynvim)
- **dwl (patched)**: [dwl](https://codeberg.org/oceanicc/dwl)

### programs
- **Init**: runit, dinit (turnstile)
- **Monitor layouts**: kanshi
- **Notification daemon**: mako
- **Terminal**: foot
- **Launcher**: mew
- **Screenlock**: [wlock](https://codeberg.org/sewn/wlock) with [widle](https://codeberg.org/sewn/widle)
- **Shell**: zsh, bash
- **Editor**: neovim, helix
- **Fetch**: [cutefetch](./.local/bin/cutefetch)
- **Music player**: spotify-player, ncmpcpp (mpd), spotify (spicetify)
- **File manager**: lf, thunar
- **PDF**: zathura
- **Browser**: chromium, librewolf
- **Wallpapers**: wbg
- **Clipboard**: cliphist (wl-clip-persist)
- **Colorscheme manager**: pywal

### menus (custom scripts)
- **Color picker**: [colorpick](./.local/bin/colorpick)
- **Emoji menu**: [emojimenu](./.local/bin/emoji-menu)
- **Wallpaper menu**: [theme](./.local/bin/theme)
- **Screenshots**: [screenshot](./.local/bin/screenshot)

### extras (custom)
- **GTK theme**: [minidark](./extras/minidark/)
- **spicetify theme**: [walspot](./.config/wal/templates/colors-spicetify.ini)
- **zen browser extensions**: [zen export](./extras/zen-themes-export.json)
- **yt enhancer config**: [enhancer](./extras/enhancer)
- **equaliser preset**: [custom eq](./extras/spotify/final-eq.json)
- **spicetify config**: [spicetify config](./extras/spotify/spicetify-settings)

## todo

- [ ] update README
- [ ] rewrite install script, apply optimisations
- [ ] remove distro specific snippets
- [ ] clean [extras](./extras) directory
- [ ] clean [shell configs](./.config/shell)
- [ ] configure ncmpcpp
- [ ] configure helix
- [ ] rewrite kanshi config
- [ ] extend minidark to theme gnome-shell
- [ ] make qt theme (similar to minidark)
- [ ] make wallpaper repo


## installation

> [!WARNING]
> install script needs to be updated — manual fixes may be needed

to use the install script, simply run -
```shell
git clone https://codeberg.org/oceanicc/minidots ~/minidots     # clone the repo
cd ~/minidots                   # enter the repo
chmod +x ./extras/install.sh    # make the install script executable
chmod +x ./extras/post-install.sh    # make the post-install script executable
chmod +x ./extras/pkg-list.sh   # make the package install script executable
./extras/install.sh             # run the install script
```


## install script details

the install script is written in a very simple and easy to understand manner. please do modify it to suite your needs and remove any unessescary actions. i've listed what the install script does below:

### system configs
- rewrites doas conf
- enables autologin from tty for dinit
- modifies sudo conf to allow members of wheel group to run sudo commands without password (convenient for startw)
- modifies grub conf (timeout and menu)
- modifies makeflags (-j8, change according to your systems threads, or if unsure, comment it out to avoid any changes)

### mirrors (artix)
- adds arch repos to artix

### yay (arch/artix)
- installs yay-bin if not installed (aur manager)

### packages
- installs packages from [package list](./extras/pkg-list.sh) (please refer to the [package list](./extras/pkg-list.sh) and remove any unessential packages that you don't want)

### services (systemd/dinit/runit)
- enables necessary services and copies user services (for dinit)
- dinit user services are used (with turnstile) to handle autostart of mpd, pipewire (with wireplumber) and syncthing, do disable them if you're not using them with ```dinitctl -u disable <service_name>```

### gtk theme
- installs custom gtk theme [minidark](./extras/minidark/)
- changes index.theme to inherit installed cursor theme (bibata)

### stow dotfiles
- makes necessary directories
- stows (links) dotfiles in respective directories

### graphics information (important)
- sets nouveau as default graphics driver to be used (might cause issues if not done, can switch to other graphics post-installation)

### wallpaper information
- sets wallpaper to the one provided in repo - [wallpaper](./extras/wall.png)

### clone and compile programs
- clones and compiles all the programs i use

### final
- changes shell to zsh
- runs grub-mkconfig (if using grub)

### disabled - compile wlroots and dulcepan
- compiles wlroots in the proper directory
- compiles dulcepan (alternative screenshot manager for wayland)


## post install script details

- for dinit user services and automatic gtk theme application, please run the [post-install](./extras/post-install.sh) script after a reboot and starting dwl*
- enables dinit user services
- sets gtk theme, changes icon pack and changes cursor theme and size
- dwl has to be recompiled after selecting any cursor theme/size (but works out of the box by install script)
- recompiles dwl to use cursor theme


## spotify script details

- [spotify](./extras/spotify/spotify.sh) - optional post-install commands to install spotify with spicetify and custom theme (arch/artix)
- *Note - custom [spicetify settings](./extras/spotify/spicetify-settings) should be manually imported*
