#!/bin/bash

SNAME="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)"
export RESPATH="${SNAME%%/MacOS*}/Resources"
export ZELDA_HOME="$HOME/Library/Application Support/io.github.snesrev.Zelda3"
export PYTHONHOME="$RESPATH"

if [ ! -e "$ZELDA_HOME" ]; then
    mkdir "$ZELDA_HOME"
fi

if [ ! -e "$ZELDA_HOME"/zelda3_assets.dat ]; then
DROPROM=`osascript <<-EOF
	set romFile to choose file of type {"sfc","smc"} with prompt "Please select your ROM:"
	return POSIX path of romFile
EOF`

ROMNAME="$(basename $DROPROM)"
ASSETDIR="$(mktemp -d /tmp/assets-XXXXX)"
export ASSETDIR
cp -r "$RESPATH/assets/" "$ASSETDIR/"
cp "$DROPROM" "$ASSETDIR"/tables
cd "$ASSETDIR"/tables/

if [[ -z $DROPROM ]]; then
	exit 1
fi

OSA=`osascript <<-EOF
display notification "Generating OTR ..."
EOF`

"$SNAME"/python restool.py --extract-from-rom -r "$ROMNAME"

OSA=`osascript <<-EOF
display notification "Asset extraction complete"
EOF`

cp "$ASSETDIR"/tables/zelda3_assets.dat "$ZELDA_HOME"/
rm -r "$ASSETDIR"
fi

if [ ! -e "$ZELDA_HOME"/zelda3.ini ]; then
    cp "$RESPATH"/zelda3.ini "$ZELDA_HOME"
fi

cd --
arch -x86_64 "$SNAME"/zelda3 --config "$ZELDA_HOME/zelda3.ini"
