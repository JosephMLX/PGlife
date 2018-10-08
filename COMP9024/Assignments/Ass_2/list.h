// Linked list interface ... COMP9024 18s2
#include <stdbool.h>

typedef struct StackRep *stack;

typedef struct ListRep *List;

List newLL();
List insertLL(List, stack);
List deleteLL(List, stack);
bool inLL(List, stack);
void freeLL(List);
void showLL(List);