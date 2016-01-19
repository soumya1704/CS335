%{
#include "lexforpy.h"
%}

%%
"assert"									return KEYWORD;
"as"										return KEYWORD;
"break"										return KEYWORD;
"class"										return KEYWORD;
"continue"									return KEYWORD;
"def"										return KEYWORD;
"del"										return KEYWORD;
"elif"										return KEYWORD;
"else"										return KEYWORD;
"except"									return KEYWORD;
"finally"									return KEYWORD;							
"for"										return KEYWORD;
"from"										return KEYWORD;
"global"									return KEYWORD;
"if"										return KEYWORD;
"import"									return KEYWORD;	
"lambda"									return KEYWORD;		
"nonlocal"									return KEYWORD;
"pass"										return KEYWORD;
"raise"										return KEYWORD;	
"return"									return KEYWORD;	
"try"										return KEYWORD;
"while"										return KEYWORD;	
"with"										return KEYWORD;
"yield"										return KEYWORD;		


"=="										return OP_REL;
"!=" 										return OP_REL;
"<"											return OP_REL;
">"											return OP_REL;		
"<="										return OP_REL;
">="										return OP_REL;
"in"										return OP_REL;
"is"										return OP_REL;
													
"and"										return OP_LOGIC;
"not"										return OP_LOGIC;	
"or"										return OP_LOGIC;
	
"("											return PARENTHESIS;
")"											return PARENTHESIS;
"{"											return PARENTHESIS;				
"}"											return PARENTHESIS;
"["											return PARENTHESIS;	
"]"											return PARENTHESIS;

"."											return PUNCTUATOR;
","											return PUNCTUATOR;				
":"											return PUNCTUATOR;
";"											return PUNCTUATOR;	
"@"											return PUNCTUATOR;

"="											return ASSIGN_MATH;	
"+="										return ASSIGN_MATH;
"-="										return ASSIGN_MATH;
"*="										return ASSIGN_MATH;
"/="										return ASSIGN_MATH;
"//="										return ASSIGN_MATH;
"%="										return ASSIGN_MATH;
"**="										return ASSIGN_MATH;

"&="										return ASSIGN_BIT;
"|="										return ASSIGN_BIT;
"^="										return ASSIGN_BIT;
"<<="										return ASSIGN_BIT;
">>="										return ASSIGN_BIT;
														
"+"											return OP_MATH;	
"-"											return OP_MATH;
"*"											return OP_MATH;	
"/"											return OP_MATH;
"//"										return OP_MATH;
"%"											return OP_MATH;
"**"										return OP_MATH;

"&"											return OP_BIT;
"|"											return OP_BIT;
"~"											return OP_BIT;
"^"											return OP_BIT;
"<<"										return OP_BIT;
">>"										return OP_BIT;

("0B"|"0b")[01]+							return LIT_INT;
("0O"|"0o")[0-7]+							return LIT_INT;	
("0X"|"0x")[a-fA-F0-9]+						return LIT_INT;
[0-9]+										return LIT_INT;

(([0-9]+)?"."[0-9]+)(("e"|"E")("+"|"-")[0-9]+)?		return LIT_FLOAT;
([0-9]+)("e"|"E")("+"|"-")[0-9]+					return LIT_FLOAT;

("True"|"False")							return LIT_BOOL;

"None"										return LIT_NONE;

("#")(.)*(\n)								;

[_a-zA-Z][_a-zA-Z0-9]*						return IDENTIFIER;

[a-zA-Z]?\"(\\.|[^\\"])*\"					return LIT_STR;

[ \n\t]										;
.											{printf("Unidentified token\n"); return -1;}



%%
// need to use y.tab.h insteadof lexforpy.h. Read up yacc
// need to add INDENT and DEDENT token definitions


int yywrap(void){
	return 1;
}