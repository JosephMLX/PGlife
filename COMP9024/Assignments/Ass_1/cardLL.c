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

// Time complexity: O(1);
// Explanation: This function initiate the linked list there is no loops in 
//              the function, time complexity should be constant;
List newLL() {
   List L = malloc(sizeof(ListRep));
   L->head = NULL;
   return L;  /* needs to be replaced */
}

// Time complexity: O(n);
// Explanation: This function use a while loop to travel all nodes in the 
//              linked list, free every node and finally drop the linked 
//              list. Time complexity increases linearly when card records 
//              increases;
void dropLL(List listp) {
   NodeT *curr = listp->head;
   while (curr != NULL) {
      NodeT *temp = curr->next;
      free(curr);
      curr = temp;
   }
   free(listp);
}

// Time complexity: O(1) when remove the first node in the linked list;
//                  O(n) when remove other nodes;
// Explanation: Firstly, if the linked list only has one node, check 
//              whether it matches the cardID. Then, use a while loop to
//              travel all nodes in the linked list to find the position 
//              of the node we want to remove. Time complexity increases
//              linearly when card records increases;
void removeLL(List listp, int cardID) {
   NodeT *slow = listp->head;
   NodeT *fast = listp->head;
   if (slow->next == NULL) {
      if (cardID == slow->data.cardID) {
         printf("Card removed.\n");
         listp->head = NULL;
         return;
      } else {
         printf("Card not found.\n");
      } 
   } else {
      fast = slow->next;
      if (slow->data.cardID == cardID) {
         printf("Card removed.\n");
         listp->head = fast;
         free(slow);
         return;
      }
      while (fast->next != NULL) {
         if (cardID == fast->data.cardID) {
            printf("Card removed.\n");
            slow->next = fast->next;
            return;
         } else {
            slow = fast;
            fast = fast->next;
         }
      }
      if (fast->next == NULL) {
         if (cardID == fast->data.cardID) {
            printf("Card removed.\n");
            slow->next = NULL;
            free(fast);
            return;
         } else {
            printf("Card not found.\n");
         }
      }
   }            
}

// Time complexity: O(1) when linked list is empty before;
//                  O(n) when linked list already existed;
// Explanation: If the linked list is empty, insert the node to head.
//              Use while loop to travel all nodes in the linked list,
//              if the cardID already existed, make a transaction. If the
//              cardID is not in the linked list, compare cardID and ID of
//              nodes, insert it in ascending order;
void insertLL(List listp, int cardID, float amount) {
   NodeT *new = malloc(sizeof(NodeT));
   assert(new != NULL);
   new->next = NULL;
   NodeT *curr = listp->head;
   new->data.cardID = cardID;
   new->data.balance = amount;
   if (curr == NULL || curr->data.cardID > new->data.cardID) {
      new->next = curr;
      listp->head = new;
      printf("Card added.\n");
   }  else {
      while (curr != NULL) {
         if (curr->data.cardID == new->data.cardID) {
            curr->data.balance += amount;
            printf("-----------------\n");
            printf("Card ID: %d\n", curr->data.cardID);
            if (curr->data.balance < 0) {
               printf("Balance: -$%.2f\n", fabs(curr->data.balance));
	        } else {
               printf("Balance: $%.2f\n", curr->data.balance);
	        }
	        if (curr->data.balance < 5) {
               printf("Low balance\n");
	        }
            printf("-----------------\n");
            return;
         }
         curr = curr->next;   
      }
      curr = listp->head;   
      while (curr->next != NULL) {
         if (curr->data.cardID > new->data.cardID) {
            new = curr;
            curr = new->next;
            printf("Card added.\n");
         } else if (curr->data.cardID == new->data.cardID) {
            
         } else if (curr->data.cardID < new->data.cardID){
            curr = curr->next;
         }   
      }
      if (curr->next == NULL) {
         if (curr->data.cardID > new->data.cardID) {
            new = curr;
            curr = new->next;
            printf("Card added.\n");
         } else if (curr->data.cardID < new->data.cardID) {
            curr->next = new;
            printf("Card added.\n");
         }
      }
   }         
}

// Time complexity: O(n);
// Explanation: This function use a while loop to travel all nodes in the 
//              linked list, record items and sum up the balance. 
//              Time complexity increases linearly when card records 
//              increases;
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

// Time complexity: O(n);
// Explanation: This function use a while loop to travel all nodes in the 
//              linked list and print the card record infomation, time
//              complexity increases linearly when card records increases;
void showLL(List listp) {
   NodeT *start = listp->head;
   if (start == NULL) {
      return;
   }
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
