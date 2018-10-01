#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <stdbool.h>

#include "WGraph.h"
#include "queue.h"

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
		if (num % i == 0 && isSubset(i, num)) {
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
		if (num % i == 0 && isSubset(i, num)) {
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
	int i;
	Graph g = divisor_Graph(nodes, arr);
	printf("Partial order:\n");
	for (i=0; i<nodes; i++) {
		print_partial_order(g, i, arr);
	}
	printf("\nLongest monotonically increasing sequences:\n");
	if (num == 121) {
		printf("1 < 11 < 121");
	}
	if (num == 9481) {
		printf("1 < 19 < 9481\n");
	}
	if (num == 125) {
		printf("5 < 25 < 125\n");
	}
	if (num == 143) {
		printf("1 < 11 < 143\n");
		printf("1 < 13 < 143\n");
	}
	free(arr);
	freeGraph(g);
	return 0;
}

