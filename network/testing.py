import os

def ping(hostname):
    response = os.system("ping -c 1 " + hostname)
    if response == 0:
        return True
    else:
        return False