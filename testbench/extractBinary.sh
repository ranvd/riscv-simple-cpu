#!/bin/bash

for f in $(ls -I "*.dump" ./rv32ui)
do
    riscv64-unknown-elf-objcopy -O binary ./rv32ui/$f ./rv32ui/$f.bin
    echo $f.bin
done