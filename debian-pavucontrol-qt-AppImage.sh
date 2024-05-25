#!/bin/sh

# TURNING THE NATIVE DEBIAN PACKAGE INTO AN APPIMAGE BECAUSE I CAN'T GET THIS TO COMPILE ON DEBIAN 20.04 KEK.

set -u
APP=pavucontrol-qt
APPDIR="$APP.AppDir"
REPO="http://ftp.us.debian.org/debian/pool/main/p/pavucontrol-qt/pavucontrol-qt_1.2.0-1_amd64.deb"
EXEC="$APP"
ICON="https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/Papirus/64x64/apps/yast-sound.svg"

LINUXDEPLOY="https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-static-x86_64.AppImage"
APPIMAGETOOL=$(wget -q https://api.github.com/repos/probonopd/go-appimage/releases -O - | sed 's/"/ /g; s/ /\n/g' | grep -o 'https.*continuous.*tool.*86_64.*mage$')

# CREATE DIRECTORIES
[ -n "$APP" ] && mkdir -p ./"$APP/$APPDIR"/tmp && cd ./"$APP/$APPDIR"/tmp || exit 1

# DOWNLOAD DEBIAN PACKAGE
CURRENTDIR="$(dirname "$(readlink -f "$0")")" # DO NOT MOVE THIS
wget $REPO && ar vx ./"$APP"* && tar fx ./data.tar* && mv ./usr .. && cd .. && rm -rf ./tmp || exit 1

# AppRun
cat >> ./AppRun << 'EOF'
#!/bin/sh
export LD_LIBRARY_PATH="/lib"
CURRENTDIR="$(dirname "$(readlink -f "$0")")"
"$CURRENTDIR/usr/bin/DUMMY" "$@"
EOF
sed -i "s|DUMMY|$EXEC|g" ./AppRun
chmod a+x ./AppRun
APPVERSION=$(./AppRun --version | awk 'FNR == 1 {print $2}')

# Desktop & Icon
cp ./usr/share/applications/*.desktop ./ && wget "$ICON" -O ./multimedia-volume-control.svg || exit 1
mkdir -p ./usr/share/icons/hicolor/scalable/apps && cp ./multimedia-volume-control.svg ./usr/share/icons/hicolor/scalable/apps

# MAKE APPIMAGE USING FUSE3 COMPATIBLE APPIMAGETOOL
cd .. && wget "$LINUXDEPLOY" -O linuxdeploy && wget -q "$APPIMAGETOOL" -O ./appimagetool && chmod a+x ./linuxdeploy ./appimagetool \
&& DEPLOY_QT=1 ./linuxdeploy --appdir "$APPDIR" --executable "$APPDIR"/usr/bin/"$EXEC" && VERSION="$APPVERSION" ./appimagetool -s ./"$APPDIR" || exit 1
[ -n "$APP" ] && mv ./*.AppImage .. && cd .. && rm -rf ./"$APP" && echo "All Done!" || exit 1
