#/usr/bin/env sh

! which curl &> /dev/null \
  && echo "FATAL: curl missing" 1>&2 \
  && exit 1

# Daily Shells
sh -c "$(curl -LSfs https://raw.githubusercontent.com/stroparo/ds/master/setup.sh)"

# Daily Shells Extras
git clone https://github.com/stroparo/ds-extras.git ~/.ds-extras \
  && (cd ~/.ds-extras && . ./overlay.sh) \
  && rm -rf ~/.ds-extras

# OhMyZsh
sh -c "$(curl -LSfs https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
(. ~/.ds/ds.sh && [ -n "$DS_LOADED" ] && installohmyzsh.sh)

# SSH key
if [[ $USER != root ]] && [ ! -e ~/.ssh/id_rsa ] ; then
  
  mkdir ~/.ssh
  
  ssh-keygen -t rsa -C "$USER@$(hostname)" \
    && chmod 700 ~/.ssh/id_rsa \
    && ls -l ~/.ssh/id_rsa
fi
if [ -e ~/.ssh/id_rsa.pub ] ; then
  echo "==> ~/.ssh/id_rsa.pub contents:"
  cat ~/.ssh/id_rsa.pub
fi
