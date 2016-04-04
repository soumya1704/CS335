%{
#include <cstdio>
#include <iostream>
#include <stack>
#include <string>
#include <cstring>
#include <fstream>
#include <sstream>

using namespace std;
struct sym_tab
{
	std::string name;
	int type;
	sym_tab* next;
};
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern "C" char* yytext;
extern "C" sym_tab* head;
void yyerror(const char *s);	
void push();
void push_new();
void push_eq();
void codegen();
void codegen_assign();
void codegen_umin();
void lab1();
void lab2();
void lab3();
void lab4();
void lab5();
void lab6();
void lab7();
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
%start S;
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
%right '='
%left '+' '-'
%left '*' '/'
%left UMINUS				
%%

S : I S | test S | W S | I | test | W
	;

I :  IF test {lab1();} ':' E {lab2();} ELSE ':' E {lab3();}
	;

W : WHILE {lab5();} test {lab6();}':' E {lab7();}ELSE E{lab3();}
	;

test : E '<'{push();} E{codegen();}
		| E '>'{push();} E{codegen();}
		| E EQ{push_eq();} E{codegen();}
		| E LEQ{push();} E{codegen();}
		| E GEQ{push();} E{codegen();}
		| E NEQ{push();} E{codegen();}
		| E NNEQ{push();} E{codegen();}
		| E
		;

E       : V '='{push();} E{codegen_assign();}
         | E '+'{push();} E{codegen();}
         | E '-'{push();} E{codegen();}
         | E '*'{push();} E{codegen();}
         | E '/'{push();} E{codegen();}
         | '(' E ')'
         | '-'{push();} E{codegen_umin();} %prec UMINUS
         | V
         | INTEGER{push();}
         | FLOAT{push();}
         ;
V       : NAME {push_new();}
        ;

%%

string to_ssstring(int i)
{
    std::stringstream ss;
    ss << i;
    return ss.str();
}
string st[50];
int label[100];
int top=0;
int i_ = 0;
string i_temp;
string temp="t";

int lno=0,ltop=0;
int start=1;

int lnum=0;


void push()
{
   st[++top]=yytext;
}

void push_new()
{
   cout<<yytext<<"\n";
   st[++top]=yytext;
}

void push_eq()
{
    st[++top]="EQ";
}

void codegen()
{
    temp="t";
    i_temp = to_ssstring(i_);
    temp+=i_temp;
    cout<<temp<<" = "<<st[top-2]<<" "<<st[top-1]<<" "<< st[top]<<"\n";
    top-=2;
    st[top]=temp;
    i_++;
}

void codegen_umin()
{
    temp="t";
    i_temp = to_ssstring(i_);
    temp+=i_temp;
    cout<<temp<<" = "<<st[top-2]<<" "<<st[top-1]<<" "<< st[top]<<"\n";
    top--;
    st[top]=temp;
    i_++;
}

void codegen_assign()
{
	cout<<st[top-2]<<" = "<<st[top]<<"\n";
    top-=2;
}
void lab1()
{
 lnum++;
 temp="t";
 i_temp = to_ssstring(i_);
 temp+=i_temp;

 cout<<temp<<" = not "<<st[top]<<"\n";
 cout<<"if "<<temp<<" goto L"<<lnum<<"\n";
 i_++;
 label[++ltop]=lnum;
}

void lab6()
{
 lnum++;
 temp="t";
 i_temp = to_ssstring(i_);
 temp+=i_temp;

 cout<<temp<<" = not "<<st[top]<<"\n";
 cout<<"if "<<temp<<" goto L"<<lnum<<"\n";
 i_++;
 label[++ltop]=lnum;
}


void lab2()
{
int x;
lnum++;
x=label[ltop--];
printf("goto L%d\n",lnum);
printf("L%d: \n",x); 
label[++ltop]=lnum;
}

void lab7()
{
int x;
lnum++;
x=label[ltop--];
printf("goto L%d\n",lnum-2);
printf("L%d: \n",x); 
label[++ltop]=lnum;
}

void lab4()
{
int x;
lnum++;
x=label[ltop--];
printf("L%d: \n",x); 
label[++ltop]=lnum;
}

void lab3()
{
int y;
y=label[ltop--];
printf("L%d: \n",y);
}

void lab5()
{
 lnum++;
 cout<<"L"<<lnum<<":"<<"\n";
}

int main(int argc, char** argv) {
	int c=1;
	FILE *fh;
	if(argc==2&&(fh=fopen(argv[1],"r")))
		yyin=fh;	
	do {
		yyparse();
		cout << endl;
	} while (!feof(yyin));
	cout<<"\n";
	sym_tab* temp_s;
	temp_s = head;
	while(temp_s){
		cout<<temp_s->name<<"	"<<temp_s->type<<"\n";
		temp_s=temp_s->next;
	}
}

void yyerror(const char *s) {
	cout << "EEK, parse error!  Message: " << s << endl;
	exit(-1);
}