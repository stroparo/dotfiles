#!/usr/bin/env bash

if ! egrep -i -q '(centos|oracle|red *hat).* 7' /etc/*release ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: Not in an Enterprise Linux 7 distribution." 1>&2
fi

echo "==> Enterprise Linux 7 Basic Graphical User Interface..."

# Fonts
sudo yum install -y dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts gnu-free-mono-fonts gnu-free-sans-fonts gnu-free-serif-fonts google-crosextra-caladea-fonts google-crosextra-carlito-fonts liberation-mono-fonts liberation-sans-fonts liberation-serif-fonts open-sans-fonts overpass-fonts ucs-miscfixed-fonts

# GNOME
sudo yum install -y NetworkManager-libreswan-gnome PackageKit-command-not-found PackageKit-gtk3-module avahi caribou caribou-gtk2-module caribou-gtk3-module control-center evince file-roller file-roller-nautilus firstboot gdm gnome-boxes gnome-classic-session gnome-clocks gnome-color-manager gnome-font-viewer gnome-getting-started-docs gnome-icon-theme-extras gnome-icon-theme-symbolic gnome-initial-setup gnome-packagekit gnome-packagekit-updater gnome-screenshot gnome-session gnome-session-xsession gnome-settings-daemon gnome-shell gnome-software gnome-system-log gnome-system-monitor gnome-themes-standard gnome-tweak-tool gnome-user-docs gvfs-afp gvfs-goa libcanberra-gtk2 libcanberra-gtk3 libproxy-mozjs librsvg2 libsane-hpaio metacity mousetweaks rhn-setup-gnome sane-backends-drivers-scanners xdg-desktop-portal-gtk ibus-chewing ibus-hangul ibus-kkc ibus-libpinyin ibus-m17n ibus-rawcode ibus-sayura ibus-table ibus-table-chinese m17n-contrib m17n-db

# MATE
sudo yum install -y NetworkManager-l2tp NetworkManager-openconnect NetworkManager-openvpn NetworkManager-pptp NetworkManager-vpnc NetworkManager-vpnc-gnome abrt-desktop abrt-java-connector dconf-editor firewall-config gparted gtk2-engines gucharmap gvfs gvfs-afc gvfs-archive gvfs-fuse gvfs-gphoto2 gvfs-mtp gvfs-smb libmatekbd lightdm lightdm-gtk marco mate-applets mate-backgrounds mate-icon-theme mate-media mate-menus mate-menus-preferences-category-menu mate-notification-daemon mate-panel mate-polkit mate-power-manager mate-search-tool mate-session-manager mate-settings-daemon mate-system-log mate-themes mozo network-manager-applet seahorse setroubleshoot simple-scan system-config-date system-config-language system-config-users xdg-user-dirs-gtk

# Etc
sudo yum install -y gtk2-immodule-xim gtk3-immodule-xim ibus-gtk2 ibus-gtk3 imsettings-gsettings rdma-core

# sudo yum install -y gstreamer1-plugins-bad-free gstreamer1-plugins-good gtk2-immodule-xim gtk3-immodule-xim ibus-gtk2 ibus-gtk3 imsettings-gsettings rdma-core
