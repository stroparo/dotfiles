#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

echo ${BASH_VERSION:+-e} '\n\n==> Installing oh-my-zsh...' 1>&2

# #############################################################################
# Checks

if ! type zsh >/dev/null 2>&1 ; then
  echo "SKIP: zsh is not installed. Nothing done." 1>&2
  exit
fi

# #############################################################################
# Globals

OMZ_SYN_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
OMZ_SYN_URL="https://github.com/zsh-users/zsh-syntax-highlighting.git"
OMZ_URL="https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"

# #############################################################################
# Install OhMyZsh

if [ ! -d "${HOME}/.oh-my-zsh" ] ; then
  sh -c "$(curl -LSfs "${OMZ_URL}")"
fi

# Restore pre-oh-my-zsh backup:
if [ -s "${HOME}/.zshrc.pre-oh-my-zsh" ] ; then
  echo ${BASH_VERSION:+-e} "\n# .zshrc.pre-oh-my-zsh restored\n" >> "${HOME}/.zshrc"
  cat >> "${HOME}/.zshrc" < "${HOME}/.zshrc.pre-oh-my-zsh" \
    && rm -f "${HOME}/.zshrc.pre-oh-my-zsh"
fi

# #############################################################################
# Plugin syntax highlighting

echo ${BASH_VERSION:+-e} '\n\n==> Installing zsh-syntax-highlighting...' 1>&2
if [ ! -d "$OMZ_SYN_PATH" ] ; then
  echo git clone "$OMZ_SYN_URL" "$OMZ_SYN_PATH"
  git clone "$OMZ_SYN_URL" "$OMZ_SYN_PATH"
fi
ls -d -l "$OMZ_SYN_PATH"

# Activate the plugin (idempotent):
if ! grep -q 'plugins=.*zsh-syntax-highlighting' ~/.zshrc ; then
  sed -i -e 's/\(plugins=(.*\))/\1 zsh-syntax-highlighting)/' ~/.zshrc
else
  echo "SKIP: zsh-syntax-highlighting already activated." 1>&2
fi

# #############################################################################
