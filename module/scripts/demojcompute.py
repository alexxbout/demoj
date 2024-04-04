import sys
import re
import random
from decimal import Decimal

expr = None
global_index = None
stress = True

def atoi(string):
	test = re.match(r'-?\d+(\.\d+)?', string)
	
	if test:
		return Decimal(test.group())
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
			nb1 = division(nb1, nb2)
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
			nb1 = addition(nb1, nb2)
		else:
			nb1 = addition(nb1, nb2 * -1)
	return nb1

def somme_entiers(n):
	resultat = n
	for i in range(n - 1):
		resultat += 1
	return resultat

def division(nb1, nb2):
	a = max(nb1, nb2)
	b = min(nb1, nb2)	

	if b == 0:
		raise ValueError("Division par zéro impossible")

	if not stress:
		return nb1 / nb2
	result = 0.0
	sign = 1 if (a > 0 and b > 0) or (a < 0 and b < 0) else -1
	#a = abs(a)
	#b = abs(b)

	while a >= b:
		a -= b
		result += 1

	remainder = a
	precision = 0.1
	while remainder != 0 and precision > 0.0000000001:
		if remainder >= b:
			remainder -= b
			result += precision
		precision *= 0.1
	res = multiply(result, sign)
	#print(res)
	return nb1 / nb2

#not optimized on purpose
def multiply(nb1, nb2):
	if not stress:
		return nb1 * nb2

	NB_INT = 6
	NB_DEC = 2

	nb1_str = "{:+0{nb_int}.{nb_dec}f}".format(Decimal(nb1), nb_int=NB_INT, nb_dec=NB_DEC)
	nb2_str = "{:+0{nb_int}.{nb_dec}f}".format(Decimal(nb2), nb_int=NB_INT, nb_dec=NB_DEC)

	nb1_str2 = nb1_str.replace('+', '').replace('-', '').replace('.', '')
	nb2_str2 = nb2_str.replace('+', '').replace('-', '').replace('.', '')

	tableau = [[0] * len(nb1_str2) for _ in range(len(nb1_str2))]
	
	#for i in range(len(nb1_str2)):
	#	for j in range(len(nb1_str2)):
	#		tableau[i][j] = int(nb2_str2[i]) * int(nb1_str2[j])

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
	if not stress:
		return nb1 + nb2

	nb1_str = "{:+031.15f}".format(nb1)
	nb2_str = "{:+031.15f}".format(nb2)
	tab_res = [0] * len(nb1_str)

	carry = 0
	if (nb1_str[0] == nb2_str[0]):
		for i in range(len(nb1_str) -1, -1, -1):
			if nb1_str[i] == '.':
				tab_res[i] = '.'
			elif nb1_str[i] == '+':
				tab_res[i] = '+'
			elif nb1_str[i] == '-':
				tab_res[i] = '-'
			elif (int(nb1_str[i]) + int(nb2_str[i]) + carry) > 9:
				res = str(int(nb1_str[i]) + int(nb2_str[i]) + carry)
				carry = int(res[:-1])
				tab_res[i] = res[-1]
			else:
				tab_res[i] = str(int(nb1_str[i]) + int(nb2_str[i]) + carry)
				carry = 0
		tab_res[0] = nb1_str[0]
	else:
		if abs(nb2) > abs(nb1):
			tmp = nb1_str
			nb1_str = nb2_str
			nb2_str = tmp
		for i in range(len(nb1_str) - 1, -1, -1):
			if nb1_str[i] == '.':
				tab_res[i] = '.'
			elif nb1_str[i] == '+':
				tab_res[i] = '+'
			elif nb1_str[i] == '-':
				tab_res[i] = '-'
			elif (int(nb2_str[i]) + carry) > int(nb1_str[i]):
				tab_res[i] = str((int(nb1_str[i]) + 10) - (int(nb2_str[i]) + carry)) 
				carry = 1
			else:
				tab_res[i] = str(int(nb1_str[i]) - (int(nb2_str[i]) + carry))
				carry = 0
		tab_res[0] = nb1_str[0]

	str_res = ''.join(tab_res)
	#print(str_res)
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
def fib(n):
	if n <= 0:
		return None
	elif n == 1:
		return 0
	elif n == 2:
		return 1
	else:
		fib_sequence = [0, 1]
		for i in range(2, n):
			fib_sequence.append(fib_sequence[-1] + fib_sequence[-2])
		return fib_sequence[-1]

def fact_sub(match):
	return str(float(fact(int(match.group(1)))))

def fib_sub(match):
	return str(float(fib(int(match.group(1)))))

def parse_plus():
	global expr

	expr = re.sub(r"fib\((\d+)\)", fib_sub, expr)
	expr = re.sub(r"fact\((\d+)\)", fact_sub, expr)
	expr = re.sub(r'(?<!\d\.)(?<!\d)(\d+)(?![.\d])', r'\1.0', expr)
	expr = re.sub(r'(\d+\.\d+)\((\d+\.\d+)\)', r'\1 * (\2)', expr)
	expr = re.sub(r'\+(?=\d)', r'', expr)

def main():
	global expr
	global global_index
	global stress
	
	if len(sys.argv) < 2:
		return None
	if len(sys.argv) >= 3:
		stress = sys.argv[2].lower == "false" #TODO: repair
	expr = sys.argv[1]
	global_index = 0
	parse_plus()
	print(parse_sum())


if __name__ == "__main__":
	main()

#TODO check no exp
