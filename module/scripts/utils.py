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