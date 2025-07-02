#!/bin/bash
set -m

if service --status-all | grep -q tcs
then
    echo "Setup already done. Booting server"
    server-boot.sh
else
    echo "Setting up server"
    setup.sh
    if [ $? -ne 0 ]; then
        echo "Setup failed. Aborting"
        server-stop.sh
    fi
fi

service cron start

server-tail-logs.sh
