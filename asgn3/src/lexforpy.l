%{
#include <iostream>	
#include "yaccforpy.tab.h"

extern "C" int yylex();
%}

%%

("0B"|"0b")[01]+							{ yylval.ival = atoi(yytext); return INTEGER;}
("0O"|"0o")[0-7]+							{ yylval.ival = atoi(yytext); return INTEGER;}	
("0X"|"0x")[a-fA-F0-9]+						{ yylval.ival = atoi(yytext); return INTEGER;}
[0-9]+										{ yylval.ival = atoi(yytext); return INTEGER;}

(([0-9]+)?"."[0-9]+)(("e"|"E")("+"|"-")[0-9]+)?		{ yylval.fval = atof(yytext); return FLOAT;}
([0-9]+)("e"|"E")("+"|"-")[0-9]+					{ yylval.fval = atof(yytext); return FLOAT;}
s
("#")(.)*(\n)								;

[_a-zA-Z][_a-zA-Z0-9]*						{ yylval.sval = strdup(yytext); return NAME; }

[\n]										return NEWLINE;

[ \t]										;

.											{printf("Unidentified token\n"); return -1;}



%%
// need to use y.tab.h insteadof lexforpy.h. Read up yacc
// need to add INDENT and DEDENT token definitions
// [a-zA-Z]?\"(\\.|[^\\"])*\"					return LIT_STR;


int yywrap(void){
	return 1;
}