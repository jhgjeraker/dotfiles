#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$DIR/bspc/common.sh"

_set_bspwm_config() {
    ## apply the bspwm configs except external_rules_command
    ## or the desktops will look funny if monitors have changed
    while read line ; do
        $line
    done < <(grep --color=never -E \
        '(split_ratio|border_width|window_gap|top_padding|bottom_padding|left_padding|right_padding)' ~/.config/bspwm/bspwmrc)
}

primary=$(xrandr | grep primary | cut -d ' ' -f 1)
monitors=($(xrandr --listactivemonitors|awk '{print $4}'|sed '/^$/d'))
n_monitors=${#monitors[@]}

# Find all desktops on all monitors.
all_desktops=($(_list_desktops))

# Create 1 placeholder desktop per monitor.
# for monitor in "${monitors[@]}"; do
#     bspc monitor "$monitor" -a "Desktop"
# done

# Move all desktops to primary monitor.
for desktop in $(bspc query --desktops --names); do
    bspc desktop "$desktop" -m "$primary"
done

# Add a minimum number of desktops.
p0=${project_name_list[0]}
n_desktops=3
for i in $(seq $((n_desktops))); do
    target_desktop="$p0$i"
    exists=false
    for existing_desktop in "${all_desktops[@]}"; do
        echo "$target_desktop $existing_desktop"
        if [[ "$existing_desktop" == "$target_desktop" ]]; then
            exists=true
            break
        fi
    done
    if [[ "$exists" == false ]]; then
        bspc monitor --add-desktops "$target_desktop"
    fi
done

# Move one desktop per monitor, starting from last.
c=0
for monitor in "${monitors[@]}"; do
    if [[ "$monitor" != "$primary" ]]; then
        bspc desktop $((n_desktops - c)) -m "$monitor"
        c=$((c+1))
    fi
done

_sort_desktops_per_monitor


for monitor in "${monitors[@]}"; do
    # Remove all desktops called `Desktop` before applying changes.
    for desktop in $(bspc query --desktops --names --monitor "$monitor"); do
        if [[ "$desktop" == "Desktop" ]]; then
            bspc desktop "$desktop" -r
        fi
    done
done

# _set_bspwm_config
