#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include "Graph.h"

#define MAX_NODES 1000

void MinMaxDegree(Graph g) {
	int degree[MAX_NODES];
	int nV = numOfVertices(g);
	int maxdegree = 0;
	int mindegree = nV - 1;
	int v, w;
	for (v=0; v<nV; v++) {
		degree[v] = 0;
		for (w=0; w<nV; w++) {
			if (adjacent(g, v, w)) {
				degree[v] += 1;
			}
		}
		if (degree[v] < mindegree) {
			mindegree = degree[v];
		}
		if (degree[v] > maxdegree) {
			maxdegree = degree[v];
		}
	}
	printf("Minimum degree: %d\n", mindegree);
	printf("Maximum degree: %d\n", maxdegree);
	
	printf("Nodes of minimum degree:\n");	
	for (v=0; v<nV; v++) {
		if (degree[v] == mindegree) {
			printf("%d\n", v);
		}
	}
	printf("Nodes of maximum degree:\n");
	for (v=0; v<nV; v++) {
		if (degree[v] == maxdegree) {
			printf("%d\n", v);	
		}
	}
}

void show3Cliques(Graph g) {
	int i, j, k;
	int nV = numOfVertices(g);
	
	printf("Triangles:\n");
	for (i=0; i<nV-2; i++) 
		for (j=i+1; j<nV-1; j++) 
			if (adjacent(g, i, j)) 
				for (k=j+1; k<nV; k++) 
					if (adjacent(g, i, k) && adjacent(g, j, k)) 
						printf("%d-%d-%d\n", i, j, k);
}

int main(void) {
	Edge e;
	int n;
	printf("Enter the number of vertices: ");
	scanf("%d", &n);
	Graph g = newGraph(n);
	printf("Enter an edge (from): ");
	while (scanf("%d", &e.v) == 1) {
		printf("Enter an edge (to): ");
		scanf("%d", &e.w);
		insertEdge(g, e);
		printf("Enter an edge (from): ");
	}
	printf("Finished.\n");		
	
	MinMaxDegree(g);
	show3Cliques(g);
	freeGraph(g);	
	return 0;
}
