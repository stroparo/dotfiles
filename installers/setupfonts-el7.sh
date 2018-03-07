#!/usr/bin/env bash

set -e

# #############################################################################
# Globals

PROGNAME="setupfonts-el7.sh"

# #############################################################################
# Prep

if ! egrep -i -q '(centos|oracle|red *hat).* 7' /etc/*release* ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: Only EL7 is supported." 1>&2
  exit
fi

# #############################################################################
# Main

# set up nux-dextop repo to install font packages. skip if this repo had already set up.
# can be done by either rpm or yum app.
# sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
sudo yum localinstall http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm

# disable nux-dextop by default and only enable it as needed as part of running yum.
# skip this step to make all packages in nux-dextop available at all time.
sudo sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/nux-dextop.repo

# install the magical packages that does font look nice.
sudo yum --enablerepo=nux-dextop install fontconfig-infinality cairo libXft freetype-infinality

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

# done.
echo
echo 'log out and log back in for clear looking fonts.'
