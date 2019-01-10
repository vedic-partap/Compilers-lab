%{
#include <stdio.h>
extern int yylex();
void yyerror(const char*);
#include "ass5_16CS10053_translator.h"
#include <string.h>
%}



%union {
  int intval;
  float floatval;
  char charval;
  char *strval;
  struct id_attr_struct id_attr;
  struct attribute_expression attribute_exp;
  struct attribute_variable_declaration var_decl_attr;
  union attribute initializer_attr;
  quad_data_types attribute_unary;
  int instr;
  struct lnode *N_attr;
  struct parameter_list *param_attr;
}
%expect 2;
%token ARROW
%token INCREMENT 
%token CONTINUE
%token DEFAULT
%token DO
%token DOUBLE
%token ELSE
%token ENUM
%token EXTERN
%token FLOAT
%token FOR
%token GOTO
%token IF
%token INLINE
%token INT
%token LONG
%token REGISTER
%token RESTRICT
%token RETURN
%token SHORT
%token SIGNED
%token SIZEOF
%token STATIC
%token STRUCT
%token SWITCH
%token TYPEDEF
%token UNION
%token UNSIGNED
%token VOID
%token VOLATILE
%token DECREMENT
%token LSHIFT
%token RSHIFT
%token LESS_THAN_EQUAL_TO
%token GREATER_THAN_EQUAL_TO
%token DOUBLE_EQUAL
%token NOT_EQUAL
%token BINARY_AND
%token BINARY_OR
%token ELLIPSIS
%token STAR_EQUAL
%token SLASH_EQUAL
%token PERCENTILE_EQUAL
%token PLUS_EQUAL
%token MINUS_EQUAL
%token LEFT_SHIFT_EQUAL
%token RIGHT_SHIFT_EQUAL
%token AND_EQUAL
%token XOR_EQUAL
%token OR_EQUAL
%token AUTO
%token BREAK 
%token CASE 
%token CHAR
%token CONST
%token WHILE
%token BOOL
%token COMPLEX
%token IMAGINARY
%token SINGLE_COMMENT
%token MULTI_COMMENT
%token <id_attr> IDENTIFIER
%token <intval> INTEGER_NO
%token <floatval> FLOAT_NO
%token <charval> CHARACTER
%token <strval> STRING
%token <intval> ENUMERATION_CONSTANT			
%token PUNCTUATOR
%token WS


%type<attribute_exp> primary_expression;
%type<attribute_exp> expression;
%type<attribute_exp> postfix_expression;
%type<attribute_exp> constant_expression;
%type<attribute_exp> statement;
%type<attribute_exp> compound_statement;
%type<attribute_exp> selection_statement;
%type<attribute_exp> conditional_expression;
%type<attribute_exp> assignment_expression;
%type<var_decl_attr> type_specifier;
%type<var_decl_attr> declaration_specifiers;
%type<var_decl_attr> direct_declarator;
%type<attribute_exp> iteration_statement;
%type<attribute_exp> jump_statement;
%type<attribute_exp> block_item_list;
%type<attribute_exp> additive_expression;
%type<attribute_exp> shift_expression;
%type<attribute_exp> relational_expression;
%type<attribute_exp> equality_expression;
%type<attribute_exp> AND_expression;
%type<attribute_exp> exclusive_OR_expression;
%type<attribute_exp> inclusive_OR_expression;
%type<attribute_exp> logical_AND_expression;
%type<attribute_exp> logical_OR_expression;
%type<var_decl_attr> declarator;
%type<var_decl_attr> parameter_declaration;
%type<attribute_exp> block_item;
%type<attribute_exp> expression_statement;
%type<attribute_exp> unary_expression;
%type<attribute_exp> cast_expression;
%type<attribute_exp> multiplicative_expression;
%type<var_decl_attr> init_declarator;
%type<initializer_attr> initializer;
%type<var_decl_attr> init_declarator_list;
%type<var_decl_attr> pointer;
%type<attribute_unary> unary_operator;
%type<instr> M;
%type<N_attr> N;
%type<param_attr> argument_expression_list;

%precedence CONFLICTIVE_IF;
%precedence ELSE 
%start translation_unit;
%%


primary_expression:
					IDENTIFIER
					{
						$1.loc = current->lookup($1.var);
	  					if(!($1.loc))
	  						$1.loc = symbol_table->lookup($1.var);
	  					$$.loc = $1.loc;
	  					$$.loc = $1.loc;
	  					$$.type = ($1.loc)->Type;
	  					$$.array = $$.loc;
	  					$$.loc1 = 0;
					}
					|INTEGER_NO
					{
						$$.val.int_data = $1;
					  	$$.type = new_node(INT_,-1);
					  	$$.loc = current->gentemp(INT_);
					  	char *arg1 = new char[10];
					  	sprintf(arg1,"%d",$1);
					  	char *res = strdup(($$.loc)->name);
					  	fields_quad x(arg1,0,res,ASSIGN,0,0,$$.loc);
					  	quad_array->emit(x);
					}
					|FLOAT_NO
					{
						$$.val.double_data = $1;
						$$.type = new_node(DOUBLE_,-1);
						$$.loc = current->gentemp(DOUBLE_);
					  	char *arg1 = new char[10];
					  	sprintf(arg1,"%lf",$1);
					  	char *res = strdup(($$.loc)->name);
					  	fields_quad x(arg1,0,res,ASSIGN,0,0,$$.loc);
					  	quad_array->emit(x);
					}
					|CHARACTER
					{
						$$.val.char_data = $1;
					  	$$.type = new_node(CHAR_,-1);
					  	$$.loc = current->gentemp(CHAR_);
					  	char *arg1 = new char[10];
					  	sprintf(arg1,"%c",$1);
					  	char *res = strdup(($$.loc)->name);
					  	fields_quad x(arg1,0,res,ASSIGN,0,0,$$.loc);
					  	quad_array->emit(x);
					}
					|STRING
					{
						// not required 
					}
					|'(' expression ')'
					{
						$$ = $2;
					}
					;

postfix_expression:
					primary_expression
					{
						$$ = $1;
					}
					|postfix_expression '[' expression ']'
					{
						$$.array = $1.array;
					  	$$.type = ($1.type)->r;
					  	if(!($1.loc1)){
					  		$$.loc1 = current->gentemp(INT_);
					  		int m = compute_width(($1.type)->r);
					  		char *arg1 = strdup(($3.loc)->name);
					  		char *arg2 = new char[10];
					  		sprintf(arg2,"%d",m);
					  		char *res = strdup(($$.loc1)->name);
					  		fields_quad y(arg1,arg2,res,INTO,$3.loc,0,$$.loc1);
					  		quad_array->emit(y);
					  	}
					  	else{
					  		symbol_table_fields *temp = current->gentemp(INT_);
						  	$$.loc1 = current->gentemp(INT_);
						  	int n = compute_width($$.type);
						  	char *arg1 = strdup(($3.loc)->name);
						  	char *arg2 = new char[10];
						  	sprintf(arg2,"%d",n);
						  	char *res = strdup(temp->name);
						  	fields_quad x(arg1,arg2,res,INTO,$3.loc,0,temp);
						  	quad_array->emit(x);
						  	arg1 = strdup(($1.loc1)->name);
						  	arg2 = strdup(temp->name);
						  	res = strdup(($$.loc1)->name);
						  	fields_quad y(arg1,arg2,res,PLUS,$1.loc1,temp,$$.loc1);
						  	quad_array->emit(y);
					  	}
					  	flag_array = 1;
					}
					|postfix_expression '(' argument_expression_list')'
					{
					  	parameter_list *temp = $3;
					  	int count = 0;
					  	while(temp){
					  		char *arg1 = strdup((temp->parameter)->name);
					  		fields_quad x(arg1,0,0,PARAM,temp->parameter,0,0);
					  		quad_array->emit(x);
					  		count++;
					  		temp = temp->next;
					  	}
					  	symbol_table_fields *t = symbol_table->lookup(($1.loc)->name);
					  	$$.loc = current->gentemp(((((t->nestedTable)->table)[count]).Type)->down);
					  	char *res = strdup(($$.loc)->name);
					  	char *arg1 = strdup(($1.loc)->name);
					  	char *arg2 = new char[10];
					  	sprintf(arg2,"%d",count);
					  	fields_quad x(arg1,arg2,res,call,$1.loc,0,$$.loc);
					  	quad_array->emit(x);
					  	$$.type = ($$.loc)->Type;
	  				}
	  				| postfix_expression '(' ')'
					  {
					  	int count = 0;
					  	symbol_table_fields *t = symbol_table->lookup(($1.loc)->name);
					  	$$.loc = current->gentemp(((((t->nestedTable)->table)[count]).Type)->down);
					  	char *res = strdup(($$.loc)->name);
					  	char *arg1 = strdup(($1.loc)->name);
					  	char *arg2 = new char[10];
					  	sprintf(arg2,"%d",count);
					  	fields_quad x(arg1,arg2,res,call,$1.loc,0,$$.loc);
					  	quad_array->emit(x);
					  	$$.type = ($$.loc)->Type;
					  }
				  	|postfix_expression '.' IDENTIFIER
				  	{
				  		// not to be implemented
				  	}
				  	|postfix_expression ARROW IDENTIFIER
				  	{
				  		// not to be implemented
				  	}
				  	|postfix_expression INCREMENT
				  	{
				  		$$.loc = current->gentemp(($1.type)->down);
					  	char *arg1 = strdup(($1.loc)->name);
					  	char *res = strdup(($$.loc)->name);
					  	fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,$$.loc);
					  	quad_array->emit(x);
					  	arg1 = strdup(($1.loc)->name);
					  	char *arg2 = new char[10];
					  	sprintf(arg2,"1");
					  	res = strdup(($1.loc)->name);
					  	fields_quad y(arg1,arg2,res,PLUS,$1.loc,0,$1.loc);
					  	quad_array->emit(y);
					  	$$.type = $1.type;	
				  	} 
				  	|postfix_expression DECREMENT
				  	{
				  		$$.loc = current->gentemp(($1.type)->down);
					  	char *arg1 = strdup(($1.loc)->name);
					  	char *res = strdup(($$.loc)->name);
					  	fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,$$.loc);
					  	quad_array->emit(x);
					  	arg1 = strdup(($1.loc)->name);
					  	char *arg2 = new char[10];
					  	sprintf(arg2,"1");
					  	res = strdup(($1.loc)->name);
					  	fields_quad y(arg1,arg2,res,MINUS,$1.loc,0,$1.loc);
					  	quad_array->emit(y);
					  	$$.type = $1.type;
				  	}
				  	|'(' type_name ')' '{' initializer_list '}'
				  	{
				  		// not to be implemented
				  	}
				  	|'(' type_name ')' '{' initializer_list ',' '}'
				  	{
				  		// not to be implemented
				  	}
				  ;

argument_expression_list:
					  assignment_expression
					  {
					  	$$ = make_param_list($1.loc);
					  }
					  |argument_expression_list ',' assignment_expression
					  {
					  	$$ = merge_param_list($1,make_param_list($3.loc));
					  }
					  ;

unary_expression:
				postfix_expression
				{
					$$ = $1;
				  	if($1.loc1){
				  		$$.loc = current->gentemp(($1.type)->down);
				  		char *arg1 = strdup(($1.array)->name);
				  		char *arg2 = strdup(($1.loc1)->name);
				  		char *res = strdup(($$.loc)->name);
				  		fields_quad x(arg1,arg2,res,EQ_BRACKET,$1.loc,$1.loc1,$$.loc);
				  		quad_array->emit(x);
					}
				}
				|INCREMENT unary_expression
				{
					$$.loc = current->gentemp(($2.type)->down);
				  	char *arg1 = strdup(($2.loc)->name);
				  	char *arg2 = new char[10];
				  	sprintf(arg2,"1");
				  	char *res = strdup(($2.loc)->name);
				  	fields_quad y(arg1,arg2,res,PLUS,$2.loc,0,$2.loc);
				  	quad_array->emit(y);
				  	arg1 = strdup(($2.loc)->name);
				  	res = strdup(($$.loc)->name);
				  	fields_quad x(arg1,0,res,ASSIGN,$2.loc,0,$$.loc);
				  	quad_array->emit(x);
				  	$$.type = $2.type;
				}
				|DECREMENT unary_expression
				{
					$$.loc = current->gentemp(($2.type)->down);
				  	char *arg1 = strdup(($2.loc)->name);
				  	char *arg2 = new char[10];
				  	sprintf(arg2,"1");
				  	char *res = strdup(($2.loc)->name);
				  	fields_quad y(arg1,arg2,res,MINUS,$2.loc,0,$2.loc);
				  	quad_array->emit(y);
				  	arg1 = strdup(($2.loc)->name);
				  	res = strdup(($$.loc)->name);
				  	fields_quad x(arg1,0,res,ASSIGN,$2.loc,0,$$.loc);
				  	quad_array->emit(x);
				  	$$.type = $2.type;
				}
				|unary_operator cast_expression
				{
					$$.loc = current->gentemp(($2.type)->down);
				  	char *arg1 = strdup(($2.loc)->name);
				  	char *res = strdup(($$.loc)->name);
				  	fields_quad x(arg1,0,res,$1,$2.loc,0,$$.loc);
				  	quad_array->emit(x);
				  	$$.type = $2.type;
				}
				|SIZEOF unary_expression
				{
					// not to be implemented
				}
				|SIZEOF '(' type_name ')' 
				{
					// not to be implemented
				}
				;					 

unary_operator: 
				'&'
				{
				  	$$ = U_ADDR;
				}
				|'*'
				{
				  	$$ = U_STAR;
				}
				|'+'
				{
				  	$$ = U_PLUS;
				}
				|'-'
				{
				  	$$ = U_MINUS;
				}
				|'~'
				{
				  	$$ = U_NEGATION;
				}
				| '!'
				{
				  	$$ = BW_U_NOT;
				}
				;

cast_expression:
			   unary_expression
			   {
			   		$$ = $1;
			   }
			   |'(' type_name ')' cast_expression
			   {
			   		// not to be implemented 
			   }
			   ;

multiplicative_expression:
						cast_expression
						{
							$$ = $1;
						}
						|multiplicative_expression '*' cast_expression
						{
							if(typecheck($1.type, $3.type)){
						  		$$.loc = current->gentemp(($1.type)->down);
						  		char *arg1 = strdup(($1.loc)->name);
						  		char *arg2 = strdup(($3.loc)->name);
						  		char *res = strdup(($$.loc)->name);
						  		fields_quad x(arg1,arg2,res,INTO,$1.loc,$3.loc,$$.loc);
						  		quad_array->emit(x);
						  		$$.type = $1.type;
						  	}
						  	else{
						  		symbol_table_fields *temp1, *temp2;
						  		if(($1.type)->down == INT_ && ($3.type)->down == DOUBLE_){
						  			temp1 = current->gentemp(DOUBLE_);
						  			char *arg1 = new char[100];
						  			sprintf(arg1,"int2dbl(%s)",($1.loc)->name);
						  			char *res = strdup(temp1->name);
						  			fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,temp1);
						  			quad_array->emit(x);
						  			temp2 = current->gentemp(DOUBLE_);
						  			arg1 = strdup(temp1->name);
						  			char *arg2 = strdup(($3.loc)->name);
						  			res = strdup(temp2->name);
						  			fields_quad y(arg1,arg2,res,INTO,temp1,$3.loc,temp2);
						  			quad_array->emit(y);
						  			$$.type = $3.type;
						  		}
						  		else if(($1.type)->down == INT_ && ($3.type)->down == CHAR_){
						  			temp1 = current->gentemp(INT_);
						  			char *arg1 = new char[100];
						  			sprintf(arg1,"char2int(%s)",($3.loc)->name);
						  			char *res = strdup(temp1->name);
						  			fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,temp1);
						  			quad_array->emit(x);
						  			temp2 = current->gentemp(INT_);
						  			arg1 = strdup(($1.loc)->name);
						  			char *arg2 = strdup(temp1->name);
						  			res = strdup(temp2->name);
						  			fields_quad y(arg1,arg2,res,INTO,$1.loc,temp1,temp2);
						  			quad_array->emit(y);
						  			$$.type = $1.type;
						  		}
						  		else if(($1.type)->down == DOUBLE_ && ($3.type)->down == INT_){
						  			temp1 = current->gentemp(DOUBLE_);
						  			char *arg1 = new char[100];
						  			sprintf(arg1,"int2dbl(%s)",($3.loc)->name);
						  			char *res = strdup(temp1->name);
						  			fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,temp1);
						  			quad_array->emit(x);
						  			temp2 = current->gentemp(DOUBLE_);
						  			arg1 = strdup(($1.loc)->name);
						  			char *arg2 = strdup(temp1->name);
						  			res = strdup(temp2->name);
						  			fields_quad y(arg1,arg2,res,INTO,$1.loc,temp1,temp2);
						  			quad_array->emit(y);
						  			$$.type = $1.type;
						  		}
						  		else if(($1.type)->down == CHAR_ && ($3.type)->down == INT_){
						  			temp1 = current->gentemp(INT_);
						  			char *arg1 = new char[100];
						  			sprintf(arg1,"char2int(%s)",($1.loc)->name);
						  			char *res = strdup(temp1->name);
						  			fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,temp1);
						  			quad_array->emit(x);
						  			temp2 = current->gentemp(INT_);
						  			arg1 = strdup(temp1->name);
						  			char *arg2 = strdup(($3.loc)->name);
						  			res = strdup(temp2->name);
						  			fields_quad y(arg1,arg2,res,INTO,temp1,$3.loc,temp2);
						  			quad_array->emit(y);
						  			$$.type = $3.type;
						  		}
						  		$$.loc = temp2;
						  	}
						}
						|multiplicative_expression '/' cast_expression
						{
							if(typecheck($1.type, $3.type)){
						  		$$.loc = current->gentemp(($1.type)->down);
						  		char *arg1 = strdup(($1.loc)->name);
						  		char *arg2 = strdup(($3.loc)->name);
						  		char *res = strdup(($$.loc)->name);
						  		fields_quad x(arg1,arg2,res,DIV,$1.loc,$3.loc,$$.loc);
						  		quad_array->emit(x);
						  		$$.type = $1.type;
						  	}
						  	else{
						  		symbol_table_fields *temp1, *temp2;
						  		if(($1.type)->down == INT_ && ($3.type)->down == DOUBLE_){
						  			temp1 = current->gentemp(DOUBLE_);
						  			char *arg1 = new char[100];
						  			sprintf(arg1,"int2dbl(%s)",($1.loc)->name);
						  			char *res = strdup(temp1->name);
						  			fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,temp1);
						  			quad_array->emit(x);
						  			temp2 = current->gentemp(DOUBLE_);
						  			arg1 = strdup(temp1->name);
						  			char *arg2 = strdup(($3.loc)->name);
						  			res = strdup(temp2->name);
						  			fields_quad y(arg1,arg2,res,DIV,temp1,$3.loc,temp2);
						  			quad_array->emit(y);
						  			$$.type = $3.type;
						  		}
						  		else if(($1.type)->down == INT_ && ($3.type)->down == CHAR_){
						  			temp1 = current->gentemp(INT_);
						  			char *arg1 = new char[100];
						  			sprintf(arg1,"char2int(%s)",($3.loc)->name);
						  			char *res = strdup(temp1->name);
						  			fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,temp1);
						  			quad_array->emit(x);
						  			temp2 = current->gentemp(INT_);
						  			arg1 = strdup(($1.loc)->name);
						  			char *arg2 = strdup(temp1->name);
						  			res = strdup(temp2->name);
						  			fields_quad y(arg1,arg2,res,DIV,$1.loc,temp1,temp2);
						  			quad_array->emit(y);
						  			$$.type = $1.type;
						  		}
						  		else if(($1.type)->down == DOUBLE_ && ($3.type)->down == INT_){
						  			temp1 = current->gentemp(DOUBLE_);
						  			char *arg1 = new char[100];
						  			sprintf(arg1,"int2dbl(%s)",($3.loc)->name);
						  			char *res = strdup(temp1->name);
						  			fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,temp1);
						  			quad_array->emit(x);
						  			temp2 = current->gentemp(DOUBLE_);
						  			arg1 = strdup(($1.loc)->name);
						  			char *arg2 = strdup(temp1->name);
						  			res = strdup(temp2->name);
						  			fields_quad y(arg1,arg2,res,DIV,$1.loc,temp1,temp2);
						  			quad_array->emit(y);
						  			$$.type = $1.type;
						  		}
						  		else if(($1.type)->down == CHAR_ && ($3.type)->down == INT_){
						  			temp1 = current->gentemp(INT_);
						  			char *arg1 = new char[100];
						  			sprintf(arg1,"char2int(%s)",($1.loc)->name);
						  			char *res = strdup(temp1->name);
						  			fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,temp1);
						  			quad_array->emit(x);
						  			temp2 = current->gentemp(INT_);
						  			arg1 = strdup(temp1->name);
						  			char *arg2 = strdup(($3.loc)->name);
						  			res = strdup(temp2->name);
						  			fields_quad y(arg1,arg2,res,DIV,temp1,$3.loc,temp2);
						  			quad_array->emit(y);
						  			$$.type = $3.type;
						  		}
						  		$$.loc = temp2;
						  	}
						}
						|multiplicative_expression '%' cast_expression
						{
							if(typecheck($1.type, $3.type)){
						  		$$.loc = current->gentemp(($1.type)->down);
						  		char *arg1 = strdup(($1.loc)->name);
						  		char *arg2 = strdup(($3.loc)->name);
						  		char *res = strdup(($$.loc)->name);
						  		fields_quad x(arg1,arg2,res,PERCENT,$1.loc,$3.loc,$$.loc);
						  		quad_array->emit(x);
						  		$$.type = $1.type;
						  	}
						  	else{
						  		symbol_table_fields *temp1, *temp2;
						  		if(($1.type)->down == INT_ && ($3.type)->down == DOUBLE_){
						  			temp1 = current->gentemp(DOUBLE_);
						  			char *arg1 = new char[100];
						  			sprintf(arg1,"int2dbl(%s)",($1.loc)->name);
						  			char *res = strdup(temp1->name);
						  			fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,temp1);
						  			quad_array->emit(x);
						  			temp2 = current->gentemp(DOUBLE_);
						  			arg1 = strdup(temp1->name);
						  			char *arg2 = strdup(($3.loc)->name);
						  			res = strdup(temp2->name);
						  			fields_quad y(arg1,arg2,res,PERCENT,temp1,$3.loc,temp2);
						  			quad_array->emit(y);
						  			$$.type = $3.type;
						  		}
						  		else if(($1.type)->down == INT_ && ($3.type)->down == CHAR_){
						  			temp1 = current->gentemp(INT_);
						  			char *arg1 = new char[100];
						  			sprintf(arg1,"char2int(%s)",($3.loc)->name);
						  			char *res = strdup(temp1->name);
						  			fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,temp1);
						  			quad_array->emit(x);
						  			temp2 = current->gentemp(INT_);
						  			arg1 = strdup(($1.loc)->name);
						  			char *arg2 = strdup(temp1->name);
						  			res = strdup(temp2->name);
						  			fields_quad y(arg1,arg2,res,PERCENT,$1.loc,temp1,temp2);
						  			quad_array->emit(y);
						  			$$.type = $1.type;
						  		}
						  		else if(($1.type)->down == DOUBLE_ && ($3.type)->down == INT_){
						  			temp1 = current->gentemp(DOUBLE_);
						  			char *arg1 = new char[100];
						  			sprintf(arg1,"int2dbl(%s)",($3.loc)->name);
						  			char *res = strdup(temp1->name);
						  			fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,temp1);
						  			quad_array->emit(x);
						  			temp2 = current->gentemp(DOUBLE_);
						  			arg1 = strdup(($1.loc)->name);
						  			char *arg2 = strdup(temp1->name);
						  			res = strdup(temp2->name);
						  			fields_quad y(arg1,arg2,res,PERCENT,$1.loc,temp1,temp2);
						  			quad_array->emit(y);
						  			$$.type = $1.type;
						  		}
						  		else if(($1.type)->down == CHAR_ && ($3.type)->down == INT_){
						  			temp1 = current->gentemp(INT_);
						  			char *arg1 = new char[100];
						  			sprintf(arg1,"char2int(%s)",($1.loc)->name);
						  			char *res = strdup(temp1->name);
						  			fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,temp1);
						  			quad_array->emit(x);
						  			temp2 = current->gentemp(INT_);
						  			arg1 = strdup(temp1->name);
						  			char *arg2 = strdup(($3.loc)->name);
						  			res = strdup(temp2->name);
						  			fields_quad y(arg1,arg2,res,PERCENT,temp1,$3.loc,temp2);
						  			quad_array->emit(y);
						  			$$.type = $3.type;
						  		}
						  		$$.loc = temp2;
						  	}
						}
						;

additive_expression:
				   multiplicative_expression
				   {
						$$ = $1;				 
				   }
				   |additive_expression '+' multiplicative_expression
				   {
				   		if(typecheck($1.type, $3.type)){
					  		$$.loc = current->gentemp(($1.type)->down);
					  		char *arg1 = strdup(($1.loc)->name);
					  		char *arg2 = strdup(($3.loc)->name);
					  		char *res = strdup(($$.loc)->name);
					  		fields_quad x(arg1,arg2,res,PLUS,$1.loc,$3.loc,$$.loc);
					  		quad_array->emit(x);
					  		$$.type = $1.type;
					  	}
					  	else{
					  		symbol_table_fields *temp1, *temp2;
					  		if(($1.type)->down == INT_ && ($3.type)->down == DOUBLE_){
					  			temp1 = current->gentemp(DOUBLE_);
					  			char *arg1 = new char[100];
					  			sprintf(arg1,"int2dbl(%s)",($1.loc)->name);
					  			char *res = strdup(temp1->name);
					  			fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,temp1);
					  			quad_array->emit(x);
					  			temp2 = current->gentemp(DOUBLE_);
					  			arg1 = strdup(temp1->name);
					  			char *arg2 = strdup(($3.loc)->name);
					  			res = strdup(temp2->name);
					  			fields_quad y(arg1,arg2,res,PLUS,temp1,$3.loc,temp2);
					  			quad_array->emit(y);
					  			$$.type = $3.type;
					  		}
					  		else if(($1.type)->down == INT_ && ($3.type)->down == CHAR_){
					  			temp1 = current->gentemp(INT_);
					  			char *arg1 = new char[100];
					  			sprintf(arg1,"char2int(%s)",($3.loc)->name);
					  			char *res = strdup(temp1->name);
					  			fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,temp1);
					  			quad_array->emit(x);
					  			temp2 = current->gentemp(INT_);
					  			arg1 = strdup(($1.loc)->name);
					  			char *arg2 = strdup(temp1->name);
					  			res = strdup(temp2->name);
					  			fields_quad y(arg1,arg2,res,PLUS,$1.loc,temp1,temp2);
					  			quad_array->emit(y);
					  			$$.type = $1.type;
					  		}
					  		else if(($1.type)->down == DOUBLE_ && ($3.type)->down == INT_){
					  			temp1 = current->gentemp(DOUBLE_);
					  			char *arg1 = new char[100];
					  			sprintf(arg1,"int2dbl(%s)",($3.loc)->name);
					  			char *res = strdup(temp1->name);
					  			fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,temp1);
					  			quad_array->emit(x);
					  			temp2 = current->gentemp(DOUBLE_);
					  			arg1 = strdup(($1.loc)->name);
					  			char *arg2 = strdup(temp1->name);
					  			res = strdup(temp2->name);
					  			fields_quad y(arg1,arg2,res,PLUS,$1.loc,temp1,temp2);
					  			quad_array->emit(y);
					  			$$.type = $1.type;
					  		}
					  		else if(($1.type)->down == CHAR_ && ($3.type)->down == INT_){
					  			temp1 = current->gentemp(INT_);
					  			char *arg1 = new char[100];
					  			sprintf(arg1,"char2int(%s)",($1.loc)->name);
					  			char *res = strdup(temp1->name);
					  			fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,temp1);
					  			quad_array->emit(x);
					  			temp2 = current->gentemp(INT_);
					  			arg1 = strdup(temp1->name);
					  			char *arg2 = strdup(($3.loc)->name);
					  			res = strdup(temp2->name);
					  			fields_quad y(arg1,arg2,res,PLUS,temp1,$3.loc,temp2);
					  			quad_array->emit(y);
					  			$$.type = $3.type;
					  		}
					  		$$.loc = temp2;
					  	}
				   }
				   |additive_expression '-' multiplicative_expression
				   {
				   		if(typecheck($1.type, $3.type)){
					  		$$.loc = current->gentemp(($1.type)->down);
					  		char *arg1 = strdup(($1.loc)->name);
					  		char *arg2 = strdup(($3.loc)->name);
					  		char *res = strdup(($$.loc)->name);
					  		fields_quad x(arg1,arg2,res,MINUS,$1.loc,$3.loc,$$.loc);
					  		quad_array->emit(x);
					  		$$.type = $1.type;
					  	}
					  	else{
					  		symbol_table_fields *temp1, *temp2;
					  		if(($1.type)->down == INT_ && ($3.type)->down == DOUBLE_){
					  			temp1 = current->gentemp(DOUBLE_);
					  			char *arg1 = new char[100];
					  			sprintf(arg1,"int2dbl(%s)",($1.loc)->name);
					  			char *res = strdup(temp1->name);
					  			fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,temp1);
					  			quad_array->emit(x);
					  			temp2 = current->gentemp(DOUBLE_);
					  			arg1 = strdup(temp1->name);
					  			char *arg2 = strdup(($3.loc)->name);
					  			res = strdup(temp2->name);
					  			fields_quad y(arg1,arg2,res,MINUS,temp1,$3.loc,temp2);
					  			quad_array->emit(y);
					  			$$.type = $3.type;
					  		}
					  		else if(($1.type)->down == INT_ && ($3.type)->down == CHAR_){
					  			temp1 = current->gentemp(INT_);
					  			char *arg1 = new char[100];
					  			sprintf(arg1,"char2int(%s)",($3.loc)->name);
					  			char *res = strdup(temp1->name);
					  			fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,temp1);
					  			quad_array->emit(x);
					  			temp2 = current->gentemp(INT_);
					  			arg1 = strdup(($1.loc)->name);
					  			char *arg2 = strdup(temp1->name);
					  			res = strdup(temp2->name);
					  			fields_quad y(arg1,arg2,res,MINUS,$1.loc,temp1,temp2);
					  			quad_array->emit(y);
					  			$$.type = $1.type;
					  		}
					  		else if(($1.type)->down == DOUBLE_ && ($3.type)->down == INT_){
					  			temp1 = current->gentemp(DOUBLE_);
					  			char *arg1 = new char[100];
					  			sprintf(arg1,"int2dbl(%s)",($3.loc)->name);
					  			char *res = strdup(temp1->name);
					  			fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,temp1);
					  			quad_array->emit(x);
					  			temp2 = current->gentemp(DOUBLE_);
					  			arg1 = strdup(($1.loc)->name);
					  			char *arg2 = strdup(temp1->name);
					  			res = strdup(temp2->name);
					  			fields_quad y(arg1,arg2,res,MINUS,$1.loc,temp1,temp2);
					  			quad_array->emit(y);
					  			$$.type = $1.type;
					  		}
					  		else if(($1.type)->down == CHAR_ && ($3.type)->down == INT_){
					  			temp1 = current->gentemp(INT_);
					  			char *arg1 = new char[100];
					  			sprintf(arg1,"char2int(%s)",($1.loc)->name);
					  			char *res = strdup(temp1->name);
					  			fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,temp1);
					  			quad_array->emit(x);
					  			temp2 = current->gentemp(INT_);
					  			arg1 = strdup(temp1->name);
					  			char *arg2 = strdup(($3.loc)->name);
					  			res = strdup(temp2->name);
					  			fields_quad y(arg1,arg2,res,MINUS,temp1,$3.loc,temp2);
					  			quad_array->emit(y);
					  			$$.type = $3.type;
					  		}
					  		$$.loc = temp2;
					  	}
				   }
				   ;

shift_expression:
				additive_expression
				{
					$$ = $1;
				}
				|shift_expression LSHIFT additive_expression
				{
					if(typecheck($1.type, $3.type)){
			  		$$.loc = current->gentemp(($1.type)->down);
			  		char *arg1 = strdup(($1.loc)->name);
			  		char *arg2 = strdup(($3.loc)->name);
			  		char *res = strdup(($$.loc)->name);
			  		fields_quad x(arg1,arg2,res,SL,$1.loc,$3.loc,$$.loc);
			  		quad_array->emit(x);
			  		$$.type = $1.type;
	  				}
				}
				|shift_expression RSHIFT additive_expression
				{
				  	if(typecheck($1.type, $3.type)){
				  		$$.loc = current->gentemp(($1.type)->down);
				  		char *arg1 = strdup(($1.loc)->name);
				  		char *arg2 = strdup(($3.loc)->name);
				  		char *res = strdup(($$.loc)->name);
				  		fields_quad x(arg1,arg2,res,SR,$1.loc,$3.loc,$$.loc);
				  		quad_array->emit(x);
				  		$$.type = $1.type;
				  	}
				  }
				;

relational_expression:
					 shift_expression
					 {
					 	$$ = $1;
					 }
					 |relational_expression '<' shift_expression
					 {
					  	$$.TL = makelist(next_instr);
					  	char *arg1 = strdup(($1.loc)->name);
					  	char *arg2 = strdup(($3.loc)->name);
					  	fields_quad x(arg1,arg2,0,goto_LT,$1.loc,$3.loc,0);
					  	quad_array->emit(x);
					  	$$.FL = makelist(next_instr);
					  	fields_quad y(0,0,0,GOTO_,0,0,0);
					  	quad_array->emit(y);
					  	$$.type = new_node(BOOL_,-1);	
					  }
					 |relational_expression '>' shift_expression
					 {
					  	$$.TL = makelist(next_instr);
					  	char *arg1 = strdup(($1.loc)->name);
					  	char *arg2 = strdup(($3.loc)->name);
					  	fields_quad x(arg1,arg2,0,goto_GT,$1.loc,$3.loc,0);
					  	quad_array->emit(x);
					  	$$.FL = makelist(next_instr);
					  	fields_quad y(0,0,0,GOTO_,0,0,0);
					  	quad_array->emit(y);
					  	$$.type = new_node(BOOL_,-1);
					  }
					 |relational_expression LESS_THAN_EQUAL_TO shift_expression
					 {
					  	$$.TL = makelist(next_instr);
					  	char *arg1 = strdup(($1.loc)->name);
					  	char *arg2 = strdup(($3.loc)->name);
					  	fields_quad x(arg1,arg2,0,goto_LTE,$1.loc,$3.loc,0);
					  	quad_array->emit(x);
					  	$$.FL = makelist(next_instr);
					  	fields_quad y(0,0,0,GOTO_,0,0,0);
					  	quad_array->emit(y);
					  	$$.type = new_node(BOOL_,-1);
					  }
					 |relational_expression GREATER_THAN_EQUAL_TO shift_expression
				 	{
					  	$$.TL = makelist(next_instr);
					  	char *arg1 = strdup(($1.loc)->name);
					  	char *arg2 = strdup(($3.loc)->name);
					  	fields_quad x(arg1,arg2,0,goto_GTE,$1.loc,$3.loc,0);
					  	quad_array->emit(x);
					  	$$.FL = makelist(next_instr);
					  	fields_quad y(0,0,0,GOTO_,0,0,0);
					  	quad_array->emit(y);
					  	$$.type = new_node(BOOL_,-1);
					 }
					;

equality_expression:
				   relational_expression
				   {
				   		$$ = $1;
				   }
				   |equality_expression DOUBLE_EQUAL relational_expression
				   {
					  	$$.TL = makelist(next_instr);
					  	char *arg1 = strdup(($1.loc)->name);
					  	char *arg2 = strdup(($3.loc)->name);
					  	fields_quad x(arg1,arg2,0,goto_EQ,$1.loc,$3.loc,0);
					  	quad_array->emit(x);
					  	$$.FL = makelist(next_instr);
					  	fields_quad y(0,0,0,GOTO_,0,0,0);
					  	quad_array->emit(y);
					  	$$.type = new_node(BOOL_,-1);
					}
				   |relational_expression NOT_EQUAL relational_expression
				   {
					  	$$.TL = makelist(next_instr);
					  	char *arg1 = strdup(($1.loc)->name);
					  	char *arg2 = strdup(($3.loc)->name);
					  	fields_quad x(arg1,arg2,0,goto_NEQ,$1.loc,$3.loc,0);
					  	quad_array->emit(x);
					  	$$.FL = makelist(next_instr);
					  	fields_quad y(0,0,0,GOTO_,0,0,0);
					  	quad_array->emit(y);
					  	$$.type = new_node(BOOL_,-1);
					}
				   ;

AND_expression:
			  equality_expression
			  {
			  	$$ = $1;
			  }
			  |AND_expression '&' equality_expression
			  {
			  	if(typecheck($1.type, $3.type)){
			  		$$.loc = current->gentemp(($1.type)->down);
			  		char *arg1 = strdup(($1.loc)->name);
			  		char *arg2 = strdup(($3.loc)->name);
			  		char *res = strdup(($$.loc)->name);
			  		fields_quad x(arg1,arg2,res,BW_AND,$1.loc,$3.loc,$$.loc);
			  		quad_array->emit(x);
			  		$$.type = $1.type;
			  	}
			  }
			  ;

exclusive_OR_expression:
					   AND_expression
					   {
						  	$$ = $1;
						}
					   |exclusive_OR_expression '^' AND_expression
					   {
					   		if(typecheck($1.type, $3.type)){
						  		$$.loc = current->gentemp(($1.type)->down);
						  		char *arg1 = strdup(($1.loc)->name);
						  		char *arg2 = strdup(($3.loc)->name);
						  		char *res = strdup(($$.loc)->name);
						  		fields_quad x(arg1,arg2,res,BW_XOR,$1.loc,$3.loc,$$.loc);
						  		quad_array->emit(x);
						  		$$.type = $1.type;
						  	}
					   }
					   ;

inclusive_OR_expression:
					   exclusive_OR_expression
					   {
						  	$$ = $1;
						  }
					   |inclusive_OR_expression '|' exclusive_OR_expression
					   {
					   		if(typecheck($1.type, $3.type)){
						  		$$.loc = current->gentemp(($1.type)->down);
						  		char *arg1 = strdup(($1.loc)->name);
						  		char *arg2 = strdup(($3.loc)->name);
						  		char *res = strdup(($$.loc)->name);
						  		fields_quad x(arg1,arg2,res,BW_INOR,$1.loc,$3.loc,$$.loc);
						  		quad_array->emit(x);
						  		$$.type = $1.type;
						  	}
					   }
					   ;

logical_AND_expression:
					  inclusive_OR_expression
					  {
					  	$$ = $1;
					  }
					  |logical_AND_expression BINARY_AND M inclusive_OR_expression 
					  {
					  	backpatch($1.TL,$3);
					  	$$.FL = merge($1.FL, $4.FL);
					  	$$.TL = $4.TL;
					  	$$.type = new_node(BOOL_,-1);
					  }
					  ;

logical_OR_expression:
					 logical_AND_expression
					 {
					  	$$ = $1;
					  }
					 |logical_OR_expression BINARY_OR M logical_AND_expression // M augmented so that if $1 is false then it jumps to $3
					 {
					  	backpatch($1.FL,$3);
					  	$$.TL = merge($1.TL,$4.TL);
					  	$$.FL = $4.FL;
					  	$$.type = new_node(BOOL_,-1);
					  }
					 ;

conditional_expression:
					  logical_OR_expression
					  {
					  	$$ = $1;
					  }
					  |logical_OR_expression N '?' M  expression N ':' M  conditional_expression	// M and N augmented
					  {
					  	$$.loc = current->gentemp(($5.type)->down);
					  	$$.type = $5.type;
					  	char *res = strdup(($$.loc)->name);
					  	char *arg1 = strdup(($9.loc)->name);
					  	fields_quad x(arg1,0,res,ASSIGN,$9.loc,0,$$.loc);
					  	quad_array->emit(x);
					  	lnode *l = makelist(next_instr);
					  	fields_quad y(0,0,0,GOTO_,0,0,0);
					  	quad_array->emit(y);
					  	backpatch($6,next_instr);
					  	res = strdup(($$.loc)->name);
					  	arg1 = strdup(($5.loc)->name);
					  	fields_quad z(arg1,0,res,ASSIGN,$5.loc,0,$$.loc);
					  	quad_array->emit(z);
					  	l = merge(l,makelist(next_instr));
					  	fields_quad a(0,0,0,GOTO_,0,0,0);
					  	quad_array->emit(a);
					  	backpatch($2,next_instr);
					  	conv2Bool(&$1);
					  	backpatch($1.TL,$4);
					  	backpatch($1.FL,$8);
					  	backpatch(l,next_instr);
					  }
					  ;

assignment_expression:
					 conditional_expression
					 {
					 	$$ = $1;
					 }
					 |unary_expression assignment_operator assignment_expression
					 {
					 	if(typecheck($1.type,$3.type)){
					  		if($1.loc1){
						  		//printf("%s\n",($1.loc)->name);
						  		char *arg1 = strdup(($1.array)->name);
						  		char *arg2 = strdup(($1.loc1)->name);
						  		char *res = strdup(($3.loc)->name);
						  		fields_quad x(arg1,arg2,res,BRACKET_EQ,$1.loc,$1.loc1,$3.loc);
						  		quad_array->emit(x);
					  		}
					  		else{
						  		char *arg1 = strdup(($3.loc)->name);
							  	char *res = strdup(($1.loc)->name);
							  	fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,$1.loc);
							  	quad_array->emit(x);
					  		}
					  	}
					  	else{
					  		symbol_table_fields *temp1, *temp2;
					  		if(($1.type)->down == INT_ && ($3.type)->down == DOUBLE_){
					  			temp1 = current->gentemp(INT_);
					  			char *arg1 = new char[100];
					  			sprintf(arg1,"dbl2int(%s)",($3.loc)->name);
					  			char *res = strdup(temp1->name);
					  			fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,temp1);
					  			quad_array->emit(x);
					  		}
					  		else if(($1.type)->down == INT_ && ($3.type)->down == CHAR_){
					  			temp1 = current->gentemp(CHAR_);
					  			char *arg1 = new char[100];
					  			sprintf(arg1,"int2char(%s)",($1.loc)->name);
					  			char *res = strdup(temp1->name);
					  			fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,temp1);
					  			quad_array->emit(x);
					  			
					  		}
					  		else if(($1.type)->down == DOUBLE_ && ($3.type)->down == INT_){
					  			temp1 = current->gentemp(INT_);
					  			char *arg1 = new char[100];
					  			sprintf(arg1,"dbl2int(%s)",($1.loc)->name);
					  			char *res = strdup(temp1->name);
					  			fields_quad x(arg1,0,res,ASSIGN,$1.loc,0,temp1);
					  			quad_array->emit(x);
					  		}
					  		else if(($1.type)->down == CHAR_ && ($3.type)->down == INT_){
					  			temp1 = current->gentemp(CHAR_);
					  			char *arg1 = new char[100];
					  			sprintf(arg1,"int2char(%s)",($3.loc)->name);
					  			char *res = strdup(temp1->name);
					  			fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,temp1);
					  			quad_array->emit(x);
					  		}
					  		if($1.loc1){
						  		//printf("%s\n",($1.loc)->name);
						  		char *arg1 = strdup(($1.array)->name);
						  		char *arg2 = strdup(($1.loc1)->name);
						  		char *res = strdup((temp1)->name);
						  		fields_quad x(arg1,arg2,res,BRACKET_EQ,$1.loc,$1.loc1,$3.loc);
						  		quad_array->emit(x);
					  		}
					  		else{
						  		char *arg1 = strdup((temp1)->name);
							  	char *res = strdup(($1.loc)->name);
							  	fields_quad x(arg1,0,res,ASSIGN,$3.loc,0,$1.loc);
							  	quad_array->emit(x);
					  		}
					  	}
					 }
					 ;

assignment_operator:
				   '='
				   {
				   	// do nothing
				   }
				   |STAR_EQUAL
				   {
				   	// no action
				   }
				   |SLASH_EQUAL
				   {
				   // DO NOTHING
				   }
				   |PERCENTILE_EQUAL
				   {
				   	// NO ACTION
				   }
				   |PLUS_EQUAL
				   {
				   // NO ACTION
				   }
				   |MINUS_EQUAL
				   {
				   	// NO ACTION
				   }
				   |LEFT_SHIFT_EQUAL
				   {
				   	// NO ACTION
				   }
				   |RIGHT_SHIFT_EQUAL
				   {
				   	// NO ACTION
				   }
				   |AND_EQUAL
				   {
				   	// NO ACTION
				   }
				   |XOR_EQUAL
				   {
				   	// NO ACTION
				   }
				   |OR_EQUAL
				   {
				   	// NO ACTION
				   }
				   ;						 

expression:
		  assignment_expression
		  {
		  	$$ = $1;
		  }
		  |expression ',' assignment_expression
		  {
		  	// not to be implemented
		  }
		  ;
		   
constant_expression:
				   conditional_expression
				   {
				   	// do nothing
				   }
				   ;

declaration
	: declaration_specifiers ';'
	  {
	  	// not in use
	  }
	| declaration_specifiers init_declarator_list ';'
	  {
	  	if(flag1 == 1 && flag2 == 0){
	  		tNode *temp = new_node(($1.type)->down,-1);
	  		char *temp1 = strdup("retVal");
	  		symbol_table_fields x(temp1,temp,0,$1.width,-1,0);
	  		temp_use->insert(x);
	  		temp = new_node(FUNCTION,-1);
	  		symbol_table_fields y($2.var,temp,0,0,-1,temp_use);
	  		symbol_table->insert(y);
	  	}
	  	flag1 = 0;
	  	flag2 = 0;
	  	c = 0;
	  }
	;

declaration_specifiers
	: storage_class_specifier {/* not in use*/}
	| storage_class_specifier declaration_specifiers {/* not in use*/}
	| type_specifier 
	{
	  	if(flag1 == 0 || flag2 == 0){
	  		$$.type = $1.type;
	  		$$.width = $1.width;
	  		t = $$.type;
	  		w = $$.width;
	  	}
	}
	| type_specifier declaration_specifiers {/* not in use*/}
	| type_qualifier {/* not in use*/}
	| type_qualifier declaration_specifiers {/* not in use*/}
	| function_specifier {/* not in use*/}
	| function_specifier declaration_specifiers {/* not in use*/}
	;

init_declarator_list
	: init_declarator
	  {
	  	if(flag1 == 1 && flag2 == 0)
	  		$$.var = $1.var;
	  }
	| init_declarator_list ',' init_declarator
	  {

	  }
	;

init_declarator
	: declarator
	  {
	  	if(flag1 == 0){
	  		tNode *temp = new_node(t->down,-1);
	  		temp = merge_node($1.type,temp);
	  		int temp_size;
	  		if(temp->down == PTR)
	  			temp_size = SIZE_OF_PTR;
	  		else{
		  		switch(t->down){
		  			case INT_ : temp_size = SIZE_OF_INT;
		  					   break;
		  			case DOUBLE_ : temp_size = SIZE_OF_DOUBLE;
		  						  break;
		  			case CHAR_   : temp_size = SIZE_OF_CHAR;
		  						  break; 	
	  			}
	  		}
	  		temp_size = temp_size * $1.width;
	  		symbol_table_fields x($1.var,temp,0,temp_size,-1,0);
	  		current->insert(x);
	  		//current->print_Table();
	  	}
	  	else if(flag1 == 1 && flag2 == 0){
	  		$$.var = $1.var;
	  	}
	  }
	| declarator '=' initializer
	  {
	  	if(flag1 == 0){
	  		tNode *temp = new_node(t->down,-1);
	  		temp = merge_node($1.type,temp);
	  		void *value;
	  		int *v1;
	  		double *v2;
	  		char *v3;
	  		int temp_size;
	  		switch(t->down){
	  			case INT_ : v1 = (int *)malloc(sizeof(int));
	  					   (*v1) = $3.int_data; 	
	  					   value = (void *)v1;
	  					   temp_size = SIZE_OF_INT;
	  					   break;
	  			case DOUBLE_ : v2 = (double *)malloc(sizeof(double));
		  					   (*v2) = $3.double_data;
		  					   //printf("%lf\n",$3.double_data); 	
		  					   value = (void *)v2;
		  					   //printf("%lf\n",*v2);
		  					   temp_size = SIZE_OF_DOUBLE;
		  					   break;
	  			case CHAR_   :v3 = (char *)malloc(sizeof(char));
	  					   (*v3) = $3.char_data; 	
	  					   value = (void *)v3;
	  					   temp_size = SIZE_OF_CHAR;
	  					   break;
	  			default     : value = 0; 	
	  		}
	  		temp_size = temp_size * $1.width;
	  		symbol_table_fields x($1.var,temp,value,temp_size,-1,0);
	  		current->insert(x);
	  	}
	  }
	;









storage_class_specifier:
					   EXTERN{}
					   |STATIC{}
					   |AUTO{}
					   |REGISTER{}
					   ;

type_specifier:
			  VOID
			  {
			  	if(flag2 == 0 || flag1 == 0){
			  		$$.type = new_node(VOID_,-1);
			  		$$.width = 0;
			  	}
			  }
			  |CHAR
			  {
			  	if(flag2 == 0 || flag1 == 0){
			  		$$.type = new_node(CHAR_,-1);
			  		$$.width = SIZE_OF_CHAR;
			  	}
			  }
			  |SHORT{}
			  |INT
			  {
			  	if(flag2 == 0 || flag1 == 0){
			  		//printf("Yo1\n");
			  		$$.type = new_node(INT_,-1);
			  		//printf("Yo2\n");
			  		$$.width = SIZE_OF_INT;
			  		//printf("Yo3\n");
			  	}
			  }
			  |LONG{}
			  |FLOAT{}
			  |DOUBLE
			  {
			  	if(flag2 == 0 || flag1 == 0){
			  		$$.type = new_node(DOUBLE_,-1);
			  		$$.width = SIZE_OF_DOUBLE;
			  	}
			  }
			  |SIGNED{}
			  |UNSIGNED{}
			  |BOOL{}
			  |COMPLEX{}
			  |IMAGINARY{}
			  |enum_specifier{}
			  ;

specifier_qualifier_list:
						type_specifier specifier_qualifier_list_optional{}
						|type_qualifier specifier_qualifier_list_optional{}
						;

specifier_qualifier_list_optional:
							specifier_qualifier_list{}
							|{}
							;

enum_specifier:
			  ENUM identifier_optional '{' enumerator_list '}'
			  {}
			  |ENUM identifier_optional '{' enumerator_list ',' '}'
			  {}
			  |ENUM IDENTIFIER
			  {}
			  ;

enumerator_list:
			   ENUM{}
			   |enumerator_list ',' enumerator
			   {}
			   ;

enumerator:
		  IDENTIFIER
		  {}
		  |IDENTIFIER '=' constant_expression
		  {}
		  ;

type_qualifier:
			  CONST{}
			  |RESTRICT{}
			  |VOLATILE{}
			  ;

function_specifier:
				  INLINE{}
				  ;

declarator:
		  pointer direct_declarator
		   {
		  	if(flag1 == 0 || flag2 == 0){
		  		$$.type = merge_node($2.type,$1.type);
		  		$$.width = $2.width;
		  		$$.var = $2.var;
		  	}
		  }
		  | direct_declarator
		  {
		  		$$.type = $1.type;
		  		$$.var = $1.var;
		  		$$.width = $1.width;
		  }
		;

direct_declarator:
				   IDENTIFIER
					{
					  	if(flag1 == 0 || flag2 == 0){
					  		$$.var = $1.var;
						  	$$.type = 0;
						  	$$.width = 1;
						  	if(c == 0){
						  		//printf("DD->Id me load hai kya?\n");
						  		symbol_table_fields *t = current->lookup($1.var);
							  	if(t){
							  		flag2 = 1;
							  		temp_use = (t->nestedTable);	// Set flag to handle multiple declaration
							  		//printf("%s\n",(t->nestedTable)[0].name);
							  		//printf("%p\n",temp_use);
							  		//printf("%p\n",t->nestedTable);
							  		//if(!temp_use)
							  		//printf("Null hai\n");
							  		//printf("%d\n",temp_use->curr_length);
							  		//printf("%s\n",(temp_use->table)[0].name);
							  		//temp_use->print_Table();
							  		//printf("Type casting ka load nahi hai\n");
							  	}												// (to be used in other actions)		
							  	else                                            
							  		flag2 = 0; 
							  	c++;	
						  	}
					  	}										
					  }				
				   |'(' declarator ')'
				   {}
				   | direct_declarator '[' type_qualifier_list assignment_expression ']'
				   {}
					| direct_declarator '[' assignment_expression ']'
					  {
					  	if(flag1 == 0 || flag2 == 0){
					  		tNode *temp = new_node(ARRAY,$3.val.int_data);
					  		$$.type = merge_node($1.type,temp);
					  		$$.width = $1.width * $3.val.int_data;
					  		$$.var = $1.var;
					  	}
					  }
					| direct_declarator '[' type_qualifier_list ']'
					  {}
					| direct_declarator '[' ']'
					  {
					  	if(flag1 == 0 || flag2 == 0){
					  		$$.var = $1.var;
						  	$$.type = $1.type;
						  	$$.width = $1.width;
					  	}
					  }
				   |direct_declarator '[' STATIC type_qualifier_list_optional assignment_expression ']'
				   {}
				   | direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
					{}
				   |direct_declarator '[' type_qualifier_list_optional '*' ']'
				   {}
				   |direct_declarator '(' parameter_type_list ')'
				   {
				  	flag1 = 1;										
				  	$$.var = $1.var;
				  	$$.type = 0;
				  	$$.width = 1;
				  }
				   |direct_declarator '(' ')'
				   {
					  	flag1 = 1;
					  	if(flag2 == 0)
					  		temp_use = construct_Symbol_Table();
					  	$$.var = $1.var;
					  	$$.type = 0;
					  	$$.width = 1;
				    }
				    | direct_declarator '(' identifier_list ')'
				    {}
				   ;

pointer:
	   '*' type_qualifier_list
	   {}
	   |'*'
	   	{
	  		$$.type = new_node(PTR,-1);
	  	}
	   |'*' type_qualifier_list pointer{}
	   |'*' pointer
	   {
	   	tNode *temp = new_node(PTR,-1);
	  	$$.type = merge_node($2.type,temp);
	   }
	   ;

type_qualifier_list:
				   type_qualifier{}
				   |type_qualifier_list type_qualifier{}
				   ;

type_qualifier_list_optional:
					   type_qualifier_list{}
					   |{}
					   ;

parameter_type_list:
				   parameter_list {}
				   |parameter_list ',' ELLIPSIS{}
				   ;

parameter_list:
			  parameter_declaration
			  {
			  	if(flag2 == 0){										// An indication of the fact that function has not been
			  		temp_use = construct_Symbol_Table();				// declared previously
			  		symbol_table_fields x($1.var,$1.type,0,$1.width,-1,0); //Insert in sym tab of function(offset comp.in insert)
			  		temp_use->insert(x);
			  	}
			  }
			  |parameter_list ',' parameter_declaration
			  {
			  	if(flag2 == 0){
			  		symbol_table_fields x($3.var,$3.type,0,$3.width,-1,0); //Insert in sym tab of function(offset comp. in insert)
			  		temp_use->insert(x);
			  		}
	  			}
			  ;

parameter_declaration:
					 declaration_specifiers declarator
					 {
					  	if(flag2 == 0){						
					  		$$.type = merge_node($2.type,$1.type);
					  		$$.var = $2.var;
					  		$$.width = $1.width*$2.width;
					  	}	
					  }
					 |declaration_specifiers
					 ;

identifier_list:
			   IDENTIFIER{}
			   |identifier_list ',' IDENTIFIER{}
			   ;

type_name:
		 specifier_qualifier_list{}
		 ;

initializer:
		   assignment_expression
		   {
			 	$$ = $1.val;
			}
		   |'{' initializer_list '}'{}
		   |'{' initializer_list ',' '}'{}
		   ;

initializer_list:
				designation_optional initializer{}
				|initializer_list ',' designation_optional initializer{}
				;

designation:
		   designator_list '='{}
		   ;

designation_optional:
		   designation{}
		   |{}
		   ;

designator_list:
			   designator{} 
			   |designator_list designator{}
			   ;

designator:
		  '[' constant_expression ']'{}
		  |'.' IDENTIFIER{}
		  ;

statement:
		 labeled_statement{}
		 |compound_statement{$$ = $1;}
		 |expression_statement{$$ = $1;}
		 |selection_statement{$$ = $1;}
		 |iteration_statement{$$ = $1;}
		 |jump_statement{$$ = $1;}
		 ;

labeled_statement:
				 IDENTIFIER ':' statement{}
				 |CASE constant_expression ':' statement{}
				 |DEFAULT ':' statement{}
				 ;

compound_statement:
				 '{' '}'{}
				  |'{' block_item_list '}'
				  { 
				  	$$ = $2;
				  }
				  ;

block_item_list:
			   block_item 
			   { 
				  $$ = $1;
				}
			   |block_item_list M block_item
			   { 
					backpatch($1.NL,$2);
					$$ = $3;
			  	}
			   ;

block_item:
		  declaration{}
		  |statement{$$ = $1;}
		  ;

expression_statement:
					expression ';'
					{$$ =$1;}
					|';'{}
					;

selection_statement:
				   IF '(' expression N')' M statement N %prec CONFLICTIVE_IF
				   {
				  	backpatch($4,next_instr);
				  	conv2Bool(&$3);
				  	backpatch($3.TL,$6);
				  	$$.NL = merge($7.NL,$3.FL);
				  	$$.NL = merge($$.NL,$8);
				  }
				   |IF '(' expression N')' M  statement N ELSE M statement
				   {
					  	lnode *l = 0;
					  	if(($3.type)->down!=BOOL_){
					  		l = makelist(next_instr);
					  		fields_quad x(0,0,0,GOTO_,0,0,0);
					  		quad_array->emit(x);
					  	}
					  	backpatch($4,next_instr);
					  	conv2Bool(&$3);
					  	backpatch($3.TL,$6);
					  	backpatch($3.FL,$10);
					  	lnode *temp = merge($8,$7.NL);
					  	$$.NL = merge(temp,$11.NL);
					  	$$.NL = merge($$.NL,l);
					 }
				   |SWITCH '(' expression ')' statement{}
				   ;

iteration_statement:
				   WHILE M '(' expression N')' M  statement
				   {
				  	char *res = new char[10];
				  	sprintf(res,"%d",$2);
				  	fields_quad x(0,0,res,GOTO_,0,0,0);
				  	quad_array->emit(x);
				  	backpatch($5,next_instr);
				  	conv2Bool(&$4);
				  	backpatch($8.NL,$2);
				  	backpatch($4.TL,$7);
				  	$$.NL = $4.FL;
				  }
				   |DO M statement M WHILE '(' expression N')' ';'
				   {
					  	backpatch($8,next_instr);
					  	conv2Bool(&$7);
					  	backpatch($7.TL,$2);
					  	backpatch($3.NL,$4);
					  	$$.NL = $7.FL;
					}
				   |FOR '(' expression_statement M expression_statement N M  expression N ')' M statement
				   {
					  	backpatch($9,$4);
					  	lnode *l = makelist(next_instr);
					  	fields_quad x(0,0,0,GOTO_,0,0,0);
					  	quad_array->emit(x);
					  	$12.NL = merge($12.NL,l);
					  	backpatch($12.NL,$7);
					  	backpatch($6,next_instr);
					  	conv2Bool(&$5);
					  	backpatch($5.TL,$11);
					  	$$.NL = $5.FL;
					}
				   |FOR '(' declaration expression_statement expression ')' statement{}
				   ;

jump_statement:
			  GOTO IDENTIFIER ';'{}
			  |CONTINUE ';'{}
			  |BREAK ';'{}
			  |RETURN expression ';'
			  {
			  	char *arg1 = strdup(($2.loc)->name);
			  	fields_quad x(arg1,0,0,RETURN_EXP,$2.loc,0,0);
			  	quad_array->emit(x);
			  }
			  |RETURN ';'
			  {
			  	fields_quad x(0,0,0,RETURN_,0,0,0);
	  			quad_array->emit(x);
			  }
			  ;

translation_unit:
				external_declaration{}
				|translation_unit external_declaration{}
				;

external_declaration:
					function_definition{}
					|declaration{}
					;

function_definition:
				   declaration_specifiers declarator declaration_list compound_statement{}
				   |declaration_specifiers declarator F compound_statement            	// augmenting F
				   {
					  	current = symbol_table; 
					}
				   ;

declaration_list:
				declaration{}
				|declaration_list declaration{}
				;

identifier_optional:
			  IDENTIFIER{}
			  |{}
			  ;
M:
				{
					$$ = next_instr;
				}
				;
N:
	{
		$$ = makelist(next_instr);
		fields_quad x(0,0,0,GOTO_,0,0,0);
		quad_array->emit(x);
	}
	;
F   :
	{
		current = temp_use;
		int i;
		char *t;
		for(i=0;i<=symbol_table->curr_length;i++){
			if((((symbol_table->table)[i]).nestedTable) == current){
				t = strdup(((symbol_table->table)[i]).name);
				break;
			}
		}
		fields_quad x(t,0,0,Function,0,0,0);
		quad_array->emit(x);
		flag1 = 0;
		flag2 = 0;
		c = 0;
	}
	;

%%

void yyerror(const char *s) {
    printf("Error occured : %s\n",s);
}
