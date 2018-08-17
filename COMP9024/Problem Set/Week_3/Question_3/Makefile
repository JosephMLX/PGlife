binary: binary.o Int_Stack.o
		gcc -o binary binary.o Int_Stack.o

binary.o: binary.c Int_Stack.h
		gcc -Wall -Werror -std=c11 -c binary.c

Int_Stack.o: Int_Stack.c Int_Stack.h
		gcc -Wall -Werror -std=c11 -c Int_Stack.c
