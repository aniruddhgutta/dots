# Extremely simple zsh plugin manager

# Compile .zsh files to .zwc
zcompile-many() {
  for f; do
    [ -f "$f" ] || continue
    base="${f%.*}"
    [ -e "$base.zwc" ] && [ "$base.zwc" -nt "$f" ] && continue
    zcompile -R "$base.zwc" "$f" && \
      print -P "%F{green}✔ Compiled $f%f"
  done
}

# List installed plugins
plug-list() {
  print -P "%F{cyan}Installed plugins:%f"
  for dir in "$ZDATADIR"/*/.git(N); do
    print -P "  %F{blue}•%f ${dir:h:t}"
  done
}

# Install a plugin
plug-install() {
  repo="$1" name="${repo##*/}" dir="$ZDATADIR/$name"
  if [ ! -d "$dir" ]; then
    if git clone --depth=1 "$repo" "$dir"; then
      zcompile-many "$dir"/**/*.zsh(N)
      print -P "%F{green}✔ Installed $name%f"
    else
      print -P "%F{red}✘ Failed to install $name%f"
    fi
  fi
}

# Update all plugins
plug-update() {
  for dir in "$ZDATADIR"/*/.git(N); do
    dir=${dir%/.git}; name=${dir:t}
    old=$(git -C "$dir" rev-parse HEAD 2>/dev/null) || continue
    if git -C "$dir" pull --ff-only --quiet; then
      new=$(git -C "$dir" rev-parse HEAD 2>/dev/null)
      [ "$old" != "$new" ] && {
        print -P "%F{blue}⬆ Updated%f $name"
        zcompile-many "$dir"/**/*.zsh(N)
      } || print -P "%F{green}✓ Up to date%f $name"
    else
      print -P "%F{red}✘ Failed to update%f $name"
    fi
  done
}


# Remove a plugin
plug-remove() {
  local name="$1"
  local dir="$ZDATADIR/$name"

  if [ -d "$dir" ]; then
    rm -rf "$dir" && \
      print -P "%F{yellow}✘ Removed%f $name" \
      || print -P "%F{red}✘ Failed to remove%f $name"
  else
    print -P "%F{red}✘ Plugin not found%f $name"
  fi
}
