#include "lexforpy.h"
#include <stdio.h>

extern int yylex();
extern int yylineno;
extern char* yytext;
extern FILE *yyin;

char *names[]={NULL};

int main(int argc,char **argv){
	int ntoken;
	FILE *fh;
	if(argc==2&&(fh=fopen(argv[1],"r")))
		yyin=fh;
	while(ntoken=yylex()){
		printf("%d\n", ntoken);
	}
	return 0;
}