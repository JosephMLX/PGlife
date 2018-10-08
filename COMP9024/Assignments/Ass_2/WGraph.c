// Weighted Directed Graph ADT
// Adjacency Matrix Representation ... COMP9024 18s2
// Edited by Lingxu Meng for COMP9024 18s2 assignment2
#include "WGraph.h"
#include "queue.h"
#include "stack.h"
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

typedef struct GraphRep {
   int **edges;  // adjacency matrix storing positive weights
		 // 0 if nodes not adjacent
   int nV;       // #vertices
   int nE;       // #edges
} GraphRep;

typedef struct node {
    int data;
    struct node *next;
} NodeT;

typedef struct StackRep {
    int    height;
    NodeT *top;
} StackRep;

typedef struct stackNode {
   stack stackData;
   struct stackNode *next;
} NodeTS;

typedef struct QueueRep {
   int   length;
   NodeTS *head;
   NodeTS *tail;
} QueueRep;

Graph newGraph(int V) {
   assert(V >= 0);
   int i;

   Graph g = malloc(sizeof(GraphRep));
   assert(g != NULL);
   g->nV = V;
   g->nE = 0;

   // allocate memory for each row
   g->edges = malloc(V * sizeof(int *));
   assert(g->edges != NULL);
   // allocate memory for each column and initialise with 0
   for (i = 0; i < V; i++) {
      g->edges[i] = calloc(V, sizeof(int));
      assert(g->edges[i] != NULL);
   }

   return g;
}

int numOfVertices(Graph g) {
   return g->nV;
}

// check if vertex is valid in a graph
int validV(Graph g, Vertex v) {
   return (g != NULL && v >= 0 && v < g->nV);
}

void insertEdge(Graph g, Edge e) {
   assert(g != NULL && validV(g,e.v) && validV(g,e.w));

   if (g->edges[e.v][e.w] == 0) {   // edge e not in graph
      g->edges[e.v][e.w] = e.weight;
      g->nE++;
   }
}

void removeEdge(Graph g, Edge e) {
   assert(g != NULL && validV(g,e.v) && validV(g,e.w));

   if (g->edges[e.v][e.w] != 0) {   // edge e in graph
      g->edges[e.v][e.w] = 0;
      g->nE--;
   }
}

int adjacent(Graph g, Vertex v, Vertex w) {
   assert(g != NULL && validV(g,v) && validV(g,w));

   return g->edges[v][w];
}

void showGraph(Graph g) {
    assert(g != NULL);
    int i, j;

    printf("Number of vertices: %d\n", g->nV);
    printf("Number of edges: %d\n", g->nE);
    for (i = 0; i < g->nV; i++)
       for (j = 0; j < g->nV; j++)
	  if (g->edges[i][j] != 0)
	     printf("Edge %d - %d: %d\n", i, j, g->edges[i][j]);
}
/* not used function

// int findMaxLength(Graph g, int nV) {
//   int i, j;
//   int maxDistance[nV];
//   for (i=0; i<nV; i++) {
//     maxDistance[i] = 0;
//   }
//   int max_path_length = 0;
//   for (i = 0; i < nV; i++) {
//     for (j = i + 1; j < nV; j++) {
//       if (adjacent(g, i, j) && maxDistance[j] <= maxDistance[i] + 1) {
//         maxDistance[j] = maxDistance[i] + 1;
//         if (maxDistance[j] > max_path_length) {
//           max_path_length = maxDistance[j];
//         }
//       }
//     }
//   }
//   return max_path_length;
// }
*/

int dfsPathCheck(Graph g, Vertex v, Vertex dest, int *visited) {
  Vertex w;
  if (v == dest)
    return 1;
  else {
    for (w=0; w<numOfVertices(g); w++) {
      if (adjacent(g, v, w) == 1 && visited[w] == -1) {
        visited[w] = v;
        if (dfsPathCheck(g, w, dest, visited))
          return 1;
      }
    }
  }
  return 0;
}

int nodesHasLongestPath(Graph g, Vertex src, Vertex dest) {
  int nV = numOfVertices(g);
  int visited[nV];
  int l = 0;
  Vertex v;
  for (v=0; v<nV; v++) {
    visited[v] = -1;
  }
  if (dfsPathCheck(g, src, dest, visited) == 1) {
    Vertex v = dest;
    while (v != src) {
      l++;
      v = visited[v];
    }
  }
  return l;
}

queue bfsPathRecord(Graph g, Vertex src,int max) {
  queue q = newQueue();
  stack s = newStack();
  StackPush(s, src);
  QueueEnqueue(q, s);
  int p = 0;
  while (p < max) {
    q = bfsRecursiveFindPath(g, q);
    p++;
  }
  return q;
}

queue bfsRecursiveFindPath(Graph g, queue q) {
  queue temp = q;
  q = newQueue();
  int nV = numOfVertices(g);
  // NodeTS *currQ = temp->head;
  while (!QueueIsEmpty(temp)) {
    int i;
    int visited[nV];
    for (i=0; i<nV; i++)
      visited[i] = -1;
    stack s = QueueDequeue(temp);
    NodeT *curr = s->top;
    int last_node = curr->data;
    visited[last_node] = last_node;
    int next_node;
    for (next_node=last_node; next_node<nV; next_node++) {
        stack s1 = CopyStack(s);
      if (adjacent(g, last_node, next_node) == 1 && visited[next_node] == -1) {
        StackPush(s1, next_node);
        QueueEnqueue(q, s1);
        visited[next_node] = last_node;
      }
    }
  }
  return q;
}

void freeGraph(Graph g) {
   assert(g != NULL);

   int i;
   for (i = 0; i < g->nV; i++)
      free(g->edges[i]);
   free(g->edges);
   free(g);
}