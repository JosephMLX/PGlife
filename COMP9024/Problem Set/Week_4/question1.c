#include <stdio.h>
#include <assert.h>

int *makeArrayOfInts() {
	int *arr = malloc(sizeof(int) * 10);
	assert(arr != NULL);
	int i;
	for (i=0; i<10; i++) {
		arr[i] = i;
	}
	return arr;
}
	
