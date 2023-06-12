#!/bin/bash

if command -v tailscale &> /dev/null
then
    if tailscale status 2>&1 | grep -q "failed to connect"; then
        echo "--"
    elif tailscale status | grep -q stopped; then
        echo 'off'
    else
        echo 'on'
    fi
else
    echo "?"
fi
