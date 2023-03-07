#!/bin/bash

path="/sys/class/power_supply"

declare -a arr=("BAT0" "BAT1")

for bat in "${arr[@]}"; do
    if [ -d "$path/$bat" ]; then
        echo $(cat "$path/$bat/capacity")"%"
        exit
    fi
done

echo "--"
