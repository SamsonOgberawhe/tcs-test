#!/bin/bash
set -m

# start mysql
service mysql start

cd

FILE_NAME="/root/config/efris_server.tar.gz"

FILE=/etc/resolv.conf
if [ -f "$FILE_NAME" ]; then
    echo "$FILE_NAME exists."

    DIR="/root/TaxControlService/"
    if [ -d "$DIR" ]; then
        # Take action if $DIR exists. #
        echo "files already extracted..."
        if [ "$(ls -A $DIR)" ]; then
             echo "Take action $DIR is not Empty"
        else
          echo "tar -zxvf $FILE_NAME"
          tar -zxvf $FILE_NAME
        fi
    else
      echo "tar -zxvf $FILE_NAME"
      tar -zxvf $FILE_NAME
    fi
else
    echo "tar -zxvf $FILE_NAME"
    tar -zxvf $FILE_NAME
fi

sh TaxControlService/tcs.sh

echo "Completed."
