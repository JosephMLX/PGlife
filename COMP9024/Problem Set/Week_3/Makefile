rbt: brackets.o Stack.o
		gcc -o rbt brackets.o Stack.o

brackets.o: brackets.c Stack.h
		gcc -Wall -Werror -std=c11 -c brackets.c

Stack.o: Stack.c Stack.h
		gcc -Wall -Werror -std=c11 -c Stack.c
