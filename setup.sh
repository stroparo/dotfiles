#/usr/bin/env sh

! which curl &> /dev/null \
  && echo "FATAL: curl missing" 1>&2 \
  && exit 1

# Shell programs: Daily Shells, OhMyZsh etc.
sh -c "$(curl -LSfs https://raw.githubusercontent.com/stroparo/ds/master/setup.sh)"
sh -c "$(curl -LSfs https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
(. ~/.ds/ds.sh && [ -n "$DS_LOADED" ] && installohmyzsh.sh)

# SSH key
if [[ $USER != root ]] && [ ! -e ~/.ssh/id_rsa ] ; then
  
  mkdir ~/.ssh
  
  ssh-keygen -t rsa -C "$USER@$(hostname)" && \
    cat ~/.ssh/id_rsa.pub && \
    chmod 700 ~/.ssh/id_rsa && \
    ls -l ~/.ssh/id_rsa
fi
