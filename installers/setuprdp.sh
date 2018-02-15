#!/usr/bin/env bash

if egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release* ; then
  sudo yum -y install xrdp tigervnc-server
fi

if egrep -i -q '(centos|fedora|oracle|red *hat).* 6' /etc/*release*
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
