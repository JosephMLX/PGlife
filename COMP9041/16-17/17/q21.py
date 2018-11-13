#!/usr/bin/python3
import sys
import copy

def simplify_str(raw_str):
	return raw_str.lower().replace(' ', '').replace('\n', '')


def is_valid_vote(email, raw_sim_cand_list):
	sim_cand_list = copy.deepcopy(raw_sim_cand_list)
	email_lines_list = open(email).readlines()
	email_lines_list = [simplify_str(x) for x in email_lines_list]
	sim_vote_list = [x for x in email_lines_list if x in sim_cand_list]
	sim_vote_list.sort()
	sim_cand_list.sort()
	return sim_vote_list == sim_cand_list


def get_sim_vote(email, sim_cand_list):
	email_lines_list = open(email).readlines()
	email_lines_list = [simplify_str(x) for x in email_lines_list]
	sim_vote_list = [x for x in email_lines_list if x in sim_cand_list]
	return sim_vote_list


def get_vote_num_list(sim_vote_lists, sim_cand_list):
	vote_num_list = [0] * len(sim_cand_list)
	for tmp_vote_list in sim_vote_lists:
		vote_num_list[sim_cand_list.index(tmp_vote_list[0])] += 1;
	return vote_num_list


def get_valid_email_list(raw_email_list):
	valid_email_list = []
	for tmp_email in raw_email_list:
		if is_valid_vote(tmp_email, sim_cand_list):
			valid_email_list.append(tmp_email)
		else:
			print(tmp_email, "is not a valid vote");
	return valid_email_list
	

def get_final_elected_ind_list(valid_email_list, raw_sim_cand_list):
	sim_cand_list = copy.deepcopy(raw_sim_cand_list)
	vote_num_list = []
	sim_vote_lists = [get_sim_vote(x, sim_cand_list) for x in valid_email_list]
	while len(vote_num_list) == 0 or max(vote_num_list) * 100. / len(vote_num_list) <= 0.5:
		vote_num_list = get_vote_num_list(sim_vote_lists, sim_cand_list)
		min_vote_num = min(vote_num_list)
		if vote_num_list.count(min_vote_num) == len(vote_num_list):
			break
		for i in range(0, len(vote_num_list)):
			if vote_num_list[i] == min_vote_num:
				for tmp_sim_list in sim_vote_lists:
					tmp_sim_list.remove(raw_sim_cand_list[i])
				sim_cand_list.remove(raw_sim_cand_list[i])
	final_elected_ind_list = []
	for i in range(0, len(vote_num_list)):
		if vote_num_list[i] == max(vote_num_list):
			final_elected_ind_list.append(i)
	return final_elected_ind_list


candidate_list = ''.join(open(sys.argv[1]).readlines()).split('\n')
candidate_list = [x for x in candidate_list if x != '']
sim_cand_list = [simplify_str(x) for x in candidate_list]
valid_email_list = get_valid_email_list(sys.argv[2:])
		
final_elected_ind_list = get_final_elected_ind_list(valid_email_list, sim_cand_list)
final_elected_name_list = [candidate_list[i] for i in final_elected_ind_list]
print('\n'.join(final_elected_name_list))

