// Stack ADT header file ... COMP9024 18s2

typedef struct QueueRep *queue;

typedef struct StackRep *stack;

stack newStack();             // set up empty stack
void  dropStack(stack);       // remove unwanted stack
int   StackIsEmpty(stack);    // check whether stack is empty
int   StackLength(stack);	  // return the length of stack
stack StackConvert(stack);	  // convert stack
void  StackPush(stack, int);  // insert an int on top of stack
int   StackPop(stack);        // remove int from top of stack
stack StackRemove(stack);	  // remove the toppest node
stack CopyStack(stack);		  // copy a stack
void  StackPrint(stack, int *);	  // print stack in required model
