#!/usr/bin/env bash

PROG=provision-minimal.sh

_print_header () {
  echo "################################################################################"
  echo "$@"
}

_print_header "Minimal provisioning"

_print_header "Basic Tools"
bash "${DOTFILES_DIR:-.}"/entry.sh -b setupds sshkeygen sshmodes
