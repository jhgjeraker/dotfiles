#!/bin/bash

engine=$(ibus engine | sed 's/.*://')

if [ "${engine}" == 'eng' ]
then
    lang=$(setxkbmap -query | grep layout | awk '{print $2}')
    echo "$lang"
elif [ "${engine}" == 'anthy' ]
then
    echo 'か'
elif [ "${engine}" == 'nor' ] || [ "${engine}" == 'nob' ]
then
    echo 'no'
else
    echo '--'
fi
