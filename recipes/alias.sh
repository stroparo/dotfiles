#!/usr/bin/env bash

PROGNAME="alias.sh"
ALIASES_FILE='${HOME}/.aliases-cs'

echo "$PROGNAME: INFO: aliases writing to '$ALIASES_FILE' started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Shell profiles

if touch ~/.bashrc && [ -r ~/.bashrc ] && [ -w ~/.bashrc ] ; then
  fgrep -i -q "/.aliases-cs" ~/.bashrc \
    || echo ". \"${ALIASES_FILE}\"" >> ~/.bashrc
fi

# Zsh profile
if touch ~/.zshrc && [ -r ~/.zshrc ] && [ -w ~/.zshrc ] ; then
  fgrep -i -q "/.aliases-cs" ~/.zshrc \
    || echo ". \"${ALIASES_FILE}\"" >> ~/.zshrc
fi

# #############################################################################
# Aliases file

cat > "$(eval echo "\"${ALIASES_FILE}\"")" <<'EOF'
# Function d - Dir navigation
unalias d 2>/dev/null
unset d 2>/dev/null
d () {
  if [ -e "$1" ] ; then cd "$1" ; shift ; fi
  for dir in "$@" ; do
    if [ -e "$dir" ] ; then cd "$dir" ; continue ; fi
    found=$(ls -1d *"${dir}"*/ | head -1)
    if [ -z "$found" ] ; then found="$(find . -type d -name "*${dir}*" | head -1)" ; fi
    if [ -n "$found" ] ; then echo "$found" ; cd "$found" ; fi
  done
  pwd; which exa >/dev/null 2>&1 && exa -ahil || ls -al
  if [ -e ./.git ] ; then
    echo ; git branch -vv
    echo ; git status -s
  fi
}

# Asorted
alias capsctrl='setxkbmap -option "ctrl:nocaps"'
alias cls='clear'
alias ctl='sudo systemctl'
alias dfg='df -gP'
alias dfh='df -hP'
alias dsloaddefault='. "$HOME/.ds/ds.sh"'
alias dumr='du -ma | sort -rn'
alias dums='du -ma | sort -n'
alias findd='find . -type d'
alias findf='find . -type f'
alias nhr='rm nohup.out'
alias nht='tail -9999f nohup.out'
alias tpf='typeset -f'
alias xcd="alias | egrep \"'c?d \" | fgrep -v 'cd -'"
alias xgit="alias | grep -w git"

# Clipboard
if [ -e /dev/clipboard ]; then
  alias pbcopy='cat >/dev/clipboard'
  alias pbpaste='cat /dev/clipboard'
fi

# Grep
if (command grep --help | command grep -q -- --color) ; then
  alias grep='grep --color=auto'
  alias egrep='egrep --color=auto'
  alias fgrep='fgrep --color=auto'
fi

# Ls / exa - list files:
unalias exa ls
if which exa >/dev/null 2>&1 ; then
  alias exa='exa --color=auto'
  alias l='exa -hil'
  alias ll='exa -ahil'
  alias lt='exa -ahil --sort=age'
elif [[ $(ls --version 2>/dev/null) = *GNU* ]] ; then
  alias ls='ls --color=auto'
  alias l='ls -Fhil'
  alias ll='ls -AFhil'
  alias lt='ls -Fhilrt'
else
  alias l='ls -Fl'
  alias ll='ls -AFl'
  alias lt='ls -Flrt'
fi

# #############################################################################
# Ag aka the silver searcher

alias agf='ag -F'
alias agn='ag --line-numbers'

# Search only certain filetypes:
alias agjs='ag --js'
alias agp='ag --python'
alias agr='ag --ruby'
alias ags='ag --shell'

# #############################################################################
# Docker

alias dk='docker'
alias dke='docker exec'
alias dkipaddr="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"

# Compose
alias dc='docker-compose'
alias dce='docker-compose exec'

# #############################################################################
# Git

alias bv='git branch -vv'
alias bav='git branch -avv'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gfa='git fetch --all'
alias gfap='git fetch --all -p'
alias gfp='git fetch -p'
alias glrum='git pull --rebase upstream master'
alias gph='git push origin HEAD'
alias gphf='git push -f origin HEAD'
alias gpmm='git push mirror master'
alias gv='git mv'

# Diff
alias gdc='git diff --cached'
alias gdh='git diff HEAD'
alias gdi='git diff --ignore-space-at-eol'
alias ge='git diff --ignore-space-at-eol'
alias gec='git diff --ignore-space-at-eol --cached'
alias gee='git diff --ignore-space-at-eol HEAD'

# Log
alias gas='git log --decorate --graph --all --stat'
alias gaso='git log --decorate --graph --all --stat --oneline'
alias glggs='git log --decorate --graph --stat'

# Override oh-my-zsh's (e.g. add --decorate):
alias glg='git log --decorate --stat'
alias glgg='git log --decorate --graph'

# If no Oh-My-ZSH then load similar git aliases:
if [ -z "${ZSH_THEME}" ] ; then
  alias ga='git add'
  alias gb='git branch'
  alias gc='git commit -v'
  alias gcb='git checkout -b'
  alias gcf='git config -l'
  alias gcl='git clone --recursive'
  alias gco='git checkout'
  alias gd='git diff'
  alias gdca='git diff --cached'
  alias gf='git fetch'
  alias gl='git pull'
  alias glgga='git log --decorate --graph --all'
  alias glog='git log --decorate --graph --oneline'
  alias gloga='git log --decorate --graph --all --oneline'
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

  # --wip--
  alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
  alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

  # --wip-- Warn if the current branch is a WIP (common usage in prompt vars eg PS1):
  function work_in_progress() {
    if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
      echo "WIP!!"
    fi
  }
fi

# #############################################################################
# Gradle

alias gdl='gradle'
alias gdlc='gradle --console=plain'

# #############################################################################
# Kitchen

alias ktc='kitchen converge'
alias ktd='kitchen destroy'
alias ktl='kitchen login'
alias kts='kitchen setup'
alias ktt='kitchen test'
alias ktv='kitchen verify'

# #############################################################################
# Packaging APT dpkg etcetera

alias apd='sudo aptitude'
alias apdup='sudo aptitude update && sudo aptitude'
alias apdupgrade='sudo aptitude update && sudo aptitude safe-upgrade'
alias apti='sudo apt install -y'
alias apts='apt-cache search'
alias aptshow='apt-cache show'
alias aptshowpkg='apt-cache showpkg'
alias aptup='sudo apt update && sudo apt'
alias aptupgrade='sudo apt update && sudo apt upgrade'
alias dpkgl='dpkg -L'
alias dpkgs='dpkg -s'
alias dpkgsel='dpkg --get-selections | egrep -i'
alias updalt='sudo update-alternatives'

# #############################################################################
# Packaging RPM etcetera

alias yumepel='sudo yum --enablerepo=epel'

# #############################################################################
# Python

alias server='python -m http.server'
alias va='. ./bin/activate'

# #############################################################################
# Tmux

alias xa='tmux attach -t'
alias xk='tmux kill-session -t'
alias xl='tmux ls'
alias xs='tmux new-session -s'

# #############################################################################
# Vim

if which vim >/dev/null 2>&1 ; then
  alias vi=vim
fi

alias vim.js="vim - -c 'set syntax=javascript'"
alias vim.py="vim - -c 'set syntax=python'"
alias vim.pl="vim - -c 'set syntax=perl'"
alias vim.rb="vim - -c 'set syntax=ruby'"

# #############################################################################

EOF

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE: aliases written to '${ALIASES_FILE}'"
exit
