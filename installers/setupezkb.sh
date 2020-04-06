PROGNAME="setupezkb.sh"

if ! (uname -a | grep -i -q linux) ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: Linux routine only." 1>&2
  exit
fi

# #############################################################################
# Dependencies

sudo apt update && sudo apt-get install -y gtk+3.0 webkit2gtk-4.0 libusb-dev
if [ $? -ne 0 ] ; then
  exit 1
fi

# #############################################################################
# Install
# Source: https://github.com/zsa/wally/wiki/Linux-install

URL="https://configure.ergodox-ez.com/wally/linux"
mkdir -p "$HOME/opt/wally"
if ! curl -Lf "$URL" > "$HOME/opt/wally/wally" ; then
  echo "$PROGNAME: FATAL: Could not write package from '$URL'..." 1>&2
  echo "$PROGNAME:    ... to '$HOME/opt/wally/wally'" 1>&2
  exit 1
fi
chmod -R -v '700' "$HOME/opt/wally"

# #############################################################################
# Configure

sudo cat > /tmp/50-wally.rules <<EOF
# Teensy rules for the Ergodox EZ Original / Shine / Glow
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

# STM32 rules for the Planck EZ Standard / Glow
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \
    MODE:="0666", \
    SYMLINK+="stm32_dfu"
EOF

sudo cp -f -v /tmp/50-wally.rules /etc/udev/rules.d/

# #############################################################################
# Configure live training
# Source: https://github.com/zsa/wally/wiki/Live-training-on-Linux

sudo cat > /tmp/50-oryx.rules <<EOF
# Rule for the Ergodox EZ Original / Shine / Glow
SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
# Rule for the Planck EZ Standard / Glow
SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"
EOF

sudo cp -f -v /tmp/50-oryx.rules /etc/udev/rules.d/

sudo groupadd plugdev
echo sudo usermod -aG plugdev "$USER"
sudo usermod -aG plugdev "$USER"
