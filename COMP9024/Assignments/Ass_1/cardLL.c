// Linked list of transport card records implementation ... Assignment 1 COMP9024 18s2
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>
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
   free(listp);
}

// Time complexity: 
// Explanation: 
void removeLL(List listp, int cardID) {
   NodeT *slow = listp->head;
   printf("cardID: %d\n", slow->data.cardID);
}

// Time complexity: 
// Explanation: 
void insertLL(List listp, int cardID, float amount) {
   NodeT *new = malloc(sizeof(NodeT));
   assert(new != NULL);
   new->data.cardID = cardID;
   new->data.balance = amount;
   new->next = listp->head;
   listp->head = new;
}

// Time complexity: 
// Explanation: 
void getAverageLL(List listp, int *n, float *balance) {
   NodeT *start = listp->head;
   int cardNum = 0;
   float avg = 0;
   while (start != NULL) {
      cardNum++;
      avg += start->data.balance;
      start = start->next;
   }
   if (cardNum == 0) {
      printf("Number of cards on file: 0\n");
      printf("Average balance: $0.00\n");
   }  else {
      avg /= cardNum;
      printf("Number of cards on file: %d\n", cardNum);
      if (avg < 0) {
         printf("Average balance: -$%.2f\n", fabs(avg));
      } else {
         printf("Average balance: $%.2f\n", avg);
      }
   }
}

// Time complexity: 
// Explanation: 
void showLL(List listp) {
   NodeT *start = listp->head;
   while (start != NULL) {
      printf("-----------------\n");
      printf("Card ID: %d\n", start->data.cardID);
      if (start->data.balance < 0) {
         printf("Balance: -$%.2f\n", fabs(start->data.balance));
	  } else {
         printf("Balance: $%.2f\n", start->data.balance);
	  }
	  if (start->data.balance < 5) {
         printf("Low balance\n");
	  }
      printf("-----------------\n");
      start = start->next;
   }
}
