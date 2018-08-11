#include <stdio.h>

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
	return i;
}
int main(void) {
	int n;
	printf("Please enter a positive integer: ");
	scanf("%d", &n);
	if (n <= 0) {
		printf("Wrong input!\n");
	}
	else {
		func(n);
	}
	return 0;
}
