#!/usr/bin/env bash

set -e
PROGNAME="base-el7-gui-fonts.sh"

if ! egrep -i -q -r '(cent *os|fedora|oracle|red *hat).*7' /etc/*release ; then echo "${PROGNAME}: SKIP: EL7 supported only" ; exit ; fi

echo "$PROGNAME: INFO: EL7 GUI base fonts setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Main

if egrep -i -q -r 'fedora' /etc/*release ; then

  sudo su -c 'dnf install -y http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'
  sudo dnf install -y freetype-freeworld

  cat <<EOF | sudo tee /etc/fonts/local.conf
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
    <match target="font">
        <edit name="antialias" mode="assign">
            <bool>true</bool>
        </edit>
        <edit name="autohint" mode="assign">
            <bool>false</bool>
        </edit>
        <edit name="embeddedbitmap" mode="assign">
            <bool>false</bool>
        </edit>
        <edit name="hinting" mode="assign">
            <bool>true</bool>
        </edit>
        <edit name="hintstyle" mode="assign">
            <const>hintslight</const>
        </edit>
        <edit name="lcdfilter" mode="assign">
            <const>lcdlight</const>
        </edit>
        <edit name="rgba" mode="assign">
            <const>rgb</const>
        </edit>
    </match>
</fontconfig>
EOF


elif egrep -i -q -r 'cent *os|oracle|red *hat' /etc/*release ; then

  # set up nux-dextop repo to install font packages. skip if this repo had already set up.
  # can be done by either rpm or yum app.
  # sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
  sudo yum localinstall -y http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm

  # disable nux-dextop by default and only enable it as needed as part of running yum.
  # skip this step to make all packages in nux-dextop available at all time.
  sudo sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/nux-dextop.repo

  # install the magical packages that does font look nice.
  sudo yum --enablerepo=nux-dextop install -y fontconfig-infinality cairo libXft freetype-infinality

  # a good .fonts.conf file. not sure if necessary.
  cat <<EOF > ~/.fonts.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
 <match target="font">
  <edit mode="assign" name="hinting" >
   <bool>true</bool>
  </edit>
 </match>
 <match target="font" >
  <edit mode="assign" name="autohint" >
   <bool>true</bool>
  </edit>
 </match>
 <match target="font">
  <edit mode="assign" name="hintstyle" >
  <const>hintslight</const>
  </edit>
 </match>
 <match target="font">
  <edit mode="assign" name="rgba" >
   <const>rgb</const>
  </edit>
 </match>
 <match target="font">
  <edit mode="assign" name="antialias" >
   <bool>true</bool>
  </edit>
 </match>
 <match target="font">
   <edit mode="assign" name="lcdfilter">
   <const>lcddefault</const>
   </edit>
 </match>
</fontconfig>
EOF

fi

# #############################################################################

echo '$PROGNAME: INFO: Log out and log back in for clear looking fonts.'

echo "$PROGNAME: COMPLETE"
exit
