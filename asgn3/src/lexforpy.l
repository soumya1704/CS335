%{
#include <iostream>	
#include <stack>
#include "yaccforpy.tab.h"
// #include "parser.hh"

// #define DEDENT_THROW (	if(line_indent_count<indent_level.top()){\
// 							indent_level.pop();\
// 							size_t i;\
// 							for (i = 0; i < line_indent_count; ++i){\
// 								unput(' ');\
// 							}\
// 							std::cout<<"DEDENT"<<std::endl;\
// 							return DEDENT;\
// 						})

#define YY_DECL extern "C" int yylex()

size_t line_indent_count=0;
std::stack<size_t> indent_level;
int fake_dedent=0;
int fake_visited=0;
// bool newline_is_hit=false;

#define YY_USER_INIT { \
        indent_level.push(0); \
        BEGIN(initial); \
    }
int yycolumn=1;

// size_t count_indent(char* s){
// 	size_t count=0;
// 	int i; 
// 	for(i = 0; i < strlen(s); ++i){
// 		if(s[0]==' ')
// 			count++;
// 		else if(s[0]=='\t')
// 			count+=4;
// 	}
// 	return count;
// }

// void set_yycolumn(int val) {
//     yycolumn = val;
//     yylloc.first_column = yycolumn;
//     yylloc.last_column = yycolumn + yyleng - 1;
// }

// #define YY_USER_ACTION { \
//     yylloc.first_line = yylloc.last_line = yylineno; \
//     set_yycolumn(yycolumn); \
//     yycolumn += yyleng; \
// }

%}

%x initial
%x indent
%s normal

%option yylineno
%option noyywrap
%option warn
%option nodefault

%%
	int indent_caller = normal;
<*>\n 										{ /*set_yycolumn(0); */yylineno--; REJECT; }

<initial>.  								{ /*set_yycolumn(yycolumn-1); */indent_caller = normal; yyless(0); 
												// std::cout<<indent_caller<<"("<<initial<<","<<indent<<","<<normal<<")"<<std::endl;
												BEGIN(indent);
												// std::cout<<"goto state "<<indent<<std::endl;
											}
<initial>\n 								{ 	indent_caller = normal; yyless(0); 
												// std::cout<<indent_caller<<"("<<initial<<","<<indent<<","<<normal<<")"<<std::endl;
												BEGIN(indent); 
												// std::cout<<"goto state "<<indent<<std::endl;
											}	

<indent>" " 								{	line_indent_count++; }
<indent>"\t"								{	line_indent_count=(line_indent_count+4)&~3; }
<indent>"\n"								{	line_indent_count=0; }
<indent><<EOF>>								{
							                    if(indent_level.top()!=0){
							                        indent_level.pop();
							                        if(line_indent_count!=indent_level.top()){
							                            unput('\n');
							                            for(size_t i = 0 ; i < indent_level.top() ; ++i) {
							                                unput(' ');
							                            }
							                        }else{
														// std::cout<<indent_caller<<"("<<initial<<","<<indent<<","<<normal<<")"<<std::endl;
							                            BEGIN(indent_caller);
							                    		// std::cout<<"goto state "<<indent_caller<<std::endl;        
							                        }
							                        std::cout<<"DEDENT"<<std::endl;
							                        return DEDENT;
						                    	}else{
						                        	yyterminate();
						                    	}
                							}
<indent>.									{ 	if(!fake_dedent)
													unput(*yytext);
												else{
													fake_visited=1;
													// std::cout<<"Fake visited\n";		
												}
												/*set_yycolumn(yycolumn-1);*/
												fake_dedent=0;
												if(line_indent_count>indent_level.top()){
													indent_level.push(line_indent_count);
													// std::cout<<indent_caller<<"("<<initial<<","<<indent<<","<<normal<<")"<<std::endl;
													BEGIN(indent_caller);
													// std::cout<<"goto state "<<indent_caller<<std::endl;
													std::cout<<"INDENT"<<std::endl;
													return INDENT;		
												}else if(line_indent_count<indent_level.top()){
													indent_level.pop();
													if(line_indent_count!=indent_level.top()){
														// std::cout<<line_indent_count<<std::endl;
														for(size_t i = 0; i<line_indent_count; ++i){
															unput(' ');		
														}
														unput('\n');
														unput('.');
														fake_dedent=1;
														// std::cout<<indent_level.top()<<std::endl;
														for(size_t i = 0; i<indent_level.top(); ++i){
															unput(' ');		
														}
														unput('\n');
													}else{
														// std::cout<<indent_caller<<"("<<initial<<","<<indent<<","<<normal<<")"<<std::endl;
														BEGIN(indent_caller);
														// std::cout<<"goto state "<<indent_caller<<std::endl;
													}	
													// newline_is_hit=true;
													std::cout<<"DEDENT"<<std::endl;
													return DEDENT;
												}else{
													// std::cout<<indent_caller<<"("<<initial<<","<<indent<<","<<normal<<")"<<std::endl;
													BEGIN(indent_caller);
													// std::cout<<"goto state "<<indent_caller<<std::endl;
												}	
											}

<normal>\n									{	
												line_indent_count=0; 
												indent_caller=YY_START; 
												// std::cout<<indent_caller<<"("<<initial<<","<<indent<<","<<normal<<")"<<std::endl;
												BEGIN(indent);
												// std::cout<<"goto state "<<indent<<std::endl; 
												if(!fake_visited){
													std::cout<<"NEWLINE"<<std::endl;
													return NEWLINE; 
												}
												fake_visited=0;
											}

<normal>"def"								return DEF;
<normal>"elif"								return ELIF;
<normal>"else"								return ELSE;
<normal>"for"								return FOR;
<normal>"from"								return FROM;
<normal>"if"								return IF;
<normal>"import"							return IMPORT;	
<normal>"while"								return WHILE;
<normal>"in"								return IN;
<normal>"as"								return AS;			
<normal>"and"								return AND;
<normal>"not"								return NOT;	
<normal>"or"								return OR;
	
<normal>"<"									return yytext[0];
<normal>">"									return yytext[0];
<normal>"=="								return EQ;
<normal>"<="								return LEQ;
<normal>">="								return GEQ;
<normal>"<>"								return NEQ;
<normal>"!="								return NNEQ;

<normal>"True"								return BOOL_TRUE;
<normal>"False"								return BOOL_FALSE;
<normal>"("									return yytext[0];
<normal>")"									return yytext[0];
<normal>"."									return yytext[0];
<normal>","									return yytext[0];				
<normal>":"									return yytext[0];
<normal>";"									return yytext[0];	

<normal>"="									return yytext[0];	
<normal>"+="								return AUG_ADD;
<normal>"-="								return AUG_SUB;
<normal>"*="								return AUG_MUL;
<normal>"/="								return AUG_DIV;
<normal>"%="								return AUG_MOD;
<normal>"**="								return AUG_POW;
													
<normal>"+"									return yytext[0];
<normal>"-"									return yytext[0];
<normal>"*"									return yytext[0];	
<normal>"/"									return yytext[0];
<normal>"%"									return yytext[0];
<normal>"**"								return POW;

<normal>("0B"|"0b")[01]+						{ yylval.ival = atoi(yytext); return INTEGER;}
<normal>("0O"|"0o")[0-7]+						{ yylval.ival = atoi(yytext); return INTEGER;}	
<normal>("0X"|"0x")[a-fA-F0-9]+					{ yylval.ival = atoi(yytext); return INTEGER;}
<normal>[0-9]+									{ yylval.ival = atoi(yytext); return INTEGER;}

<normal>(([0-9]+)?"."[0-9]+)(("e"|"E")("+"|"-")[0-9]+)?		{ yylval.fval = atof(yytext); return FLOAT;}
<normal>([0-9]+)("e"|"E")("+"|"-")[0-9]+					{ yylval.fval = atof(yytext); return FLOAT;}

("#")(.)*(\n)								;

<normal>[_a-zA-Z][_a-zA-Z0-9]*						{ yylval.sval = strdup(yytext); return NAME; }

<normal>[ \t]+								;

(.|\n)										{	std::cout<<"Unidentified token "<<yytext<<" at "<<yylineno<<std::endl; return -1;}



%%
// need to use y.tab.h insteadof lexforpy.h. Read up yacc
// need to add INDENT and DEDENT token definitions
// [a-zA-Z]?\"(\\.|[^\\"])*\"					return LIT_STR;