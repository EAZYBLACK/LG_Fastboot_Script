for windows use Flash_Windows.bat
if it gets stuck in waiting for device, install drivers with the script

for linux use Flash_Linux.sh (dont forget installing fastboot and the udev rules)

if you have usb issues , use usb 2.0 port
or else do this for windows
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbflags\18D1D00D0100" /v "osvc" /t REG_BINARY /d "0000" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbflags\18D1D00D0100" /v "SkipContainerIdQuery" /t REG_BINARY /d "01000000" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbflags\18D1D00D0100" /v "SkipBOSDescriptorQuery" /t REG_BINARY /d "01000000" /f

this for linux:

echo -1 | sudo tee /sys/module/usbcore/parameters/autosuspend
echo '18d1:d00d:k' | sudo tee /sys/module/usbcore/parameters/quirks
echo 1 | sudo tee /sys/bus/usb/devices/1-1/power/pm_qos_no_power_off
echo | sudo tee /sys/bus/usb/devices/1-1/power/wakeup
echo on | sudo tee /sys/bus/usb/devices/1-1/power/control
echo -1 | sudo tee /sys/bus/usb/devices/1-1/power/autosuspend_delay_ms
echo n | sudo tee /sys/bus/usb/devices/1-1/power/usb2_hardware_lpm

to make udev rules on linux:

sudo curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules
sudo chmod a+r /etc/udev/rules.d/51-android.rules
