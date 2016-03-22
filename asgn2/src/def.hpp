/**
*Definitions of headers and operations
*/
#include <string> 
// Instruction types

#define ASSIGN 1
#define JUMP 2
#define COPY 3

// Operator types
#define IFGOTO 0
#define ADD 1
#define SUB 2
#define ASGN 3
#define GOTO 4

// Relational operators
#define LEQ 1
#define GEQ 2
#define EQ	3
#define LT  4
#define GT  5
#define NE  6

// Operand types
#define LITERAL 0
#define VARIABLE 1

typedef	struct var
{
	int type;
	std::string name;
	// more required	
} var;

class ThreeAddrInstr
{
public:
	int lineno;
	int instr;
	int op;
	var dest;
	var op1;
	var op2;
	ThreeAddrInstr(std::string Line);
	~ThreeAddrInstr();	
};

ThreeAddrInstr::def()
