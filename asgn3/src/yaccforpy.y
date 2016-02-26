%{
#include <cstdio>
#include <iostream>

using namespace std;

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;

void yyerror(const char *s);	
%}

%union{
	int ival;
	float fval;
	char *sval;
	char cval;
}
%start single_input;
%token <ival> NUM;
%token <fval> NUM;
%token <sval> NAME;
%token NEWLINE;
%token INDENT;
%token DEDENT;

%%

single_input	: NEWLINE 
				| simple_stmt
				| compound_stmt

simple_stmt 	: small_stmt ';' simple_stmt
				| small_stmt NEWLINE

small_stmt 		: expr_stmt
				| import_stmt

expr_stmt 		: testlist_star_expr augassign testlist
				| testlist_star_expr '=' expr_stmt
				| testlist_star_expr

testlist_star_expr 	: test ',' testlist_star_expr
					| 	 