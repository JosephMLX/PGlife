#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	if (argc != 2) {
		fprintf(stderr, "Usage : %s number\n", argv[0]);
		return 1;
	}
	int n = atoi(argv[1]);
	if (n > 0) {
		unsigned long long int *arr = malloc(n * sizeof(unsigned long long int));
		arr[0] = 1;
		arr[1] = 1;
		int i;
		for (i=2; i<n; i++) {
			arr[i] = arr[i-1] + arr[i-2];
		}
		printf("%llu\n", arr[n-1]);
		free(arr);
	}
	return 0;
}
