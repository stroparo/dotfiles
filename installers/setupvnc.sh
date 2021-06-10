#!/usr/bin/env bash

PROGNAME="setupvnc.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

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
# Download and install TigerVNC

if ! which vncserver >/dev/null 2>&1 ; then
  firefox 'https://sourceforge.net/projects/tigervnc/files/stable/'
  cd ~/Downloads
  tar xzvf tigervnc-*gz
  cd tigervnc-*/
  cp -v -R usr /
fi

# #############################################################################
# Make default configuration

sudo mkdir ~root/.vnc >/dev/null 2>&1
mkdir ~/.vnc >/dev/null 2>&1

if [ ! -f ~/.vnc/config ] ; then
  cat > ~/.vnc/config <<EOF
## Supported server options to pass to vncserver upon invocation can be listed
## in this file. See the following manpages for more: vncserver(1) Xvnc(1).
## Several common ones are shown below. Uncomment and modify to your liking.
##
# securitytypes=vncauth,tlsvnc
# desktop=sandbox
depth=32
geometry=1440x900
# localhost
# alwaysshared
EOF
fi

if [ ! -f ~/.vnc/xstartup ] ; then
  cat > ~/.vnc/xstartup <<EOF
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
xfce4-session &
EOF
fi

# Admin conf:
if [ ! -f ~root/.vnc/xstartup ] ; then
  cat <<EOF | sudo tee ~root/.vnc/xstartup
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
lightdm &
EOF
fi

# #############################################################################
# Make service

if [ ! -f /etc/systemd/system/vncserver.service ] ; then
  cat <<EOF | sudo tee /etc/systemd/system/vncserver.service
[Unit]
Description=VNC server
After=syslog.target network.target

[Service]
Type=forking
User=root
PAMName=login
PIDFile=/root/.vnc/%H:1.pid
ExecStartPre=-/usr/bin/vncserver -kill :1 > /dev/null 2>&1
ExecStart=/usr/bin/vncserver
ExecStop=/usr/bin/vncserver -kill :1

[Install]
WantedBy=multi-user.target
EOF
fi

if [[ $- = *i* ]] && ! sudo ls ~/.vnc/passwd ; then
  echo "${PROGNAME:+$PROGNAME: }INFO: Setting up VNC userspace password..." 1>&2
  vncpasswd
fi
if [[ $- = *i* ]] && ! sudo ls ~root/.vnc/passwd ; then
  echo "${PROGNAME:+$PROGNAME: }INFO: Setting up VNC admin (root) password..." 1>&2
  sudo -H vncpasswd
fi
sudo systemctl daemon-reload
sudo systemctl enable --now vncserver

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE"
exit
