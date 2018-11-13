#!/usr/bin/python3
import sys

def is_pos_int(num):
	try:
		num = int(str(num))
		return isinstance(num, int) and num > 0
	except:
		return False

match_int_list = [];
for i in range(1, len(sys.argv)):
	if is_pos_int(sys.argv[i]):
		match_int_list.append(int(sys.argv[i]))
match_int_list.sort()
match_str_list = [str(x) for x in match_int_list]
print(' '.join(match_str_list))
