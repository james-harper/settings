#!/bin/bash
# ──────────────────────────────────────────────────────────# 1. CORE ENVIRONMENT & COMFORT CONFIG# ──────────────────────────────────────────────────────────
export EDITOR="/usr/bin/nano"
export LANG="en_GB.UTF-8"
export PATH="$HOME/.local/bin:$PATH"
# Standardise Linux core colors
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
# Tab completion & shell menu improvements
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
# Up & Down arrows map to history fuzzy search based on typed prefix
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
# ──────────────────────────────────────────────────────────# 2. ADVANCED RECURSIVE HISTORY ENGINE# ──────────────────────────────────────────────────────────# Creates structured, permanent daily logs of your terminal historyif [ ! -d ~/.history/$(date -u +%Y/%m/) ]; then
    mkdir -p ~/.history/$(date -u +%Y/%m/)fi

export HISTFILE="${HOME}/.history/$(date -u '+%Y/%m/%d %H.%M.%S')"
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%d/%m/%Y-%H:%M:%S: "
export HISTIGNORE='&:bg:fg:clear:ls:pwd:history:exit:make*:* --help:c:cs:cls:ll:la'
# Search your permanent history logs recursivelyfunction hgr() {
    grep -r "$@" ~/.history
    history | grep "$@"
}
# ──────────────────────────────────────────────────────────# 3. DIRECTORY NAVIGATION & AUTOMATED LISTS# ──────────────────────────────────────────────────────────# Overrides 'cd' to automatically run 'ls' upon arrival
cd() { builtin cd "$@"; ls -CF --color=auto; }

alias cdev='cd ~/code'
alias crm='cd ~/code/company-crm'
alias home='cd ~'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'
# ──────────────────────────────────────────────────────────# 4. SYSTEM TEXT UTILITIES & MACROS# ──────────────────────────────────────────────────────────
alias c='clear'
alias cs='clear;ls -CF --color=auto'
alias cls='clear'
alias g='grep -i'
alias f='find . | grep'
alias myip="curl ifconfig.me; echo"
alias sudo='sudo --preserve-env'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
# Make critical file actions verbose and safety-prompted
alias mv="mv -v"
alias rm="rm -vi"
alias cp="cp -v"
alias mkdir="mkdir -pv"
# Custom directory sorting macros
alias l='ls -CF'
alias la='ls -AF'
alias ldir='ls -d */'
alias ll='ls -l'
alias lh='ls -lash'
alias l.='ls -A | egrep "^\."'
alias lsh='ls -lash'
alias lsl="ls -lhFA | less"
alias labc='ls -lap'
alias lsdesc='ls -alt'
alias lsasc='ls -laptr'
# Linux / WSL Trash Can implementation (replaces legacy macOS Trash)function trash() {
   if [ $# -eq 0 ]; then
       echo "Usage: trash FILE..."
       return 1
   fi
   local DATE=$(date +%Y%m%d)
   [ -d "${HOME}/.local/share/Trash/${DATE}" ] || mkdir -p "${HOME}/.local/share/Trash/${DATE}"
   for FILE in "$@"; do
     mv "${FILE}" "${HOME}/.local/share/Trash/${DATE}/"
     echo "${FILE} moved to Linux local trash container!"
   done
}
# Linux-native clipboard copy helper (replaces macOS pbcopy)
alias copyLastCmd='fc -ln -1 | awk '\''{$1=$1}1'\'' ORS='\'''\'' | xclip -sel clip'
# ──────────────────────────────────────────────────────────# 5. DOCKER & CONTAINER ROUTING (0ms Bridge)# ──────────────────────────────────────────────────────────
alias dc="docker compose"
alias dcup="docker compose up -d --build"
alias dcdown="docker compose down"
alias dclogs="docker compose logs -f"
alias dcps="docker compose ps"
# Automatically routes paths straight into active containers
alias art="docker compose exec -it crm-php php artisan"
alias artisan="docker compose exec -it crm-php php artisan"
alias composer="docker compose exec -it crm-php composer"
alias npm="docker compose exec -it crm-websocket npm"
alias npm-fresh="docker compose run --rm crm-websocket npm install"
# ──────────────────────────────────────────────────────────# 6. DYNAMIC NATIVE PROMPT STATEMENT# ──────────────────────────────────────────────────────────# Displays [User@WSL-Machine: CurrentDir] (Active Git Branch)if [ -f /usr/lib/git-core/git-sh-prompt ]; then
    . /usr/lib/git-core/git-sh-prompt
export PS1='\[\e[32m\][\u@wsl: \W]\[\e[33m\]$(__git_ps1 " (%s)")\[\e[0m\]\$ 'else
export PS1='\[\e[32m\][\u@wsl: \W]\[\e[0m\]\$ 'fi
