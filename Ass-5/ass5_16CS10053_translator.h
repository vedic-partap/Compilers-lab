#ifndef ASS5_16CS10053_TRANSLATOR_INCLUDED
#define ASS5_16CS10053_TRANSLATOR_INCLUDED

# define SIZE_OF_CHAR 1
# define SIZE_OF_INT 4
# define SIZE_OF_DOUBLE 8
# define SIZE_OF_PTR 4

// Maxsize for symbol table
# define MAX_SIZE 10000

extern int c, w, flag1, flag2, line_count, temp_count, next_instr, flag_array;
extern char *func_name;								

enum quad_data_types {DEFAULT_, PLUS, MINUS, INTO, DIV, PERCENT, U_PLUS, U_MINUS, BW_U_NOT,U_NEGATION, 
				SL, SR, LT, LTE, GT, GTE, EQ, NEQ, BW_AND, BW_XOR, PARAM, RETURN_EXP, RETURN_, Function,
  				BW_INOR, LOG_AND, LOG_OR, goto_LT, goto_LTE, goto_GT, goto_GTE, goto_EQ, goto_NEQ, call,
    			EQ_BRACKET, BRACKET_EQ, U_ADDR, U_STAR, ASSIGN, GOTO_, IF_GOTO, IF_FALSE_GOTO};

enum date_types { ARRAY, PTR, FUNCTION, VOID_, CHAR_, INT_, DOUBLE_, BOOL_};


typedef struct lnode{														
	int index_list;
	struct lnode *next; 
}lnode; 

typedef struct tNode{													
	date_types down;
	int *l;
	struct tNode *r;
}tNode;
extern tNode *t;

class symbol_table_fields; 
class symbolTable;

class symbol_table_fields{													
	public:
		void *initial_value;
		int size;
		char *name;
		tNode *Type;
		int offset; 
		symbolTable *nestedTable;
		void print_row();
		symbol_table_fields(char * = 0 , tNode * = 0, void * = 0, int = -1, int = -1, symbolTable * = 0); 
		void operator=(symbol_table_fields &);
		~symbol_table_fields();
};

typedef struct parameter_list{
	symbol_table_fields *parameter;
	struct parameter_list *next;
}parameter_list;

typedef struct fields_quad{
	char *arg1;
	char *arg2;
	char *res;
	quad_data_types op;
	symbol_table_fields *arg1_loc;
	symbol_table_fields *arg2_loc;
	symbol_table_fields *res_loc;
	fields_quad(char * = 0, char * = 0, char * = 0, quad_data_types = DEFAULT_, symbol_table_fields * = 0, symbol_table_fields * = 0, symbol_table_fields * = 0);
	~fields_quad();
	void operator=(struct fields_quad &);
	void print_fields_quad(int);
}fields_quad;


typedef union attribute{										
	int int_data;
	double double_data;
	char char_data;
}attribute;

typedef struct attribute_expression{                                                
	symbol_table_fields *loc;													
	lnode *TL;															
	lnode *FL;
	lnode *NL;															
	tNode *type;														
	symbol_table_fields *array;
	symbol_table_fields *loc1;														
	attribute val;																	
}attribute_expression;

typedef struct attribute_variable_declaration{												
	tNode *type;
	int width;
	char *var;
}attribute_variable_declaration;

typedef struct id_attr_struct{														
	symbol_table_fields *loc;
	char *var;
}id_attr_struct;

class symbolTable{
public:
	symbol_table_fields *table;
	int curr_length;
	symbolTable(unsigned int);
	~symbolTable();
	symbol_table_fields *lookup(char *);
	void insert(symbol_table_fields &);
	symbol_table_fields *gentemp(date_types);
	void print_Table();
};

class quadArray{
public:
	fields_quad *quad_Table;
	quadArray(unsigned int);
	~quadArray();
	void emit(fields_quad &);
	void print_quadArray();
	void fill_dangling_goto(int,int);
};
extern quadArray *quad_array;	


symbolTable *construct_Symbol_Table();
void print_Tree(tNode *);
void print_Initial_Value(void *,tNode *);
tNode *new_node(date_types ,int);
tNode *merge_node(tNode *, tNode *);
lnode *makelist(int);
lnode *merge(lnode *, lnode *);
void backpatch(lnode *, int);
int typecheck(tNode *,tNode *);
void conv2Bool(attribute_expression *);
int compute_width(tNode *);
parameter_list *make_param_list(symbol_table_fields *);
parameter_list *merge_param_list(parameter_list *, parameter_list *);
extern symbolTable *symbol_table;
extern symbolTable *current;
extern symbolTable *temp_use;
#endif









