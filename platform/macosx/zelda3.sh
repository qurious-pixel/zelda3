#!/bin/bash

SNAME="$(dirname $0)"
export RESPATH="${SNAME%/MacOS*}/Resources"
export ZELDA_HOME="${SNAME%zelda3*}"


while [ ! -e "$ZELDA_HOME"/zelda3_assets.dat ]; do
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

osascript -e 'display notification "Generating assets.dat"'

python restool.py --extract-from-rom -r "$ROMNAME"

cp "$ASSETDIR"/tables/zelda3_assets.dat "$ZELDA_HOME"/

rm -r "$ASSETDIR"
done



arch -x86_64 "$SNAME"/zelda3
