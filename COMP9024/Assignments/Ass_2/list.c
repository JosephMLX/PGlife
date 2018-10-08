// Linked list implementation ... COMP9024 18s2
#include "list.h"
#include "stack.h"
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

typedef struct Node {
   stack  stackData;
   struct Node *next; 
} Node;

typedef struct ListRep {
    int    length;
    Node   *head;
} ListRep;

Node *makeNode(stack s) {
   Node *new = malloc(sizeof(Node));
   assert(new != NULL);
   new->stackData = s;
   new->next = NULL;
   return new;
}

List newLL() {
    List L = malloc(sizeof(ListRep));
    L->length = 0;
    L->head = NULL;
    return L;
}

List insertLL(List L, stack s) {
   if (inLL(L, s))
      return L;

   // add new node at the beginning
   Node *new = makeNode(s);
   new->next = L;
   return new;
}

List deleteLL(List L, stack s) {
   if (L == NULL)
      return L;
   if (L->stackData == s)
      return L->next;

   L->next = deleteLL(L->next, s);
   return L;

}

bool inLL(List L, stack s) {
   if (L == NULL)
      return false;
   if (L->stackData == s)
     return true;

   return inLL(L->next, s);
}

void showLL(List L) {
   if (L == NULL)
      putchar('\n');
   else {
      printf("123123\n");
      // printf("%d ", L->stackData);
      showLL(L->next);
   }
}

void freeLL(List L) {
   if (L != NULL) {
      freeLL(L->next);
      free(L);
   }
}