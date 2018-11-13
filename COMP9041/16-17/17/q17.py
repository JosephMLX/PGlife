#!/usr/bin/python3
import re
import sys

result = []
max_num = 0;

for line in sys.stdin:
	search_obj = re.search('[0-9]+', line);
	if search_obj:
		if max_num < int(search_obj.group()):
			max_num = int(search_obj.group())
			result = []
			result.append(line)
		elif max_num == int(search_obj.group()):
			result.append(line)	
	

print(''.join(result), end = '')

