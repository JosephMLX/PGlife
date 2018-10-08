 // Queue ADT header file ... COMP9024 18s2

typedef struct QueueRep *queue;

typedef struct StackRep *stack;

queue newQueue();               // set up empty queue
void  dropQueue(queue);         // remove unwanted queue
int   QueueIsEmpty(queue);      // check whether queue is empty
int   QueueLength(queue);		// caculate queue length
void  QueueEnqueue(queue, stack); // insert an int at end of queue
stack QueueDequeue(queue);      // remove int from front of queue
void  QueuePrint(queue, int *);		// print all stacks in queue