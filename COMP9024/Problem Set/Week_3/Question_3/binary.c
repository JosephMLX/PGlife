#include <stdio.h>
#include <stdlib.h>
#include "Int_Stack.h"

int main(int argc, char *argv[]) {
	int n;
	n = atoi(argv[1]);
	
	StackInit();
	while (n > 0) {
		StackPush(n%2);
		n = n/2;
	}
	while (!StackIsEmpty()) {
		printf("%d", StackPop());
	}
	printf("\n");	
	return 0;
}
