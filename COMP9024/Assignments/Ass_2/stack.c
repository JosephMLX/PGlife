// Stack ADT implementation ... COMP9024 18s2
// Edited by Lingxu Meng for COMP9024 18s2 assignment2

#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include "stack.h"
#include "queue.h"

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

// set up empty stack
stack newStack() {
    stack S = malloc(sizeof(StackRep));
    S->height = 0;
    S->top = NULL;
    return S;
}

// remove unwanted stack
void dropStack(stack S) {
    NodeT *curr = S->top;
    while (curr != NULL) {
        NodeT *temp = curr->next;
        free(curr);
        curr = temp;
    }
    free(S);
}

// check whether stack is empty
int StackIsEmpty(stack S) {
    return (S->height == 0);
}

int StackLength(stack S) {
    int len = 0;
    if (StackIsEmpty(S)) {
        return len;
    } else {
        NodeT *curr = S->top;
        while (curr != NULL) {
            curr = curr->next;
            len++;
        }
    }
    return len;
}

// insert an int on top of stack
void StackPush(stack S, int v) {
    NodeT *new = malloc(sizeof(NodeT));
    assert(new != NULL);
    new->data = v;
    new->next = S->top;
    S->top = new;
    S->height++;
}

// remove int from top of stack
int StackPop(stack S) {
    assert(S->height > 0);
    NodeT *head = S->top;
    S->top = S->top->next;
    S->height--;
    int d = head->data;
    free(head);
    return d;
}

stack StackRemove(stack S) {
    // assert(S->height > 0);
    NodeT *head = S->top;
    S->top = S->top->next;
    S->height--;
    free(head);
    return S;
}

stack StackConvert(stack S) {
    stack converted = newStack();
    while (!StackIsEmpty(S)) {
        int i = StackPop(S);
        StackPush(converted, i);
    }
    return converted;
}
// copy given stack to a new stack
stack CopyStack(stack S) {
    stack temp1 = newStack();
    stack temp2 = newStack();
    stack copied = newStack();
    int i;
    while (!StackIsEmpty(S)) {
        i = StackPop(S);
        StackPush(temp1, i);
        StackPush(temp2, i);
    }
    while (!StackIsEmpty(temp1)) {
        i = StackPop(temp1);
        StackPush(S, i);
    }
    while (!StackIsEmpty(temp2)) {
        i = StackPop(temp2);
        StackPush(copied, i);
    }
    dropStack(temp1);
    dropStack(temp2);
    return copied;
}

void StackPrint(stack S, int *arr) {
    int len = StackLength(S);
    // printf("Stack Length: %d\n", len);
    NodeT *curr = S->top;
    int d = curr->data;
    printf("%d", arr[d]);
    while (len != 1) {
        curr = curr->next;
        d = curr->data;
        printf(" < %d", arr[d]);
        len--;
    }
    printf("\n");
}
