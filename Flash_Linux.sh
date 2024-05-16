#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=3
BACKTITLE="Fastboot ROM Flasher"
TITLE="Welcome to the fastboot ROM Flasher"
MENU="Choose one of the following options:"

OPTIONS=(1 "Clean Flash"
         2 "Dirty flash")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            export FLASHCLEAN=true
            export CLEANMSG="THIS WILL ERASE YOUR DATA"
            ;;
        2)
            export FLASHCLEAN=false
            export CLEANMSG=""
            ;;
esac
fastboot $* getvar product 2>&1 | grep "^product: *sdm845"
if [ $? -ne 0  ] ; then echo "Wrong device plugged in, re-run script."; read -n1 -r -p "Press any key to exit..." key; exit 1; fi
echo Are you sure you want to flash this rom? $CLEANMSG
read -n1 -r -p "Press any key to continue..." key
fastboot $* --set-active=other
if [ $? -ne 0 ] ; then echo "Changing slots error"; read -n1 -r -p "Press any key to exit..." key; exit 1; fi
fastboot $* flash boot `dirname $0`/resources/images/boot.img
if [ $? -ne 0 ] ; then echo "Flash boot error"; read -n1 -r -p "Press any key to exit..." key; exit 1; fi
fastboot $* flash dtbo `dirname $0`/resources/images/dtbo.img
if [ $? -ne 0 ] ; then echo "Flash dtbo error"; read -n1 -r -p "Press any key to exit..." key; exit 1; fi
fastboot $* flash vbmeta `dirname $0`/resources/images/vbmeta.img
if [ $? -ne 0 ] ; then echo "Flash vbmeta error"; read -n1 -r -p "Press any key to exit..." key; exit 1; fi
fastboot $* flash system `dirname $0`/resources/images/system.img
if [ $? -ne 0 ] ; then echo "Flash system error"; read -n1 -r -p "Press any key to exit..." key; exit 1; fi
fastboot $* flash vendor `dirname $0`/resources/images/vendor.img
if [ $? -ne 0 ] ; then echo "Flash vendor error"; read -n1 -r -p "Press any key to exit..." key; exit 1; fi
[[ $FLASHCLEAN == "true" ]] && fastboot $* flash userdata `dirname $0`/resources/images/userdata.img
[[ $FLASHCLEAN == "true" ]] && if [ $? -ne 0 ] ; then echo "Flash userdata error"; read -n1 -r -p "Press any key to exit..." key; exit 1; fi
read -n1 -r -p "Press any key to reboot..." key
fastboot $* reboot
if [ $? -ne 0 ] ; then echo "Reboot error"; read -n1 -r -p "Press any key to exit..." key; exit 1; fi


