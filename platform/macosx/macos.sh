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
cp platform/macosx/${APPNAME}.icns .

# Python Bundle
cp tables/restool.py .
python3 -m venv venv
. venv/bin/activate
pip install --upgrade pip
pip install py2app PILLOW pyyaml
python platform/macosx/setup.py py2app 

mv dist/restool.app dist/${APPBUNDLE}
rm ${APPNAME}.icns
mkdir dist/${APPBUNDLERESOURCES}/assets
cp -r {tables,other} dist/${APPBUNDLERESOURCES}/assets/
mv dist/${APPBUNDLERESOURCES}/lib/python3*/{PIL,yaml} dist/${APPBUNDLERESOURCES}/assets/tables
cp zelda3.ini dist/${APPBUNDLERESOURCES}/
sed -i '' 's/restool/zelda3/g' dist/${APPBUNDLECONTENTS}/Info.plist
cp platform/macosx/${APPNAME}.icns dist/${APPBUNDLEICON}/
cp ${APPNAME} dist/${APPBUNDLEEXE}/${APPNAME}
cp platform/macosx/${APPNAME}.sh dist/${APPBUNDLEEXE}/${APPNAME}.sh
chmod a+x dist/${APPBUNDLEEXE}/*

hdiutil create dist/tmp.dmg -ov -volname "Zelda3" -fs HFS+ -srcfolder "dist/${APPBUNDLE}"
hdiutil convert dist/tmp.dmg -format UDZO -o dist/${APPNAME}.dmg
rm dist/tmp.dmg

mkdir uploads
cp dist/${APPNAME}.dmg uploads
#cp -r dist/${APPBUNDLE}.dmg uploads
