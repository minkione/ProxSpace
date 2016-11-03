#!/bin/bash 
pm3Dir=/pm3
buildDir=/build
uploadDir=/upload
qtDir=/qt
mingwDir=/mingw

cd $pm3Dir
for i in $( ls ); do
    echo Processing: $i
	cd $pm3Dir/$i
	git fetch
	git pull
	hash=$(git rev-parse HEAD)
	date=$(date +%Y%m%d)
	if ! ls $uploadDir/$i/*-$hash.zip 1> /dev/null 2>&1; then
		make clean
		make all
		if [ $? -eq 0 ]; then
			mkdir -p $buildDir/$i/win32/lualibs
			mkdir -p $buildDir/$i/win32/scripts
			mkdir -p $buildDir/$i/win32/platforms
			mkdir -p $buildDir/$i/firmware_win/bootrom
			mkdir -p "$buildDir/$i/firmware_win/JTAG Only"
			mkdir -p $uploadDir/$i
			rm -rf $buildDir/$i/win32/lualibs/*
			rm -rf $buildDir/$i/win32/scripts/*
			cp $qtDir/bin/Qt5Core.dll $buildDir/$i/win32
			cp $qtDir/bin/Qt5Gui.dll $buildDir/$i/win32
			cp $qtDir/bin/Qt5Widgets.dll $buildDir/$i/win32
			cp $qtDir/bin/libstdc++-6.dll $buildDir/$i/win32
			cp $mingwDir/bin/readline5.dll $buildDir/$i/win32
			cp $qtDir/bin/libwinpthread-1.dll $buildDir/$i/win32
			cp $qtDir/bin/libgcc_s_dw2-1.dll $buildDir/$i/win32
			cp $qtDir/plugins/platforms/qwindows.dll $buildDir/$i/win32/platforms
			cp -r $buildDir/common/* $buildDir/$i
			cp $pm3Dir/$i/client/proxmark3.exe $buildDir/$i/win32
			cp $pm3Dir/$i/client/flasher.exe $buildDir/$i/win32
			cp $pm3Dir/$i/client/lualibs/* $buildDir/$i/win32/lualibs
			cp $pm3Dir/$i/client/scripts/* $buildDir/$i/win32/scripts
			cp $pm3Dir/$i/armsrc/obj/fullimage.elf $buildDir/$i/firmware_win
			cp $pm3Dir/$i/armsrc/obj/fullimage.s19 $buildDir/$i/firmware_win
			cp $pm3Dir/$i/bootrom/obj/bootrom.elf $buildDir/$i/firmware_win/bootrom
			cp $pm3Dir/$i/bootrom/obj/bootrom.s19 $buildDir/$i/firmware_win/bootrom
			cp $pm3Dir/$i/recovery/bootrom.bin "$buildDir/$i/firmware_win/JTAG Only"
			cp $pm3Dir/$i/recovery/fullimage.bin "$buildDir/$i/firmware_win/JTAG Only"
			cp $pm3Dir/$i/recovery/proxmark3_recovery.bin "$buildDir/$i/firmware_win/JTAG Only"
			cd $buildDir/$i
			zip -r $uploadDir/$i/$date-$hash.zip ./*
		else
			echo $i failed
		fi
	fi
done
