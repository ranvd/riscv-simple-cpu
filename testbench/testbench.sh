#!/bin/bash

path="../sim/obj_dir/"
exec="VCore"
bench="rv32ui"

RED='\033[0;31m'
GREEN='\033[0;32m'
RESET="\033[0m"
for file in $(ls $bench/*.bin)
do
    $path$exec $file
    if [ $? -eq "0" ]; then
        echo -e "$GREEN$file : PASS$RESET"
    else
        echo -e "$RED$file : FAIL$RESET"
    fi
done
