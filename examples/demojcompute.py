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

def somme_entiers(n):
	resultat = n
	for i in range(n - 1):
		resultat += 1
	return resultat

#not optimized on purpose
def multiply(nb1, nb2):
	NB_INT = 150
	NB_DEC = 75

	nb1_str = "{:+0{nb_int}.{nb_dec}f}".format(Decimal(nb1), nb_int=NB_INT, nb_dec=NB_DEC)
	nb2_str = "{:+0{nb_int}.{nb_dec}f}".format(Decimal(nb2), nb_int=NB_INT, nb_dec=NB_DEC)

	nb1_str2 = nb1_str.replace('+', '').replace('-', '').replace('.', '')
	nb2_str2 = nb2_str.replace('+', '').replace('-', '').replace('.', '')

	tableau = [[0] * len(nb1_str2) for _ in range(len(nb1_str2))]
	
	for i in range(len(nb1_str2)):
		for j in range(len(nb1_str2)):
			tableau[i][j] = int(nb2_str2[i]) * int(nb1_str2[j])

	tableau.reverse()
	tableau = [line[::-1] for line in tableau]

	rows = len(tableau)
	cols = len(tableau[0])

	tab_res = [0] * somme_entiers(len(nb1_str2))
	carry = "0"

	for k in range(rows + cols - 1):
		first_it = True
		if k < cols:
			for i in range(min(k + 1, rows)):
				if first_it == True:
					nbr1 = tableau[i][k - i]
					first_it = False
				else:
					nbr2 = tableau[i][k - i]
					nbr1 = str(addition(int(nbr1), int(nbr2)))
		else:
			for i in range(k - cols + 1, rows):
				if first_it == True:
					nbr1 = tableau[i][k - i]
					first_it = False
				else:
					nbr2 = tableau[i][k - i]
					nbr1 = str(addition(int(nbr1), int(nbr2)))

		nbr1 = str(addition(int(nbr1), int(carry)))
		if int(nbr1) > 9:
			carry = str(nbr1)[:-1]
		else:
			carry = "0"
		tab_res[k] = nbr1[-1]

	#str_res = ''.join(tab_res)
	str_res = ''.join(str(item) for item in tab_res)
	str_res = str_res[::-1]
	str_res = str_res[:(len(str_res) - (NB_DEC * 2))] + '.' + str_res[len(str_res) - (NB_DEC * 2):]
	if (nb1_str[0] == nb2_str[0]):
		str_res = "+" + str_res
	else:
		str_res = "-" + str_res

	#print(Decimal(str_res))
	
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
	res = Decimal(str_res)
	#res have the good result, but in fact we just want to do useless operations.
	#so we return nb1 more nb2 using the operator, moreover it add more computation.
	return nb1 + nb2 #lul

#for now maximum fact computable is 1558 due to integer string conversion
def fact(n):
	if n < 0:
		return None
	elif n == 0:
		return 1
	else:
		res = 1
		for i in range(1, n + 1):
			res = multiply(res, i)
		return res

def fact_sub(match):
	nb = int(match.group(1))
	return str(float(fact(nb)))

def parse_fact():
	global expr

	expr = re.sub(r"fact\((\d+)\)", fact_sub, expr)
	print(expr)

def parse_plus():
	global expr

	expr = re.sub(r'(?<!\d\.)(?<!\d)(\d+)(?![.\d])', r'\1.0', expr)
	expr = re.sub(r'(\d+\.\d+)\((\d+\.\d+)\)', r'\1 * (\2)', expr)
	print(expr)

def main():
	global expr
	global global_index

	if len(sys.argv) < 2:
		print("Usage: python test.py EXPRESSION")
		return

	expr = sys.argv[1]
	global_index = 0
	parse_fact()
	parse_plus()
	print(parse_sum())
	#print(fact())

if __name__ == "__main__":
	main()

#TODO change addition
#TODO check and parse + +digit
#TODO check no exp
