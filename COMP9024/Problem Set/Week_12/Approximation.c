#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define EPSILON 1.0e-10

double bisection(double (*f)(double), double x1, double x2) {
	double mid;
	do {
		mid = (x1 + x2) / 2;
		if (f(x1) * f(mid) < 0) 
			x2 = mid;
		else
			x1 = mid;
	}
	while (f(mid) != 0 && x2 - x1 >= EPSILON);
		return mid;
}

double f1(double x) {
   return pow(x,3) - 7*x - 6;
}

double f3(double x) {
   return sin(5*x) + cos(10*x) + x*x/10;
}

int main(void) {
   printf("%.10f\n", bisection(f1, 0, 10));
   printf("%.10f\n", bisection(sin, 2, 4));
   printf("%.10f\n", bisection(f3, 0, 1));
   printf("%.10f\n", bisection(f3, 1, 2));
   return 0;
}
