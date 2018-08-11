#include <stdio.h>
<<<<<<< HEAD
void swap (char *x, char *y)
{
    char temp;
    temp = *x;
    *x = *y;
    *y = temp;
}

void heappermute(char v[], int n) {
	int i;
	char temp;
	for (i = 0; i < n; i++) {
    	heappermute(v, n-1);
        if (n % 2 == 1) {
        	swap(&v[0], &v[n-1]);
	    }
        else {
            swap(&v[i], &v[n-1]);
        }
	}
}
 
int main()
{
    char catdog[] = {'a','c','d','g','o','t'};
    int  i = 6;
    heappermute(catdog, i);
    return 0;
}
=======
>>>>>>> ff78da2e871674cbfdd9f52508e7ffabadecc438
