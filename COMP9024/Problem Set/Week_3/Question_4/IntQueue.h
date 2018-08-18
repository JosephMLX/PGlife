// Integer Queue ADO header file ... COMP9024 18s2
#define MAXITEMS 10

void QueueInit();        // set up empty queue
int  QueueIsEmpty();     // check whether queue is empty
void QueueEnqueue(int);  // insert int at end of queue
int  QueueDequeue();     // remove int from front of queue
