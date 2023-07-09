#!/bin/bash

project_name_list=('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J')

_get_current_desktop() {
    bspc query -D -d --names
}

_get_current_project() {
    current_desktop=$(_get_current_desktop)

    # If current project is not a letter, return empty string.
    current_project=${current_desktop:0:1}
    if [[ ! $current_project =~ [a-zA-Z] ]]
    then
        current_project=''
    fi
    echo "$current_project"
}

_list_desktops() {
    declare -a all_desktops
    monitors=$(bspc query --monitors --names)
    for monitor in $monitors; do
        desktops=$(bspc query --desktops -m "$monitor" --names)
        all_desktops+=($desktops)
    done
    echo "${all_desktops[@]}"
}

_list_desktops_current_monitor() {
    monitor_desktops=("$(bspc query --desktops -m $monitor --names)")
    echo "${monitor_desktops[@]}"
}

_list_desktops_current_project() {
    all_desktops=($(_list_desktops))
    current_project=$(_get_current_project)

    declare -a project_desktops
    for desktop in "${all_desktops[@]}"; do
        if [[ $current_project == '' ]]; then
            if [[ ! $desktop =~ [a-zA-Z] ]]; then
                project_desktops+=($desktop)
            fi
        elif [[ ${desktop:0:1} == $current_project ]]; then
            project_desktops+=($desktop)
        fi
    done

    project_desktops=($(printf "%s\n" "${project_desktops[@]}" | sort -g))
    echo "${project_desktops[@]}"
}

_list_project_letters() {
    # Find all desktops on all monitors.
    all_desktops=($(_list_desktops))

    # Get the first character of each desktop name.
    first_chars=$(printf "%s\n" "${all_desktops[@]}" | awk '{print substr($0, 1, 1)}')

    # Convert the array to a string, lower-case it, keep only letters a-z, and sort it
    array=$(printf "%s\n" "${first_chars[@]}" | tr '[:lower:]' '[:upper:]' | grep -o '[A-Z]' | sort)

    # Get only unique letters
    unique_letters=$(echo "$array" | uniq)

    # Convert the result back into an array
    existing_projects=($unique_letters)

    echo "${existing_projects[@]}"
}

_sort_desktops_per_monitor() {
    for monitor in $(bspc query --monitors --names); do
        desktops=$(bspc query --desktops -m "$monitor" --names)

        # Arrays to hold entries start with digits and letters
        digit_entries=()
        letter_entries=()

        # Separate entries that start with digits from entries that start with letters
        for entry in "${desktops[@]}"; do
        if [[ $entry =~ ^[0-9] ]]; then
            digit_entries+=("$entry")
        else
            letter_entries+=("$entry")
        fi
        done

        # Sort each array
        IFS=$'\n'
        sorted_digit_entries=($(sort <<<"${digit_entries[*]}"))
        sorted_letter_entries=($(sort <<<"${letter_entries[*]}"))

        # Concatenate arrays
        sorted_array=("${sorted_digit_entries[@]}" "${sorted_letter_entries[@]}")

        bspc monitor "$monitor" -o ${sorted_array[@]}
    done
}