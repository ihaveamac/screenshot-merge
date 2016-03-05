#!/usr/bin/env bash
TITLEVER=1056
VERSION="1.2"
rm -r output/
rm -r tmp-output/
mkdir output/
mkdir tmp-output/
bannertool makesmdh -s "screenshot merge" -l "screenshot merge" -p "ihaveamac" -i resources/icon.png -f visible,nosavebackups -o tmp-output/icon.bin
bannertool makebanner -i resources/banner.png -ca resources/hbchannel.cwav -o tmp-output/banner.bin
smdhtool --create "screenshot merge $VERSION" "Merge top and botton screenshots into single images" "ihaveamac" resources/icon.png output/screenshot-merge.smdh
3dstool -cvtf romfs tmp-output/romfs.bin --romfs-dir romfs/
if [[ "$1" == "release" ]]; then
    echo "release"
    makerom -f cia -o output/screenshot-merge${VERSION}.cia -elf resources/lpp-3ds-unsafe.elf -rsf resources/cia_workaround.rsf -icon tmp-output/icon.bin -banner tmp-output/banner.bin -exefslogo -target t -romfs tmp-output/romfs.bin -ver $TITLEVER
    3dsxtool resources/lpp-3ds-unsafe.elf output/screenshot-merge.3dsx --smdh=output/screenshot-merge.smdh --romfs=romfs/
    mkdir release/
    rm release/screenshot-merge${VERSION}.zip
    cd output/
    zip ../release/screenshot-merge${VERSION}.zip screenshot-merge.3dsx screenshot-merge.smdh
    cp screenshot-merge${VERSION}.cia ../release
else
    echo "testing"
    makerom -f cia -o output/screenshot-merge${VERSION}.cia -elf resources/lpp-3ds-normal.elf -rsf resources/cia_workaround.rsf -icon tmp-output/icon.bin -banner tmp-output/banner.bin -exefslogo -target t -romfs tmp-output/romfs.bin -ver $TITLEVER
    3dsxtool resources/lpp-3ds-normal.elf output/screenshot-merge.3dsx --smdh=output/screenshot-merge.smdh --romfs=romfs/
fi