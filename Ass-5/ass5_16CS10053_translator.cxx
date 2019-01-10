# include "ass5_16CS10053_translator.h"
# include "y.tab.h"
# include <string.h>
# include <stdlib.h>
# include <stdio.h>
#include <iomanip>
# include <iostream>
#include <assert.h>
using namespace std;
#define TEMP_MAX_SIZE 1000

symbol_table_fields::symbol_table_fields(char *name_f, tNode *Type_f, void *initial_value_f, int size_f, int offset_f, symbolTable *nestedTable_f) 
: name(name_f), Type(Type_f), initial_value(initial_value_f), size(size_f), offset(offset_f), nestedTable(nestedTable_f) {}
void symbol_table_fields::operator=(symbol_table_fields &x){
	this->name = x.name;
	this->Type = x.Type;
	this->initial_value = x.initial_value;
	this->size = x.size;
	this->offset = x.offset;
	this->nestedTable = x.nestedTable;
}
symbol_table_fields::~symbol_table_fields(){}
void symbol_table_fields::print_row(){
	// printf("%s\t ",name);
	cout<<setw(20)<<name;
	print_Initial_Value(initial_value,Type);
	cout<<setw(20)<<size;
	cout<<setw(20)<<offset;
	if(nestedTable == NULL)
		cout<<setw(20)<<"null";
	else
		// printf("%s \t",(nestedTable->table)[0].name);
		cout<<setw(20)<<(nestedTable->table)[0].name;
	print_Tree(Type);
}

symbolTable::symbolTable(unsigned int capacity){
	table = new symbol_table_fields[capacity];
	curr_length = -1;
}
symbolTable::~symbolTable(){}
symbol_table_fields *symbolTable::lookup(char *t){											
	int i, j;
	i = 0; j = 0;
	i = j && i;
	for(i = 0;i<=curr_length;i++){
		if(strcmp(table[i].name,t) == 0)
			return (table + i);
	}
	return 0;
}
void symbolTable::insert(symbol_table_fields &x){												
	if(curr_length == -1)
		x.offset = 0;
	else
		x.offset = table[curr_length].size + table[curr_length].offset;
	curr_length++;
	table[curr_length] = x;
}
void symbolTable::print_Table(){
	if(MAX_SIZE>=0){
		int i;
		cout<<setw(20)<<"Name"<<setw(20)<<"Initial Value"<<setw(20)<<"Size"<<setw(20)<<"Offset"<<setw(20)<<"Nested Table"<<setw(20)<<"Type\n\n";
		for(i=0;i<=(this->curr_length);i++){
			table[i].print_row();
			cout<<"\n";
		}
	}															
	
}
symbol_table_fields *symbolTable::gentemp(date_types temp){
	tNode *t = new_node(temp,-1);
	char *s = new char[10];
	sprintf(s,"t%d",temp_count);
	temp_count++;
	int temp_size = 0;
	switch(temp){
		case INT_ : temp_size = SIZE_OF_INT;
					break;
		case CHAR_ : temp_size = SIZE_OF_CHAR;
					break;
		case DOUBLE_ : temp_size = SIZE_OF_DOUBLE;
					break;
		case PTR : temp_size = SIZE_OF_PTR;
					break;
	}
	symbol_table_fields x(s,t,0,temp_size,-1,0);
	this->insert(x);
	return &((this->table)[curr_length]);
}
/* Implementation of fields_quad */

fields_quad::fields_quad(char *arg1_f, char *arg2_f, char *res_f, quad_data_types op_f, symbol_table_fields *arg1_loc_f, symbol_table_fields *arg2_loc_f, symbol_table_fields *res_loc_f) : arg1(arg1_f), arg2(arg2_f), res(res_f), op(op_f), arg1_loc(arg1_loc_f), arg2_loc(arg2_loc_f), res_loc(res_loc_f) {}

fields_quad::~fields_quad() {}

void fields_quad::operator=(fields_quad &x){
	this->arg1 = x.arg1;
	this->arg2 = x.arg2;
	this->res = x.res;
	this->op = x.op;
	this->arg1_loc = x.arg1_loc;
	this->arg2_loc = x.arg2_loc;
	this->res_loc = x.res_loc;
}

void fields_quad::print_fields_quad(int line){
	if(this->arg2){
		switch(this->op){
			case PLUS : printf("%3d) %s = %s + %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case MINUS : printf("%3d) %s = %s - %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case INTO : printf("%3d) %s = %s * %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case DIV : printf("%3d) %s = %s / %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case PERCENT : printf("%3d) %s = %s %% %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case SL : printf("%3d) %s = %s << %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case SR : printf("%3d) %s = %s >> %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case LT : printf("%3d) %s = %s < %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case LTE : printf("%3d) %s = %s <= %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case GT : printf("%3d) %s = %s > %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case GTE : printf("%3d) %s = %s >= %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case EQ : printf("%3d) %s = %s == %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case NEQ : printf("%3d) %s = %s != %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case BW_AND : printf("%3d) %s = %s & %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case BW_XOR : printf("%3d) %s = %s ^ %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case BW_INOR : printf("%3d) %s = %s | %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case LOG_AND : printf("%3d) %s = %s && %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case LOG_OR : printf("%3d) %s = %s || %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case goto_LT : printf("%3d) if %s < %s goto %s\n",line,this->arg1,this->arg2,this->res);
						break;
			case goto_LTE : printf("%3d) if %s <= %s goto %s\n",line,this->arg1,this->arg2,this->res);
						break;
			case goto_GT : printf("%3d) if %s > %s goto %s\n",line,this->arg1,this->arg2,this->res);
						break;
			case goto_GTE : printf("%3d) if %s >= %s goto %s\n",line,this->arg1,this->arg2,this->res);
						break;
			case goto_EQ : printf("%3d) if %s == %s goto %s\n",line,this->arg1,this->arg2,this->res);
						break;
			case goto_NEQ : printf("%3d) if %s != %s goto %s\n",line,this->arg1,this->arg2,this->res);
						break;
			case call : printf("%3d) %s = call %s, %s\n",line,this->res,this->arg1,this->arg2);
						break;
			case EQ_BRACKET : printf("%3d) %s = %s[%s]\n",line,this->res,this->arg1,this->arg2);
						break;
			case BRACKET_EQ : printf("%3d) %s[%s] = %s\n",line,this->arg1,this->arg2,this->res);
						break;
		}
	}
	else{
		switch(this->op){
			case U_PLUS : printf("%3d) %s = %s\n",line,this->res,this->arg1);
						break;
			case U_MINUS : printf("%3d) %s = - %s\n",line,this->res,this->arg1);
						break;
			case BW_U_NOT : printf("%3d) %s = ~%s\n",line,this->res,this->arg1);
						break;
			case U_NEGATION : printf("%3d) %s = !%s\n",line,this->res,this->arg1);
						break;
			case U_ADDR : printf("%3d) %s = & %s\n",line,this->res,this->arg1);
						break;
			case U_STAR : printf("%3d) %s = * %s\n",line,this->res,this->arg1);
						break;
			case ASSIGN : printf("%3d) %s = %s\n",line,this->res,this->arg1);
						break;
			case GOTO_ : printf("%3d) goto %s\n",line,this->res);
						break;
			case IF_GOTO : printf("%3d) if %s goto %s\n",line,this->arg1,this->res);
						break;
			case IF_FALSE_GOTO : printf("%3d) ifFalse %s goto %s\n",line,this->arg1,this->res);
						break;
			case PARAM : printf("%3d) param %s\n",line,this->arg1);
						break;
			case RETURN_EXP : printf("%3d) return %s\n",line,this->arg1);
						break;
			case RETURN_ : printf("%3d) return\n",line);
						break;
			case Function : printf("%3d) %s : \n",line,arg1);
						break;
		}
	}
}



quadArray::quadArray(unsigned int capacity = MAX_SIZE){
	quad_Table = new fields_quad[capacity];
	next_instr = 0;
}
void quadArray::emit(fields_quad &x){
	quad_Table[next_instr++] = x;
}

void quadArray::print_quadArray(){
	int i;
	for(i = 0;i < next_instr;i++){
		quad_Table[i].print_fields_quad(i);
	}
}

void quadArray::fill_dangling_goto(int index, int data){
	char *temp = new char[10];
	sprintf(temp,"%d",data);
	((this->quad_Table)[index]).res = temp;
}

symbolTable *construct_Symbol_Table(){
	if(MAX_SIZE >=0){
		symbolTable *st = new symbolTable(MAX_SIZE);
		return st;
	}										
}

void __construct_quad_list(int n){
	if(MAX_SIZE>0)
	{
		int quadArrayList[n/2];
	}
	else
	{
		printf("Error: Maximum Size should be greater than 0");
	}
}

void construct_quad_list(int n){
	if(MAX_SIZE>0)
	{
		 __construct_quad_list(n+1);
	}
	else
	{
		printf("Error: Maximum Size should be greater than 0");
	}
}
void print_Tree(tNode *temp){
	cout<<setw(20);
	while(temp){
		switch(temp->down){
			case ARRAY : cout<<"array ";
			break;
			case VOID_ : cout<<"void ";
			break;
			case INT_ : cout<<"int ";
			break;
			case DOUBLE_ : cout<<"double ";
			break;
			case CHAR_ : cout<<"char ";
			break;
			case PTR : cout<<"ptr ";
			break;
			case FUNCTION : cout<<"function ";
			break;
			default : cout<<"No Type ";
		}
		if(temp->l)
			cout<<*(temp->l)<<" ";
		temp = temp->r;
	}
}
void print_Initial_Value(void *temp, tNode *t){
	if(!temp)
		cout<<setw(20)<<"null";
	else{
		switch(t->down){
			case INT_ : cout<<setw(20)<<(*((int *)temp))<<" ";
						break;
			case DOUBLE_ : cout<<setw(20)<<(*((double *)temp))<<" ";
						break;
			case CHAR_ : cout<<setw(20)<<(*((char *)temp))<<" ";
						break;
		}
	}
}
tNode *new_node(date_types t, int val){
	tNode *temp = new tNode;
	temp->down = t;

	if(t == ARRAY)
		temp->l = new int(val);
	else
		temp->l = 0;

	temp->r = 0;

	return temp;
}
tNode *merge_node(tNode *sub, tNode *one_node){
	if(!sub) return one_node;
	tNode *temp = sub;
	while(temp->r)
		temp = temp->r;
	temp->r = one_node;
	return sub;
}

lnode *makelist(int id){
	lnode *temp = new lnode;
	temp->index_list = id;
	temp->next = 0;
	return temp;
}

lnode *merge(lnode *l1, lnode *l2){
	if(!l1) return l2;
	if(!l2) return l1;
	lnode *temp = l1;
	while(temp->next)
		temp = temp->next;
	temp->next = l2;
	return l1;
}

void backpatch(lnode *l, int data){
	lnode *temp = l;
	while(temp){
		quad_array->fill_dangling_goto(temp->index_list,data);
		temp = temp->next;
	}
}

int typecheck(tNode *t1, tNode *t2){
	if(!t1 && !t2) return 1;
	if(!t1) return 0;
	if(!t2) return 0;
	return (t1->down == t2->down) && typecheck(t1->r,t2->r);
}

void conv2Bool(attribute_expression *E){
	if(((E->type)->down) != BOOL_){
		E->FL = makelist(next_instr);
		char *arg1 = strdup((E->loc)->name);
		char *arg2 = new char[10];
		sprintf(arg2,"0");
		fields_quad x(arg1,arg2,0,goto_EQ,E->loc,0,0);
		quad_array->emit(x);
		E->TL = makelist(next_instr);
		fields_quad y(0,0,0,GOTO_,0,0,0);
		quad_array->emit(y);
	}
}

int compute_width(tNode *temp){
	if(!temp) return 0;
	int width = 1;
	while(temp){
		switch(temp->down){
			case ARRAY : width *= (*temp->l);
						break;
			case INT_ : width *= 4;
						break;
			case DOUBLE_ : width *= 8;
						break;
			case CHAR_ : width *= 1;
						break;
			case PTR : width *= 4;
						break;
		}
		if(temp->down == PTR)
			break;
		temp = temp->r;
	}
	return width;
}

parameter_list *make_param_list(symbol_table_fields *p){
	parameter_list *temp = new parameter_list;
	temp->parameter = p;
	temp->next = 0;
	return temp;
}

parameter_list *merge_param_list(parameter_list *l1, parameter_list *l2){
	if(!l1) return l2;
	if(!l2) return l1;
	parameter_list *temp = l1;
	while(temp->next)
		temp = temp->next;
	temp->next = l2;
	return l1;
}
tNode *t = 0;
int w;	
symbolTable *symbol_table = 0;
symbolTable *current = 0;
symbolTable *temp = 0;
symbolTable *temp_use = 0;
int flag1 = 0;
int flag2 = 0;
int c = 0;
char *func_name;								
int line_count = 0;
int temp_count = 0;
int next_instr = 0;
quadArray *quad_array = 0;
int flag_array = 0;


int main(){
  symbol_table = construct_Symbol_Table();
  temp = symbol_table;
  current = symbol_table;
  current = temp;
  construct_quad_list(100);
  quad_array = new quadArray(100000);
  int x = yyparse();
  printf("\n+++++++++++++++++++++++++++++++ Global Symbol Table +++++++++++++++++++++++++++++++\n\n");
  symbol_table->print_Table();
  int i,j;
  for(i=0;i<=symbol_table->curr_length;i++){
  	if((symbol_table->table[i]).nestedTable){
  		printf("\n+++++++++++++++++++++++++++++++ %s Symbol Table +++++++++++++++++++++++++++++++ \n\n",(symbol_table->table[i]).name);
  		((symbol_table->table[i]).nestedTable)->print_Table();
  	}
  }
  quad_array->print_quadArray();
  return 0;
}
