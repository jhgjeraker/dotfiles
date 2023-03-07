#!/bin/bash

if command -v sensors &> /dev/null
then
    if sensors 2>&1 | grep -q "No sensors found!"; then
        echo "--"
    elif sensors | grep -q fan; then
        speed=$(sensors | grep fan1 | awk '{print $2}')
        if (( speed > 0 )); then
            echo %{F$POLYBAR_C_FG}on%{F-}
        else
            echo %{F$POLYBAR_C_FG_DIM}off%{F-}
        fi
    else
        echo %{F$POLYBAR_C_FG}--%{F-}
    fi
else
    echo "?"
fi
