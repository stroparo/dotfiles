#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

echo ${BASH_VERSION:+-e} '\n\n==> Installing nerd-fonts...' 1>&2

# #############################################################################
# Globals

BASE_URL="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts"
INSTALL_DIR="$HOME/.local/share/fonts/NerdFonts"

# #############################################################################
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "FATAL: Only Linux is supported." 1>&2
  exit 1
fi

mkdir -p "${INSTALL_DIR}"

if [ ! -d "${INSTALL_DIR}" ] ; then
  echo "FATAL: could not create '${INSTALL_DIR}' directory." 1>&2
  exit 1
fi

# #############################################################################
# Install

cd "$INSTALL_DIR"

while read fontpath ; do

  output_basename=$(echo "${fontpath##*/}" | sed -e 's/%20/ /g')
  if [ -e "$INSTALL_DIR/$output_basename" ] ; then
    echo "==> Skipped '$output_basename' as it is present already..."
  else
    echo "==> Downloading '$output_basename'..."
    curl -LSfs "$BASE_URL/$fontpath" > "$INSTALL_DIR/$output_basename"
  fi
done <<EOF
AnonymousPro/complete/Anonymice%20Nerd%20Font%20Complete.ttf
AnonymousPro/complete/Anonymice%20Nerd%20Font%20Complete%20Mono.ttf
FiraCode/Regular/complete/Fura%20Code%20Regular%20Nerd%20Font%20Complete.otf
FiraCode/Regular/complete/Fura%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.otf
FiraCode/Medium/complete/Fura%20Code%20Medium%20Nerd%20Font%20Complete.otf
FiraCode/Medium/complete/Fura%20Code%20Medium%20Nerd%20Font%20Complete%20Mono.otf
FiraCode/Light/complete/Fura%20Code%20Light%20Nerd%20Font%20Complete.otf
FiraCode/Light/complete/Fura%20Code%20Light%20Nerd%20Font%20Complete%20Mono.otf
FiraCode/Bold/complete/Fura%20Code%20Bold%20Nerd%20Font%20Complete.otf
FiraCode/Bold/complete/Fura%20Code%20Bold%20Nerd%20Font%20Complete%20Mono.otf
Hack/Bold/complete/Knack%20Bold%20Nerd%20Font%20Complete.ttf
Hack/Bold/complete/Knack%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
Hack/BoldItalic/complete/Knack%20Bold%20Italic%20Nerd%20Font%20Complete.ttf
Hack/BoldItalic/complete/Knack%20Bold%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
Hack/Italic/complete/Knack%20Italic%20Nerd%20Font%20Complete.ttf
Hack/Italic/complete/Knack%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
Hack/Regular/complete/Knack%20Regular%20Nerd%20Font%20Complete.ttf
Hack/Regular/complete/Knack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
Meslo/L/complete/Meslo%20LG%20L%20Regular%20Nerd%20Font%20Complete.otf
Meslo/L/complete/Meslo%20LG%20L%20Regular%20Nerd%20Font%20Complete%20Mono.otf
Meslo/M/complete/Meslo%20LG%20M%20Regular%20Nerd%20Font%20Complete.otf
Meslo/M/complete/Meslo%20LG%20M%20Regular%20Nerd%20Font%20Complete%20Mono.otf
Meslo/S/complete/Meslo%20LG%20S%20Regular%20Nerd%20Font%20Complete.otf
Meslo/S/complete/Meslo%20LG%20S%20Regular%20Nerd%20Font%20Complete%20Mono.otf
Meslo/L-DZ/complete/Meslo%20LG%20L%20DZ%20Regular%20Nerd%20Font%20Complete.otf
Meslo/L-DZ/complete/Meslo%20LG%20L%20DZ%20Regular%20Nerd%20Font%20Complete%20Mono.otf
Meslo/M-DZ/complete/Meslo%20LG%20M%20DZ%20Regular%20Nerd%20Font%20Complete.otf
Meslo/M-DZ/complete/Meslo%20LG%20M%20DZ%20Regular%20Nerd%20Font%20Complete%20Mono.otf
Meslo/S-DZ/complete/Meslo%20LG%20S%20DZ%20Regular%20Nerd%20Font%20Complete.otf
Meslo/S-DZ/complete/Meslo%20LG%20S%20DZ%20Regular%20Nerd%20Font%20Complete%20Mono.otf
SourceCodePro/Black/complete/Sauce%20Code%20Pro%20Black%20Nerd%20Font%20Complete.ttf
SourceCodePro/Black/complete/Sauce%20Code%20Pro%20Black%20Nerd%20Font%20Complete%20Mono.ttf
SourceCodePro/Bold/complete/Sauce%20Code%20Pro%20Bold%20Nerd%20Font%20Complete.ttf
SourceCodePro/Bold/complete/Sauce%20Code%20Pro%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
SourceCodePro/Extra-Light/complete/Sauce%20Code%20Pro%20ExtraLight%20Nerd%20Font%20Complete.ttf
SourceCodePro/Extra-Light/complete/Sauce%20Code%20Pro%20ExtraLight%20Nerd%20Font%20Complete%20Mono.ttf
SourceCodePro/Light/complete/Sauce%20Code%20Pro%20Light%20Nerd%20Font%20Complete.ttf
SourceCodePro/Light/complete/Sauce%20Code%20Pro%20Light%20Nerd%20Font%20Complete%20Mono.ttf
SourceCodePro/Medium/complete/Sauce%20Code%20Pro%20Medium%20Nerd%20Font%20Complete.ttf
SourceCodePro/Medium/complete/Sauce%20Code%20Pro%20Medium%20Nerd%20Font%20Complete%20Mono.ttf
SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf
SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf
SourceCodePro/Semibold/complete/Sauce%20Code%20Pro%20Semibold%20Nerd%20Font%20Complete.ttf
SourceCodePro/Semibold/complete/Sauce%20Code%20Pro%20Semibold%20Nerd%20Font%20Complete%20Mono.ttf
UbuntuMono/Bold-Italic/complete/Ubuntu%20Mono%20Bold%20Italic%20Nerd%20Font%20Complete.ttf
UbuntuMono/Bold-Italic/complete/Ubuntu%20Mono%20Bold%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
UbuntuMono/Bold/complete/Ubuntu%20Mono%20Bold%20Nerd%20Font%20Complete.ttf
UbuntuMono/Bold/complete/Ubuntu%20Mono%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
UbuntuMono/Regular-Italic/complete/Ubuntu%20Mono%20Italic%20Nerd%20Font%20Complete.ttf
UbuntuMono/Regular-Italic/complete/Ubuntu%20Mono%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete.ttf
UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf
EOF

fc-cache -f -v
sudo fc-cache -f -v

mkfontscale "$INSTALL_DIR"
mkfontdir "$INSTALL_DIR"

if ls -l "$INSTALL_DIR"/* ; then
  echo "SUCCESS: installed nerd-fonts successfully." 1>&2
  exit 0
else
  exit 1
fi
