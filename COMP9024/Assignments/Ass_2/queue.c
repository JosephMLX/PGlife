// Queue ADT implementation ... COMP9024 18s2
// Edited by Lingxu Meng for COMP9024 18s2 assignment2

#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include "queue.h"
#include "stack.h"

typedef struct stackNode {
   stack stackData;
   struct stackNode *next;
} NodeTS;

typedef struct QueueRep {
   int   length;
   NodeTS *head;
   NodeTS *tail;
} QueueRep;

typedef struct node {
    int data;
    struct node *next;
} NodeT;

typedef struct StackRep {
    int    height;
    NodeT *top;
} StackRep;

// set up empty queue
queue newQueue() {
   queue Q = malloc(sizeof(QueueRep));
   Q->length = 0;
   Q->head = NULL;
   Q->tail = NULL;
   return Q;
}

// remove unwanted queue
void dropQueue(queue Q) {
   NodeTS *curr = Q->head;
   while (curr != NULL) {
      NodeTS *temp = curr->next;
      free(curr);
      curr = temp;
   }
   free(Q);
}

// check whether queue is empty
int QueueIsEmpty(queue Q) {
   return (Q->length == 0);
}

int QueueLength(queue Q) {
    int len = 0;
    if (QueueIsEmpty(Q)) {
        return len;
    } else {
        NodeTS *curr = Q->head;
        while (curr != NULL) {
            curr = curr->next;
            len++;
        }
    }
    return len;
}

// insert an int at end of queue
void QueueEnqueue(queue Q, stack s) {
   NodeTS *new = malloc(sizeof(NodeTS));
   assert(new != NULL);
   new->stackData = s;
   new->next = NULL;
   if (Q->tail != NULL) {
      Q->tail->next = new;
      Q->tail = new;
   } else {
      Q->head = new;
      Q->tail = new;
   }
   Q->length++;
}

// remove int from front of queue
stack QueueDequeue(queue Q) {
   assert(Q->length > 0);
   NodeTS *p = Q->head;
   Q->head = Q->head->next;
   if (Q->head == NULL) {
      Q->tail = NULL;
   }
   Q->length--;
   stack s = p->stackData;
   free(p);
   return s;
}

void QueuePrint(queue Q, int *arr) {
  // int len = QueueLength(Q);
  // printf("QueueLength3: %d\n", len);
  NodeTS *curr = Q->head;
  while (curr != NULL) {
    stack s = curr->stackData;
    // int len = StackLength(s);
    // printf("before: %d\n", len);
    stack c = StackConvert(s);
    // len = StackLength(c);
    // printf("after: %d\n", len);
    StackPrint(c, arr);
    curr = curr->next;
  }
}
