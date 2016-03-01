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
}
%start single_input;
%token <ival> INTEGER;
%token <fval> FLOAT;
%token <sval> NAME;
%token DEF;
%token ELIF;
%token ELSE;
%token FOR;
%token FROM;
%token IF;
%token IMPORT;	
%token WHILE;												
%token AND;
%token NOT;	
%token OR;
%token NEWLINE;
%token INDENT;
%token DEDENT;

%%

single_input	: NEWLINE 							{}
				| simple_stmt						{cout<<"simple_stmt";}
				| compound_stmt						{cout<<"compound_stmt";}
;

compound_stmt 	: if_stmt 
				| while_stmt
				| for_stmt
;

if_stmt 		: IF test ':' suite 
				| IF test ':' suite "else" ':' suite
				| IF test ':' suite elif_stmt
				| IF test ':' suite elif_stmt "else" ':' suite
;

elif_stmt		: ELIF test ':' suite
				| ELIF test ':' suite elif_stmt 
;

while_stmt 		: WHILE test ':' suite 
				| WHILE test ':' suite "else" ':' suite
;

for_stmt		: "for" exprlist "in" testlist ':' suite 
				| "for" exprlist "in" testlist ':' suite "else" ':' suite
;

exprlist 		: expr
				| expr ','
				| expr ',' exprlist
;

suite			: simple_stmt
				| NEWLINE INDENT stmts DEDENT
;

stmts			: stmt stmts
				| stmt
;

stmt 			: simple_stmt
				| compound_stmt
;

simple_stmt 	: small_stmt ';' simple_stmt		{cout<<"small_stmt ; simple_stmt";}
				| small_stmt NEWLINE				{cout<<"small_stmt \n";}
;

small_stmt 		: expr_stmt							{cout<<"expr_stmt";}
				| import_stmt						{cout<<"import_stmt";}
;

expr_stmt 		: testlist augassign testlist		{cout<<"testlist augassign testlist";}
				| testlist '=' expr_stmt			{cout<<"testlist = expr_stmt";}
				| testlist							{cout<<"testlist";}
;
testlist 	 	: test ',' testlist					{cout<<"test , testlist";}
				| test								{cout<<"test";}
;
augassign 		: "+="								{cout<<"+=";}
				| "-="								{cout<<"-=";}
				| "*="								{cout<<"*=";}
				| "/="								{cout<<"/=";}
				| "**="								{cout<<"**=";}
;
test 	 		: expr comp_op testlist				{cout<<"expr comp_op testlist";}
				| expr 								{cout<<"expr";}
;
comp_op 		: '<'								{cout<<"<";}
				| '>'								{cout<<">";}
				| "=="								{cout<<"==";}
				| "<="								{cout<<"<=";}
				| ">="								{cout<<">=";}
				| "<>"								{cout<<"<>";}
				| "!="								{cout<<"!=";}
;
expr 			: expr '+' term 					{cout<<"expr + term";}
				| expr '-' term 					{cout<<"expr - term";}
				| term								{cout<<"term";}
;
term 			: factor '*' term					{cout<<"factor * term";}
				| factor '/' term					{cout<<"factor / term";}
				| factor '%' term					{cout<<"factor \% term";}
				| factor							{cout<<"factor";}
;
factor 			: '+' factor						{cout<<"+ factor";}
				| '-' factor						{cout<<"- factor";}
				| power								{cout<<"power";}
;
power 			: atom_expr "**DEF" factor				{cout<<"atom_expr ** factor";}
				| atom_expr							{cout<<"atom_expr";}
;
atom_expr 		: atom								{cout<<"atom";}
				| atom trailer						{cout<<"atom trailer";}
;
atom 			: NAME 								{cout<<$1;}
				| INTEGER							{cout<<$1;}
				| FLOAT								{cout<<$1;}
				| "True"							{cout<<"True";}
				| "False"							{cout<<"False";}
;
trailer 		: '(' argslist ')'					{cout<<"( argslist )";}
				| '.' NAME 							{cout<<". "<<$2;}
;
argslist 		: arg ',' argslist					{cout<<"arg , argslist";}
				| arg 								{cout<<"arg";}
;
arg 			: test 								{cout<<"test";}
				| test '=' test						{cout<<"test = test";}
;
import_stmt 	: "import" dotted_as_names			{cout<<"import dotted_as_names";}
;				
dotted_as_names : dotted_names 						{cout<<"dotted_names";}
				| dotted_names "as" NAME 			{cout<<"dotted_names as NAME";}
;
dotted_names 	: NAME '.' dotted_names 			{cout<<"NAME . dotted_names";}
				| NAME 								{cout<<"NAME";}
;

%%

int main(int argc, char** argv) {
	// open a file handle to a particular file:
	FILE *fh;
	if(argc==2&&(fh=fopen(argv[1],"r")))
		yyin=fh;
	
	// FILE *myfile = fopen("in.snazzle", "r");
	// // make sure it's valid:
	// if (!myfile) {
	// 	cout << "I can't open a.snazzle.file!" << endl;
	// 	return -1;
	// }
	// set flex to read from it instead of defaulting to STDIN:
	// yyin = myfile;

	// parse through the input until there is no more:
	do {
		yyparse();
		cout << endl;
	} while (!feof(yyin));	
}

void yyerror(const char *s) {
	cout << "EEK, parse error!  Message: " << s << endl;
	exit(-1);
}