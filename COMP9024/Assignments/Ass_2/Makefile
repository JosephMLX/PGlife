poG: poG.o WGraph.o
	gcc -o poG poG.o WGraph.o
poG.o : poG.c WGraph.h
	gcc -Wall -Werror -std=c11 -c poG.c
WGraph.o : WGraph.c WGraph.h
	gcc -Wall -Werror -std=c11 -c WGraph.c
clean:
	rm -f poG *.o core
