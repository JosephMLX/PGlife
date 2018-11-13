#!/usr/bin/python3
import sys

nums_str = ''.join(sys.stdin).replace('\n', ' ')
nums_list = nums_str.split(' ')
nums_list = [x for x in nums_list if x != '']
nums_list = [int(x) for x in nums_list]
nums_list.sort()

for i in range(0, len(nums_list) - 1):
	if nums_list[i] + 1 != nums_list[i + 1]:
		print(nums_list[i] + 1)
		break
