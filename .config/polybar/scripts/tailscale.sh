#!/bin/bash

if command -v tailscale &> /dev/null
then
    if tailscale status 2>&1 | grep -q "failed to connect"; then
        echo "--"
    elif tailscale status | grep -q stopped; then
        echo %{F$POLYBAR_C_FG_DIM}off%{F-}
    else
        echo %{F$POLYBAR_C_FG}on%{F-}
    fi
else
    echo "?"
fi
