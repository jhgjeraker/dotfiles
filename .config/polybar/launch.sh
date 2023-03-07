#!/bin/bash

BAR_NAME='bar'
BAR_CFG="$HOME/.config/polybar/config.ini"

# Terminate already running bar instances.
killall -q polybar

# Wait until the processes have been shut down.
while pgrep -x polybar >/dev/null; do sleep 1; done

screens=$(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f6)

if [[ $(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f4 | cut -d"+" -f2- | uniq | wc -l) == 1 ]]; then
  MONITOR=$(polybar --list-monitors | cut -d":" -f1) TRAY_POS=right polybar -r -c $BAR_CFG $BAR_NAME &
else
  primary=$(xrandr --query | grep primary | cut -d" " -f1)

  for m in $screens; do
    echo $m
    if [[ $primary == $m ]]; then
        MONITOR=$m TRAY_POS=right polybar -r -c $BAR_CFG $BAR_NAME &
    else
        MONITOR=$m TRAY_POS=none polybar -r -c $BAR_CFG $BAR_NAME &
    fi
  done
fi
