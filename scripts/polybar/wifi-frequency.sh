#!/bin/bash

frequency=$(iwconfig wlo1 | grep Frequency | tr -s " " | cut -d " " -f 3 | cut -d ":" -f 2)

if [ -z $frequency ];then
    echo "%{T9}󰤮 %{T-}" 
else
    echo ${frequency} Ghz
fi
