# IP ADDRESS
IP_TERMINAL = "10.3.141.2"
IP_NETWORK = "10.3.141.1"
IP_SERVER = "10.3.141.3"

# COMMANDS
RESTART_CMD = ["sudo", "reboot"]
STOP_CMD = ["sudo", "shutdown", "-h", "now"]
STRESS_CMD = ["stress", "-c", "8", "-i", "8", "-m", "8", "--timeout", "10s"]
