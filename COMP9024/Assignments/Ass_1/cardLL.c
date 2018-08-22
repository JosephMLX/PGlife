// Linked list of transport card records implementation ... Assignment 1 COMP9024 18s2
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "cardLL.h"
#include "cardRecord.h"

// linked list node type
// DO NOT CHANGE
typedef struct node {
    cardRecordT data;
    struct node *next;
} NodeT;

// linked list type
typedef struct ListRep {
   NodeT *head;

/* Add more fields if you wish */

} ListRep;

/*** Your code for stages 2 & 3 starts here ***/

// Time complexity: O(1)
// Explanation: 
List newLL() {
   List L = malloc(sizeof(ListRep));
   L->head = NULL;
   return L;  /* needs to be replaced */
}

// Time complexity: 
// Explanation: 
void dropLL(List listp) {
   NodeT *curr = listp->head;
   while (curr != NULL) {
      NodeT *temp = curr->next;
      free(curr);
      curr = temp;
   }
   free(listp);  /* needs to be replaced */
}

// Time complexity: 
// Explanation: 
void removeLL(List listp, int cardID) {

   return;  /* needs to be replaced */
}

// Time complexity: 
// Explanation: 
void insertLL(List listp, int cardID, float amount) {
   NodeT *new = malloc(sizeof(NodeT));
   assert(new != NULL);
   new->data.cardID = cardID;
   new->data.balance = amount;
   new->next = listp->head;
   listp->head = new;  /* needs to be replaced */
}

// Time complexity: 
// Explanation: 
void getAverageLL(List listp, int *n, float *balance) {

   return;  /* needs to be replaced */
}

// Time complexity: 
// Explanation: 
void showLL(List listp) {

   return;  /* needs to be replaced */
}
