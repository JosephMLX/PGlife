// check whether stdin contains balanced (), [] and {} ... COMP9024 18s2

#include <stdio.h>
#include "Stack.h"

#define OPENA '('
#define CLOSA ')'
#define OPENB '{'
#define CLOSB '}'
#define OPENC '['
#define CLOSC ']'

int main() {
   char ch, opening;
   int  mismatch = 0;

   StackInit();
   while ((ch = getchar()) != EOF && !mismatch) {
      if (ch == OPENA || ch == OPENB || ch == OPENC) {
         StackPush(ch);
      } else if (ch == CLOSA || ch == CLOSB || ch == CLOSC) {
         if (StackIsEmpty()) {
            mismatch = 1;              // an opening bracket is missing
         } else {
            opening = StackPop();
            if (!((opening == OPENA && ch == CLOSA) ||
                  (opening == OPENB && ch == CLOSB) ||
                  (opening == OPENC && ch == CLOSC))) {
               mismatch = 1;           // wrong closing bracket
            }
         }
      }
   }
   if (mismatch || !StackIsEmpty()) {  // mismatch or some brackets unmatched
      printf("unbalanced\n");
   } else {
      printf("balanced\n");
   }
   return 0;
}
