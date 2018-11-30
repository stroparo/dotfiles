#!/usr/bin/env bash

echo
echo "################################################################################"
echo "Configure pip; \$0='$0'; \$PWD='$PWD'"

mkdir -p "$HOME/.config/pip" 2>/dev/null
cp -v "$HOME/.config/pip/pip.conf" "$HOME/.config/pip/pip.conf.$(date '+%Y%m%d-%OH%OM%OS')"
cat > "$HOME/.config/pip/pip.conf" <<EOF
[list]
format=columns
EOF
