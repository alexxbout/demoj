#!/bin/bash

# SSID to monitor
ssid="DemoJ"
pass=""

# Check if the Raspberry Pi is already connected to a network with the SSID "DemoJ"
connected_ssid=$(iwgetid -r)
if [ "$connected_ssid" == "$ssid" ]; then
    echo "Already connected to the $ssid network. Exiting the script."
    exit 0
fi

# Loop to monitor and connect to the network
while true; do
    # Check if the network exists
    if sudo iwlist wlan0 scanning | grep -q "$ssid"; then
        echo "The $ssid network has been found. Attempting to connect..."
        # Try to connect to the network
        raspi-config nonint do_wifi_ssid_passphrase "$ssid" "$pass"
        # Check if the connection was successful
        connected_ssid=$(iwgetid -r)
        if [ "$connected_ssid" == "$ssid" ]; then
            echo "Connected to the $ssid network."
            exit 0
        else
            echo "Failed to connect to the $ssid network. Retrying in 10 seconds..."
        fi
    else
        echo "The $ssid network is not available. Retrying in 10 seconds..."
    fi
    # Wait for 10 seconds before retrying
    sleep 10
done
