#include <stdio.h>

typedef struct {
	int StudentID;
	int age;
	char gender;
	float WAM;
} PersonT;

void printdata(PersonT p) {
	printf("StudentID: %d\n", p.StudentID);
	printf("Age: %d\n", p.age);
	printf("Gender: %c\n", p.gender);
	printf("WAM : %.3f\n", p.WAM);
}

void main() {
	PersonT per1;
	PersonT per2;
	PersonT *ptr;

	ptr = &per1;	
	per1.StudentID = 3141592;
	ptr->gender = 'M';
	ptr = &per2;
	ptr->StudentID = 2718281;
	ptr->gender = 'F';
	per1.age = 25;
	per2.age = 24;
	ptr = &per1;
	per2.WAM = 86.0;
	ptr->WAM = 72.625;
	
	printf("per1\n");
	printdata(per1);
	printf("per2\n");
	printdata(per2);
}

