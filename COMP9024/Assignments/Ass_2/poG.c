#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <stdbool.h>

#include "WGraph.h"
#include "stack.h"
#include "queue.h"

#define MAX_NODES 1000

/*
	Task A: O(n) = n^2;
	Travel from 1 to the input number, caculate the number of divisors and put all divisors into an array
	Used two nested for-loops to determine whether all digits in x also occur in y and create the graph and print

	Task B: O(n) = n^3;
	Firstly, use dfs algorithm to record the longest path can start from each node, and get the longest path distance
	of the whole graph, time complexity is O(n) = n^2 * n = n^3;
	Then, use bfs algorithm to search paths has longest path from the nodes searched before, time complexity O(n) = n^3
	each node has a queue to store all paths, use stack to store each path, finally, print each path in main function
*/

// For Stage 2 and after, all digits in x also occur in y
// Time complexity: O(n) = n, relative to the size of numbers
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
// number of all divisors of input
// Time complexity: O(n) = n, relative to the size of number
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
// Time complexity: O(n) = n, relative to the size of number
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
// Create a weighted graph to express the relation of the set, weight of path = 1
// O(n) = n^2, two nested for loops
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
// print the paths in the graph created
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
	if (argc < 2) {
		printf("Partial order:\n");
		printf("\nLongest monotonically increasing sequences:\n");
		return 0;
	}
	int num = atoi(argv[1]);
	int nodes = divisor_num(num);			// divisor numbers
	int *arr = divisor_list(num, nodes);	// divisor array
	int nodeLength[nodes];					// the longest path starts from each node
	int i, j;
	Graph g = divisor_Graph(nodes, arr);
	printf("Partial order:\n");
	for (i=0; i<nodes; i++) {
		print_partial_order(g, i, arr);
		nodeLength[i] = 0;
	}
	printf("\nLongest monotonically increasing sequences:");
	printf("\n");
	for (i=0; i<nodes; i++) {
		for (j=i; j<nodes; j++) {
			if (nodesHasLongestPath(g, i, j) > nodeLength[i]) {		
				nodeLength[i] = nodesHasLongestPath(g, i, j);	// longest path distance can be started from each node
			}
		}
	}
	int maxPathLength = 0;					// the longest path distance in the graph
	for (i=0; i<nodes; i++) {
		if (nodeLength[i] > maxPathLength)
			maxPathLength = nodeLength[i];
	}
	for (i=0; i<nodes; i++) {
	 	if (nodeLength[i] == maxPathLength) {				// select nodes that can begin a longest path
	 		queue q = bfsPathRecord(g, i, maxPathLength);	// return all longest paths from this node as a queue
			QueuePrint(q, arr);								// print all paths in the returned queue
			dropQueue(q);
		}
	}
	free(arr);
	freeGraph(g);
	return 0;
}

