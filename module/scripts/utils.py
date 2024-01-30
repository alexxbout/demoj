#!/usr/bin/env python3
import os
import subprocess
import time
import json
from const import IP_TERMINAL, IP_NETWORK, IP_SERVER
from functools import reduce

def execute_command(command):
    """
    Execute a command.

    Parameters:
    - command (list): The command to execute.

    Returns:
    - True if the command was executed successfully, False otherwise.
    """
    try:
        subprocess.Popen(command)
        return True
    except Exception as e:
        print(f"Error executing command: {str(e)}")
        return False

def ping(hostname):
    """
    Ping a host and return True if it is reachable, False otherwise.

    Parameters:
    - hostname (str): The hostname to ping.

    Returns:
    - True if the host is reachable, False otherwise.
    """
    return os.system("ping -c 1 " + hostname) == 0

def update_json_value(json_data, path, new_value):
    """
    Update the value in a JSON object using a specified path.

    Parameters:
    - json_data (dict): The JSON data to be updated.
    - path (str): The path to the value to be updated, e.g., "modules.terminal.isConnected".
    - new_value: The new value to set.

    Returns:
    - Updated JSON data.
    """
    keys = path.split('.')
    key_path = keys[:-1]
    last_key = keys[-1]

    # Use functools.reduce to access nested keys
    nested_data = reduce(lambda d, key: d[key], key_path, json_data)

    # Update the value
    nested_data[last_key] = new_value

    return json_data

def write_json_to_file(json_data, file_path):
    """
    Write the JSON data to a file.

    Parameters:
    - json_data (dict): The JSON data to be written.
    - file_path (str): The path to the file.
    """
    with open(file_path, 'w') as json_file:
        json.dump(json_data, json_file, indent=2)

def update_and_write_json(file_path, path, new_value):
    """
    Update the value in a JSON file using a specified path and write the updated JSON to the file.

    Parameters:
    - file_path (str): The path to the JSON file.
    - path (str): The path to the value to be updated, e.g., "modules.terminal.isConnected".
    - new_value: The new value to set.
    """
    # Read JSON data from file
    with open(file_path, 'r') as json_file:
        json_data = json.load(json_file)

    # Update the value at the specified path
    updated_json_data = update_json_value(json_data, path, new_value)

    # Write the updated data back to the file
    write_json_to_file(updated_json_data, file_path)

def get_device_from_addr(addr):
    """
    Get the device name from its IP address.

    Parameters:
    - addr (str): The IP address of the device.

    Returns:
    - The device name.
    """
    if addr == IP_TERMINAL:
        return "terminal"
    elif addr == IP_SERVER:
        return "server"
    else:
        return "client"
