#!/bin/bash

function showHelp {
    echo -e "Usage: cs-vnc <args>"
    echo -e "   -h          Print this message"
    echo -e "   -f          Run in the foreground"
    echo -e "   -k          Kill running daemon"
}

function runningMessage {
    echo "Cloudshell VNC is starting. In the top-right corner, select 'Preview on port 8080' to open the noVNC client."
}

function foregroundStart {

    
    # Set environment variables
    export XDG_RUNTIME_DIR=/tmp/cs-vnc-temp
    export DISPLAY=:99.0
    
    # Back up existing conf
    cp ${HOME}/.config/supervisord.conf ${HOME}/.config/supervisord.conf.bak
    # Modify supervisord.conf
    sed -i -e 's/nodaemon=false/nodaemon=true/' ${HOME}/.config/supervisord.conf
    
    # Run supervisord
    supervisord -c ${HOME}/.config/supervisord.conf
    
    # Revert back to original
    mv ${HOME}/.config/supervisord.conf.bak ${HOME}/.config/supervisord.conf
}

function daemonStart {
    echo -e "No arguments provided. Assuming daemon mode is specified."
    echo -e "Starting cs-vnc daemon..."
    echo -e "Run 'cs-vnc -k' to terminate Cloudshell VNC."
    {
    # Set environment variables
    export XDG_RUNTIME_DIR=/tmp/cs-vnc-temp
    export DISPLAY=:99.0
    
    # Run supervisord
    supervisord -c ${HOME}/.config/supervisord.conf
    }
}

function daemonStop {
    {
    supervisorctl stop novnc
    supervisorctl stop x11vnc
    supervisorctl stop xvfb
    supervisorctl stop desktop

    killall Xvfb x11vnc websockify supervisord openbox lxpanel pcmanfm
    # https://stackoverflow.com/questions/11583562/how-to-kill-a-process-running-on-particular-port-in-linux
    fuser -k 8080/tcp
    }&> /dev/null
}

# No arguments, assuming daemon
if [ $# -eq 0 ]
  then
    runningMessage; daemonStart ; sleep 5 ; exit ;
fi

while getopts :hfk opt; do
    case $opt in 
        h) showHelp; exit ;;
        f) runningMessage; foregroundStart ;;
        k) daemonStop ; exit ;;
       \?) echo "Unknown option -$OPTARG"; exit 1;;
    esac
done
