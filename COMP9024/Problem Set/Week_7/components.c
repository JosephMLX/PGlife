#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include "Graph.h"
#define MAX_NODES 1000

int componentOf[MAX_NODES];

void dfsComponents(Graph g, int v, int id) {
	componentOf[v] = id;
	Vertex w;
	for (w=0; w<numOfVertices(g); w++)
		if (adjacent(g, v, w) && componentOf[w] == -1)
			dfsComponents(g, v, id);
}

int components(Graph g) {
	Vertex v;
	int nv = numOfVertices(g);
	for (v=0; v<nv; v++)
		componentOf[v] = -1;

	int compID = 0;
	for (v=0; v<nv; v++) {
		if (componentOf[v] == -1) {
			dfsComponents(g, v, compID);
			compID++;
		}
	}
	return compID;
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
	int i, c = components(g);
	printf("Number of connected components: %d\n", c);
	for (i = 0; i < c; i++) {
   		printf("Component %d:\n", i+1);
   		Vertex v;
   		for (v = 0; v < numOfVertices(g); v++)
      		if (componentOf[v] == i)
	 			printf("%d\n", v);
	}
}
