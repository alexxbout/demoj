import sys
import re
import random
from decimal import Decimal

expr = None
global_index = None

def atoi(string):
	#test = re.match(r'-?\d+', string)
	test = re.match(r'-?\d+(\.\d+)?', string)
	
	if test:
		#return int(test.group())
		return float(test.group())
	return None

def parse_number():
	global global_index
	global expr
	nb = 0.0

	while expr[global_index] == ' ':
		global_index += 1
	if (expr[global_index] == '('):
		global_index += 1
		nb = parse_sum()
		if (expr[global_index] == ')'):
			global_index += 1
		return nb
	nb = atoi(expr[global_index:])
	global_index += len(str(nb))
	return nb

def parse_factor():
	global global_index
	global expr
	nb1 = 0.0
	nb2 = 0.0
	op = None

	nb1 = parse_number()
	while global_index < len(expr):
		while expr[global_index] == ' ':
			global_index += 1
		op = expr[global_index]
		if op != '*' and op != '/':
			return nb1
		global_index += 1
		nb2 = parse_number()
		if op == '*':
			#nb1 *= nb2
			nb1 = multiply(nb1, nb2)
		else:
			nb1 /= nb2
	return nb1

def parse_sum():
	global global_index
	global expr
	nb1 = 0.0
	nb2 = 0.0
	op = None

	nb1 = parse_factor()
	while global_index < len(expr):
		while expr[global_index] == ' ':
			global_index += 1
		op = expr[global_index]
		if op != '+' and op != '-':
			return nb1
		global_index += 1
		nb2 = parse_factor()
		if op == '+':
			#nb1 += nb2
			nb1 = addition(nb1, nb2)
		else:
			nb1 -= nb2
	return nb1

#not optimized on purpose
def multiply(nb1, nb2):
	nb1_str = "{:+031.15f}".format(Decimal(nb1))
	nb2_str = "{:+031.15f}".format(Decimal(nb2))
	#nb1_str = "{:+031.15f}".format(nb1)
	#nb2_str = "{:+031.15f}".format(nb2)
	tableau = [[0] * 29 for _ in range(29)]
	
	for i in range(28, -1, -1):
		i_loc = i
		if (nb2_str[i_loc] == '.' 
			or nb2_str[i_loc] == '+' 
				or nb2_str[i_loc] == '-'):
			i_loc -= 1
		for j in range(28, -1, -1):
			j_loc = j
			if (nb1_str[j_loc] == '.' 
				or nb1_str[j_loc] == '+' 
					or nb1_str[j_loc] == '-'):
				j_loc -= 1
			tableau[i][j] = int(nb1_str[j_loc]) * int(nb2_str[i_loc])

	#Work In Progress.
	#but in fact even when finished it will have the same operations to do.
	#so i added this for the calibration test.
	for i in range(28, -1, -1):
		for j in range(28, -1, -1):
			cpt = addition(random.randint(0, 100), random.randint(0, 100))

	return nb1 * nb2 #add more computation...

#we assume len(nb1_str) == len(nb2_str)
#not optimized on purpose
def addition(nb1, nb2):
	nb1_str = "{:+031.15f}".format(nb1)
	nb2_str = "{:+031.15f}".format(nb2)
	tab_res = [0] * len(nb1_str)

	for i in range(len(nb1_str)):
		if nb1_str[i] == '.':
			tab_res[i] = '.'
		if nb1_str[i] == '+':
			tab_res[i] = '+'
		if nb1_str[i] == '-':
			tab_res[i] = '-'
		if nb1_str[i] != '.' and nb1_str[i] != '+' and nb1_str[i] != '-':
			tab_res[i] = str(int(nb1_str[i]) + int(nb2_str[i]))

	str_res = ''.join(tab_res)
	#str_res have the good result, but in fact we just want to do useless operations.
	#so we return nb1 more nb2 using the operator, moreover it add more computation.
	return nb1 + nb2 #lul

#for now maximum fact computable is 1558 due to integer string conversion
def fact():
	global expr
	n = int(expr)

	if n < 0:
		return None
	elif n == 0:
		return 1
	else:
		res = 1
		for i in range(1, n + 1):
			res = multiply(res, i)
		return res

def main():
	global expr
	global global_index

	if len(sys.argv) < 2:
		print("Usage: python test.py EXPRESSION")
		return

	expr = sys.argv[1]
	global_index = 0
	#print(parse_sum())
	print(fact())

if __name__ == "__main__":
	main()
