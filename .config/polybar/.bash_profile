#!/bin/bash

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

xinput --set-prop 'ELAN0676:00 04F3:3195 Touchpad' 'libinput Natural Scrolling Enabled' 1
xinput --set-prop 'ELAN0676:00 04F3:3195 Touchpad' 'libinput Tapping Enabled' 1
