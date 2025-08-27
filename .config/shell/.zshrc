# ~/.zshrc

# Evaluate on start
prompt="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
[ -r "$prompt" ] && source "$prompt"
# (cat ~/.cache/wal/sequences &)
# sh ~/.cache/hellwal/terminal.sh
# eval "$(zoxide init zsh --cmd cd)"

# Shell options
setopt no_beep                # No bell
setopt interactive_comments   # Allow comments in interactive shell
setopt hist_ignore_all_dups   # Ignore duplicates in history
setopt hist_reduce_blanks     # Remove leading whitespace from history
setopt inc_append_history     # Append to history file immediately
setopt extended_history       # Save timestamp of command
setopt no_share_history       # Do not share history between terminals

# History (write only on shell exit)
HISTFILE="$HOME/.local/share/zsh-history"
HISTSIZE=100000
SAVEHIST=100000

# Completions
autoload -Uz compinit && compinit
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

# Plugins
source $ZDOTDIR/.profile
source $ZDOTDIR/plugins/zoxide.zsh
source $ZDOTDIR/plugins/lf-icons.sh
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source $ZDOTDIR/plugins/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh
source $ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme

# Load prompt
[ ! -f $ZDOTDIR/.p10k.zsh ] || source $ZDOTDIR/.p10k.zsh
