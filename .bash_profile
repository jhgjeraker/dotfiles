#!/bin/bash

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
export BROWSER='firefox'
export EDITOR='/usr/bin/nvim'

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# -----------------------------------------------
# Input Devices
#
# Set xinput parameters for certain known devices.
#
# Thinkpad X1 Extreme Touchpad.
if xinput list | grep -q 'SynPS/2 Synaptics TouchPad'; then
    xinput --set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Accel Speed' 0.5
    xinput --set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Tapping Enabled' 1
    xinput --set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Natural Scrolling Enabled' 1
fi
# Thinkpad X1 Extreme + X13 Gen 2 Trackpoint.
if xinput list | grep -q 'TPPS/2 Elan TrackPoint'; then
    xinput --set-prop 'TPPS/2 Elan TrackPoint' 'libinput Accel Speed' 0.5
    xinput --set-prop 'TPPS/2 Elan TrackPoint' 'libinput Accel Profile Enabled' 0, 1
fi
# Thinkpad X13 Gen 2 Touchpad.
if xinput list | grep -q 'ELAN0676:00 04F3:3195 Touchpad'; then
    xinput --set-prop 'ELAN0676:00 04F3:3195 Touchpad' 'libinput Natural Scrolling Enabled' 1
    xinput --set-prop 'ELAN0676:00 04F3:3195 Touchpad' 'libinput Tapping Enabled' 1
fi
