#!/usr/bin/env bash

PROGNAME="xfce.sh"

if ! (uname -a | grep -i linux) ; then exit ; fi

echo "$PROGNAME: INFO: XFCE setup"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

export USAGE="[-d] [-h]"

# System installers
export APTPROG=apt-get; if which apt >/dev/null 2>&1 ; then export APTPROG=apt ; fi
export PACPROG=pacman
export RPMPROG=yum; if which dnf >/dev/null 2>&1 ; then export RPMPROG=dnf ; fi
export RPMGROUP="yum groupinstall"; if which dnf >/dev/null 2>&1 ; then export RPMGROUP="dnf group install" ; fi
export INSTPROG="$APTPROG"; if which "$RPMPROG" >/dev/null 2>&1 ; then export INSTPROG="$RPMPROG" ; fi
export INSTCKPROG="dpkg -s"; if which "$RPMPROG" >/dev/null 2>&1 ; then export INSTCKPROG="yum list installed" ; fi

# #############################################################################
# Specific globals

# Options:
OPTIND=1
while getopts ':h' option ; do
  case "${option}" in
    h) echo "$USAGE"; exit;;
  esac
done
shift "$((OPTIND-1))"

# #############################################################################
# Helpers

source "${RUNR_DIR:-.}"/helpers/dsenforce.sh
if [ -f "${DS_HOME:-$HOME/.ds}/ds01testsdistros.sh" ] ; then
  . "${DS_HOME:-$HOME/.ds}/ds01testsdistros.sh"
else
  echo "${PROGNAME:+$PROGNAME: }FATAL: Must have DRYSL (DRY Scripting Library) installed in the environment." 1>&2
  exit 1
fi


_install_packages () {
  typeset filestamp="$(date '+%Y%m%d-%OH%OM%OS')"

  for package in "$@" ; do
    if eval ${INSTCKPROG} "${package}" >/dev/null 2>&1 ; then
      echo "$PROGNAME: SKIP: Package '${package}' already installed..."
    else
      echo "$PROGNAME: INFO: Installing '${package}'..."
      if ! sudo $INSTPROG install -y "${package}" 2>&1 | tee /tmp/pkg-install-${filestamp}-${package}.log ; then
        echo "${PROGNAME}: WARN: There was an error installing packages - see '/tmp/pkg-install-${filestamp}-${package}.log'." 1>&2
      fi
    fi
  done
}


_install_rpm_groups () {
  for group in "$@" ; do
    echo "Installing RPM group '$group'"
    if ! sudo $RPMGROUP -y "$group" >/tmp/rpm-group-install-err-$group.log 2>&1 ; then
      echo "${PROGNAME:+$PROGNAME: }WARN: There was an error with group '$group' - see '/tmp/rpm-group-install-err-$group.log'." 1>&2
    fi
  done
}


_set_fedora_version () {
  export FEDORA_VERSION=$(egrep -i -o -r 'fedora [0-9]+' /etc/*release \
    | head -1 \
    | awk '{ print $2; }')
}


# #############################################################################
if _is_el_family ; then

  _install_rpm_groups "x window system"
  if ! _is_fedora ; then
    if _is_el6 ; then
      _install_rpm_groups "desktop" "general purpose desktop"
    elif _is_el7 ; then
      _install_rpm_groups "desktop" "server with gui" "mate desktop"
    fi
  fi
  _install_rpm_groups xfce

  _install_packages xorg-x11-fonts-Type1 xorg-x11-fonts-misc

  echo "$PROGNAME: INFO: XFCE Whisker Menu setup..."
  if _is_el ; then
    _install_packages "xfce4-whiskermenu-plugin"
  elif egrep -i -q -r 'fedora 2[6-9]' /etc/*release ; then
    _set_fedora_version
    if [ ! -e /etc/yum.repos.d/home:gottcode.repo ] ; then
      sudo $INSTPROG remove -y "xfce4-whiskermenu-plugin" >/dev/null 2>&1
      sudo curl -LSf -k -o /etc/yum.repos.d/home:gottcode.repo \
        "http://download.opensuse.org/repositories/home:\
/gottcode/Fedora_${FEDORA_VERSION}/home:\
gottcode.repo"
      _install_packages "xfce4-whiskermenu-plugin"
    fi
  fi

# #############################################################################
elif _is_debian_family ; then

  _install_packages xfce4 xfce4-goodies
  _install_packages "xfwm4-themes"
  _install_packages xfce4-clipman-plugin xfce4-mount-plugin xfce4-places-plugin xfce4-timer-plugin

# #############################################################################
elif _is_arch_family ; then

  # TODO update for arch:
  # _install_packages xfce4 xfce4-goodies
  # _install_packages "xfwm4-themes"
  # _install_packages xfce4-clipman-plugin xfce4-mount-plugin xfce4-places-plugin xfce4-timer-plugin

  sudo "$PACPROG" -Syyu

  # xfce4
  # _install_packages \
  #   exo \
  #   garcon \
  #   thunar \
  #   thunar-volman \
  #   tumbler \
  #   xfce4-appfinder \
  #   xfce4-panel \
  #   xfce4-power-manager \
  #   xfce4-session \
  #   xfce4-settings \
  #   xfce4-terminal \
  #   xfconf \
  #   xfdesktop \
  #   xfwm4 \
  #   xfwm4-themes

  # xfce4-goodies
  # _install_packages \
  #   mousepad \
  #   parole \
  #   ristretto \
  #   thunar-archive-plugin \
  #   thunar-media-tags-plugin \
  #   xfburn \
  #   xfce4-artwork \
  #   xfce4-battery-plugin \
  #   xfce4-clipman-plugin \
  #   xfce4-cpufreq-plugin \
  #   xfce4-cpugraph-plugin \
  #   xfce4-datetime-plugin \
  #   xfce4-dict \
  #   xfce4-diskperf-plugin \
  #   xfce4-eyes-plugin \
  #   xfce4-fsguard-plugin \
  #   xfce4-genmon-plugin \
  #   xfce4-mailwatch-plugin \
  #   xfce4-mount-plugin \
  #   xfce4-mpc-plugin \
  #   xfce4-netload-plugin \
  #   xfce4-notes-plugin \
  #   xfce4-notifyd \
  #   xfce4-pulseaudio-plugin \
  #   xfce4-screensaver \
  #   xfce4-screenshooter \
  #   xfce4-sensors-plugin \
  #   xfce4-smartbookmark-plugin \
  #   xfce4-systemload-plugin \
  #   xfce4-taskmanager \
  #   xfce4-time-out-plugin \
  #   xfce4-timer-plugin \
  #   xfce4-verve-plugin \
  #   xfce4-wavelan-plugin \
  #   xfce4-weather-plugin \
  #   xfce4-whiskermenu-plugin \
  #   xfce4-xkb-plugin
fi

# #############################################################################


# Remarks:
# No longer installing whisker menu as XFCE now has similar app 'xfce4-appfinder'


echo "$PROGNAME: COMPLETE"
exit
