#include <stdio.h>
#include <stdlib.h>
#include "Int_Stack.h"

int main(int argc, char *argv[]) {
	int i;
	StackInit();
	
	for (i=1; i<argc, i++) {
		StackPush(atoi(argv[i]));
	}
	while (!StackIsEmpty()) {
		printf("%d\n", StackPop());
	}
	return 0;
}
