@echo off
if not exist resources ( echo The script is missing some files, unzip it again && pause && exit )
:start
cls
echo Welcome to the fastboot rom flasher script!
echo ---------------------------------------------
echo 1. Install Drivers
echo 2. Clean flash (ERASES DATA)
echo 3. Dirty flash
echo 4. Exit
choice /c 1234 /m "Your Choice: "
IF ERRORLEVEL 4 exit
IF ERRORLEVEL 3 GOTO dirty
IF ERRORLEVEL 2 GOTO clean
IF ERRORLEVEL 1 GOTO drivers
exit
REM the above exit is a failsafe incase the choice bugs out and script continues without choice
:drivers
cls
echo Press any key to install drivers, it is recommend to unplug the device now
pause >nul
echo Installing..
cd resources/driver
pnputil /i /a android_winusb.inf
cd ../..
echo Done. You can plug device now, press any key to go to start
goto start
exit
:clean
resources\platform-tools\fastboot.exe %* getvar product 2>&1 | findstr /r /c:"^product: *sdm845" || echo Wrong device plugged in, re-run script.
resources\platform-tools\fastboot.exe %* getvar product 2>&1 | findstr /r /c:"^product: *sdm845" || pause >nul
echo Are you sure you want to flash this rom? THIS WILL WIPE YOUR DATA
echo Press enter to continue
pause >nul
resources\platform-tools\fastboot.exe --set-active=other || @echo "Changing slots error" && pause >nul
resources\platform-tools\fastboot.exe %* flash boot %~dp0resources\images\boot.img || @echo "Flash boot error" && pause >nul
resources\platform-tools\fastboot.exe %* flash dtbo %~dp0resources\images\dtbo.img || @echo "Flash dtbo error" && pause >nul
resources\platform-tools\fastboot.exe %* flash vbmeta %~dp0resources\images\vbmeta.img || @echo "Flash vbmeta error" && pause >nul
resources\platform-tools\fastboot.exe %* flash system %~dp0resources\images\system.img || @echo "Flash system error" && pause >nul
resources\platform-tools\fastboot.exe %* flash vendor %~dp0resources\images\vendor.img || @echo "Flash vendor error" && pause >nul
resources\platform-tools\fastboot.exe %* flash userdata %~dp0resources\images\userdata.img || @echo "Flash userdata error" && pause >nul
echo Press any key to reboot your device.
pause >nul
resources\platform-tools\fastboot.exe %* reboot || @echo "Reboot error" && pause >nul
goto start
exit
:dirty
resources\platform-tools\fastboot.exe %* getvar product 2>&1 | findstr /r /c:"^product: *sdm845" || echo Wrong device plugged in, re-run script.
resources\platform-tools\fastboot.exe %* getvar product 2>&1 | findstr /r /c:"^product: *sdm845" || pause >nul
echo Are you sure you want to flash this rom?
echo Press enter to continue
pause >nul
resources\platform-tools\fastboot.exe --set-active=other || @echo "Changing slots error" && pause >nul
resources\platform-tools\fastboot.exe %* flash boot %~dp0resources\images\boot.img || @echo "Flash boot error" && pause >nul
resources\platform-tools\fastboot.exe %* flash dtbo %~dp0resources\images\dtbo.img || @echo "Flash dtbo error" && pause >nul
resources\platform-tools\fastboot.exe %* flash vbmeta %~dp0resources\images\vbmeta.img || @echo "Flash vbmeta error" && pause >nul
resources\platform-tools\fastboot.exe %* flash system %~dp0resources\images\system.img || @echo "Flash system error" && pause >nul
resources\platform-tools\fastboot.exe %* flash vendor %~dp0resources\images\vendor.img || @echo "Flash vendor error" && pause >nul
echo Press any key to reboot your device.
pause >nul
resources\platform-tools\fastboot.exe %* reboot || @echo "Reboot error" && pause >nul
exit


