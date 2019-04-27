## import modules here
import submission as submission
import math
import re


################# Question 0 #################


def add(a, b):  # do not change the heading of the function
    return a + b


################# Question 1 #################

def nsqrt(x):  # do not change the heading of the function
    left, right = 1, x
    while True:
        mid = int((left + right) / 2)
        if mid ** 2 <= x < (mid + 1) ** 2:
            return mid
        elif mid ** 2 > x:
            right = mid
        else:
            left = mid


################# Question 2 #################


# x_0: initial guess
# EPSILON: stop when abs(x - x_new) < EPSILON
# MAX_ITER: maximum number of iterations

## NOTE: you must use the default values of the above parameters, do not change them

# def f(x):
#     return x * math.log(x) - 16.0
#
#
# def fprime(x):
#     return 1.0 + math.log(x)


def find_root(f, fprime, x_0=1.0, EPSILON=1E-7, MAX_ITER=1000):  # do not change the heading of the function
    for i in range(MAX_ITER):
        x = x_0 - f(x_0) / fprime(x_0)
        if abs(x - x_0) <= EPSILON:
            return x
        x_0 = x
    return x


################# Question 3 #################

class Tree(object):
    def __init__(self, name='ROOT', children=None):
        self.name = name
        self.children = []
        if children is not None:
            for child in children:
                self.add_child(child)

    def __repr__(self):
        return self.name

    def add_child(self, node):
        assert isinstance(node, Tree)
        self.children.append(node)


def print_tree(root, indent=0):
    print(' ' * indent, root)
    if len(root.children) > 0:
        for child in root.children:
            print_tree(child, indent + 4)


def myfind(s, char):
    pos = s.find(char)
    if pos == -1:  # not found
        return len(s) + 1
    else:
        return pos


def next_tok(s):  # returns tok, rest_s
    if s == '':
        return (None, None)
    # normal cases
    poss = [myfind(s, ' '), myfind(s, '['), myfind(s, ']')]
    min_pos = min(poss)
    if poss[0] == min_pos:  # separator is a space
        tok, rest_s = s[: min_pos], s[min_pos + 1:]  # skip the space
        if tok == '':  # more than 1 space
            return next_tok(rest_s)
        else:
            return (tok, rest_s)
    else:  # separator is a [ or ]
        tok, rest_s = s[: min_pos], s[min_pos:]
        if tok == '':  # the next char is [ or ]
            return (rest_s[:1], rest_s[1:])
        else:
            return (tok, rest_s)


def str_to_tokens(str_tree):
    # remove \n first
    str_tree = str_tree.replace('\n', '')
    out = []

    tok, s = next_tok(str_tree)
    while tok is not None:
        out.append(tok)
        tok, s = next_tok(s)
    return out


def make_tree(tokens):  # do not change the heading of the function
    # ignore the situation that token is None
    code = 'Tree(\'' + tokens[0] + '\','
    for i in range(1, len(tokens) - 1):
        if tokens[i] == '[':
            sub_code = '['
        elif tokens[i] == ']':
            if tokens[i+1] == ']':
                sub_code = ']) '
            else:
                sub_code = ']), '
        elif tokens[i+1] == '[':
            sub_code = 'Tree(\'' + tokens[i] + '\','
        else:
            sub_code = "Tree('" + tokens[i] + "'), "
        code += sub_code
    code += '])'
    return eval(code)


def max_depth(root):  # do not change the heading of the function
    if not root.children:
        return 1
    deepest_depth = 0
    for i, x in enumerate(root.children):
        if max_depth(x) > deepest_depth:
            deepest_depth = max_depth(x)
    return deepest_depth + 1
