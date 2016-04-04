%{
#include <cstdio>
#include <iostream>
#include <stack>
#include <string>
#include <fstream>
#include <sstream>

using namespace std;

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
void yyerror(const char *s);	

stack<int> rule_no;
stack<int> rule_no_temp;
stack<string> parent;
stack<string> parent_temp;
stack<string> statement;
stack<string> statement_temp;
stack<string> statement_temp2;

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
%token AUG_ADD;
%token AUG_SUB;
%token AUG_MUL;
%token AUG_DIV;
%token AUG_MOD;
%token AUG_POW;
%token EQ;
%token LEQ;
%token GEQ;
%token NEQ;
%token NNEQ;
%token AS;
%token POW;
%token BOOL_FALSE;
%token BOOL_TRUE;
%token IN;
				

%%

single_input	: NEWLINE 							{}
				| stmts								{rule_no.push(2);parent.push("single_input");}
				| compound_stmt						{rule_no.push(3);parent.push("single_input");}
;

compound_stmt 	: if_stmt							{rule_no.push(4);parent.push("compound_stmt");} 
				| while_stmt						{rule_no.push(5);parent.push("compound_stmt");} 
				| for_stmt							{rule_no.push(6);parent.push("compound_stmt");} 
;

if_stmt 		: IF test ':' suite 				{rule_no.push(7);parent.push("if_stmt");} 
				| IF test ':' suite ELSE ':' suite	{rule_no.push(8);parent.push("if_stmt");} 
				| IF test ':' suite elif_stmt		{rule_no.push(9);parent.push("if_stmt");} 
				| IF test ':' suite elif_stmt ELSE ':' suite {rule_no.push(10);parent.push("if_stmt");} 
;

elif_stmt		: ELIF test ':' suite				{rule_no.push(11);parent.push("elif_stmt");} 
				| ELIF test ':' suite elif_stmt 	{rule_no.push(12);parent.push("elif_stmt");} 
;

while_stmt 		: WHILE test ':' suite 				{rule_no.push(13);parent.push("while_stmt");} 
				| WHILE test ':' suite ELSE ':' suite {rule_no.push(14);parent.push("while_stmt");} 
;

for_stmt		: FOR exprlist IN testlist ':' suite {rule_no.push(15);parent.push("for_stmt");} 
				| FOR exprlist IN testlist ':' suite ELSE ':' suite {rule_no.push(16);parent.push("for_stmt");} 
;

exprlist 		: expr 								{rule_no.push(17);parent.push("exprlist");} 
				| expr ',' exprlist					{rule_no.push(19);parent.push("exprlist");}
;

suite			: simple_stmt						{rule_no.push(20);parent.push("suite");} 
				| NEWLINE INDENT stmts DEDENT		{rule_no.push(21);parent.push("suite");}
;

stmts			: stmt stmts						{rule_no.push(22);parent.push("stmts");} 
				| stmt 								{rule_no.push(23);parent.push("stmts");} 
;

stmt 			: simple_stmt						{rule_no.push(24);parent.push("stmt");} 
				| compound_stmt						{rule_no.push(25);parent.push("stmt");} 
;

simple_stmt 	: small_stmt ';' simple_stmt		{rule_no.push(26);parent.push("simple_stmt");} 
				| small_stmt NEWLINE				{rule_no.push(27);parent.push("simple_stmt");} 
;

small_stmt 		: expr_stmt							{rule_no.push(28);parent.push("small_stmt");} 
				| import_stmt						{rule_no.push(29);parent.push("small_stmt");} 
;

expr_stmt 		: testlist augassign testlist		{rule_no.push(30);parent.push("expr_stmt");} 
				| testlist '=' expr_stmt			{rule_no.push(31);parent.push("expr_stmt");} 
				| testlist							{rule_no.push(32);parent.push("expr_stmt");} 
;

testlist 	 	: test ',' testlist					{rule_no.push(33);parent.push("testlist");} 
				| test								{rule_no.push(34);parent.push("testlist");} 
;

augassign 		: AUG_ADD							{rule_no.push(35);parent.push("augassign");} 
				| AUG_SUB							{rule_no.push(36);parent.push("augassign");} 
				| AUG_MUL							{rule_no.push(37);parent.push("augassign");} 
				| AUG_DIV							{rule_no.push(38);parent.push("augassign");} 
				| AUG_POW							{rule_no.push(39);parent.push("augassign");} 
;

test 	 		: expr comp_op testlist				{rule_no.push(40);parent.push("test");} 
				| expr 								{rule_no.push(41);parent.push("test");} 
;

comp_op 		: '<'								{rule_no.push(42);parent.push("comp_op");} 
				| '>'								{rule_no.push(43);parent.push("comp_op");} 
				| EQ								{rule_no.push(44);parent.push("comp_op");} 
				| LEQ								{rule_no.push(45);parent.push("comp_op");} 
				| GEQ								{rule_no.push(46);parent.push("comp_op");} 
				| NEQ								{rule_no.push(47);parent.push("comp_op");} 
				| NNEQ								{rule_no.push(48);parent.push("comp_op");} 
;

expr 			: expr '+' term 					{rule_no.push(49);parent.push("expr");} 
				| expr '-' term 					{rule_no.push(50);parent.push("expr");} 
				| term								{rule_no.push(51);parent.push("expr");} 
;

term 			: factor '*' term					{rule_no.push(52);parent.push("term");}
				| factor '/' term					{rule_no.push(53);parent.push("term");}
				| factor '%' term					{rule_no.push(54);parent.push("term");} 
				| factor							{rule_no.push(55);parent.push("term");} 
;

factor 			: '+' factor						{rule_no.push(56);parent.push("factor");}
				| '-' factor						{rule_no.push(57);parent.push("factor");}
				| power								{rule_no.push(58);parent.push("factor");}
;

power 			: atom_expr POW factor				{rule_no.push(59);parent.push("power");} 
				| atom_expr							{rule_no.push(60);parent.push("power");} 
;

atom_expr 		: atom								{rule_no.push(61);parent.push("atom_expr");} 
				| atom trailer						{rule_no.push(62);parent.push("atom_expr");} 
;

atom 			: NAME 								{rule_no.push(63);parent.push("atom");}
				| INTEGER							{rule_no.push(64);parent.push("atom");} 
				| FLOAT								{rule_no.push(65);parent.push("atom");} 
				| BOOL_TRUE							{rule_no.push(66);parent.push("atom");} 
				| BOOL_FALSE						{rule_no.push(67);parent.push("atom");} 
;

trailer 		: '(' argslist ')'					{rule_no.push(68);parent.push("trailer");} 
				| '.' NAME 							{rule_no.push(69);parent.push("trailer");}
				| '.' NAME '(' argslist ')' 		{rule_no.push(80);parent.push("trailer");}
				| '(' ')'							{rule_no.push(79);parent.push("trailer");} 
;

argslist 		: arg ',' argslist					{rule_no.push(70);parent.push("argslist");} 
				| arg 								{rule_no.push(71);parent.push("argslist");} 
;

arg 			: test 								{rule_no.push(72);parent.push("arg");} 
				| test '=' test						{rule_no.push(73);parent.push("arg");} 
;

import_stmt 	: IMPORT dotted_as_names			{rule_no.push(74);parent.push("import_stmt");} 
;

dotted_as_names : dotted_names 						{rule_no.push(75);parent.push("dotted_as_names");} 
				| dotted_names AS NAME 				{rule_no.push(76);parent.push("dotted_as_names");} 
;

dotted_names 	: NAME '.' dotted_names 			{rule_no.push(77);parent.push("dotted_names");} 
				| NAME 								{rule_no.push(78);parent.push("dotted_names");} 
;

%%

string find(int k){
	string s="";
	switch(k){
		case 1 : return "NEWLINE" ;
		case 2 : return "stmts" ;
		case 3 : return "compound_stmt" ;
		case 4 : return "if_stmt" ;
		case 5 : return "while_stmt" ;
		case 6 : return "for_stmt" ;
		case 7 : return "IF test : suite" ;
		case 8 : return "IF test : suite ELSE : suite" ;
		case 9 : return "IF test : suite elif_stmt" ;
		case 10 : return "IF test : suite elif_stmt ELSE : suite" ;
		case 11 : return "ELIF test : suite" ;
		case 12 : return "ELIF test : suite elif_stmt" ;
		case 13 : return "WHILE test : suite" ;
		case 14 : return "WHILE test : suite ELSE : suite" ;
		case 15 : return "FOR exprlist IN testlist :" ;
		case 16 : return "FOR exprlist IN testlist : suite ELSE : suite" ;
		case 17 : return "expr" ;
		case 18 : return "expr ," ;
		case 19 : return "expr , exprlist" ;
		case 20 : return "simple_stmt" ;
		case 21 : return "NEWLINE INDENT stmts DEDENT" ;
		case 22 : return "stmt stmts" ;
		case 23 : return "stmt" ;
		case 24 : return "simple_stmt" ;
		case 25 : return "compound_stmt" ;
		case 26 : return "small_stmt ; simple_stmt" ;
		case 27 : return "small_stmt NEWLINE" ;
		case 28 : return "expr_stmt" ;
		case 29 : return "import_stmt" ;
		case 30 : return "testlist augassign testlist" ;
		case 31 : return "testlist = expr_stmt" ;
		case 32 : return "testlist" ;
		case 33 : return "test , testlist" ;
		case 34 : return "test" ;
		case 35 : return "AUG_ADD" ;
		case 36 : return "AUG_SUB" ;
		case 37 : return "AUG_MUL" ;
		case 38 : return "AUG_DIV" ;
		case 39 : return "AUG_POW" ;
		case 40 : return "expr comp_op testlist" ;
		case 41 : return "expr" ;
		case 42 : return "<" ;
		case 43 : return ">" ;
		case 44 : return "EQ" ;
		case 45 : return "LEQ" ;
		case 46 : return "GEQ" ;
		case 47 : return "NEQ" ;
		case 48 : return "NNEQ" ;
		case 49 : return "expr + term" ;
		case 50 : return "expr - term" ;
		case 51 : return "term" ;
		case 52 : return "factor * term" ;
		case 53 : return "factor / term" ;
		case 54 : return "factor \% term" ;
		case 55 : return "factor" ;
		case 56 : return "+ factor" ;
		case 57 : return "- factor" ;
		case 58 : return "power" ;
		case 59 : return "atom_expr POW factor" ;
		case 60 : return "atom_expr" ;
		case 61 : return "atom" ;
		case 62 : return "atom trailer" ;
		case 63 : return "NAME" ;
		case 64 : return "INTEGER" ;
		case 65 : return "FLOAT" ;
		case 66 : return "BOOL_TRUE" ;
		case 67 : return "BOOL_FALSE" ;
		case 68 : return "( argslist )" ;
		case 69 : return ". NAME" ;
		case 70 : return "arg , argslist" ;
		case 71 : return "arg" ;
		case 72 : return "test" ;
		case 73 : return "test = test" ;
		case 74 : return "IMPORT dotted_as_names" ;
		case 75 : return "dotted_names" ;
		case 76 : return "dotted_names AS NAME" ;
		case 77 : return "NAME . dotted_names" ;
		case 78 : return "NAME" ;
		case 79 : return "()" ;
		case 80 : return ". NAME ( argslist )" ;
		 
	}
	return s;
}

int main(int argc, char** argv) {
	int c=1;

	ofstream a_file ("example.html");
	FILE *fh;
	if(argc==2&&(fh=fopen(argv[1],"r")))
		yyin=fh;	
	do {
		yyparse();
	} while (!feof(yyin));
	int q, flag = 0, k;
	string temp1, temp2, temp3, ex1, word, output;
	q = rule_no.size();
	temp1 = parent.top();
	statement.push(temp1);
	while(!rule_no.empty()){
		k = rule_no.top();
		rule_no.pop();
		parent.pop();
		if(!parent.empty()){
			temp2 = parent.top();
		}
		else{
			temp2 = "";
		}
		while(!statement.empty()){
			temp3 = statement.top();
			statement.pop();
			if(temp3.compare(temp1)==0){
				ex1 = find(k);
				istringstream iss(ex1);
				while(iss >> word){
					if(word.compare(temp2)==0){
						statement_temp2.push("<font color=\"green\">"); //token for color
						statement_temp2.push(temp2);
						statement_temp2.push("</font>"); //close token for color change
						flag = 1;
					}
					else{
						statement_temp2.push("<font color=\"red\">"); //token for color
						statement_temp2.push(word);
						statement_temp2.push("</font>"); //close token for color change
					}
				}
				while(!statement_temp2.empty()){
					temp3 = statement_temp2.top();
					statement_temp2.pop();
					statement_temp.push(temp3);
				}
				if(flag==1){
					while(!statement.empty()){
						temp3 = statement.top();
						statement.pop();
						statement_temp.push(temp3);
						flag = 0;
					}
				}
				else{
					while(!statement.empty()){
						temp3 = statement.top();
						statement.pop();
						if(temp3.compare(temp2)==0){
						statement_temp.push("</font>"); //close token for color change
						statement_temp.push(temp3);
						statement_temp.push("<font color=\"red\">"); //token for color
						}
						else{
							statement_temp.push(temp3);
						}
					}
				}
				temp3 = "";
			}
			else if(temp3.compare(temp2)==0&&(temp3!="")){
				statement_temp.push("</font>"); //close token for color change
				statement_temp.push(temp3);
				statement_temp.push("<font color=\"blue\">"); //token for color
				while(!statement.empty()){
					temp3 = statement.top();
					statement.pop();
					if(temp3.compare(temp1)==0){
						ex1 = find(k);
						istringstream iss(ex1);
						statement_temp2.push("<font color=\"red\">"); //token for color
						while(iss >> word){
							statement_temp2.push(word);
						}
						statement_temp2.push("</font>"); //close token for color
						while(!statement_temp2.empty()){
							temp3 = statement_temp2.top();
							statement_temp2.pop();
							statement_temp.push(temp3);
						}
					}
					else {
						statement_temp.push(temp3);
					}
				}
				temp3 = "";
			}
			else if(temp3!=""){
				statement_temp.push(temp3);
			}
		}
		output = "";
		while(!statement_temp.empty()){
			temp3 = statement_temp.top();
			statement_temp.pop();
			output += temp3;
			output += " ";
			statement.push(temp3);
		}
		if(temp2!=""){
			temp1 = temp2;
		}
		a_file<<output;
		a_file<<"<br>";
	}
}

void yyerror(const char *s) {
	cout << "Message: " << s << endl;
	exit(-1);
}