// Stack ADO implementation ... COMP9024 18s2

#include "Stack.h"
#include <assert.h>

typedef struct {
   char item[MAXITEMS];
   int  top;
} stackRep;                   // defines the Data Structure

static stackRep stackObject;  // defines the Data Object

void StackInit() {            // set up empty stack
   stackObject.top = -1;
}

int StackIsEmpty() {          // check whether stack is empty
   return (stackObject.top < 0);
}

void StackPush(char ch) {     // insert char on top of stack
   assert(stackObject.top < MAXITEMS-1);
   stackObject.top++;
   int i = stackObject.top;
   stackObject.item[i] = ch;
}

char StackPop() {             // remove char from top of stack
   assert(stackObject.top > -1);
   int i = stackObject.top;
   char ch = stackObject.item[i];
   stackObject.top--;
   return ch;
}
