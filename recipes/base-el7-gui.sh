#!/usr/bin/env bash

PROGNAME=base-el7-gui.sh

# #############################################################################
# Early checks

if ! egrep -i -q -r '(cent ?os|oracle|red ?hat).* 7' /etc/*release ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: This is not an Enterprise Linux 7 distribution." 1>&2
  exit
fi

# #############################################################################
# Globals

# System installers
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"
export INSTPROG="$RPMPROG"

# #############################################################################
# Helpers

_install_packages () {
  for package in "$@" ; do
    echo "Installing '$package'..."
    if ! sudo $INSTPROG install -y "$package" >/tmp/pkg-install-${package}.log 2>&1 ; then
      echo "${PROGNAME:+$PROGNAME: }WARN: There was an error installing package '$package' - see '/tmp/pkg-install-${package}.log'." 1>&2
    fi
  done
}

# #############################################################################
# Main

echo "################################################################################"
echo "Enterprise Linux 7 GUI graphical desktop environment base"
echo "################################################################################"

# Fonts
_install_packages dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts gnu-free-mono-fonts gnu-free-sans-fonts gnu-free-serif-fonts google-crosextra-caladea-fonts google-crosextra-carlito-fonts liberation-mono-fonts liberation-sans-fonts liberation-serif-fonts open-sans-fonts overpass-fonts ucs-miscfixed-fonts

# GNOME
_install_packages NetworkManager-libreswan-gnome PackageKit-command-not-found PackageKit-gtk3-module avahi caribou caribou-gtk2-module caribou-gtk3-module control-center evince file-roller file-roller-nautilus firstboot gdm gnome-boxes gnome-classic-session gnome-clocks gnome-color-manager gnome-font-viewer gnome-getting-started-docs gnome-icon-theme-extras gnome-icon-theme-symbolic gnome-initial-setup gnome-packagekit gnome-packagekit-updater gnome-screenshot gnome-session gnome-session-xsession gnome-settings-daemon gnome-shell gnome-software gnome-system-log gnome-system-monitor gnome-themes-standard gnome-tweak-tool gnome-user-docs gvfs-afp gvfs-goa libcanberra-gtk2 libcanberra-gtk3 libproxy-mozjs librsvg2 libsane-hpaio metacity mousetweaks rhn-setup-gnome sane-backends-drivers-scanners xdg-desktop-portal-gtk ibus-chewing ibus-hangul ibus-kkc ibus-libpinyin ibus-m17n ibus-rawcode ibus-sayura ibus-table ibus-table-chinese m17n-contrib m17n-db

# MATE
_install_packages NetworkManager-l2tp NetworkManager-openconnect NetworkManager-openvpn NetworkManager-pptp NetworkManager-vpnc NetworkManager-vpnc-gnome abrt-desktop abrt-java-connector dconf-editor firewall-config gparted gtk2-engines gucharmap gvfs gvfs-afc gvfs-archive gvfs-fuse gvfs-gphoto2 gvfs-mtp gvfs-smb libmatekbd lightdm lightdm-gtk marco mate-applets mate-backgrounds mate-icon-theme mate-media mate-menus mate-menus-preferences-category-menu mate-notification-daemon mate-panel mate-polkit mate-power-manager mate-search-tool mate-session-manager mate-settings-daemon mate-system-log mate-themes mozo network-manager-applet seahorse setroubleshoot simple-scan system-config-date system-config-language system-config-users xdg-user-dirs-gtk

# Etc
_install_packages gtk2-immodule-xim gtk3-immodule-xim ibus-gtk2 ibus-gtk3 imsettings-gsettings rdma-core

# _install_packages gstreamer1-plugins-bad-free gstreamer1-plugins-good gtk2-immodule-xim gtk3-immodule-xim ibus-gtk2 ibus-gtk3 imsettings-gsettings rdma-core
