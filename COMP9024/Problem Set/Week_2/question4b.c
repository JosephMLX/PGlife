#include <stdio.h>
#define MAX 10

void func(int i) {
	printf("%d\n", i);
	while (i != 1) {
		if (i % 2 != 0) {
			i = 3*i + 1;
			printf("%d\n", i);
		}
		else {
			i /= 2;
			printf("%d\n", i);
		}
	}
}

int main(void) {
	int fib[MAX] = {1,1};
	int i;
	for (i=2; i<MAX; i++) {
		fib[i] = fib[i-1] + fib[i-2];
	}
	for (i=0; i<MAX; i++) {
		printf("Fib[%d] = %d\n", i+1, fib[i]);
		func(fib[i]);
	}
	return 0;
}
