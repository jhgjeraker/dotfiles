#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$DIR/common.sh"

existing_projects=($(_list_project_letters))

for project_name in "${project_name_list[@]}"; do
    exists=false
    for existing_project in "${existing_projects[@]}"; do
        if [[ "$project_name" == "$existing_project" ]]; then
            exists=true
            break
        fi
    done

    if [[ "$exists" == false ]]; then
        break
    fi
done

new_project="${project_name}1"

if [[ "$@" == *"--dry"* ]]; then
    echo "Existing Projects: ${existing_projects[@]}"
    echo "      New Project: ${new_project}"
else
    bspc monitor --add-desktops "${new_project}"
    bspc desktop -f "${new_project}"
    _sort_desktops_per_monitor
fi
