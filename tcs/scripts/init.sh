#!/bin/bash
set -m

echo "Setting up private key..."
response=$(curl -f 'http://127.0.0.1:9880/efristcs/tcs/privateKey/savePrivateKey' \
    -F "pwd=$(cat /root/config/passphrase)" \
    -F "tin=$(cat /root/config/tin)" \
    -F "type=pfx" \
    -F "file=@/root/config/certificate.pfx")
echo $response
echo
if [ $(echo $response | jq '.error') -ne 0 ]; then
    echo 'Failed to setup private key'
    exit 1
fi

echo "Initializing system"
response=$(curl "http://127.0.0.1:9880/efristcs/ws/tcsapp/init/$(cat /root/config/tin)")
echo $response
echo
if [ "$response" != 'true' ]; then
    echo 'Failed to initialize system'
    exit 1
fi
