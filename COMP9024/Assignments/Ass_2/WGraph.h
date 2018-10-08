// Weighted Graph ADT interface ... COMP9024 18s2

typedef struct GraphRep *Graph;

typedef struct StackRep *stack;

typedef struct QueueRep *queue;

// vertices are ints
typedef int Vertex;

// edges are pairs of vertices (end-points)
typedef struct Edge {
   Vertex v;
   Vertex w;
   int weight;
} Edge;

Graph newGraph(int);
int   numOfVertices(Graph);
int   validV(Graph, Vertex);
void  insertEdge(Graph, Edge);
void  removeEdge(Graph, Edge);
int   adjacent(Graph, Vertex, Vertex);  // returns weight, or 0 if not adjacent
void  showGraph(Graph);
int   findMaxLength(Graph, int);
int   dfsPathCheck(Graph, Vertex, Vertex, int *);
// stack recordPath(Graph, Vertex, Vertex, int *);
queue bfsPathRecord(Graph, Vertex, int);
queue bfsRecursiveFindPath(Graph, queue);
void  tryatry(queue);
int   nodesHasLongestPath(Graph, Vertex, Vertex);
void  freeGraph(Graph);