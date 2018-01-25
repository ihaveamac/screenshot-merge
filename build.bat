@echo off
:: version format help: https://www.3dbrew.org/wiki/Titles#Versions
set TITLEVER=1088
set VERSION=1.4
set HOMEBREWNAME=screenshot merge
set HOMEBREWFILENAME=screenshot-merge
set CIADESCRIPTION=Merge top and botton screenshots into single images
set PUBLISHER=ihaveamac

rd /s /q output
rd /s /q tmp-output
mkdir output
mkdir tmp-output
bannertool makesmdh -s %HOMEBREWNAME% -l "%HOMEBREWNAME%" -p "%PUBLISHER%" -i resources/icon.png -f visible,nosavebackups -o tmp-output/icon.bin
bannertool makebanner -i resources/banner.png -ca resources/hbchannel.cwav -o tmp-output/banner.bin
smdhtool --create "%HOMEBREWNAME% %VERSION%" "%CIADESCRIPTION%" "%PUBLISHER%" resources/icon.png "tmp-output/%HOMEBREWFILENAME%.smdh"
3dstool -cvtf romfs tmp-output/romfs.bin --romfs-dir romfs/

if "%1"=="release" (
    echo "release"
    makerom -f cia -o "output/%HOMEBREWFILENAME%-v%VERSION%.cia" -elf resources/lpp-3ds-unsafe.elf -rsf resources/cia_workaround.rsf -icon tmp-output/icon.bin -banner tmp-output/banner.bin -exefslogo -target t -romfs tmp-output/romfs.bin -ver $TITLEVER
    3dsxtool resources/lpp-3ds-unsafe.elf "output/%HOMEBREWFILENAME%.3dsx" --smdh="tmp-output/%HOMEBREWFILENAME%.smdh" --romfs=romfs/
) else (
    echo "testing"
    makerom -f cia -o "output/%HOMEBREWFILENAME%-v%VERSION%.cia" -elf resources/lpp-3ds-normal.elf -rsf resources/cia_workaround.rsf -icon tmp-output/icon.bin -banner tmp-output/banner.bin -exefslogo -target t -romfs tmp-output/romfs.bin -ver $TITLEVER
    3dsxtool resources/lpp-3ds-unsafe.elf "output/%HOMEBREWFILENAME%.3dsx" --smdh="tmp-output/%HOMEBREWFILENAME%.smdh" --romfs=romfs/
)

exit /b
