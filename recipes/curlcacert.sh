#!/usr/bin/env bash

cd
curl -L -o "$HOME/.curl-cacert.pem" 'http://curl.haxx.se/ca/cacert.pem'

if ! grep -q 'CURL_CA_BUNDLE=' ~/.profile ; then
  cat >> ~/.profile <<EOF
export CURL_CA_BUNDLE="$HOME/.curl-cacert.pem"
EOF
fi
