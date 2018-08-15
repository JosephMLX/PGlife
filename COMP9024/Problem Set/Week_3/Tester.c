#include <stdio.h>
#include "Int_Stack.h"

int main() {
	StackInit();
	int items;
	printf("Enter a positive number: ");
	scanf("%d", &items);
	if (items < 0) {
		printf("It's not positive!\n");
	}
	else {
		int i;
		for (i=0; i<items; i++) {
			int n;
			printf("Enter a number: ");
			scanf("%d", &n);
			StackPush(n);
		}
		for (i=0; i<items; i++) {
			int n;
			n = StackPop();
			printf("%d\n", n);
		}
	}
	return 0;
}			