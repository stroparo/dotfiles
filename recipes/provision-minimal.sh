#!/usr/bin/env bash

PROG=provision-minimal.sh

_print_header () {
  echo "################################################################################"
  echo "$@"
}

_print_header "Minimal provisioning"
bash "${DOTFILES_DIR:-.}"/entry.sh -b setupds sshkeygen sshmodes
