#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Setup Oh-My-Zsh"

# #############################################################################
# Globals

PROGNAME=setupohmyzsh.sh
OMZ_SYN_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
OMZ_SYN_URL="https://github.com/zsh-users/zsh-syntax-highlighting.git"
OMZ_URL="https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
ZSH_THEME="robbyrussell"

# #############################################################################
# Checks

if ! type zsh >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: zsh is not installed. Nothing done." 1>&2
  exit
fi

# #############################################################################
# Main

echo
echo ">>> IMPORTANT <<<"
echo "... After installing oh-my-zsh, it will change"
echo "... the default shell to zsh and log into it."
echo "... IF THAT IS THE CASE (like the prompt stopped"
echo "... and nothing else happened), then exit or CTRL+D"
echo "... for this sequence to continue."
echo

if [ ! -d "${HOME}/.oh-my-zsh" ] ; then
  sh -c "$(curl ${DLOPTEXTRA} -LSfs "${OMZ_URL}")"
fi

# Restore pre-oh-my-zsh backup:
if [ -s "${HOME}/.zshrc.pre-oh-my-zsh" ] ; then
  echo ${BASH_VERSION:+-e} "\n# .zshrc.pre-oh-my-zsh restored\n" >> "${HOME}/.zshrc"
  cat >> "${HOME}/.zshrc" < "${HOME}/.zshrc.pre-oh-my-zsh" \
    && rm -f "${HOME}/.zshrc.pre-oh-my-zsh"
fi

# #############################################################################

echo
echo "Installing ohmyzsh plugin zsh-syntax-highlighting"
echo

if [ ! -d "$OMZ_SYN_PATH" ] ; then
  echo git clone "$OMZ_SYN_URL" "$OMZ_SYN_PATH"
  git clone --depth 1 "$OMZ_SYN_URL" "$OMZ_SYN_PATH"
fi
ls -d -l "$OMZ_SYN_PATH"

# Activate the plugin (idempotent):
if ! grep -q 'plugins=.*zsh-syntax-highlighting' ~/.zshrc ; then
  sed -i -e 's/\(plugins=(.*\))/\1 zsh-syntax-highlighting)/' ~/.zshrc
  grep "zsh-syntax-highlighting" ~/.zshrc /dev/null
else
  echo "SKIP: zsh-syntax-highlighting already activated." 1>&2
fi

# #############################################################################

echo
echo "Selecting ZSH_THEME=\"${ZSH_THEME:-robbyrussell}\""
echo

sed -i -e "s/^ZSH_THEME=.*$/ZSH_THEME=\"${ZSH_THEME:-robbyrussell}\"/" "${HOME}/.zshrc"

# #############################################################################
# Finish

echo "FINISHED Oh-My-Zsh setup"
echo
