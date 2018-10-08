poG: poG.o WGraph.o queue.o stack.o
	gcc -o poG poG.o WGraph.o stack.o queue.o
poG.o : poG.c WGraph.h stack.h queue.h
	gcc -Wall -Werror -std=c11 -c poG.c
WGraph.o : WGraph.c WGraph.h stack.h queue.h
	gcc -Wall -Werror -std=c11 -c WGraph.c
queue.o : queue.c queue.h stack.o
	gcc -Wall -Werror -std=c11 -c queue.c
stack.o : stack.c stack.h
	gcc -Wall -Werror -std=c11 -c stack.c
clean:
	rm -f poG *.o core
