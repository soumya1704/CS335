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

expr_stmt 		: testlist augassign testlist
				| testlist '=' expr_stmt
				| testlist

testlist 	 	: test ',' testlist_star_expr
				| test

augassign 		: '+='
				| '-='
				| '*='
				| '/='
				| '**='

test 	 		: expr comp_op test
				| expr

comp_op 		: '<'
				| '>'
				| '=='
				| '<='
				| '>='
				| '<>'
				| '!='

expr 			: term '+' expr
				| term '-' expr
				| term				

term 			: factor '*' term
				| factor '/' term
				| factor '%' term
				| factor

factor 			: '+' factor
				| '-' factor
				| power

power 			: atom_expr '**' factor
				| atom_expr

atom_expr 		: atom trailer												