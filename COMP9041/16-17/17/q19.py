#!/usr/bin/python3
import sys

raw_file_list = sys.argv[1:]
raw_file_list.sort()
same_file_lists = []

while len(raw_file_list) > 0:
	tmp_same_file_list = []
	tmp_same_file_list.append(raw_file_list[0])
	target_file_content = open(raw_file_list[0]).readlines()
	for tmp_file_name in raw_file_list[1:]:
		tmp_file_content = open(tmp_file_name).readlines()
		if target_file_content == tmp_file_content:
			tmp_same_file_list.append(tmp_file_name)
	if len(tmp_same_file_list) > 1:
		same_file_lists.append(tmp_same_file_list)
	for file_to_rm in tmp_same_file_list:
		raw_file_list.remove(file_to_rm)

for tmp_same_file_list in same_file_lists:
	print(' '.join(tmp_same_file_list))

