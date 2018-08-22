#include <stdio.h>
#include <assert.h>
#include <stdlib.h>

void func(int **a) {
	*a = malloc(sizeof(int));
	assert(*a != NULL);
}

int main(void) {
	int *p;
	
	func(&p);
	*p = 6;
	printf("%d\n", *p);
	free(p);
	return 0;
}
