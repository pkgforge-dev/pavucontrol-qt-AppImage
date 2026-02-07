#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q pavucontrol-qt | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export APPNAME=pavucontrol-qt
export ICON="https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/64x64/apps/yast-sound.svg"
export DESKTOP=/usr/share/applications/pavucontrol-qt.desktop
export DEPLOY_OPENGL=0
export ANYLINUX_LIB=1

# Deploy dependencies
quick-sharun /usr/bin/pavucontrol-qt

# Turn AppDir into AppImage
quick-sharun --make-appimage
