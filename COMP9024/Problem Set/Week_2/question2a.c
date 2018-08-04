#include <stdio.h>

float innerProduct(float a[], float b[], int n) 
{
	float result = 0.0;
	int i;
	for (i = 0; i < n; i++) 
	{
		result += a[i]*b[i];
	}
	return result;	
}

int main() 
{
	int n;
	printf("The index of the array: ");
	scanf("%d", &n);
	float a[n];
	printf("The first array: ");
	int index;
	for (index = 0; index < n; index++)
	{
		scanf("%f", &a[index]);
	}
	float b[n];
	printf("The second array: ");
	for (index = 0; index < n; index++)
	{
		scanf("%f", &b[index]);
	}
	float result = innerProduct(a, b, n);
	printf("%f", result);
}
