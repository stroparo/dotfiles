#!/usr/bin/env bash

PROGNAME="setuprdp.sh"

if egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release* ; then

  sudo yum -y install xrdp tigervnc-server

  if egrep -i -q '(oracle|red *hat)' /etc/*release* ; then

    echo "$PROGNAME: INFO: setting up firewall"
    if [ "$(sudo firewall-cmd --state)" = "not running" ] ; then
      sudo systemctl start firewalld
    fi
    sudo firewall-cmd --permanent --zone=public --add-port=5904-5905/tcp \
      && sudo firewall-cmd --reload

    if egrep -i -q '(oracle|red *hat).* [67]' /etc/*release* ; then
      echo ${BASH_VERSION:+-e} "Force Xclients to startxfce4? [y/N]\c"
      read ans
      if [ "$ans" = y ] ; then
        sudo mv -v /etc/X11/xinit/Xclients /etc/X11/xinit/Xclients.bak.$(date '+%Y-%m-%d-%OH%OM%OS')
        cat <<'EOF' | sudo tee /etc/X11/xinit/Xclients
#!/usr/bin/env bash
exec $(which startxfce4)
EOF
      fi
      sudo chmod 755 /etc/X11/xinit/Xclients
    fi
  fi
fi

