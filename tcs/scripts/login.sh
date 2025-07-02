#!/bin/bash
set -m

function login() {
    echo "Logging in"
    response=$(curl 'http://127.0.0.1:9880/efristcs/ws/tcsapp/tcsLogin')
    # Check if response is a valid json
    echo "$response" | jq . || { echo "Login failed with response: $reponse" && return 1; }
    if echo "$response" | jq -r 'to_entries[].value' | grep -q -v -e 'code:00' -e 'Successfully' -e 'Failure to regularly update all branch!'; then
        echo "Login failed with response: $reponse"
        return 1
    fi
}

success=1
counter=0
while test ${success} -gt 0; do
    sleep 1
    login
    success=$?
    counter=$(($counter+1))

    if [ ${counter} -gt 60 ]
    then
        echo "Failed to login after 1 minute"
        exit 1
    fi
done
echo "Login done"
