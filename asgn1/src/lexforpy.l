%{
#include "lexforpy.h"
%}

%%
=								return OP_ASSIGN;
"print"							return KEY_PRINT;
[_a-zA-Z][_a-zA-Z0-9]*			return IDENTIFIER;
[0-9]*							return LIT_INT_CONST;
L?\"(\\.|[^\\"])*\"				return LIT_STRING;
[ \t\n]							;
.								printf("Unidentified token\n");

%%
// need to use y.tab.h insteadof lexforpy.h. Read up yacc
// need to add INDENT and DEDENT token definitions


int yywrap(void){
	return 1;
}