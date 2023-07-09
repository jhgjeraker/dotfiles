#!/bin/bash

DIRECTION_NEXT='next'
DIRECTION_PREV='prev'

UPPER_LIM=10
LOWER_LIM=1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$DIR/common.sh"

direction="$1"
if [[ "$direction" != "$DIRECTION_NEXT" && "$direction" != "$DIRECTION_PREV" ]]; then
    echo "Invalid direction: $direction. Use 'next' or 'prev'."
    exit 1
fi

current_desktop=($(_get_current_desktop))
current_desktop_number=${current_desktop:1}

if [[ "$direction" == "$DIRECTION_NEXT" ]]; then
    target_desktop_number=$((current_desktop_number + 1))
    if [[ "$target_desktop_number" -ge "$UPPER_LIM" ]]; then
        echo "Cannot swap desktops. Already on last desktop."
        exit 0
    fi
else
    target_desktop_number=$((current_desktop_number - 1))
    if [[ "$current_desktop_number" -le "$LOWER_LIM" ]]; then
        echo "Cannot swap desktops. Already on first desktop."
        exit 0
    fi
fi

target_desktop="${current_desktop:0:1}${target_desktop_number}"
project_desktops=($(_list_desktops_current_project))

target_exists=false
for desktop in "${project_desktops[@]}"; do
    if [[ "$desktop" == "$target_desktop" ]]; then
        target_exists=true
        break
    fi
done

if [[ "$@" == *"--dry"* ]]; then
    echo "Project Desktops: ${project_desktops[@]}"
    echo "Current Desktop:  $current_desktop"
    echo "      Direction:  $direction"
    echo " Target Desktop:  $target_desktop"
    echo "         Exists:  $target_exists"
    echo ""
    echo "$current_desktop -> $target_desktop"
else
    if [[ "$target_exists" == true ]]; then
        bspc desktop "$current_desktop" --rename "${target_desktop}_tmp"
        bspc desktop "$target_desktop" --rename "${current_desktop}"
        bspc desktop "${target_desktop}_tmp" --rename "$target_desktop"
        _sort_desktops_per_monitor
    else
        bspc desktop "$current_desktop" --rename "$target_desktop"
    fi
fi
