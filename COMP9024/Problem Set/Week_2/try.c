#include <stdio.h>
#define MAX 100

int main(void) {
	int arr[MAX];
	int i;
	for (i=0; i<MAX; i++) {
		arr[i] = i+1;
	}
	for (i=0; i<MAX; i++) {
		printf("%d, ", arr[i]);
	}
	return 0;
}
