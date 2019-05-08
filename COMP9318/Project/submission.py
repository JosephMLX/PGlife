# Import your files here...
import re
import numpy as np
import math


# helper function to split given file into parts we need
def split_file(file):
    f = open(file, 'r')
    lines = f.readlines()
    lines = ([l.strip('\n') for l in lines])
    file_num = int(lines[0])                # how many ids in the file
    id_list = lines[1:file_num+1]           # id list
    frequency = lines[file_num+1:]          # frequency list
    return file_num, id_list, frequency


# extract all tokens from Query File
def get_query_tokens(symbol_ids, Query_File):
    f = open(Query_File, 'r')
    lines = f.readlines()
    lines = ([l.strip('\n') for l in lines])
    symbol_set = set(symbol_ids)
    for i, x in enumerate(lines):
        tmp_line = lines[i].split()
        for index, item in enumerate(tmp_line):
            # special_char: , / - ( ) & split each query by them
            tmp_line[index] = re.split(r'([,()/&-])', item)
        lines[i] = []
        for index_outer in range(len(tmp_line)):
            for index_inner in range(len(tmp_line[index_outer])):
                lines[i].append(tmp_line[index_outer][index_inner])
        # lines[i] = re.split('([^a-zA-Z0-9.?])', x)
        lines[i] = list(filter(lambda x: x != '', lines[i]))
        lines[i] = list(filter(lambda x: x != ' ', lines[i]))
        for j, word in enumerate(lines[i]):
            if word not in symbol_set:
                lines[i][j] = -1
            else:
                lines[i][j] = symbol_ids.index(lines[i][j])
    return lines
    

def get_transition(state_num, state_fre):
    # calculate the transition pr
    transition_frequency = np.zeros((state_num, state_num))
    state_probability = np.zeros((state_num, state_num))
    for f in state_fre:
        s_1, s_2, times = list(map(int, f.split(" ")))
        transition_frequency[s_1][s_2] = times
    for i in range(len(transition_frequency)):
        sum_i = sum(transition_frequency[i])
        if i == state_num-1:
        # j is end state, keep A[END, j] be 0
            continue
        else:
            for j in range(len(transition_frequency[i])):
                if j == state_num-2:
                    # i is begin state, keep A[i,BEGIN] be 0
                    continue
                else:
                    state_probability[i][j] = (transition_frequency[i][j] + 1) / (sum_i + state_num - 1)

    return state_probability


def get_emission(state_num, symbol_fre, symbol_num):
    # calculate the emission pr
    emission_frequency = np.zeros((state_num, symbol_num+1))
    emission_probability = np.zeros((state_num, symbol_num+1))
    for f in symbol_fre:
        s1, s2, times = map(int, f.split(' '))
        emission_frequency[s1][s2] = times
    for i in range(len(emission_probability)):
        sum_i = sum(emission_frequency[i])
        if i >= state_num - 2:
            continue
        for j in range(len(emission_probability[i])):
            if j == symbol_num:
                # j is UNK
                emission_probability[i][j] = 1/(sum_i+symbol_num+1)
            else:
                emission_probability[i][j] = (emission_frequency[i][j]+1)/(sum_i+symbol_num+1)
    return emission_probability


# Question 1
def viterbi_algorithm(State_File, Symbol_File, Query_File): # do not change the heading of the function
    state_num, state_ids, state_fre = split_file(State_File)
    symbol_num, symbol_ids, symbol_fre = split_file(Symbol_File)
    A = get_transition(state_num, state_fre)
    B = get_emission(state_num, symbol_fre, symbol_num)
    query_tokens = get_query_tokens(symbol_ids, Query_File)
    result = []
    for q in query_tokens:
        # for each query
        # table = [[0 for i in range(len(q))] for j in range(state_num)]
        delta = np.zeros((state_num-2, len(q)+1))
        phsis = np.zeros((state_num-2, len(q)))
        for o in range(len(q)):
            for s in range(state_num-2):
                # print(delta[s][o])
                if o == 0:
                    delta[s][o] = np.log(A[-2][s]) + np.log(B[s][q[o]])
                else:
                    candidates = []
                    for s_prime in range(state_num-2):
                        a = delta[s_prime][o-1] \
                            +np.log(A[s_prime][s])+np.log(B[s][q[o]])
                        candidates.append(a)
                    delta[s][o] = max(candidates)
                    former_position = candidates.index(delta[s][o])
                    phsis[s][o] = former_position
        final_array = []
        for s in range(state_num-2):
            delta[s][-1] = delta[s][-2] + np.log(A[s][-1])
            final_array.append(delta[s][-1])
        final_possibility = max(final_array)
        final_state = final_array.index(final_possibility)
        path = [state_num-1]
        path.append(final_state)
        i = len(q)-1
        while i > 0:
            path.append(int(phsis[final_state][i]))
            final_state = int(phsis[final_state][i])
            i-=1
        path.append(state_num-2)
        path = path[::-1]
        path.append(final_possibility)
        result.append(path)
    return result


# grab a (top-k values, state) tuple from all of the last step values
# delta is the probability table
# o is current observation
def grab_last_k_values(delta, k, o, cur_state, q, A, B, line_status):
    # line_status: 1 --> First Line; 2--> Middle Lines; 3--> Last Line;
    states = len(delta)
    former_candidates = []
    for s in range(states):                             # s is the num of state
        for v in range(len(delta[s][o-1])):         # v is each value in delta[s][t]
            # import pdb; pdb.set_trace()
            if line_status <= 2:
                probability = delta[s][o-1][v] \
                    +np.log(A[s][cur_state])\
                    +np.log(B[cur_state][q])
            if line_status == 3:
                probability = delta[s][o-1][v] \
                    +np.log(A[s][cur_state])
            position = s
            former_candidates.append((probability, (position, v)))
    res = sorted(former_candidates, reverse=True)
    return res[:k]


# Question 2
def top_k_viterbi(State_File, Symbol_File, Query_File, k): # do not change the heading of the function
    state_num, state_ids, state_fre = split_file(State_File)
    symbol_num, symbol_ids, symbol_fre = split_file(Symbol_File)
    A = get_transition(state_num, state_fre)
    B = get_emission(state_num, symbol_fre, symbol_num)
    query_tokens = get_query_tokens(symbol_ids, Query_File)
    result = []
    for q in query_tokens:
        # for each query
        # print(q)
        delta = np.zeros((state_num-2, len(q)+1, k))
        phsis = np.zeros((state_num-2, len(q)+1, k, 2))
        for o in range(len(q)):
            for s in range(state_num-2):
                if o == 0:  # initial value
                    delta[s][o][0] = np.log(A[-2][s])+np.log(B[s][q[o]])
                    for i in range(1, k):
                        delta[s][o][i] = -math.inf
                    phsis[s][o] = s
                else:
                    line_status = 1 if o == 1 else 2
                    candidates = grab_last_k_values(delta, k, o, s, q[o],\
                                                     A, B, line_status)
                    for i in range(len(candidates)):
                        delta[s][o][i] = candidates[i][0]
                        phsis[s][o][i][0] = candidates[i][1][0]
                        phsis[s][o][i][1] = candidates[i][1][1]      

        for s in range(state_num-2):
            candidates = grab_last_k_values(delta, k, len(q), -1, q[-1], A, B, 3)
            # print(candidates)
            for i in range(len(candidates)):
                delta[s][-1][i] = candidates[i][0]
                phsis[s][-1][i][0] = candidates[i][1][0]
                phsis[s][-1][i][1] = candidates[i][1][1]
        # back trace
        print(delta)
        print(phsis)
        for i_k in range(k):
            i = len(q)-1
            final_state = int(phsis[-1][-1][i_k][0])
            v = int(phsis[-1][-1][i_k][1])
            path = [state_num-1, final_state]
            while i > 0:
                pre_state = final_state
                final_state = int(phsis[final_state][i][v][0])
                path.append(final_state)
                v = int(phsis[pre_state][i][v][1])
                i -= 1
            path = path[::-1]
            path += [delta[0][-1][i_k]]
            path = [state_num-2] + path
            result.append(path)
    return result
            

# Question 3 + Bonus
def advanced_decoding(State_File, Symbol_File, Query_File): # do not change the heading of the function
    pass # Replace this line with your implementation...


# if __name__ == "__main__":
#     State_File = './toy_example/State_File'
#     Symbol_File = './toy_example/Symbol_File'
#     Query_File = './toy_example/Query_File'
#     k = 2
#     State_File = './dev_set/State_File'
#     Symbol_File = './dev_set/Symbol_File'
#     Query_File = './dev_set/Query_File'
#     viterbi_result = viterbi_algorithm(State_File, Symbol_File, Query_File)
#     for row in viterbi_result:
#         print(row)
#     top_k_viterbi(State_File, Symbol_File, Query_File, k)
#     top_k_viterbi_result = top_k_viterbi(State_File, Symbol_File, Query_File, k)
#     for row in top_k_viterbi_result:
#         print(row)
