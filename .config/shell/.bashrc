# ~/.bashrc

# If not running interactievly, don't do anything
[[ $- != *i* ]] && return

# Prompt
# with git status (requires git-prompt to be sourced)
# source "$HOME/.config/zsh/git-prompt"
# GIT_PS1_SHOWDIRTYSTATE=1
# PS1='\[\e[1;32m\]\u@\h \[\e[0;34m\]\w\[\e[90m\]$(__git_ps1 " %s")\[\e[38;5;5m\] ❯ \[\e[0m\]'

# without git status
# PS1='[\[\e[1;32m\]\u@\h \[\e[0;34m\]\w\[\e[0m\]] \$ '
PS1='\[\e[0;34m\]\w\[\e[0m\] ❯ '

# Shell options
shopt -s autocd
shopt -s cdspell
shopt -s histappend

# History
HISTFILE=~/.local/share/bash-history
HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoredups:erasedups
PROMPT_COMMAND='history -a; history -n'

# Keybindings
bind '"\e[1;5D": backward-word'
bind '"\e[1;5C": forward-word'
bind '"\C-h": backward-kill-word'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Source
source /usr/share/bash-completion/bash_completion
source "$HOME/.config/shell/.profile"
source "$HOME/.config/shell/plugins/lf-icons.sh"
