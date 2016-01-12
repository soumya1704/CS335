#include "lexforpy.h"
#include <stdio.h>

extern int yylex();
extern int yylineno;
extern char* yytext;

char *names[]={NULL};

int main(void){
	int ntoken;
	while(ntoken=yylex()){
		printf("%d\n", ntoken);
	}
	return 0;
}