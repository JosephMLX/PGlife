#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

typedef struct node {
	int data;
	struct node *next;
} NodeT;

NodeT *makeNode(int v) {
	NodeT *new = malloc(sizeof(NodeT));
	assert(new != NULL);
	new->data = v;
	new->next = NULL;
	return new;
}

void freeLL(NodeT *list) {
	NodeT *p;
	
	p = list;
	while (p != NULL) {
		NodeT *temp = p->next;
		free(p);
		p = temp;
	}
}

void showLL(NodeT *list) {
	NodeT *p;
	for (p=list; p!=NULL; p=p->next) {
		printf("%d", p->data);
		if (p->next != NULL) 
			printf("->");
	}
	putchar('\n');
}

NodeT *joinLL(NodeT *head1, NodeT *head2) {
	if (head1 == NULL) {
		head1 = head2;
	}
	else {
		NodeT *p = head1;
		while (p->next != NULL) {
			p = p->next;
		}
		p->next = head2;
	}
	return head1;
}


int main(void) {
	NodeT *all = NULL;
	int data;
	
	printf("Enter an integer: ");
	while (scanf("%d", &data) == 1) {
		NodeT *new = makeNode(data);
		all = joinLL(all, new);
		printf("Enter an integer: ");
	}
	if (all != NULL) {
		printf("Finished. List is ");
		showLL(all);
		freeLL(all);
	}
	else {
		printf("Finished.\n");
	}
	return 0;
}

