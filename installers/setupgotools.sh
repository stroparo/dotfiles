#!/usr/bin/env bash

PROGNAME="setupgotools.sh"

if ! which go >/dev/null 2>&1 ; then echo "$PROGNAME: SKIP: No go available." ; exit ; fi

echo "$PROGNAME: INFO: Go tools setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

go get -u "mvdan.cc/sh/cmd/shfmt"

echo "$PROGNAME: COMPLETE: Go tools setup"
exit
