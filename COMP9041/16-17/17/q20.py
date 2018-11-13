#!/usr/bin/python3
import sys

def get_digit_of_letter(lett):
	if lett == 'a' or lett == 'b' or lett == 'c':
		return '2'
	if lett == 'd' or lett == 'e' or lett == 'f':
		return '3'
	if lett == 'g' or lett == 'h' or lett == 'i':
		return '4'
	if lett == 'j' or lett == 'k' or lett == 'l':
		return '5'
	if lett == 'm' or lett == 'n' or lett == 'o':
		return '6'
	if lett == 'p' or lett == 'q' or lett == 'r' or lett == 's':
		return '7'
	if lett == 't' or lett == 'u' or lett == 'v':
		return '8'
	if lett == 'w' or lett == 'x' or lett == 'y' or lett == 'z':
		return '9'
	return ''


def get_digits_of_word(word):
	digits_str = ''
	for char in word:
		digits_str += get_digit_of_letter(char)
	return digits_str


def get_matched_index_list_of_digits(digits, digits_list):
	matched_index_list = []
	for i in range(len(digits_list)):
		if digits_list[i] == digits:
			matched_index_list.append(i)
	return matched_index_list


def get_split_of_digits(digits):
	split_lists = []
	split_lists.append([digits])
	for i in range(1, len(digits)):
		split_lists.append([digits[:i], digits[i:]])
	return split_lists
		

def gen_cross_str_list(list1, list2):
	cross_str_list = []
	for word1 in list1:
		for word2 in list2:
			cross_str_list.append(word1 + ' ' + word2 + '\n')
	return cross_str_list


raw_word_str = ''.join(open(sys.argv[1]).readlines()).replace('\n', ' ')
word_list = raw_word_str.split(' ')
word_list = [x for x in word_list if x != '']
word_digits_list = [get_digits_of_word(x) for x in word_list]
result_list = []
digits_split_lists = get_split_of_digits(sys.argv[2])
print(digits_split_lists)


for tmp_list in digits_split_lists:
	if len(tmp_list) == 1:
		tmp_matched_index_list = get_matched_index_list_of_digits(tmp_list[0], word_digits_list)
		if len(tmp_matched_index_list) > 0:
			result_list.extend([word_list[x] + '\n' for x in tmp_matched_index_list])
	elif len(tmp_list) == 2:
		tmp_matched_index_list1 = get_matched_index_list_of_digits(tmp_list[0], word_digits_list)
		tmp_matched_index_list2 = get_matched_index_list_of_digits(tmp_list[1], word_digits_list)
		if len(tmp_matched_index_list1) > 0 and len(tmp_matched_index_list2) > 0:
			tmp_matched_word_list1 = [word_list[x] for x in tmp_matched_index_list1]
			tmp_matched_word_list2 = [word_list[x] for x in tmp_matched_index_list2]
			result_list.extend(gen_cross_str_list(tmp_matched_word_list1, tmp_matched_word_list2))
	
print(''.join(result_list), end = '')

