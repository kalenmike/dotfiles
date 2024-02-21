#!/bin/bash

status(){
    RUNNING=$(ps aux | grep "[g]reenclip daemon" | wc -l)
    if [ "$RUNNING" != "0" ];then 
        echo -e "  %{T9}󰅍 %{T-}$(greenclip print | wc -l)"
    else
        echo -e "  %{T9}󱘚 %{T-}"
    fi
}

kill_greenclip(){
    echo "Killing"
    pkill -f "greenclip daemon"
}

clear_clip(){
    echo "Clearing"
    greenclip clear && xsel -p -c && xsel -s -c && xsel -b -c
}

start_greenclip(){
    echo "Starting"
    greenclip daemon &
}

if [ "$#" -gt 0 ]; then
    for opt in "$@" 
    do
        case "${opt}" in
            status) status;;
           restart) kill_greenclip; clear_clip && start_greenclip &;;
            stop) kill_greenclip && clear_clip;;
        esac
    done
else
    echo "usage <script.sh> [status|restart|stop]"
fi
