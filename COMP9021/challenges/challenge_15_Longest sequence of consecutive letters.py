# Prompts the user for a string w of lowercase letters and outputs the
# longest sequence of consecutive letters that occur in w,
# but with possibly other letters in between, starting as close
# as possible to the beginning of w.


import sys


# Insert your code here
string = str(input('Please input a string of lowercase letters: '))
list_ord = [ord(e) for e in list(str(string))]
list_ord = sorted(list_ord)
set_ord = set(list_ord)

unique_list = list(set_ord)
length = 1
start = unique_list[0]
longest = [unique_list[0]]
result = [unique_list[0]]

for i in range(1, len(unique_list)):
    if unique_list[i] - unique_list[i-1] == 1:
        longest.append(unique_list[i])
    else:
        if len(longest) > length:
            result = longest
            length = len(longest)
        start = unique_list[i]
        longest = [unique_list[i]]
    if i == len(unique_list) - 1 and len(longest) > length:
        result = longest
        length = len(longest)

print('The solution is: ', end = '')
for e in result:
    print(chr(e), end = '')
print()
