#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <stdbool.h>

#include "WGraph.h"
#include "stack.h"

#define MAX_NODES 1000

bool isSubset(int i, int j) {
	int digit_i[10] = {};
	int digit_j[10] = {};
	int k;
	while (i > 0) {
		int remainder_i = i % 10;
		digit_i[remainder_i] = 1;
		i /= 10;
	}
	while (j > 0) {
		int remainder_j = j % 10;
		digit_j[remainder_j] = 1;
		j /= 10;
	}
	for (k = 0; k<10; k++) {
		if (digit_i[k] > digit_j[k]) {
			return false;
		}
	}
	return true;
}
// number of divisors of input
int divisor_num(int num) {		
	int i;
	int j = 0;
	for (i=1; i<=num; i++) {
		if (num % i == 0) {
			j += 1;
		}
	}
	return j;
}
// list of all divisors of input
int *divisor_list(int num, int len) {
	int *arr;
	int i;
	int j = 0;
	arr = malloc(len * sizeof(int));
	assert(arr != NULL);
	for (i=1; i<=num; i++) {
		if (num % i == 0) {
			arr[j] = i;
			j++;
		}
	}
	return arr;
}

Graph divisor_Graph(int nodes, int *arr) {
	Graph g = newGraph(nodes);
	int i, j;
	for (i=0; i<nodes-1; i++) {
		for (j=1; j<nodes; j++) {
			if (arr[j] % arr[i] == 0 && arr[i] != arr[j] && isSubset(arr[i], arr[j])) {
				Edge e;
				e.v = i;
				e.w = j;
				e.weight = 1;
				insertEdge(g, e);
			}
		}
	}
	return g;
}

void print_partial_order(Graph g, int i, int *arr) {
	int nodes = numOfVertices(g);
	int j;
	printf("%d:", arr[i]);
	for (j=i+1; j<nodes; j++) {
		if (adjacent(g, i, j) == 1) {
			printf(" %d", arr[j]);
		}
	}
	printf("\n");
}

int main(int argc, char *argv[]) {
	int num = atoi(argv[1]);
	int nodes = divisor_num(num);
	int *arr = divisor_list(num, nodes);
	int nodeLength[nodes];
	int i;
	Graph g = divisor_Graph(nodes, arr);
	printf("Partial order:\n");
	for (i=0; i<nodes; i++) {
		print_partial_order(g, i, arr);
		nodeLength[i] = nodesHasLongestPath(g, i, nodes-1);
	}
	printf("\nLongest monotonically increasing sequences:");
	// showGraph(g);
	int m = findMaxLength(g, nodes);
	if (m == 0) {
		for (i=0; i<nodes; i++) {
			printf("\n%d", arr[i]);
		}
	}
	for (i=0; i<nodes; i++) {
		if (nodeLength[i] == m) {
			// printPath(g, i, nodes-1, arr);
			stack s = recordPath(g, i, nodes-1, arr);
			printf("\n");
			StackPrint(s);
		}
	}
	// StackPush(s, 25);
	// StackPush(s, 5);
	// printf("%d\n", StackLength(s));
	// StackPrint(s);
	
	// printf("\n%d\n", findPathDFS(g, 0, 1));
	free(arr);
	freeGraph(g);
	return 0;
}

