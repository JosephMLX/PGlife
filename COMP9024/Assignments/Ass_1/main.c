/**
     main.c

     Program supplied as a starting point for
     Assignment 1: Transport card manager

     COMP9024 18s2
**/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <ctype.h>

#include "cardRecord.h"
#include "cardLL.h"

void printHelp();
void CardLinkedListProcessing();

int main(int argc, char *argv[]) {
   if (argc == 2) {

      /*** Insert your code for stage 1 here ***/
      int records = atoi(argv[1]);
      cardRecordT *ptr = malloc(records * sizeof(cardRecordT));    // set the dynamic array cardRecordT
      assert(ptr != NULL);
      int i;
      float avg = 0;
      for (i=0; i<records; i++) {
         int id;
         float amount;
         printf("Enter card ID: ");
         while (!(id = readValidID())) {                   // keep asking ID until the return ID is right(8 digits integer)
            printf("Not valid. Enter a valid value: ");
         }
         ptr[i].cardID = id;
         printf("Enter amount: ");                         // keep asking the amount when the return number is 1000(return of wrong input)
         while ((amount = readValidAmount()) == 1000) {
            printf("Not valid. Enter a valid value: ");
         }
         ptr[i].balance = amount;
      }
      for (i=0; i<records; i++) {
         printCardData(ptr[i]);
         avg += ptr[i].balance;
      }
      avg /= i;
      printf("Number of cards on file: %d\n", records);
      if (avg < 0) {
         printf("Average balance: -$%.2f\n", fabs(avg));   // change the format to -$avg for negative numbers
      }
      else {
      printf("Average balance: $%.2f\n", avg);
      free(ptr);
      }
   }
   else {
      CardLinkedListProcessing();
   }
   return 0;
}

/* Code for Stages 2 and 3 starts here */

void CardLinkedListProcessing() {
   int op, ch;
   int cardID;
   int removeID;
   float newAmount;
   int *cardNums = NULL;
   float *average = NULL;
   List list = newLL();   // create a new linked list
   
   while (1) {
      printf("Enter command (a,g,p,q,r, h for Help)> ");

      do {
	 ch = getchar();
      } while (!isalpha(ch) && ch != '\n');  // isalpha() defined in ctype.h
      op = ch;
      // skip the rest of the line until newline is encountered
      while (ch != '\n') {
	 ch = getchar();
      }

      switch (op) {

         case 'a':
         case 'A':
            /*** Insert your code for adding a card record ***/
                      
            printf("Enter card ID: ");
            while (!(cardID = readValidID())) {
            printf("Not valid. Enter a valid value: ");
            }
            printf("Enter amount: ");
            while ((newAmount = readValidAmount()) == 1000) {
            printf("Not valid. Enter a valid value: ");
            }
            insertLL(list, cardID, newAmount);

	    break;

         case 'g':
         case 'G':
            /*** Insert your code for getting average balance ***/
            getAverageLL(list, cardNums, average);

	    break;
	    
         case 'h':
         case 'H':
            printHelp();
	    break;
	    
         case 'p':
         case 'P':
            /*** Insert your code for printing all card records ***/
            showLL(list);

	    break;

         case 'r':
         case 'R':
            /*** Insert your code for removing a card record ***/
            printf("Enter card ID: ");
            while (!(removeID = readValidID())) {
            printf("Not valid. Enter a valid value: ");
            }
            removeLL(list, removeID);

	    break;

	 case 'q':
         case 'Q':
            dropLL(list);       // destroy linked list before returning
	    printf("Bye.\n");
	    return;
      }
   }
}

void printHelp() {
   printf("\n");
   printf(" a - Add card record\n" );
   printf(" g - Get average balance\n" );
   printf(" h - Help\n");
   printf(" p - Print all records\n" );
   printf(" r - Remove card\n");
   printf(" q - Quit\n");
   printf("\n");
}
