#include <iostream>
#include <sstream>
#include <string>
using namespace std;

typedef struct item {
   int val;
   item * next;
} item;

typedef struct variable{
	string name;
	variable* next;
	item* first;
	item* last;

}variable;

typedef struct basic_block{
	int id;
	int first;
	int last;
	basic_block * next;
}bb;

int main()
{
int num, i, line = -1, counter = 0, flag =0, flag2, flag4 = 0, id_count = 1;
string ex1,ex2;
variable * v_head, *v_temp;
item * i_head, *i_temp;
bb * bb_head, * bb_temp;
string word;

cout<<"Print\n";
getline(cin,ex1);
istringstream iss(ex1);
while(iss >> word) {
	if(word.compare(",")==0){
		line = -1;
	}
	else if (isdigit(word.at(0))){
		//collect the number
		num = std::stoi(word);
		if(line==-1){
			line = num;
			if(line==1){
				bb * asd = new bb;
				asd->id = 1;
				asd->first = line;
				asd->last = 1;
				asd->next = NULL;
				bb_head = asd;
				bb_temp = asd;
				id_count++;
			}
		}
		cout<<num<<"\n";
    	}
	else if (word.size()>1 && isdigit(word.at(1))){
		//collect number and multiply by -1
		//word=word(
		num = std::stoi(word);
		//num=num*-1;
		cout<<num<<"\n";
	}
	else{
		//make list
        	cout<<word<<"\n";
		if((word.compare("if")==0)&&line!=1){
			flag4 = 1;
			bb * asd = new bb;
			asd->id = id_count;
			asd->first = line;
			asd->last = line;
			asd->next = NULL;
			bb_temp->last = (line-1);
			bb_temp->next = asd;
			bb_temp = asd;
			id_count++;
		}
		else if((word.compare("if")==0)&&line==1){
			flag4 = 1;
		}
		else if((word.compare("goto")==0)&&flag4==1){
			flag4 = 0;
			bb_temp->last = line;
			bb * asd = new bb;
			asd->id = id_count;
			asd->first = line+1;
			asd->last = line+1;
			asd->next = NULL;
			bb_temp->next = asd;
			bb_temp = asd;
			id_count++;
		}	
		else if((word.compare("goto"))==0){
			bb * asd = new bb;
			bb_temp->last = line;
			asd->id = id_count;
			asd->first = (line+1);
			asd->last = (line+1);
			asd->next = NULL;
			bb_temp->next = asd;
			bb_temp = asd;
			id_count++;
		}
		if(((word.compare("+")!=0)&&(word.compare("-")!=0)&&(word.compare("=")!=0)&&(word.compare("if")!=0)&&(word.compare("goto")!=0))&&(word.compare("<")!=0)&&(word.compare(">")!=0)){
			flag2 = 0;
			v_temp = v_head;
			if(counter==0){
				counter++;
				variable * qwer = new variable;
				qwer->name = word;
				qwer->next = NULL;
				item * curr = new item;
				curr->val = line;
				curr->next = NULL;
				qwer->first = curr;
				qwer->last = curr;
				v_head = qwer;
				v_temp = qwer;
				//remember to skip below code
				flag2 = 1;
			}
			if(flag2 == 0){
				for(i=1;i<=counter;i++){
					if(word.compare(v_temp->name)==0){
						flag = 1;
						//update next use to line
						i_temp = v_temp->last;
						item * curr = new item;
      						curr->val = line;
      						curr->next  = NULL;
						i_temp->next = curr;
						v_temp->last = curr;
					}
					if(v_temp->next!=NULL){
						v_temp = v_temp->next;
					}
				}
				if(flag==0){
					//allot new list to variable
					counter++;
					variable * qwer = new variable;
					qwer->name = word;
					qwer->next = NULL;
					item * curr = new item;
					curr->val = line;
					curr->next = NULL;
					qwer->first = curr;
					qwer->last = curr;
					v_temp->next = qwer;
					v_temp = qwer;
				}
				flag = 0;
			}
		}
	}
}
v_temp = v_head;
cout<<"\n";
if(line>bb_temp->last){
	bb_temp->last=line;
}
else if(bb_temp->last>line){
	bb_temp = NULL;
}
cout<<"Counter	 "<<counter<<"\n";
while(v_temp!=NULL){
	cout<<v_temp->name;
	i_temp = v_temp->first;
	while(i_temp!=NULL){
		cout<<i_temp->val<<"	";
		i_temp = i_temp->next;
	}
	cout<<"\n";
	v_temp = v_temp->next;
}
cout<<"\n";
bb_temp = bb_head;
while(bb_temp!=NULL){
	cout<<bb_temp->id<<"	"<<bb_temp->first<<"	"<<bb_temp->last<<"\n";
	bb_temp = bb_temp->next;
}
return 0;
}
