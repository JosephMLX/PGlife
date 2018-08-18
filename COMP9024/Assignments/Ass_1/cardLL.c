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

// Time complexity: 
// Explanation: 
List newLL() {

   return NULL;  /* needs to be replaced */
}

// Time complexity: 
// Explanation: 
void dropLL(List listp) {

   return;  /* needs to be replaced */
}

// Time complexity: 
// Explanation: 
void removeLL(List listp, int cardID) {

   return;  /* needs to be replaced */
}

// Time complexity: 
// Explanation: 
void insertLL(List listp, int cardID, float amount) {

   return;  /* needs to be replaced */
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
