#!/usr/bin/env bash

PROGNAME="setupgcp.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: GCP - Google Cloud Platform - client setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

URL=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-182.0.0-linux-x86_64.tar.gz
TAR=gcsdk.tar.gz
SHA256=3cae8a7b021f3c9eaab6c0b59a1301eb7cda3a422e645b3b0c6ccfe89b1e0332

WORKDIR=/tmp

# #############################################################################
# Prep

echo "WORKDIR='$WORKDIR'"

# Pre-req Python 2:
if ! [[ $(python -V 2>&1) =~ 2[.] ]]; then
  echo "$PROGNAME: FATAL: python command must be Python 2" 1>&2
  exit 1
fi

# Pre-req sha256deep:
if ! which sha256deep; then
  if egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
    sudo apt update && sudo apt install -y md5deep
    sudo ln -s -v /usr/bin/hashdeep /usr/local/bin/md5deep
    sudo ln -s -v /usr/bin/hashdeep /usr/local/bin/sha1deep
    sudo ln -s -v /usr/bin/hashdeep /usr/local/bin/sha256deep
  elif egrep -i -q -r 'centos|fedora|oracle|red *hat' /etc/*release ; then
    sudo yum install -y md5deep
  fi
fi
if ! which sha256deep; then exit 1; fi

cd "$WORKDIR"

# Download:
if ! curl -Lf "$URL" > "$TAR" ; then
  echo "$PROGNAME: FATAL: Could not write package from '$URL'..." 1>&2
  echo "$PROGNAME:    ... to '$TAR'" 1>&2
  exit 1
fi

# Checksum:
cat > "$TAR".sha256 <<EOF
${SHA256} *${TAR}
EOF
if [ -z "$(sha256deep -m "$TAR".sha256 "$TAR")" ]; then
  echo "$PROGNAME: FATAL: Checksum failed (${TAR}.sha256)" 1>&2
fi

if ! tar -xzvf "$TAR" ; then
  echo "$PROGNAME: FATAL: There was an error decompressing '$TAR'." 1>&2
  exit 1
fi

# #############################################################################
# Main

./google-cloud-sdk/install.sh
echo "$PROGNAME: COMPLETE: GCP client setup"
exit
