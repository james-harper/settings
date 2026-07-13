#!/bin/bash
# ──────────────────────────────────────────────────────────
# 1. CORE ENVIRONMENT, LOGGING & PATH ARCHITECTURE
# ──────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:/c/php8:$PATH" # Maps portable tools and local PHP 8 binary
export EDITOR="/usr/bin/nano"
export LANG="en_GB.UTF-8"
export CODE_PATH="~/Documents/Code" # Target for cdev shortcut fallback

export CLICOLOR=1                  # Enforces universal terminal color mapping
export LSCOLORS=Gxfxcxdxbxegedabagacad

# Enhances history limit to 9,001 entries and appends sessions instead of overwriting
export HISTSIZE=9001
export HISTFILESIZE=$HISTSIZE
shopt -s histappend

# Dynamic folder tree generation creates structured permanent logs (~/.history/YYYY/MM/DD)
if [ ! -d ~/.history/$(date -u +%Y/%m/) ]; then
    mkdir -p ~/.history/$(date -u +%Y/%m/)
fi

export HISTFILE="${HOME}/.history/$(date -u '+%Y/%m/%d %H.%M.%S')"
export HISTCONTROL="ignoreboth" # Ignores duplicate commands and lines starting with a space
export HISTCONTROL="erasedups"  # Purges older matching instances throughout the current session
export HISTTIMEFORMAT="%d/%m/%Y-%H:%M:%S: "

# Explicit string exclusions to block common noise aliases from cluttering historical log files
export HISTIGNORE='&:bg:fg:clear:ls:pwd:history:exit:make*:* --help:c:cs:cls:ll:la'

# ──────────────────────────────────────────────────────────
# 2. CROSS-PLATFORM INTERFACE ROUTER
# ──────────────────────────────────────────────────────────
# Dynamically detects the core operating system layer to inject isolated sub-profiles
case "$OSTYPE" in
    msys*|cygwin*|mingw*)
        [ -f ~/.bash_windows ] && . ~/.bash_windows
        ;;
    darwin*)
        [ -f ~/.bash_mac ] && . ~/.bash_mac
        ;;
    linux*)
        [ -f ~/.bash_linux ] && . ~/.bash_linux
        ;;
esac

# Safe polyfill maps the OS default browser or file launcher tool depending on host hardware
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "mingw" ]]; then
    open() { start "$@"; }
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    open() { xdg-open "$@"; }
fi

# ──────────────────────────────────────────────────────────
# 3. ADVANCED DIRECTORY NAVIGATION & LIST FILTERS
# ──────────────────────────────────────────────────────────
cd() { builtin cd "$@"; ls -CF --color=auto; } # Auto-triggers an 'ls' view upon changing directories

alias cdev='cd "${CODE_PATH:-~/code}"' # Dynamically falls back to ~/code if custom path variable is unset
alias home='cd ~'
alias ~='cd ~'
alias -- -='cd -' # Rapid toggle shortcut allowing you to hop back to your previous directory path

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias c='clear'
alias cs='clear;ls -CF --color=auto'
alias g='grep -i' # Case-insensitive global regular expression lookups
alias f='find . | grep'

# File alteration safety filters mapping interactive confirmation flags and verbosity output
alias mv="mv -v"
alias rm="rm -vi"
alias cp="cp -v"
alias mkdir="mkdir -pv"

alias l='ls -CF'
alias la='ls -AF'   # Lists all files including hidden system dotfiles, excluding . and ..
alias ll='ls -l'   # Generates long form layout showing user permissions and modified dates
alias lh='ls -lash' # Displays human-readable file file system byte weights (e.g., 4K, 20M)

alias ldir='ls -lhF | grep "^d"'              # Filters directory trees only
alias l.='ls -ld .[^.]*'                      # Isolates hidden system dotfiles exclusively
alias lsl="ls -lhFA --color=always | less -R" # Pager utility that keeps ANSI syntax coloring active
alias lnew='ls -lhAtr'                         # Sorts directory files pushing newest items to the bottom
alias lold='ls -lhAt'                          # Sorts directory files keeping oldest entries at the base

alias numFiles='ls -1 | wc -l' # Calculates raw file item totals sitting inside active folder path
alias rmnode='rm -rf node_modules' # Sequential file cleanup script safe for Windows system threads

# Formats backup scripts for active configurations to recreate environments on separate computers
alias list-vscode-extensions="code --list-extensions | xargs -L 1 echo code --install-extension"

# Core navigation functions
cdf() { cd "$1" && here; } # Drags you into a directory and pops open your graphical File Explorer
mkcd() { mkdir -p "$1" && cd "$1"; } # Instantly spawns a nested file directory structure and jumps inside

up() { # Jumps upward through the file system by a designated numeric count integer (e.g., up 4)
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++)); do d=$d/..; done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then d=..; fi
  cd $d
}

# ──────────────────────────────────────────────────────────
# 4. UNIFIED GIT OPERATIONAL MACROS
# ──────────────────────────────────────────────────────────
alias ga='git add'
alias ga.='git add .'
alias gb='git branch'
alias gco='git checkout'
alias g-='git checkout -' # Swift branch toggle command allowing you to jump to your prior tracking target
alias gts='git status'
alias gdf='git diff'
alias gdfs='git diff --staged'
alias gfa='git fetch --all --prune' # Syncs remote connections, wiping deleted branch references
alias gpo='git push origin'
alias gpl='git pull'
alias gcp='git cherry-pick'
alias gnew='git checkout -b'
alias gres='git reset --hard'
alias gmaster='git checkout master'
alias gmain='git checkout main'
alias gmerge='git merge'
alias gclone='git clone'

# Sorts branches using core metadata to place recently touched items at the top with hashes
alias gbd='git branch --sort=-committerdate -v'

# Standalone color fallback routine for displaying diff tracking arrays securely
alias gitdiff='git diff --blank-at-eol --color=always | less -R'

# Quick history tree visualization alias showing graph loops and decorator tags
alias glg='git log --oneline --graph --decorate'
alias glo='git log --oneline'

# Combines environment checks to automatically pull origin repository details post branch checkout
alias gdev='git checkout develop && git pull origin develop'

,,() { # Jump directly to root index location of the current git repository tracking container
  local toplevel=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ -n "$toplevel" ]; then cd "$toplevel"; else echo "Not in a git repo"; fi
}

# ──────────────────────────────────────────────────────────
# 5. INTEGRATED PLATFORM WEB UTILITIES
# ──────────────────────────────────────────────────────────
_get_git_hosting() { # Parses remote origins to flag host type
  local ORIGIN=$(git config --get remote.origin.url)
  case "$ORIGIN" in
    *github*)    echo "github" ;;
    *bitbucket*) echo "bitbucket" ;;
    *gitlab*)    echo "gitlab" ;;
  esac
}

_get_repo() { # Cleans upstream markers returning standardized organization/repository text
  local TYPE="$1"
  local REGEX
  case "$TYPE" in
    "--github")    REGEX="s/.*github.com[:/]\(.*\)\.git.*/\1/" ;;
    "--bitbucket") REGEX="s/.*git@bitbucket.org[:/]\(.*\)\.git.*/\1/" ;;
    "--gitlab")    REGEX="s/.*git@gitlab.com[:/]\(.*\)\.git.*/\1/" ;;
  esac
  local REPO=$(git remote -v | grep -m 1 "(push)" | sed -e "$REGEX")
  echo "$REPO"
}

# Web integration router targeting active git repositories
gurl() {
  local SERVICE=$(_get_git_hosting)
  local BRANCH=$(git name-rev --name-only HEAD)
  case "$SERVICE" in
    "github")    open "https://github.com(_get_repo --github)/tree/$BRANCH" ;;
    "bitbucket") open "https://bitbucket.org(_get_repo --bitbucket)/branch/$BRANCH#commits" ;;
    "gitlab")    open "https://gitlab.com(_get_repo --gitlab)/-/tree/$BRANCH" ;;
  esac
}

# Automatic PR setup loops forwarding active tracking targets to remote hosting providers
pr()  { open "https://github.com(_get_repo --github)/pull/new/$(git name-rev --name-only HEAD)?expand=1"; }
prb() { open "https://bitbucket.org(_get_repo --bitbucket)/pull-requests/new?source=$(git name-rev --name-only HEAD)&event_source=branch_list"; }
prg() { open "https://gitlab.com(_get_repo --gitlab)/-/merge_requests/new?merge_request%5Bsource_branch%5D=$(git name-rev --name-only HEAD)&merge_request%5Btarget_branch%5D=master"; }

# ──────────────────────────────────────────────────────────
# 6. EXTERNAL TOOLS, APIS & INJECTION UTILITIES
# ──────────────────────────────────────────────────────────
cheat() { curl -s "cht.sh/${1// /+}"; } # Code example repository browser helper
alias cht='cheat'
alias weather='curl -s wttr.in/Manchester'
google() { open "https://google.com{1// /+}"; } # Converts plain text spaces into valid web queries
alias ip="curl -s ifconfig.me; echo" # Instantly retrieves your active public WAN IP address

alias hnews="open https://ycombinator.com"
alias bbc="open https://bbc.co.uk"
phone() { open "https://who-called.co.uk"; }

alias mx='chmod +x' # Explicit script execution permission tagging mapper
alias d='date "+%A, %d %B %Y"'
alias now='date +"%T"'

# Local terminal configuration adjustment aliases
alias bp='nano ~/.bash_profile'
alias bpc='code ~/.bash_profile'
alias bp!='source ~/.bash_profile'
alias ua="unalias"

add_alias() { # Automatic configuration injection router
  if [ $# -ne 2 ]; then
    echo "Invalid input. 2 arguments required: Alias and Command."
  else
    local target_profile="~/.bash_profile"
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "mingw" ]]; then
        target_profile="~/.bash_windows" # Appends to isolated auxiliary file on Windows
    fi
    echo "alias $1=\"$2\"" >> "$target_profile"
    source ~/.bash_profile
    echo "Alias safely appended to $target_profile! $1 : $2"
  fi
}

alias ua="unalias"

# Recursive history search across local directory trees
hgr() { grep -r "$@" ~/.history && history | grep "$@"; }
alias hs='history | grep -i'

# ──────────────────────────────────────────────────────────
# 7. ARCHIVE UNPACKER & THROWAWAY CONTEXT SANDBOXING
# ──────────────────────────────────────────────────────────
extract() { # Safe extraction router processing multiple file compression arrays safely
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar e "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)     echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

drp() { # Managed asset dispatching utility syncing directory contexts to cloud directories
  local DROPBOX=~/Dropbox
  if [ $# -eq 0 ]; then
    cd "$DROPBOX"
  else
    local SUBDIR="${2:-""}"
    local NEWDIR="$DROPBOX/$SUBDIR"
    mkdir -pv "$NEWDIR" && cp -av "$1" "$NEWDIR"
  fi
}

ghcode() { # Temporary storage workspace isolation script sandbox utility
  local repo=$1
  if [ $# -eq 2 ]; then repo=$1/$2; fi
  [[ ! $repo =~ "https://*" ]] && repo="https://github.com{repo}"
  echo "Opening $repo in sandbox environment..."
  local temp="$(mktemp -d)"
  git clone --depth=1 "${repo}" "${temp}" && code --wait -n "${temp}" && rm -rf "${temp}"
}

# ──────────────────────────────────────────────────────────
# 8. GENERAL RUNTIME LOGISTICS UTILITIES
# ──────────────────────────────────────────────────────────
# Standalone unified legacy docker alias definitions
alias dc="docker compose"
alias dcu="docker compose up"
alias dcb="docker compose up --build"
alias dcd="docker compose down"
alias dclogs="docker compose logs -f"

trim() { # POSIX space reduction processing filter stripping utility
  local var=$@
  var="${var#"${var%%[![:space:]]*}"}"
  var="${var%"${var##*[![:space:]]}"}"
  echo -n "$var"
}

# ──────────────────────────────────────────────────────────
# 9. PROMPT INVOCATION CALL BACK
# ──────────────────────────────────────────────────────────
parse_git_branch() { # Stable local file parse extracting branch definitions securely
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

get_prompt_branch() { # High-performance prompt processing configuration
    local GREEN="\[\e[32m\]"
    local PINK="\[\e[35m\]"
    local YELLOW="\[\e[33m\]"
    local CYAN="\[\e[36m\]"
    local NORMAL="\[\e[m\]"
    local ENV_TAG="${GREEN}\u${PINK}@bash ${YELLOW}\w${NORMAL}"
    if [ -d .git ]; then
        local BRANCH="${CYAN}$(parse_git_branch)${NORMAL}"
        export PS1="${ENV_TAG}${BRANCH}\n\$ "
    else
        export PS1="${ENV_TAG}\n\$ "
    fi
}
export PROMPT_COMMAND=get_prompt_branch # Registers execution layout loop engine
