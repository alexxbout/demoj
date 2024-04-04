# IP ADDRESS
IP_TERMINAL = "10.3.141.2"
IP_NETWORK = "10.3.141.1"
IP_SERVER = "10.3.141.3"

# COMMANDS
RESTART_CMD = ["sudo", "reboot"]
STOP_CMD = ["sudo", "shutdown", "-h", "now"]
STRESS_LVL_1_CMD = ["stress", "-c", "1", "-i", "1", "-m", "1", "--timeout", "10s"]
STRESS_LVL_2_CMD = ["stress", "-c", "2", "-i", "2", "-m", "2", "--timeout", "10s"]
STRESS_LVL_3_CMD = ["stress", "-c", "4", "-i", "4", "-m", "4", "--timeout", "10s"]