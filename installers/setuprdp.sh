#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

# #############################################################################
# Globals

PROGNAME="setuprdp.sh"
export USAGE="[-h] [-y]"

export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf

export STARTXFCE=false

# Options:
OPTIND=1
while getopts ':h' option ; do
  case "${option}" in
    h) echo "$USAGE"; exit;;
  esac
done
shift "$((OPTIND-1))"

if echo "$@" | grep -q -w 'xfce' ; then
  export STARTXFCE=true
fi

# #############################################################################

if egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release 2>/dev/null ; then

  sudo $RPMPROG install -y xrdp tigervnc-server

  if egrep -i -q '(oracle|red *hat)' /etc/*release 2>/dev/null ; then

    echo "$PROGNAME: INFO: setting up firewall"
    if [ "$(sudo firewall-cmd --state)" = "not running" ] ; then
      sudo systemctl start firewalld
    fi
    sudo firewall-cmd --permanent --zone=public --add-port=5904-5905/tcp \
      && sudo firewall-cmd --reload

    if egrep -i -q '(oracle|red *hat).* [67]' /etc/*release 2>/dev/null ; then

      # Xclients customization in /etc/X11/xinit for XFCE:
      # TODO verify if applies to centos & fedora
      if which startxfce4 >/dev/null 2>&1 ; then
        if ${STARTXFCE:-false} ; then
          ans=y
        else
          echo ${BASH_VERSION:+-e} "Force Xclients to startxfce4? [y/N]\c"
          read ans
        fi
        if [ "$ans" = y ] ; then
          # Root Xclients is in /etc/X11/xinit/Xclients but prefer the local one:
          sudo mv -v ~/.Xclients ~/.Xclients.bak.$(date '+%Y-%m-%d-%OH%OM%OS')
          cat <<'EOF' | sudo tee ~/.Xclients
#!/usr/bin/env bash
exec $(which startxfce4)
EOF
        fi
        sudo chmod 755 ~/.Xclients
      fi

    fi
  fi

  sudo systemctl enable xrdp
  sudo systemctl start xrdp
fi

