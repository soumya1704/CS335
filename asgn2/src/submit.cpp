#include <iostream>
#include <sstream>
#include <vector>
#include <string>
// #include "def.h"
// #include "gen.cpp"
#include <algorithm>
#include "submit.hpp"
#include <map>
#ifndef EXIT_CODE
#define EXIT_CODE "\tli	$v0, 10\n\tsyscall\n\n"
#endif

typedef struct basic_block{
	int first, last;
	basic_block * next;
}bb;

typedef struct symbol_table{
	std::string variable;
	int count;
	symbol_table * next;
}sym_tab;

std::string text="\t.text\n__start:";
std::string reg_desc[32];
std::map<std::string, std::string> addr_desc; 

void beq(std::string reg1,std::string reg2,std::string target);
{
	text+="\tbeq ";
	text+=reg1;
	text+=", ";
	text+=reg2;
	text+=", ";
	text+=target;
	text+="\n";
}

void ble(std::string reg1,std::string reg2,std::string target);
{
	text+="\tble ";
	text+=reg1;
	text+=", ";
	text+=reg2;
	text+=", ";
	text+=target;
	text+="\n";
}

void bge(std::string reg1,std::string reg2,std::string target);
{
	text+="\tbge ";
	text+=reg1;
	text+=", ";
	text+=reg2;
	text+=", ";
	text+=target;
	text+="\n";
}

void blt(std::string reg1,std::string reg2,std::string target);
{
	text+="\tblt ";
	text+=reg1;
	text+=", ";
	text+=reg2;
	text+=", ";
	text+=target;
	text+="\n";
}

void bgt(std::string reg1,std::string reg2,std::string target);
{
	text+="\tbgt ";
	text+=reg1;
	text+=", ";
	text+=reg2;
	text+=", ";
	text+=target;
	text+="\n";
}

void bne(std::string reg1,std::string reg2,std::string target);
{
	text+="\tbne ";
	text+=reg1;
	text+=", ";
	text+=reg2;
	text+=", ";
	text+=target;
	text+="\n";
}

void print_int(std::string reg){
	text+="\tli	$v0, 1\n\tmove $a0, ";
	text+=reg;
	text+="\n\tsyscall\n";
}

void move_to_memory(std::string var_name,std::string reg_name){
	text+="\tsw ";
	text+=reg_name;
	text+=", ";
	text+=var_name;
	text+="\n";
}

void move_to_register(std::string var_name,std::string reg_name){
	text+="\tlw ";
	text+=reg_name;
	text+=", ";
	text+=var_name;
	text+="\n";
}

void move_to_register_imm(std::string var_name,std::string reg_name){
	text+="\tli ";
	text+=reg_name;
	text+=", ";
	text+=var_name;
	text+="\n";
}

void move_reg_to_reg(std::string var_name,std::string reg_name){
	text+="\tmove ";
	text+=reg_name;
	text+=", ";
	text+=var_name;
	text+="\n";
}

void add_immediate(std::string reg1,std::string reg2, std::string num){
	text+="\taddi ";
	text+=reg1;
	text+=", ";
	text+=reg2;
	text+=", ";
	text+=num;
	text+="\n";
}

void add(std::string reg1,std::string reg2, std::string reg3){
	text+="\tadd ";
	text+=reg1;
	text+=", ";
	text+=reg2;
	text+=", ";
	text+=reg3;
	text+="\n";
}
void sub(std::string reg1,std::string reg2, std::string reg3){
	text+="\tsub ";
	text+=reg1;
	text+=", ";
	text+=reg2;
	text+=", ";
	text+=reg3;
	text+="\n";
}

inline bool is_digit(const std::string &s)
{
   // if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) return false;
   // char *p ;
   // strtol(s.c_str(), &p, 10) ;
   // return (*p == 0) ;
	char c*
}

bb *bb_head, *bb_temp, *bb_short;

int register_to_spill(int line){
	bb_temp = bb_head;
	int k = 0;
	string str;
	while(bb_temp!=NULL){
		if((bb_temp->last)<line){
			bb_temp=bb_temp->next;
			k++;
		}
		else{
			sym_tab_temp = head[k];
			min = sym_tab_temp->count;
			str = sym_tab_temp->variable;
			while(sym_tab_temp!=NULL){
				if((min>=sym_tab_temp->count) && (sym_tab_temp->variable!=var[0])&& (sym_tab_temp->variable!=var[1])&& (sym_tab_temp->variable!=var[2])){
					min = sym_tab_temp->count;
					str = sym_tab_temp->variable;
					break;
				}
				sym_tab_temp=sym_tab_temp->next;
			}
		}
		return addr_desc[str];
	}
}

// gives MIPS shorthand name for register
std::string regtostring(int r){
	std::string names[]={"zero","$at","$v0","$v1","$a0","$a1","$a2","$a3","$t0","$t1","$t2","$t3","$t4","$t5","$t6","$t7","$s0","$s1","$s2","$s3","$s4","$s5","$s6","$s7","$t8","$t9","$k0","$k1","$gp","$sp","$fp","$ra"};
	return names[i];
}
// gives MIPS register number for appropriate regname
std::string stringtoreg(std::string reg){
	std::string names[]={"zero","$at","$v0","$v1","$a0","$a1","$a2","$a3","$t0","$t1","$t2","$t3","$t4","$t5","$t6","$t7","$s0","$s1","$s2","$s3","$s4","$s5","$s6","$s7","$t8","$t9","$k0","$k1","$gp","$sp","$fp","$ra"};
	for (int i = 0; i < 32; ++i){
		if(names[i]==reg)
			return i;
	}
}
// allocates register for Y 
void get_register(std::string Y, std::string X){
	int flag=0;
	// First check if X has a register, if not, give it one
	if(addr_desc.find(X)==addr_desc.end()){
		int t=8;
		while(!reg_desc[t].empty()&&t<=25){
			t++;
			if(t==16)
				t+=8;
		}
		if(t<26){
			// a temporary can be allotted
			reg_desc[t]=X;
			addr_desc[X]=regtostring(t);
			move_to_register(X,addr_desc[X]);	
		}else{
			int t=register_to_spill();
			// store content of t to memory
			move_to_memory(reg_desc[t],regtostring[t]);	
			reg_desc[t]=X;
			addr_desc[X]=regtostring(t);
			move_to_register(X,addr_desc[X]);
		}
	}
	if(is_digit(Y)){
		move_to_register_imm(Y,addr_desc[X]);
	}else
		if(addr_desc.find(Y)!=addr_desc.end())
		{
			// Do nothing: Y already has a register to live in
		}
		else{
			// Allocate an empty register for Y
			int t=8;
			while(!reg_desc[t].empty()&&t<=25){
				t++;
				if(t==16)
					t+=8;
			}
			if(t<26){
				reg_desc[t]=Y;
				addr_desc[Y]=regtostring(t);
				move_to_register(Y,addr_desc[Y]);	
			}else{
				flag=1;
			}
		}
	if(flag){
		if(has_next_use(X)){
			int t=register_to_spill();
			// store content of t to memory
			move_to_memory(reg_desc[t],regtostring[t]);	
			reg_desc[t]=Y;
			addr_desc[Y]=regtostring(t);
			move_to_register(Y,addr_desc[Y]);	
		}else{
			addr_desc[Y]=addr_desc[X];
			move_to_memory(Y,addr_desc[Y]);
		}
	}
}
std::string get_uniqreg(std::string Z){
	if(addr_desc.find(Z)!=addr_desc.end())
	{
		// Do nothing: Y already has a register to live in
		return addr_desc[Z];
	}
	int t=8;
	while(!reg_desc[t].empty()&&t<=25){
		t++;
		if(t==16)
			t+=8;
	}
	if(t<26){
		// a temporary can be allotted
		reg_desc[t]=Z;
		if(is_digit(Z)){
			move_to_register_imm(Z,regtostring(t));
		}else{
			addr_desc[Z]=regtostring(t);
			move_to_register(Z,addr_desc[Z]);
		}		
	}else{
		int t=register_to_spill();
		// store content of t to memory
		move_to_memory(reg_desc[t],regtostring[t]);	
		reg_desc[t]=Z;
		if(is_digit(Z)){
			move_to_register_imm(Z,regtostring(t));
		}else{
			addr_desc[Z]=regtostring(t);
			move_to_register(Z,addr_desc[Z]);
		}
	}
	return regtostring(t);
}


void mips_writer(std::string X,std::string Y,std::string Z,int op,int relop){
	// data_writer();
	switch(op){
		case ADD:
			if(is_digit(Y)&&!is_digit(Z)){
				get_register(Z,X);
				add_immediate(addr_desc[X],addr_desc[Z],Y);
				// reg_desc[stringtoreg(addr_desc[X])]=X;
				if(addr_desc[Z]==addr_desc[X])
					addr_desc.erase(Z);
			}else if(!is_digit(Y)&&is_digit(Z)){
				get_register(Y,X);
				add_immediate(addr_desc[X],addr_desc[Y],Z);
				if(addr_desc[Y]==addr_desc[X])
					addr_desc.erase(Y);
			}else if(is_digit(Y)&&is_digit(Z)){
				get_register(Y,X);
				add_immediate(addr_desc[X],addr_desc[X],Z);
			}else{
				get_register(Y,X);
				get_uniqreg(Z);
				add(addr_desc[X],addr_desc[Y],addr_desc[Z]);
				if(Y!=Z)
					if(addr_desc[Y]==addr_desc[X])
						addr_desc.erase(Y);
					else if(addr_desc[Z]==addr_desc[X])
						addr_desc.erase(Z);
				else if(addr_desc[Y]==addr_desc[X])
					addr_desc.erase(Y);	
			}	
		break;
		case SUB:
			if(is_digit(Y)&&!is_digit(Z)){
				get_register(Z,X);
				sub(addr_desc[X],addr_desc[Z],get_uniqreg(Y));
				// reg_desc[stringtoreg(addr_desc[X])]=X;
				if(addr_desc[Z]==addr_desc[X])
					addr_desc.erase(Z);
			}else if(!is_digit(Y)&&is_digit(Z)){
				get_register(Y,X);
				sub(addr_desc[X],addr_desc[Y],get_uniqreg(Z));
				if(addr_desc[Y]==addr_desc[X])
					addr_desc.erase(Y);
			}else if(is_digit(Y)&&is_digit(Z)){
				get_register(Y,X);
				sub(addr_desc[X],addr_desc[Y],get_uniqreg(Z));
			}else{
				get_register(Y,X);
				get_uniqreg(Z);
				sub(addr_desc[X],addr_desc[Y],addr_desc[Z]);
				if(Y!=Z)
					if(addr_desc[Y]==addr_desc[X])
						addr_desc.erase(Y);
					else if(addr_desc[Z]==addr_desc[X])
						addr_desc.erase(Z);
				else if(addr_desc[Y]==addr_desc[X])
					addr_desc.erase(Y);	
			}	
		break;
		case ASGN:
			// Assumptions: X is destination, Y is source
			if(is_digit(Y)){
				move_to_register_imm(Y,get_uniqreg(X));
			}else{
				move_reg_to_reg(get_uniqreg(Y),get_uniqreg(X));
			}
		break;
		case IFGOTO:
			// Assumptions: X contains operand1, Y contains operand2, Z has jump target
			switch(relop){
				case EQ:
					beq(get_uniqreg(X),get_uniqreg(Y),Z);
				break;
				case GEQ:
					bge(get_uniqreg(X),get_uniqreg(Y),Z);
				break;
				case LEQ:
					ble(get_uniqreg(X),get_uniqreg(Y),Z);
				break;
				case GT:
					bgt(get_uniqreg(X),get_uniqreg(Y),Z);
				break;
				case LT:
					blt(get_uniqreg(X),get_uniqreg(Y),Z);
				break;
				case NE:
					bne(get_uniqreg(X),get_uniqreg(Y),Z);
				break;
			}		
		break;	
	}
	text+=EXIT_CODE;
}

sym_tab *head[1000], *sym_tab_temp, *sym_tab_short;
// 

int main(){
	std::string ex1, ex2, ex3, word;
	int t_flag = 0,line = -1, num, bb_count=1, flag4 = 0, flag2, flag = 0,row_count = 0, temp_count, i, j, temp, q, g;
	// bb *bb_head, *bb_temp, *bb_short;

	std::cout<<"Print\n";
	getline(std::cin, ex1);
	ex2 = ex1;
	ex3 = ex1;	
	istringstream iss(ex1);
	while(iss >> word){
		if(word.compare(",")==0){
			line = -1;
		}
		else if(isdigit(word.at(0))){
			num = std::stoi(word);
			if(line==-1){
				line = num;
				if(line==1){
					bb * zxc = new bb;
					zxc->first = 1;
					zxc->last = 1;
					zxc->next = NULL;
					bb_head = zxc;
					bb_temp = zxc;
				}
			}
			std::cout<<num<<"\n";
		}
		else if(word.size()>1 && isdigit(word.at(1))){
			num = std::stoi(word);
			std::cout<<num<<"\n";;
		}
		else{
			std::cout<<word<<"\n";
			if((word.compare("if")==0) && line!=1){
				flag4 = 1;
				bb_count++;
				std::cout<<"line:bb_count"<<line<<" "<<bb_count;
				bb * zxc = new bb;
				zxc->first = line;
				zxc->last = line;
				zxc->next = NULL;
				bb_temp->next = zxc;
				bb_temp = zxc;
			}
			else if(word.compare("if")==0 && line==1){
				flag4 = 1;
			}
			else if((word.compare("goto")==0) && flag4==1){
				flag4 = 1;
				bb_count++;
				bb_temp->last = line;
				bb *zxc = new bb;
				zxc->first = line+1;
				zxc->last = line+1;
				zxc->next = NULL;
				bb_temp->next = zxc;
				bb_temp = zxc;				
				std::cout<<"line:bb_count"<<line<<" "<<bb_count;
			}
			else if(word.compare("goto")==0){
				bb_temp->last = line;
				bb * zxc = new bb;
				zxc->first = line+1;
				zxc->last = line+1;
				zxc->next = NULL;
				bb_temp->next = zxc;
				bb_temp = zxc;
				bb_count++;
			}
		}
	}
	std::cout<<"bb\n";
	bb_temp = bb_head;
	while(bb_temp!=NULL){
		std::cout<<bb_temp->first<<":"<<bb_temp->last;
		bb_temp = bb_temp->next;
	}
	std::cout<<"end\n";
	line = -1;
	temp = 0;
	bb_temp =bb_head;
	std::istringstream ss(ex2);
	while(ss >> word){
		flag2 = 0;
		if(word.compare(",")==0){
			line = -1;
		}
		else if(isdigit(word.at(0))){
			num = std::stoi(word);
			if(line==-1){
				line = num;
				std::cout<<"line chng\n";
			}
			std::cout<<num<<"\n";
		}else if(word.size()>1 && isdigit(word.at(1))){
			num = std::stoi(word);
			std::cout<<num<<"\n";;
		}
		else{
			std::cout<<word<<"\n";
			if(word.compare("+")!=0 && word.compare("-")!=0 && word.compare("<")!=0 && word.compare(">")!=0 && word.compare("if")!=0 && word.compare("goto")!=0 && word.compare("=")!=0){
				std::cout<<word<<"\n";
				q=0;
				std::cout<<"line:"<<line<<"\n";
				while(line<=bb_temp->last && q==0){
					if(flag == 0){
						q=1;
						flag = 1;
						sym_tab * asd = new sym_tab;
						asd->variable = word;
						asd->count = 1;
						asd->next = NULL;
						head[temp] = asd;
						flag2 = 1;
					}else{
						std::cout<<"here";
						sym_tab_temp = head[temp];
						while(sym_tab_temp!=NULL){
							if(sym_tab_temp->variable==word){
								std::cout<<"no\n";
								sym_tab_temp->count++;
								flag2 = 1;
								q=1;
								break;
							}else{
								std::cout<<"end";
								sym_tab_short = sym_tab_temp;
								sym_tab_temp = sym_tab_temp->next;
								q = 1;
							}
						}
						std::cout<<"atleast";
						if(flag2 == 0){
							std::cout<<"why not";
							q=1;
							sym_tab * asd = new sym_tab;
							asd->variable = word;
							asd->count = 1;
							asd->next = NULL;
							sym_tab_short->next = asd;
							flag2 = 1;
						}
					}
				}
				while(line>bb_temp->last){
					std::cout<<"right";
					temp++;
					flag2 = 0;
					std::cout<<temp<<"\n";
					bb_temp = bb_temp->next;
					sym_tab * asd = new sym_tab;
					asd->variable = word;
					asd->count = 1;
					asd->next = NULL;
					head[temp] = asd;
				}
			}
		}
	}
	for(i=0; i<=bb_count; i++){
		sym_tab_temp = head[i];
		while(sym_tab_temp!=NULL){
			std::cout<<i<<":";
			std::cout<<sym_tab_temp->variable<<":"<<sym_tab_temp->count<<"	";
			sym_tab_temp = sym_tab_temp->next;
		}
		std::cout<<"\n";
	}
	std::string goto_target;
	std::string var[]={"","",""};
	int op, relop = -1;
	std::istringstream ssi(ex3);
	line = -1;
	i = 0;
	// var_count = 0;
	while(ssi >> word){
		if(word.compare(",")==0){
			mips_writer(var[0],var[1],var[2],op,relop);
			line = -1;
			i = 0;
			relop = -1;
		}
		else if(isdigit(word.at(0))){
			num = std::stoi(word);
			if(t_flag==1){
				goto_target = word;
				t_flag = 0;
			}
			if(line==-1){
				line = num;
			}
			else{
				var[i] = word;
				i++;
			}
		}
		else{
			if(word.compare("=")==0){
				op = ASGN;
			}
			else if(word.compare("+")==0){
				op = ADD;
			}
			else if(word.compare("-")==0){
				op = SUB;
			}
			else if(word.compare("if")==0){
				op = IFGOTO;
			}
			else if(word.compare("<")==0){
				if(op == IFGOTO){
					relop = LT;
				}
			}
			else if(word.compare(">")==0){
				if(op == IFGOTO){
					relop = GT;
				}
			}
			else if(word.compare(">=")==0){
				if(op == IFGOTO){
					relop = GEQ;
				}
			}
			else if(word.compare("<=")==0){
				if(op == IFGOTO){
					relop = LEQ;
				}
			}
			else if(word.compare("<>")==0){
				if(op == IFGOTO){
					relop = NE;
				}
			}
			else if(word.compare("=")==0){
				if(op == IFGOTO){
					relop = EQ;
				}
			}
			else if(word.compare("goto")==0){
				t_flag = 1;
				if(op != IFGOTO){
					op = GOTO;
				}
			}
			else{
				if(t_flag==1){
					goto_target = word;
				}
				var[i] = word;
				i++;
			}
		}
	}	
	std::cout<<"Solution\n";
	std::cout<<text;
	return 0;
}
