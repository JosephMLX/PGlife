// Transport card record implementation ... Assignment 1 COMP9024 18s2
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "cardRecord.h"

#define LINE_LENGTH 1024
#define NO_NUMBER -999
#define OUT_OF_LIMIT 1000

// scan input line for a positive integer, ignores the rest, returns NO_NUMBER if none
int readInt(void) {
	char line[LINE_LENGTH];
	int  n;

	fgets(line, LINE_LENGTH, stdin);
	if ( (sscanf(line, "%d", &n) != 1) || n <= 0 )
		return NO_NUMBER;
	else
		return n;
}

// scan input for a floating point number, ignores the rest, returns NO_NUMBER if none
float readFloat(void) {
	char  line[LINE_LENGTH];
	float f;

	fgets(line, LINE_LENGTH, stdin);
	if (sscanf(line, "%f", &f) != 1)
		return NO_NUMBER;
	else
		return f;
}

int readValidID(void) {
	int ID = readInt();     // get ID from readInt
	int n = ID;
	int digit = 0;
	while (n != 0) {
		n /= 10;
		++digit;
	}
	if (digit == 8) {
		return ID;
	}
	// 0012345678 ?????
	return 0;  /* needs to be replaced */
}

float readValidAmount(void) {
	float amount = readFloat();
	if (amount == -0) {
		amount = 0;
	}
	if (amount >= -2.35 && amount <= 250) {
		return amount;
	}
	return OUT_OF_LIMIT;  /* needs to be replaced */
}

void printCardData(cardRecordT card) {
	printf("-----------------\n");
	printf("Card ID: %d\n", card.cardID);
	printf("Balance: $%.2f\n", card.balance);
	if (card.balance < 0) {
		printf("Balance: -$%.2f\n", fabs(card.balance));
	}
	else {
		printf("Balance: $%.2f\n", card.balance);
	}
	if (card.balance < 5) {
		printf("Low balance\n");
	}
	printf("-----------------\n");
	return;  /* needs to be replaced */
}
