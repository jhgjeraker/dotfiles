#!/bin/bash
#
BAR_CFG="$HOME/.config/waybar/config.json"
BAR_STYLE="$HOME/.config/waybar/style.css"

# Launch new instance of waybar.
while true; do
    # Terminate already running bar instances.
    killall -q waybar

    # Wait until the processes have been shut down.
    while pgrep -x waybar >/dev/null; do sleep 1; done

    waybar --config "$BAR_CFG" --style "$BAR_STYLE" &
    inotifywait -e create,modify --recursive "$HOME/.config/waybar"
done

