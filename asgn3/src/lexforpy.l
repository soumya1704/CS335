%{
#include <iostream>	
#include "yaccforpy.tab.h"

extern "C" int yylex();
%}

%%
"def"										return DEF;
"elif"										return ELIF;
"else"										return ELSE;
"for"										return FOR;
"from"										return FROM;
"if"										return IF;
"import"									return IMPORT;	
"while"										return WHILE;	
													
"and"										return AND;
"not"										return NOT;	
"or"										return OR;
	
"("											return yytext[0];
")"											return yytext[0];

"."											return yytext[0];
","											return yytext[0];				
":"											return yytext[0];
";"											return yytext[0];	

"="											return yytext[0];	
"+="										return AUG_ADD;
"-="										return AUG_SUB;
"*="										return AUG_MUL;
"/="										return AUG_DIV;
"%="										return AUG_MOD;
"**="										return AUG_POW;
														
"+"											return yytext[0];
"-"											return yytext[0];
"*"											return yytext[0];	
"/"											return yytext[0];
"%"											return yytext[0];
"**"										return POW;

("0B"|"0b")[01]+							{ printf("%s ",yytext); yylval.ival = atoi(yytext); return INTEGER;}
("0O"|"0o")[0-7]+							{ printf("%s ",yytext); yylval.ival = atoi(yytext); return INTEGER;}	
("0X"|"0x")[a-fA-F0-9]+						{ printf("%s ",yytext); yylval.ival = atoi(yytext); return INTEGER;}
[0-9]+										{ printf("%s ",yytext); yylval.ival = atoi(yytext); return INTEGER;}

(([0-9]+)?"."[0-9]+)(("e"|"E")("+"|"-")[0-9]+)?		{ printf("%s ",yytext); yylval.fval = atof(yytext); return FLOAT;}
([0-9]+)("e"|"E")("+"|"-")[0-9]+					{ printf("%s ",yytext); yylval.fval = atof(yytext); return FLOAT;}

("#")(.)*(\n)								;

[_a-zA-Z][_a-zA-Z0-9]*						{ printf("%s ",yytext); yylval.sval = strdup(yytext); return NAME; }

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
