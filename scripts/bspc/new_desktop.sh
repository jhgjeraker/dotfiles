#!/bin/bash

# Source the common functions.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$DIR/common.sh"

project_desktops=($(_list_desktops_current_project))
current_project=$(_get_current_project)

i=1
next_desktop="$current_project$i"
for desktop in "${project_desktops[@]}"; do
    echo ">> $desktop $next_desktop"
    if (( "$desktop" != "$next_desktop" )); then
        break
    fi
    # If the number is as expected, increment the expected number for the next iteration
    ((++i))
    next_desktop="$current_project$i"
done

if [[ "$@" == *"--dry"* ]]; then
    echo "Project Desktops: ${project_desktops[@]}"
    echo "Current Project:  $current_project"
    echo "   Next Desktop:  $next_desktop"
else
    bspc monitor --add-desktops "$next_desktop"
    bspc desktop -f "$next_desktop"
    _sort_desktops_per_monitor
fi

