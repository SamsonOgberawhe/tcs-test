#!/bin/bash
set -m

function refresh_encryption_key() {
    echo "Refreshing encryption key"
    response=$(curl 'http://127.0.0.1:9880/efristcs/tcs/tcsKey/updateSymmetricKey' --data-raw '_aos_data=%7B%7D')
    # Check if response is a valid json
    echo "$response" | jq . || { echo "Encryption key refresh failed with response: $reponse" && return 1; }
    if [ $(echo "$response" | jq -r '.success') != "true" ]
    then
        echo "Encryption key refresh failed with response: $reponse"
        return 1
    fi
}

success=1
counter=0
while test ${success} -gt 0; do
    sleep 1
    refresh_encryption_key
    success=$?
    counter=$(($counter+1))

    if [ ${counter} -gt 60 ]
    then
        echo "Failed to refresh encryption key after 1 minute"
        exit 1
    fi
done
echo "Encryption key refresh done"
