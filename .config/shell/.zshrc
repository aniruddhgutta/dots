# ~/.zshrc

# Setup plugin manager
plug-setup() {
  dir="$ZDATADIR/plug" src="$ZDOTDIR/plug.zsh" dst="$dir/plug.zsh"
  mkdir -p "$dir"
  [ ! -e "$dir/plug.zwc" ] || [ "$src" -nt "$dst" ] && {
    cp "$src" "$dst"
    zcompile "$dir/plug.zwc" "$dst"
    print -P "%F{green}✔ Compiled plug.zsh%f"
  }
  source "$dst"
}
ZDATADIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
plug-setup

zmodload zsh/system 2>/dev/null || true

# Install plugins
plug-install https://github.com/zsh-users/zsh-syntax-highlighting
plug-install https://github.com/zsh-users/zsh-autosuggestions
plug-install https://github.com/romkatv/powerlevel10k
plug-install https://github.com/joshskidmore/zsh-fzf-history-search

# Evaluate on start
prompt="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
colors="${XDG_CACHE_HOME:-$HOME/.cache}/wal/sequences"
[ -r "$prompt" ] && source "$prompt"
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"
command -v wal >/dev/null && [ -f "$colors" ] && (cat "$colors" &)

# Shell options
setopt no_beep                # No bell
setopt interactive_comments   # Allow comments in interactive shell
setopt hist_ignore_all_dups   # Ignore duplicates in history
setopt hist_reduce_blanks     # Remove leading whitespace from history
setopt inc_append_history     # Append to history file immediately
setopt extended_history       # Save timestamp of command
setopt no_share_history       # Do not share history between terminals

# History (written only on shell exit)
HISTFILE="$ZDATADIR/zsh-history"
HISTSIZE=100000
SAVEHIST=100000

# Completions
comp="$ZDATADIR/.zcompdump"
autoload -Uz compinit && compinit -d "$comp" && zcompile-many "$comp"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true

# Keybindings
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
autoload -U select-word-style
select-word-style bash
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^H" backward-kill-word

# History search
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS="--height=30%"

# Load plugins
source "$ZDOTDIR/profile"
source "$ZDOTDIR/lf-icons"
source "$ZDATADIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZDATADIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDATADIR/powerlevel10k/powerlevel10k.zsh-theme"
source "$ZDATADIR/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh"

# Load prompt
[ ! -f "$ZDOTDIR/.p10k.zsh" ] || source "$ZDOTDIR/.p10k.zsh"
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

export PATH=$PATH:/home/vye/.spicetify
