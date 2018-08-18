#include "IntQueue.h"
#include <assert.h>

static struct {
	int item[MAXITEMS];
	int top;
} queueObject;

void QueueInit() {
	queueObject.top = -1;
}

int QueueIsEmpty() {
	return (queueObject.top < 0);
}

void QueueEnqueue(int n) {
	assert(queueObject.top < MAXITEMS-1);
	queueObject.top++;
	int i;
	for (i = queueObject.top; i > 0; i--) {
		queueObject.item[i] = queueObject.item[i-1];
	}
	queueObject.item[0] = n;
}

int QueueDequeue() {
	assert(queueObject.top > -1);
	int i = queueObject.top;
	int n = queueObject.item[i];
	queueObject.top--;
	return n;
}


	
