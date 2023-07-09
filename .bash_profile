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

# Surface Laptop 2
if xinput list | grep -q 'MSHW0092:00 045E:0933 Touchpad'; then
    xinput --set-prop 'MSHW0092:00 045E:0933 Touchpad' 'libinput Natural Scrolling Enabled' 1
    xinput --set-prop 'MSHW0092:00 045E:0933 Touchpad' 'libinput Tapping Enabled' 1
fi
