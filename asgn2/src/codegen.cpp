/**
*To generate code
*/
#include "def.h"
#include "gen.cpp"
#include <algorithm>
#include <string>
#include <sstream>
#include <iostream>
#include <map>;
#ifndef EXIT_CODE
#define EXIT_CODE "\tli	$v0, 10\n\tsyscall\n\n"
#endif

extern std::vector<bb> qwer;

std::string text="\t.text\n__start:";
std::string reg_desc[32];
std::map<std::string, std::string> addr_desc; 
// std::string target_headers[/*number of blocks*/];

void target_generate(){
	// fill above string array with header targets of basic blocks
	for (std::vector<bb>::iterator i = qwer.begin(); i != qwer.end(); ++i){
		
	}
}

void data_writer(){
	// scan all variables and define them in .data
}

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
   if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) return false ;
   char * p ;
   strtol(s.c_str(), &p, 10) ;
   return (*p == 0) ;
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
	data_writer();
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
int main(int argc, char const *argv[])
{
	std::fill_n(reg_desc,32,-1);
	reg_desc[0]=0;
	
	return 0;
}