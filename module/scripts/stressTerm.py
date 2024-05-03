from demojcompute import compute
import random
import time

def stress():
	wait_time = 0
	compute_value = 0
	while (True):
		compute_value = random.randint(50, 150)
		print("compute: fact of " + str(compute_value))
		compute("fact(" + str(compute_value) + ")")
		wait_time = random.randint(2, 6)
		print("waiting " + str(wait_time) + " second(s)")
		time.sleep(wait_time)
