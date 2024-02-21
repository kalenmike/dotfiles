#!/bin/bash

echo -e "\nHello $(whoami)!"

echo -e  "\nWould you like to launch the GUI? (y, n) "

read -n 1 INPUT

if [ "$INPUT" == "y" ] || [ "$INPUT" == "Y" ];then
    # lxpolkit &
    startx
fi
