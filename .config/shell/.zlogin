# ~/.login

# Source environment variables
# source "$HOME/.profile"

# Source .bashrc for interactive shell
if [[ $- == *i* ]] && [ -f ~/.bashrc ]; then
  source "$HOME/.bashrc"
fi

# Automatically start dwl
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  
  # export XDG_RUNTIME_DIR=/tmp/xdg-runtime-1000
  # mkdir -p $XDG_RUNTIME_DIR
  file="/tmp/tty1_logged_in"
  
  if [ ! -f "$file" ]; then
    touch "$file"
    graphics="$HOME/.cache/script-cache/graphics"
    [ -f "$graphics" ] && source "$graphics"
    exec dwl >/dev/null 2>&1
    rm "$file"
  fi
fi
