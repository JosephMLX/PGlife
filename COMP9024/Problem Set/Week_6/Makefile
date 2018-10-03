main: graphAnalyser.o Graph.o
	gcc -o main graphAnalyser.o Graph.o
graphAnalyser.o : graphAnalyser.c Graph.h
	gcc -Wall -Werror -std=c11 -c graphAnalyser.c
Graph.o : Graph.c Graph.h
	gcc -Wall -Werror -std=c11 -c Graph.c
clean:
	rm -f main *.o core
