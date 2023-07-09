#!/bin/bash

# Deploy fonts.
mkdir -p "$HOME/.local/share/fonts"
rsync -r fonts/* "$HOME/.local/share/fonts/"
fc-cache -f