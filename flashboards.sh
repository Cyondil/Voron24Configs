#!/bin/bash
### Thanks to Eddie the engineer for providing examples on how to flash Klipper on different devices!!!

echo "Stopping Klipper..."
sudo service klipper stop
echo "Klipper has stopped"

### Flash the Octopus via USB...
echo "Start processing for the Octopus..."
make clean KCONFIG_CONFIG=config.octopus
#make menuconfig KCONFIG_CONFIG=config.octopus
make -j4 KCONFIG_CONFIG=config.octopus
make flash KCONFIG_CONFIG=config.octopus FLASH_DEVICE=/dev/serial/by-id/usb-Klipper_stm32h723xx_1B0037001551303531313638-if00

# Sometimes the Octopus is stuck in DFU mode...
if [ $? -eq 0 ]; then
   echo "*** Successfully flashed Octopus"
else
   echo "*** Unable to flash via serial path, attempting via USB device ID..."
   make flash KCONFIG_CONFIG=config.octopus FLASH_DEVICE=0483:df11
fi

echo
echo ----------------------------------------------------------
echo

### Flash the SB2209 via CAN Boot...
#echo "Start processing for the SB2209..."
#make clean KCONFIG_CONFIG=config.sb2209
#make menuconfig KCONFIG_CONFIG=config.sb2209
#make -j4 KCONFIG_CONFIG=config.sb2209
#python3 ~/CanBoot/scripts/flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u d063055012c2

echo "Starting Klipper..."
sudo service klipper start
echo "Klipper has started"
