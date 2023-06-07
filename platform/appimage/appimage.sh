#!/bin/bash

export LINUXDEPLOY="./linuxdeploy-x86_64.AppImage --appimage-extract-and-run"
export CONDA_PACKAGES="pyyaml;pillow"
curl -sSfLO https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
curl -sSfLO https://raw.githubusercontent.com/linuxdeploy/linuxdeploy-plugin-conda/master/linuxdeploy-plugin-conda.sh
chmod +x linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-plugin-conda.sh
$LINUXDEPLOY --appdir=AppDir
cp {zelda3,sm,smw} AppDir/usr/bin/
cp /usr/bin/zenity AppDir/usr/bin/
cp platform/appimage/{AppRun,zelda3.desktop,zelda3.png} AppDir
chmod +x AppDir/AppRun
chmod +x AppDir/usr/bin/zelda3
mkdir -p AppDir/usr/assets
cp -r {tables,other,smb} AppDir/usr/assets/
cp {sm.ini,smw.ini,zelda3.ini} AppDir/usr/assets/
cp /usr/bin/notify-send AppDir/usr/bin/
$LINUXDEPLOY --appdir=AppDir --plugin conda --output appimage
mkdir uploads
mv Zelda*.AppImage uploads/Launcher.AppImage
