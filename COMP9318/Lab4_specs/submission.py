## import modules here
# import pandas as pd
# import numpy as np


################# Question 1 #################
# def tokenize(sms):
#     return sms.split(' ')
#
#
# def get_freq_of_tokens(sms):
#     tokens = {}
#     for token in tokenize(sms):
#         if token not in tokens:
#             tokens[token] = 1
#         else:
#             tokens[token] += 1
#     return tokens


def word_statistic(dic_indi, dic_multi):
    for i in dic_indi:
        if i not in dic_multi:
            dic_multi[i] = dic_indi.get(i)
        else:
            dic_multi[i] += dic_indi.get(i)
    return dic_multi


def nb(w, d, p, v):
    if d.get(w):
        p = p * ((d.get(w) + 1) / (sum(d.values()) + v))
    else:
        p = p * 1 / (sum(d.values()) + v)
    return p


def multinomial_nb(training_data, sms):
    p_ham = 0
    ham_dict = {}
    spam_dict = {}
    for i in training_data:
        if i[1] == 'ham':
            p_ham += 1
            word_statistic(i[0], ham_dict)
        else:
            word_statistic(i[0], spam_dict)

    p_ham = p_ham / len(training_data)
    p_spam = 1 - p_ham
    set_vocabulary = len(set(ham_dict) | set(spam_dict))

    for w in list(sms):
        if w not in ham_dict and w not in spam_dict:
            continue
        else:
            p_ham = nb(w, ham_dict, p_ham, set_vocabulary)
            p_spam = nb(w, spam_dict, p_spam, set_vocabulary)

    # print(ham_dict)
    # print(spam_dict)
    # print(set_vocabulary)
    return p_spam/p_ham


# if __name__ == "__main__":
#     raw_data = pd.read_csv('./asset/data.txt', sep='\t')
#     raw_data.head()
#
#     training_data = []
#     for index in range(len(raw_data)):
#         training_data.append((get_freq_of_tokens(raw_data.iloc[index].text), raw_data.iloc[index].category))
#
#     sms = 'I am not spam'
#     print(multinomial_nb(training_data, tokenize(sms)))
