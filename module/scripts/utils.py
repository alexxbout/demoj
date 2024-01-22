#!/usr/bin/env python3
import os
import subprocess
import time

def execute_command(command):
    try:
        subprocess.Popen(command)
        return True
    except Exception as e:
        print(f"Error executing command: {str(e)}")
        return False

def ping(hostname):
    return os.system("ping -c 1 " + hostname) == 0