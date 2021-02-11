source ~/.bashrc
alias composer="php ~/composer.phar"
alias art='php artisan'

export EDITOR=/usr/bin/nano

# git tab completion
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# General bash tab completion 
# brew install bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

## Tab improvements
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
# bind 'TAB: menu-complete'

cd() { builtin cd "$@"; ls; }               # Always list directory contents upon 'cd'

alias sudo='sudo --preserve-env'
# Up & down map to history search once a command has been started.
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

alias c='clear'
alias cs='clear;ls'
alias g='grep -i'

# Make some of the file manipulation programs verbose
alias mv="mv -v"
alias rm="rm -vi"
alias cp="cp -v"

alias mkdir="mkdir -pv"
alias cdev='cd ~/code'
alias home='cd ~'
alias ~='cd ~'
alias -- -='cd -'
alias cdo='cd && open .'
alias o='open'
alias chrome="open -a google\ chrome"
alias finder_s='defaults write com.apple.Finder AppleShowAllFiles TRUE; killAll Finder'
alias finder_h='defaults write com.apple.Finder AppleShowAllFiles FALSE; killAll Finder'
alias here='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
# open current finder directory in terminal
cdf () {
  target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
  if [ "$target" != "" ] then
    cd "$target"
    pwd
  else
    echo 'No Finder window found' >&2
  fi
}

# git commit (with or without message)
function gc () {
  if [ $# -eq 0 ]
    then
      git commit
  else
    git commit -m "$1"
  fi
}

alias ga='git add'
alias ga.='git add .'
alias gb='git branch'
alias gco='git checkout'
alias g-='git checkout -'
alias gts='git status'
alias gdf='git diff'
alias gdfs='git diff --staged'
alias glg='git log'
alias gfa='git fetch --all --prune'
alias gpo='git push origin'
alias gpl='git pull'
alias gcp='git cherry-pick'
alias gnew='git checkout -b'
alias res='git reset --hard'
alias gdev='git checkout develop && git pull origin'
alias master='git checkout master'
alias gitdiff='git difftool -y -x "colordiff -y -W $COLUMNS" | less -R'
alias merge='git merge'
alias clone='git clone'

git_branch_dates() {
  git for-each-ref --sort=authordate --format '%(authordate:iso) %(align:left,25)%(refname:short)%(end) %(subject)' refs/heads
}

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Set upstream and push
1stpush() {
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  git push --set-upstream origin $BRANCH
}

# log a git branch - show commit hashes
glo () {
  git log $1 --oneline
}

# open pr page on github for current branch
pr () {
  local repo=`git remote -v | grep -m 1 "(push)" | sed -e "s/.*github.com[:/]\(.*\)\.git.*/\1/"`
  local branch=`git name-rev --name-only HEAD`
  echo "... creating pull request for branch \"$branch\" in \"$repo\""
  open "https://github.com/$repo/pull/new/$branch?expand=1"
}

# Open bitbucket PR
prb () {
  local repo=`git remote -v | grep -m 1 "(push)" | sed -e "s/.*git@bitbucket.org[:/]\(.*\)\.git.*/\1/"`
  local branch=`git name-rev --name-only HEAD`
  echo "... creating pull request for branch \"$branch\" in \"$repo\""
  open "https://bitbucket.org/$repo/pull-requests/new?source=$branch&event_source=branch_list"
}

# Open Bitbucket branch
brb() {
  local repo=`git remote -v | grep -m 1 "(push)" | sed -e "s/.*git@bitbucket.org[:/]\(.*\)\.git.*/\1/"`
  local branch=`git name-rev --name-only HEAD`
  echo "...Opening \"$branch\" in \"$repo\""
  open "https://bitbucket.org/$repo/branch/$branch#commits"
}

# Open Gitlab PR
prg () {
  local repo=`git remote -v | grep -m 1 "(push)" | sed -e "s/.*git@gitlab.com[:/]\(.*\)\.git.*/\1/"`
  local branch=`git name-rev --name-only HEAD`
  echo "... creating pull request for branch \"$branch\" in \"$repo\""
  open "https://gitlab.com/$repo/-/merge_requests/new?merge_request%5Bsource_branch%5D=$branch&merge_request%5Btarget_branch%5D=master"
}

alias h='history'
alias histgrep='history | grep'
alias hs='history | grep -i $1'
if [ ! -d ~/.history/$(date -u +%Y/%m/) ]; then
  mkdir -p ~/.history/$(date -u +%Y/%m/)
fi

export HISTFILE="${HOME}/.history/$(date -u '+%Y/%m/%d %H.%M.%S')"
export HISTCONTROL=ignoreboth
export HISTCONTROL=erasedups
export HISTTIMEFORMAT="%d/%m/%Y-%H:%M:%S: "
export HISTIGNORE='&:bg:fg:clear:ls:pwd:history:exit:make*:* --help:c'
function hgr() {
  grep -r "$@" ~/.history
  history | grep "$@"
}

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias f='find . | grep'

alias l='ls -CF'
alias la='ls -AF' # List all files
alias ldir='ls -d */' # List only directories
alias ll='ls -l'
alias lh='ls -lash'
alias l.='ls -A | egrep "^\."' # List only dotfiles (hidden files)
alias lsh='ls -lash'
alias lsl="ls -lhFA | less" # For viewing large directories
alias labc='ls -lap' #alphabetical sort
alias lsdesc='ls -alt' # newest first sort
alias lsasc='ls -laptr' #oldest first sort

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels

# cd to root of current git project
alias ,,='git rev-parse --git-dir >/dev/null 2>&1 && cd `git rev-parse --show-toplevel` || echo "Not in git repo"'

function cheat() {
  curl cht.sh/$1
}
alias cht='cheat'
alias weather='curl wttr.in/Manchester'

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

alias d='date +%F'
alias now='date +"%T"'

alias hosts='sudo nano /etc/hosts'
alias bp='nano ~/.bash_profile'
alias bpc='code ~/.bash_profile'
alias bp!='source ~/.bash_profile'
alias brc='nano ~/.bashrc'
alias brcc='code ~/.bashrc'

alias psg='ps ax | grep -v grep | grep -i -e VSZ -e'
pid() { lsof -t -c "$@" ; }

alias rmnode='rm -rf node_modules &'
alias list-vscode-extensions='code --list-extensions | xargs -L 1 echo code --install-extension'

alias numFiles='echo $(ls -1 | wc -l)'

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

alias hup='cd ~/Homestead && vagrant up'
alias hssh='cd ~/Homestead && vagrant ssh'
source ~/.nvm/nvm.sh

function homestead() {
  ( cd ~/Homestead && vagrant $* )
}

mkcd() {
  mkdir -p $1;
  cd $1;
}

search(){
  egrep -roiI $1 . | sort | uniq;
}

#   ---------------------------
#    SEARCHING
#   ---------------------------

alias qf="find . -name "                 # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

google() {
  open "https://google.com/search?q=$1"
}

#   spotlight: Search for a file using MacOS Spotlight's metadata
#   -----------------------------------------------------------
spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }

# Goes up a specified number of directories  (i.e. up 4)
up () {
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

# Trim leading and trailing spaces (for scripts)
trim() {
  local var=$@
  var="${var#"${var%%[![:space:]]*}"}"  # remove leading whitespace characters
  var="${var%"${var##*[![:space:]]}"}"  # remove trailing whitespace characters
  echo -n "$var"
}

trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash

rmpwd() {
  THIS=`pwd`
  cd ..
  rm -rf $THIS
}

# check who uses port
port() {
  lsof -i tcp:"$@"
}

# Get current public ip address
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
  else
    echo "'$1' is not a valid file"
  fi
}

#   myps: List processes owned by my user:
#   ------------------------------------------------------------
myps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
alias ttop="top -R -F -s 10 -o rsize"

## History
# Larger bash history (default is 500)
export HISTSIZE=9001
export HISTFILESIZE=$HISTSIZE
# Causes bash to append to history instead of overwriting it so if you start a
# new terminal, you have old session history
shopt -s histappend

function get_prompt_branch() {
  IS_GIT_DIRECTORY=$(git rev-parse --is-inside-work-tree > /dev/null 2>&1;)
  BASIC_PROMPT="\[\e[33m\]\w \\$\[\e[m\] ";
  if [ IS_GIT_DIRECTORY ]; then
    BRANCH="\[\e[32m\]$(trim $(parse_git_branch))\[\e[m\]";
    export PS1="${BRANCH} ${BASIC_PROMPT}";
  else
    export PS1="${BASIC_PROMPT}";
  fi
}

export PROMPT_COMMAND=get_prompt_branch
export PROMPT_COMMAND="history -a; history -r; $PROMPT_COMMAND"

# Quickly add a new alias
function add_alias {
  if [ $# -ne 2 ]; then
    echo "Invalid input. 2 arguments required. Alias and command.";
  else
    echo "alias $1=\"$2\"" >> ~/.bash_profile;
    source ~/.bash_profile;
    echo "Alias added! $1 : $2";
  fi
}

alias ua="unalias"

npmi () {
  local packagename=$(echo ${@} | sed -E 's/(\-+[a-zA-Z0-9]+| )//g')
  local opt
  npm info ${packagename} | less
  echo "Is it the right package? (y/n)"
  read opt
  if [[ "${opt}" == "y" ]]; then
    npm i ${@}
  fi
}

alias hnews="open https://news.ycombinator.com/news"
alias bbc="open https://www.bbc.co.uk/"

phone() {
  open https://who-called.co.uk/Number/$1
}

alias dcu="docker-compose up"
alias dcb="docker-compose up --build"
alias dcd="docker-compose down"

# Run program on Docker Container - defaults to shell
dssh() {
  local PROG=${2:-sh}
  docker exec -it $1 $PROG
}

# Search for Docker container ID by name
dfind() {
  docker ps --filter "name=$1" --format "{{.ID}}"
}

# Find docker container by name and open a shell
ds() {
  ID=$(dfind $1)
  echo "connecting to docker container: $ID ($1)"
  dssh $ID
}

# Dropbox
function drp () {
  local DROPBOX=~/Dropbox
  if [ $# -eq 0 ]
    then
      cd $DROPBOX
  else
    local SUBDIR=${2:-""}
    local NEWDIR=$DROPBOX/$SUBDIR
    mkdir -pv "$NEWDIR"
    cp -av $1 $NEWDIR
  fi
}
