#include "lexforpy.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;
extern char* yytext;
extern FILE *yyin;

int token_count[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
char *token_name[]={"KEYWORD","OP_MATH","OP_REL","OP_LOGIC",
"OP_BIT","PARENTHESIS","PUNCTUATOR","ASSIGN_MATH","ASSIGN_BIT",
"LIT_INT","LIT_FLOAT","LIT_IMAGINARY","LIT_BOOL","LIT_STR",
"LIT_NONE","IDENTIFIER"};
int main(int argc,char **argv){
	int tokenid;
	int i;
	FILE *fh;
	if(argc==2&&(fh=fopen(argv[1],"r")))
		yyin=fh;
	FILE *f_intermediate[16];
	for (i = 0; i < 16; ++i)
	{
		char filename[20];
		sprintf(filename,"count%d.txt",i);
		f_intermediate[i]=fopen(filename,"w");
	}
	while(tokenid=yylex()){
		if(tokenid>0)
		{
			//printf("%s\n",yytext);
			token_count[tokenid-1]++;
			fprintf(f_intermediate[tokenid-1], "%s\n",yytext);
		}	
		else if(tokenid==-1)
		{
			printf("Line %d - Unknown stream of characters : %s\n", yylineno,yytext);
			return 0;
		}
	}
	printf("      Token      Occurances        Lexemes\n");
	printf("____________________________________________\n");	
	for (i = 0; i < 16; ++i)
	{
		char filename[20];
		fclose(f_intermediate[i]);
		sprintf(filename,"count%d.txt",i);
		f_intermediate[i]=fopen(filename,"r");
	}
	for (i = 0; i < 16; ++i)
	{
		ssize_t read;
		size_t len=0;
		char *line=NULL;
		if(token_count[i]>0){
			printf("%11s%12d",token_name[i],token_count[i]);	
			while(getline(&line,&len,f_intermediate[i])!=-1)
			{
				printf("%20s\n                       ", line);
			}
			printf("\n");
		}	
		fclose(f_intermediate[i]);
		char filename[20];
		sprintf(filename,"count%d.txt",i);
		remove(filename);
	}
	return 0;
}