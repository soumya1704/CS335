%{
#include <iostream>	
#include <stack>
#include "yaccforpy.tab.h"

#define YY_DECL extern "C" int yylex()

size_t line_indent_count=0;
std::stack<size_t> indent_level;
int fake_dedent=0;
int fake_visited=0;
int flag_def=0;

#define YY_USER_INIT { \
        indent_level.push(0); \
        BEGIN(initial); \
    }
int yycolumn=1;
struct sym_tab
{
	std::string name;
	int type;
	sym_tab* next;
};
sym_tab* head=NULL;
void placeit(std::string holding){
	// printf("waste\n");
	sym_tab* root;
	sym_tab* temp;
	sym_tab* ptemp;
	if(head==NULL){
		// printf("????\n");
		root = new sym_tab;
		root->next=NULL;
		if(flag_def==1){
			root->type=1;
			flag_def=0;
		}
		else{
			root->type=2;
		}
		root->name = holding;
		head = root;
	}
	else{
		// printf("=======\n");
		temp = head;
		while(temp){
			ptemp = temp;
			temp=temp->next;
		}
		// printf("!!!!\n");
		root = new sym_tab;
		// printf("qqqq\n");
		root->next=NULL;
		if(flag_def==1){
			root->type=1;
			flag_def=0;
		}
		else{
			// printf("aaaaaaaa\n");
			root->type=2;
		}
		// printf("sssss\n");
		root->name = holding;
		// printf("ffff\n");
		ptemp->next = root;
		// printf("``````````\n");
	}
}
void findit(std::string holding){
	// printf("here\n");
	int flag_holding = 0;
	sym_tab* temp;
	if(head!=NULL){
	temp = head;	
	}
	else{
		// printf("/////\n");
		temp = NULL;
	}
	// printf("here2\n");
	
	while(temp!=NULL){
		if(temp->name==holding){
			flag_holding=1;
		}
		temp=temp->next;
	}
	if(flag_holding==0){
		placeit(holding);
	}	
}


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
<*>\n 										{ yylineno--; REJECT; }

<initial>.  								{ indent_caller = normal; yyless(0); 
												BEGIN(indent);
											}
<initial>\n 								{ 	indent_caller = normal; yyless(0); 
												BEGIN(indent); 
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
							                            BEGIN(indent_caller);
							                        }
							                        return DEDENT;
						                    	}else{
						                        	yyterminate();
						                    	}
                							}
<indent>.									{ 	if(!fake_dedent)
													unput(*yytext);
												else{
													fake_visited=1;
												}
												fake_dedent=0;
												if(line_indent_count>indent_level.top()){
													indent_level.push(line_indent_count);
													BEGIN(indent_caller);
													return INDENT;		
												}else if(line_indent_count<indent_level.top()){
													indent_level.pop();
													if(line_indent_count!=indent_level.top()){
														for(size_t i = 0; i<line_indent_count; ++i){
															unput(' ');		
														}
														unput('\n');
														unput('.');
														fake_dedent=1;
														for(size_t i = 0; i<indent_level.top(); ++i){
															unput(' ');		
														}
														unput('\n');
													}else{
														BEGIN(indent_caller);
													}	
													return DEDENT;
												}else{
													BEGIN(indent_caller);
												}	
											}

<normal>\n									{	
												line_indent_count=0; 
												indent_caller=YY_START; 
												BEGIN(indent);
												if(!fake_visited){
													return NEWLINE; 
												}
												fake_visited=0;
											}

<normal>"def"								{	flag_def=1;
												return DEF;
											}
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

<normal>[_a-zA-Z][_a-zA-Z0-9]*						{ yylval.sval = strdup(yytext); findit(yylval.sval); return NAME; }

<normal>[ \t]+								;

(.|\n)										{	std::cout<<"Unidentified token "<<yytext<<" at "<<yylineno<<std::endl; return -1;}



%%
