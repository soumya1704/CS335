
#include <iostream>
#include <sstream>
#include <vector>
#include <string>

using namespace std;

typedef struct basic_block{
	int first, last;
}bb;

typedef struct symbol_table{
	string variable;
	int count;
	symbol_table * next;
}sym_tab;

int main(){
	string ex1, ex2, word;
	int line = -1, num, bb_count=1, flag4 = 0, flag2 ,row_count = 0, temp_count, i, j, temp;
	sym_tab * head[1000], *sym_tab_temp, *sym_tab_short;
	
	std::vector<bb> qwer;
	std::vector<vector<sym_tab>> primary;
	vector<sym_tab> secondary;

//iterators
	vector<vector<sym_tab>>::iterator row;
	vector<sym_tab>::iterator col;

	cout<<"Print\n";
	getline(cin, ex1);
	ex2 = ex1;
	
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
					qwer.push_back(bb());
					qwer[0].first = 1;
					qwer[0].last = 1;
				}
			}
	cout<<num<<"\n";

		}
		else if(word.size()>1 && isdigit(word.at(1))){
			num = std::stoi(word);
			cout<<num<<"\n";;
		}
		else{
			cout<<word<<"\n";
			if((word.compare("if")==0) && line!=1){
				flag4 = 1;
				bb_count++;
				qwer[bb_count-1].last = line-1;
				qwer.push_back(bb());
				qwer[bb_count].first = line;
				qwer[bb_count].last = line;
			}
			else if(word.compare("if")==0 && line==1){
				flag4 = 1;
			}
			else if((word.compare("goto")==0) && flag4==1){
				flag4 = 1;
				qwer[bb_count].last = line;
				qwer.push_back(bb());
				bb_count++;
				qwer[bb_count].first = line+1;
				qwer[bb_count].last = line+1;
			}
			else if(word.compare("goto")==0){
				qwer[bb_count].last = line;
				qwer.push_back(bb());
				bb_count++;
				qwer[bb_count].first = line+1;
				qwer[bb_count].last = line +1;
			}
			if(word.compare("+")!=0 && word.compare("-")!=0 && word.compare("<")!=0 && word.compare(">")!=0 && word.compare("if")!=0 && word.compare("goto")!=0 && word.compare("=")!=0){
			/*	flag2 = 0;
				while(row_count==temp){
					//row = primary.at(row_count);
					//for(col = row->begin(); col!=row->end();col++){
					for(i=0;i<=temp;i++){
						if(word.compare(primary[row_count][i].name)==0){
							primary[row_count][i].count++;
						flag2 = 1;
							break;
						}
					}
					if(flag2 == 0){
						primary[row_count].push_back(sym_tab());
						temp++;
						primary[row_count][temp].variable = word;
						primary[row_count][temp].count = 1;
					}
				}
				while(row_count!=temp){
					vector<sym_tab> secondary;
					primary.push_back(secodary);
					row_count++;
					primary[row_count].push_back(sym_tab());
					temp=0;
					primary[row_count][temp].variable = word;
					primary[row_count][temp].count = 1;
				}*/
	/*			while(row_count==bb_count){
					sym_tab_temp = head[row_count];
					while(sym_tab_temp!=NULL){
						if(sym_tab_temp->variable==word){
							sym_tab_temp->count++;
							flag2 = 1;
							break;
						}
						else{
							sym_tab_short = sym_tab_temp;
							sym_tab_temp = sym_tab_temp->next;
						}
					}
					if(flag2 == 0){
						sym_tab * qwer = new sym_tab;
						qwer->variable = word;
						qwer->count = 1;
						qwer->next = NULL;
						sym_tab_short->next = qwer;
						flag2 = 0;
					}
				}
				while(row_count!=bb_count){
					row_count++;
					sym_tab * qwer = new sym_tab;
					qwer->variable = word;
					qwer->count = 1;
					qwer->next = NULL;
					head[row_count] = qwer;
				}
	*/
			}
		}
	}
cout<<"end\n";
	temp = 0;
	istringstream ss(ex2);
	while(ss >> word){
		if(word.compare(",")==0){
			line = -1;
		}
		else if(isdigit(word.at(0))){
			num = std::stoi(word);
			if(line==-1){
				line = num;
cout<<"line chng\n";
			}
		cout<<num<<"\n";

		}
		else if(word.size()>1 && isdigit(word.at(1))){
			num = std::stoi(word);
			cout<<num<<"\n";;
		}
		else{
			cout<<word<<"\n";
			if(word.compare("+")!=0 && word.compare("-")!=0 && word.compare("<")!=0 && word.compare(">")!=0 && word.compare("if")!=0 && word.compare("goto")!=0 && word.compare("=")!=0){
cout<<word<<"\n";
			/*	flag2 = 0;
				while(row_count==bb_count){
					//row = primary.at(row_count);
					//for(col = row->begin(); col!=row->end();col++){
					for(i=0;i<=temp;i++){
						if(word.compare(primary[row_count][i].name)==0){
							primary[row_count][i].count++;
						flag2 = 1;
							break;
						}
					}
					if(flag2 == 0){
						primary[row_count].push_back(sym_tab());
						temp++;
						primary[row_count][temp].variable = word;
						primary[row_count][temp].count = 1;
					}
				}
				while(row_count!=bb_count){
					vector<sym_tab> secondary;
					primary.push_back(secodary);
					row_count++;
					primary[row_count].push_back(sym_tab());
					temp=0;
					primary[row_count][temp].variable = word;
					primary[row_count][temp].count = 1;
				}*/
cout<<line<<"\n";
cout<<"qwer[temp].last"<<qwer[temp].last<<"\n";
				while(line<=qwer[temp].last){
cout<<"wrong";
					sym_tab_temp = head[row_count];
					while(sym_tab_temp!=NULL){
						if(sym_tab_temp->variable==word){
							sym_tab_temp->count++;
							flag2 = 1;
							break;
						}
						else{
							sym_tab_short = sym_tab_temp;
							sym_tab_temp = sym_tab_temp->next;
						}
					}
					if(flag2 == 0){
						sym_tab * asd = new sym_tab;
						asd->variable = word;
						asd->count = 1;
						asd->next = NULL;
						sym_tab_short->next = asd;
						flag2 = 0;
					}
				}
				while(line>qwer[temp].last){
cout<<"right";
					temp++;
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
			cout<<sym_tab_temp->variable<<":"<<sym_tab_temp->count<<"	";
			sym_tab_temp = sym_tab_temp->next;
		}
		cout<<"\n";
	}


/*	i=0;
	for(row=primary.begin();row!=primary.end();row++){
		j = 0;
		for(col=row->begin;col!=row->end;col++){
			cout<<primary[i][j].name<<":"<<primary[i][j].count<<"	";
			j++;
		}
		i++;
		cout<<"\n";
	}*/

	return 0;
}
