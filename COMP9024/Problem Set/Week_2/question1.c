#include <stdio.h>

int main(void) {
    for (int a = 10000; a < 25000; a ++) {
        int b = a * 4;
	    int a1 = a / 10000;
	    int a2 = (a / 1000) % 10;
	    int a3 = (a / 100) % 10;
	    int a4 = (a / 10) % 10;
	    int a5 = a % 10;
	    int b1 = b / 10000;
	    int b2 = (b / 1000) % 10;
	    int b3 = (b / 100) % 10;
	    int b4 = (b / 10) % 10;
	    int b5 = b % 10;
	    if (a1 == b5 && a2 == b4 && a3 == b3 && a4 == b2 && a5 == b1) {
	        printf("%d\n", a);
	        }
    }
}
