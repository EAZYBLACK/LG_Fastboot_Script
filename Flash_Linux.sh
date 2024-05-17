#!/bin/bash

# Fastboot flash scripts by Eazy Black @ https://github.com/EAZYBLACK 
# and Juleast @ https://github.com/juleast

ded() {
    status=$1
    msg=$2
    if [ "$status" -ne 0 ]; then
        echo -e "\n$msg"
        read -n1 -s -r -p "Press any key to exit..."
        exit 1
    fi
}

fastboot_flash() {
    echo -e "### Starting fastboot flash ###"
    echo -e "-------------------------------"
    fastboot $* --set-active=other
    ded $? "Error changing slots. Check cable."

    IFS=" " read -r -a slot_lines <<< $(fastboot $* getvar current-slot 2>&1 | grep "slot: ")
    ded $? "Error changing slots. Check cable and try again."
    current_slot=${slot_lines[1]}

    for part in ${part_list[@]}; do
        if [ "$part" == "userdata" ]; then
            fastboot $* flash ${part} `dirname $PWD`/resources/images/${part}.img
        else
            fastboot $* flash "${part}_${current_slot}" `dirname $PWD`/resources/images/${part}.img
        fi
        ded $? "Error flashing ${part}. Check cable and try again."
        echo ""
    done

    read -n1 -s -r -p "Press any key to continue rebooting..."
    echo ""
    fastboot $* reboot
    ded $? "Failed to reboot. Check cable and reboot manually if necessary."
    return 0
}

echo -e "### Fastboot flasher v1.0 ###"
echo -e "-----------------------------"
echo "Choose flash option:"
echo "1. Dirty flash"
echo "2. Clean flash"
echo "3. Exit"

read -p "Enter your option (1-3): " flash_option
echo -e "--------------------------"

case "$flash_option" in
    1)
        clean_flash="false"
        flash_msg=""
        ;;
    2)
        clean_flash="true"
        flash_msg=" THIS WILL WIPE YOUR DATA!!!"
        ;;
    3)
        echo "Exiting script..."
        exit 0
        ;;
    *)
        echo "Illegal option!"
        echo "Exiting script..."
        exit 1
        ;;
esac

part_list=("boot" "dtbo" "system" "vbmeta" "vendor")

if $clean_flash; then
    part_list+=("userdata")
fi

fastboot $* getvar product 2>&1 | grep "^product: *sdm845"
ded $? "Wrong device. Replug device and try again."

echo ""
read -r -p "Continue?${flash_msg} (y/n): " confirm
case "$confirm" in
    [yY][eE][sS]|[yY])
        echo ""
        fastboot_flash
        ;;
    *)
        ded 1 "Aborting script..."
        ;;
esac
