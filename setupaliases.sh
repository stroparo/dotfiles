#!/usr/bin/env bash
# Cristian Stroparo's dotfiles

echo "################################################################################"
echo "Aliases ==> '$HOME/.aliases-cs'"
echo "################################################################################"

echo "==> Setting up aliases..."

# Globals
ALIASES_FILE="$HOME/.aliases-cs"
echo "INFO: ALIASES_FILE='$ALIASES_FILE'"

# #############################################################################
# Shell profiles

if [ -r ~/.bashrc ] && [ -w ~/.bashrc ] ; then
  fgrep -i -q "$ALIASES_FILE" ~/.bashrc \
    || echo ". '$ALIASES_FILE'" >> ~/.bashrc
fi

# Zsh profile
if [ -r ~/.zshrc ] && [ -w ~/.zshrc ] ; then
  fgrep -i -q "$ALIASES_FILE" ~/.zshrc \
    || echo ". '$ALIASES_FILE'" >> ~/.zshrc
fi

# #############################################################################
# Aliases file

cat > "$ALIASES_FILE" <<'EOF'
unalias d 2>/dev/null
unset d 2>/dev/null
d () {
  if [ -e "$1" ] ; then cd "$1" ; shift ; fi
  for dir in "$@" ; do
    found=$(ls -1d *"${dir}"* | head -1)
    if [ -z "$found" ] ; then found="$(find . -type d -name "*${dir}*" | head -1)" ; fi
    if [ -n "$found" ] ; then echo "$found" ; cd "$found" ; fi
  done
  pwd; which exa >/dev/null 2>&1 && exa -ahil || ls -al
  if [ -e ./.git ] ; then git branch -vv ; fi
}

# Asorted
alias capsctrl='setxkbmap -option "ctrl:nocaps"'
alias cls='clear'
alias dfg='df -gP'
alias dfh='df -hP'
alias dsloaddefault='. ~/.ds/ds.sh'
alias dumr='du -ma | sort -rn'
alias dums='du -ma | sort -n'
alias e='exa -hil'
alias ea='exa -ahil'
alias findd='find . -type d'
alias findf='find . -type f'
alias nhr='rm nohup.out'
alias nht='tail -9999f nohup.out'
alias server='python3 -m http.server'
alias sourceds='. "$HOME/.ds/ds.sh"'
alias sourcevirtualenv='. ./bin/activate'
alias xcd="alias | egrep \"'c?d \" | fgrep -v 'cd -'"
alias xgit="alias | grep -w git"

# Breaking aliases
which vim >/dev/null 2>&1 && alias vi=vim

# Grep
if (command grep --help | command grep -q -- --color) ; then
  alias grep='grep --color=auto'
  alias egrep='egrep --color=auto'
  alias fgrep='fgrep --color=auto'
fi

# Ls
if [[ $(ls --version 2>/dev/null) = *GNU* ]] ; then
  alias ls='ls --color=auto'
  alias l='ls -Flhi'
  alias ll='ls -AFlhi'
  alias lt='ls -Flrthi'
else
  alias l='ls -Fl'
  alias ll='ls -AFl'
  alias lt='ls -Flrt'
fi

# #############################################################################
# Ag aka the silver searcher

if which ag >/dev/null 2>&1 ; then

  alias agbare='command ag'

  alias agf='ag -F'
  alias agfi='ag -Fi'
  alias agi='ag -i'
  alias agin='ag -i --line-numbers'
  alias agn='ag --line-numbers'

  alias agp='ag --python'
  alias agr='ag --ruby'

  alias agasm='ag --asm'
  alias agbat='ag --batch'
  alias agcc='ag --cc'
  alias agclojure='ag --clojure'
  alias agcpp='ag --cpp'
  alias agcsharp='ag --csharp'
  alias agcss='ag --css'
  alias agdelphi='ag --delphi'
  alias agelixir='ag --elixir'
  alias agerlang='ag --erlang'
  alias aghtml='ag --html'
  alias agjs='ag --js'
  alias agmd='ag --md -i'
  alias agmk='ag --mk -i'
  alias agphp='ag --php'
  alias agrust='ag --rust'
  alias agshell='ag --shell'
  alias agsass='ag --sass'
  alias agscala='ag --scala'
  alias agsql='ag --sql'
  alias agvim='ag --vim'
  alias agyaml='ag --yaml'
  alias agxml='ag --xml'
fi

# #############################################################################
# Docker

alias dc='docker-compose'
alias de='docker-compose exec'

# #############################################################################
# Git

if which git >/dev/null 2>&1 ; then

  alias bv='git branch -vv'
  alias bav='git branch -avv'
  alias gh='git diff HEAD'
  alias glggas='git log --graph --decorate --all --stat'
  alias glogas='git log --graph --decorate --all --stat --oneline'
  alias glrum='git pull --rebase upstream master'
  alias gpmm='git push mirror master'
  alias gv='git mv'

  # If no Oh-My-ZSH then load similar git aliases:
  if [ -z "${ZSH_THEME}" ] ; then
    alias ga='git add'
    alias gb='git branch'
    alias gc='git commit -v'
    alias gcb='git checkout -b'
    alias gcl='git clone --recursive'
    alias gco='git checkout'
    alias gd='git diff'
    alias gdca='git diff --cached'
    alias gf='git fetch'
    alias gl='git pull'
    alias glg='git log --stat'
    alias glgg='git log --graph'
    alias glog='git log --oneline --decorate --graph'
    alias gp='git push'
    alias grh='git reset HEAD'
    alias grhh='git reset HEAD --hard'
    alias gru='git reset --'
    alias gsps='git show --pretty=short --show-signature'
    alias gss='git status -s'
    alias gst='git status'
    alias gts='git tag -s'

    alias gr='git remote'
    alias gra='git remote add'
    alias grmv='git remote rename'
    alias grrm='git remote remove'
    alias grset='git remote set-url'
    alias grup='git remote update'
    alias grv='git remote -v'
  fi
fi

# #############################################################################
# Packaging APT dpkg etcetera

if which apt >/dev/null 2>&1 || which apt-get >/dev/null 2>&1 ; then
  alias apd='sudo aptitude update && sudo aptitude'
  alias apdi='sudo aptitude install -y'
  alias apdnoup='sudo aptitude'
  alias apdup='sudo aptitude update'
  alias apdupsafe='sudo aptitude update && sudo aptitude safe-upgrade'
  alias apti='sudo apt install -y'
  alias apts='apt-cache search'
  alias aptshow='apt-cache show'
  alias aptshowpkg='apt-cache showpkg'
  alias aptup='sudo apt update'
  alias aptupgrade='sudo apt update && sudo apt upgrade'
  alias dpkgl='dpkg -L'
  alias dpkgs='dpkg -s'
  alias dpkgsel='dpkg --get-selections | egrep -i'
  alias upalt='sudo update-alternatives'
fi

# #############################################################################
# Packaging RPM etcetera

if egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release ; then
  alias yumepel='sudo yum --enablerepo=epel'
fi

# #############################################################################
# Tmux

alias tls='tmux ls'
alias tat='tmux attach -t'
alias tns='tmux new-session -s'
alias tks='tmux kill-session -t'

# #############################################################################

EOF

# #############################################################################
