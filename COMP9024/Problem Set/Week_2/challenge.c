#include <stdio.h>

int max(int a, int b, int c) {
	int d = a * (a >= b) + b * (b > a);
	return c * (c >= d) + d * (d > c);
}

int main(void) {
	int a, b, c, m;
	printf("Please print the first number: ");
	scanf("%d", &a);
	printf("Please print the second number: ");
	scanf("%d", &b);
	printf("Please print the third number: ");
	scanf("%d", &c);
	m = max(a,b,c);
	printf("The largest number is %d\n", m);
	return 0;
}
	
	