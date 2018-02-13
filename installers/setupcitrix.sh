#!/usr/bin/env bash

# Daily Shells Extras extensions
# More instructions and licensing at:
# https://github.com/stroparo/ds-extras

# Sources:
# https://help.ubuntu.com/community/CitrixICAClientHowTo

# Remark SSL error 47, download Linux Receiver 13.4, source:
# https://discussions.citrix.com/topic/385459-ssl-error-with-135-works-with-134/

# #############################################################################
# Globals

PROGNAME=setupcitrix

CITRIX_VERSION=${1:-13.4}
CITRIX_MAJOR_VERSION=${CITRIX_VERSION%%.*}
CITRIX_MINOR_VERSION=${CITRIX_VERSION##*.}
CITRIX_DOWNLOAD_URL="https://www.citrix.com.br/downloads/citrix-receiver/\
legacy-receiver-for-linux/receiver-for-linux-latest-\
${CITRIX_MAJOR_VERSION}-${CITRIX_MINOR_VERSION}.html"

# #############################################################################

echo ${BASH_VERSION:+-e} '\n\n==> Installing citrix...' 1>&2

# #############################################################################
# Checks

# Check for idempotency
if [ -e /opt/Citrix/ICAClient/selfservice ] ; then
  echo "$PROGNAME: SKIP: Already installed." 1>&2
  exit
fi

# #############################################################################
# Main

rm -r -f -v "$HOME"/.ICAClient
sudo rm -f -r -v /opt/setupcitrix/*
sudo mkdir /opt/setupcitrix
sudo chmod 777 /opt/setupcitrix
cd /opt/setupcitrix

while ! ls -1 "$HOME"/Downloads/*linuxx64* >/dev/null 2>&1 ; do
  echo "$PROGNAME: INFO: Opening Firefox to download citrix (linuxx64...tar.gz)..."
  echo "$PROGNAME: INFO: Place it in the "$HOME"/Downloads directory" 1>&2
  firefox "$CITRIX_DOWNLOAD_URL"
  sleep 10
done

if sudo tar xzvf $(ls -1 "$HOME"/Downloads/*linuxx64* | tail -n 1) ; then
  echo "$PROGNAME: FATAL: There was some error extracting the tarball." 1>&2
fi

sudo /opt/setupcitrix/setupwfc

if egrep -i -q 'ubuntu' /etc/*release* ; then
  # SSL certificates from Firefox
  sudo cp -v \
    /usr/share/ca-certificates/mozilla/* \
    /opt/Citrix/ICAClient/keystore/cacerts/
  sudo c_rehash /opt/Citrix/ICAClient/keystore/cacerts/

  # Firefox fix
  sudo rm -f \
    /usr/lib/mozilla/plugins/npwrapper.npica.so \
    /usr/lib/firefox/plugins/npwrapper.npica.so
  sudo rm -f /usr/lib/mozilla/plugins/npica.so
  sudo ln -s \
    /opt/Citrix/ICAClient/npica.so \
    /usr/lib/mozilla/plugins/npica.so
  sudo ln -s \
    /opt/Citrix/ICAClient/npica.so \
    /usr/lib/firefox-addons/plugins/npica.so

elif egrep -i -q 'centos|fedora|oracle|red *hat' /etc/*release* ; then
  curl -kLSfo /tmp/cacert-roots-symantec.zip \
    http://www.symantec.com/content/en/us/enterprise/verisign/roots/roots.zip
  unzip /tmp/cacert-roots-symantec.zip -d "$HOME"
  sudo cp -a "$HOME"/VeriSign\ Root\ Certificates/Generation\ 5\ \(G5\)\ PCA/VeriSign\ Class\ 3\ Public\ Primary\ Certification\ Authority\ -\ G5.* \
    /opt/Citrix/ICAClient/keystore/cacerts/

  sudo c_rehash /opt/Citrix/ICAClient/keystore/cacerts/
else
  echo "$PROGNAME: SKIP: No ca-cert setup supported for this distro." 1>&2
fi

# Chrome mime type for ICAClient
# xdg-mime default wfica.desktop application/x-ica

# #############################################################################
