# Prompts the user for an amount, and outputs the minimal number of banknotes
# needed to match that amount, as well as the detail of how many banknotes
# of each type value are used.
# The available banknotes have a face value which is one of
# $1, $2, $5, $10, $20, $50, and $100.


# Insert your code here    
amount = int(input('Input the desired amount: '))
banknote = [0] * 7
denomination = [100, 50, 20, 10, 5, 2, 1]
i = 0
while i <= 6:
    banknote[i] = amount // denomination[i]
    amount -= banknote[i] * denomination[i]
    i += 1

print()
if sum(banknote) == 1:
    print('1 banknote is needed.')
else:
    print(f'{sum(banknote)} banknotes are needed.')
print('The detail is:')
for i in range(len(banknote)):
    if banknote[i] != 0:
        deno = '$'+str(denomination[i])
        print(f'{deno:>4}: {banknote[i]}')

