#!/bin/sh

set -eux

EXTRA_PACKAGES="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/get-debloated-pkgs.sh"

echo "Installing build dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	base-devel            \
	curl                  \
	git                   \
	hicolor-icon-theme    \
	libxtst               \
	pavucontrol-qt        \
	pipewire-audio        \
	pulseaudio            \
	pulseaudio-alsa       \
	qt6ct                 \
	qt6-wayland           \
	wget                  \
	xorg-server-xvfb      \
	zsync

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$EXTRA_PACKAGES" -O ./get-debloated-pkgs.sh
chmod +x ./get-debloated-pkgs.sh
./get-debloated-pkgs.sh qt6-base-mini libxml2-mini opus-mini
