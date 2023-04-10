#!/bin/sh

python ldstasm.py KFMMC_DRIVE_SPI_MODE.asm -o KFMMC_SPI_ROM.v
sed -i -e "s/LDST_PROGRAM_ROM/LDST_KFMMC_SPI_ROM/g" KFMMC_SPI_ROM.v

