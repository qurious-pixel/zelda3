#/bin/bash

# Apple App Bundle
APPNAME=zelda3
APPBUNDLE=${APPNAME}.app
APPBUNDLECONTENTS=${APPBUNDLE}/Contents
APPBUNDLEEXE=${APPBUNDLECONTENTS}/MacOS
APPBUNDLERESOURCES=${APPBUNDLECONTENTS}/Resources
APPBUNDLEICON=${APPBUNDLECONTENTS}/Resources

rm -rf platform/macosx/${APPNAME}.iconset
mkdir platform/macosx/${APPNAME}.iconset
sips -z 16 16     platform/macosx/${APPNAME}Icon.png --out platform/macosx/${APPNAME}.iconset/icon_16x16.png
sips -z 32 32     platform/macosx/${APPNAME}Icon.png --out platform/macosx/${APPNAME}.iconset/icon_16x16@2x.png
sips -z 32 32     platform/macosx/${APPNAME}Icon.png --out platform/macosx/${APPNAME}.iconset/icon_32x32.png
sips -z 64 64     platform/macosx/${APPNAME}Icon.png --out platform/macosx/${APPNAME}.iconset/icon_32x32@2x.png
sips -z 128 128   platform/macosx/${APPNAME}Icon.png --out platform/macosx/${APPNAME}.iconset/icon_128x128.png
sips -z 256 256   platform/macosx/${APPNAME}Icon.png --out platform/macosx/${APPNAME}.iconset/icon_128x128@2x.png
sips -z 256 256   platform/macosx/${APPNAME}Icon.png --out platform/macosx/${APPNAME}.iconset/icon_256x256.png
sips -z 512 512   platform/macosx/${APPNAME}Icon.png --out platform/macosx/${APPNAME}.iconset/icon_256x256@2x.png
sips -z 512 512   platform/macosx/${APPNAME}Icon.png --out platform/macosx/${APPNAME}.iconset/icon_512x512.png
cp platform/macosx/${APPNAME}Icon.png platform/macosx/${APPNAME}.iconset/icon_512x512@2x.png
iconutil -c icns -o platform/macosx/${APPNAME}.icns platform/macosx/${APPNAME}.iconset
rm -r platform/macosx/${APPNAME}.iconset


rm -rf ${APPBUNDLE}
mkdir ${APPBUNDLE}
mkdir ${APPBUNDLE}/Contents
mkdir ${APPBUNDLE}/Contents/MacOS
mkdir ${APPBUNDLE}/Contents/Resources
cp platform/macosx/Info.plist ${APPBUNDLECONTENTS}/
cp platform/macosx/${APPNAME}.icns ${APPBUNDLEICON}/
cp ${APPNAME} ${APPBUNDLEEXE}/zelda3
otool -l ${TARGET} | grep -A 2 LC_RPATH  | tail -n 1 | awk '{print $2}' | dylibbundler -od -b -x  ${APPBUNDLEEXE}/zelda3 -d ${APPBUNDLECONTENTS}/libs
