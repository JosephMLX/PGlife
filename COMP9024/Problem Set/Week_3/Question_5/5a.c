#include <stdio.h>

int main() {
	int data[12] = {5,3,6,2,7,4,9,1,8};
	int *p;
	p = &data[0];
	printf("&data[0]: %x\n", p);
	printf("data: %x\n", data);
	printf("data + 4: %x\n", data+4);
	printf("*data + 4: %d\n", *data + 4);
	printf("*(data + 4): %d\n", *(data+4));
	printf("data[4]: %d\n", data[4]);
	printf("*(data + *(data + 3)): %d\n", *(data + *(data + 3)));
	printf("data[data[2]]: %d\n", data[data[2]]);
}
