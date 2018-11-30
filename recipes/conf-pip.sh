#!/usr/bin/env bash

mkdir -p "$HOME/.config/pip" 2>/dev/null
cp -v "$HOME/.config/pip/pip.conf" "$HOME/.config/pip/pip.conf.$(date '+%Y%m%d-%OH%OM%OS')"
cat > "$HOME/.config/pip/pip.conf" <<EOF
[list]
format=columns
EOF
