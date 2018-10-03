main: components.o Graph.o
	gcc -o main components.o Graph.o
components.o: components.c Graph.h
	gcc -Wall -Werror -std=c11 -c components.c
Graph.o: Graph.c Graph.h
	gcc -Wall -Werror -std=c11 -c Graph.c
clean:
	rm -f main *.o core
