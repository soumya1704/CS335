%{
#include <iostream>	
#include <stack>
#include "yaccforpy.tab.h"

#define DEDENT_THROW (	if(line_indent_count<indent_level.top()){\
							indent_level.pop();\
							size_t i;\
							for (i = 0; i < line_indent_count; ++i){\
								unput(' ');\
							}\
							std::cout<<"DEDENT"<<std::endl;\
							return DEDENT;\
						})

extern "C" int yylex();

size_t line_indent_count=0;
std::stack<size_t> indent_level;
int fake_outdent=0;
bool newline_is_hit=false;
size_t count_indent(char* s){
	size_t count=0;
	int i; 
	for(i = 0; i < strlen(s); ++i){
		if(s[0]==' ')
			count++;
		else if(s[0]=='\t')
			count+=4;
	}
	return count;
}
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
"in"										return IN;
"as"										return AS;			
"and"										return AND;
"not"										return NOT;	
"or"										return OR;
	
"<"											return yytext[0];
">"											return yytext[0];
"=="										return EQ;
"<="										return LEQ;
">="										return GEQ;
"<>"										return NEQ;
"!="										return NNEQ;

"True"										return BOOL_TRUE;
"False"										return BOOL_FALSE;
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

("0B"|"0b")[01]+							{ yylval.ival = atoi(yytext); return INTEGER;}
("0O"|"0o")[0-7]+							{ yylval.ival = atoi(yytext); return INTEGER;}	
("0X"|"0x")[a-fA-F0-9]+						{ yylval.ival = atoi(yytext); return INTEGER;}
[0-9]+										{ yylval.ival = atoi(yytext); return INTEGER;}

(([0-9]+)?"."[0-9]+)(("e"|"E")("+"|"-")[0-9]+)?		{ yylval.fval = atof(yytext); return FLOAT;}
([0-9]+)("e"|"E")("+"|"-")[0-9]+					{ yylval.fval = atof(yytext); return FLOAT;}

("#")(.)*(\n)								;

[_a-zA-Z][_a-zA-Z0-9]*						{ yylval.sval = strdup(yytext); return NAME; }

[\n]										{ std::cout<<"NEWLINE"<<std::endl;return NEWLINE; }

^[ \t]*										{ 		
													if(indent_level.empty())
														indent_level.push(0);
													line_indent_count=count_indent(yytext);
													if(line_indent_count>indent_level.top()){
														indent_level.push(line_indent_count);
														std::cout<<"INDENT"<<std::endl;
														return INDENT;
													
													}else if(line_indent_count<indent_level.top()){
														indent_level.pop();
														size_t i;	
														for (i = 0; i < line_indent_count; ++i){
															unput(' ');		
														}
														newline_is_hit=true;
														std::cout<<"DEDENT"<<std::endl;
														return DEDENT;
													}												
											}

[ \t]+										{	if(newline_is_hit)
													if(line_indent_count<indent_level.top()){
														indent_level.pop();
														size_t i;	
														for (i = 0; i < line_indent_count; ++i){
															unput(' ');		
														}
														newline_is_hit=true;
														std::cout<<"DEDENT"<<std::endl;
														return DEDENT;
													}else 
													newline_is_hit=false;
											}

.											{printf("Unidentified token\n"); return -1;}



%%
// need to use y.tab.h insteadof lexforpy.h. Read up yacc
// need to add INDENT and DEDENT token definitions
// [a-zA-Z]?\"(\\.|[^\\"])*\"					return LIT_STR;


int yywrap(void){
	return 1;
}
