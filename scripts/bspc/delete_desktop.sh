#!/bin/bash

yes="y"
no="n"

n=$(bspc query -N -d focused | wc -l)
if [[ $n -gt 0 ]]; then
    mode="$(echo -e "$yes\n$no" | dmenu)"
    if [[ "$mode" == "$yes" ]]; then
        bspc desktop --remove
    fi
else
    bspc desktop --remove
fi