#!/bin/sh

time=$(date +'%a %Y-%m-%d %H:%M')
battery=$(upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | awk '{print $2}')
power_profile=$(bash /usr/local/bin/powerprofile.sh)

echo "$power_profile | $time | bat: $battery"
