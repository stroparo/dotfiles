#!/usr/bin/env bash

echo
echo "################################################################################"
echo "EL7 Enterprise Linux GUI setup..."

# Fonts
sudo yum install -y cjkuni-uming-fonts dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts gnu-free-mono-fonts gnu-free-sans-fonts gnu-free-serif-fonts google-crosextra-caladea-fonts google-crosextra-carlito-fonts jomolhari-fonts khmeros-base-fonts liberation-mono-fonts liberation-sans-fonts liberation-serif-fonts lklug-fonts madan-fonts nhn-nanum-gothic-fonts open-sans-fonts overpass-fonts paktype-naskh-basic-fonts paratype-pt-sans-fonts ucs-miscfixed-fonts

# GNOME
sudo yum install -y NetworkManager-libreswan-gnome PackageKit-command-not-found PackageKit-gtk3-module avahi baobab caribou caribou-gtk2-module caribou-gtk3-module cheese compat-cheese314 control-center evince file-roller file-roller-nautilus firstboot gdm gnome-bluetooth gnome-boxes gnome-classic-session gnome-clocks gnome-color-manager gnome-contacts gnome-dictionary gnome-disk-utility gnome-font-viewer gnome-getting-started-docs gnome-icon-theme-extras gnome-icon-theme-symbolic gnome-initial-setup gnome-packagekit gnome-packagekit-updater gnome-screenshot gnome-session gnome-session-xsession gnome-settings-daemon gnome-shell gnome-software gnome-system-log gnome-system-monitor gnome-terminal gnome-terminal-nautilus gnome-themes-standard gnome-tweak-tool gnome-user-docs gnome-weather gvfs-afp gvfs-goa libcanberra-gtk2 libcanberra-gtk3 libproxy-mozjs librsvg2 libsane-hpaio metacity mousetweaks orca rhn-setup-gnome sane-backends-drivers-scanners sushi vinagre vino xdg-desktop-portal-gtk ibus-chewing ibus-hangul ibus-kkc ibus-libpinyin ibus-m17n ibus-rawcode ibus-sayura ibus-table ibus-table-chinese m17n-contrib m17n-db icedtea-web

# MATE
sudo yum install -y NetworkManager-l2tp NetworkManager-openconnect NetworkManager-openvpn NetworkManager-pptp NetworkManager-vpnc NetworkManager-vpnc-gnome abrt-desktop abrt-java-connector atril atril-caja brasero caja caja-image-converter caja-open-terminal caja-sendto dconf-editor engrampa eom filezilla firefox firewall-config gnote gparted gtk2-engines gucharmap gvfs gvfs-afc gvfs-archive gvfs-fuse gvfs-gphoto2 gvfs-mtp gvfs-smb libmatekbd libmateweather lightdm lightdm-gtk marco mate-applets mate-backgrounds mate-calc mate-control-center mate-desktop mate-dictionary mate-disk-usage-analyzer mate-icon-theme mate-media mate-menus mate-menus-preferences-category-menu mate-notification-daemon mate-panel mate-polkit mate-power-manager mate-screensaver mate-screenshot mate-search-tool mate-session-manager mate-settings-daemon mate-system-log mate-system-monitor mate-terminal mate-themes mozo network-manager-applet pluma rhythmbox seahorse setroubleshoot simple-scan system-config-date system-config-language system-config-printer system-config-users totem transmission-gtk xchat xdg-user-dirs-gtk yumex

# Etc
sudo yum install -y gstreamer1-plugins-bad-free gstreamer1-plugins-good gtk2-immodule-xim gtk3-immodule-xim ibus-gtk2 ibus-gtk3 imsettings-gsettings rdma-core

# #############################################################################
# Finish

echo "FINISHED EL7 Enterprise Linux GUI setup setup"
echo
