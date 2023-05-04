#!/bin/bash

dir="./rv32um"
for f in $(ls -I "*.dump" $dir)
do
    riscv64-unknown-elf-objcopy -O binary ./$dir/$f ./$dir/$f.bin
    echo $f.bin
done