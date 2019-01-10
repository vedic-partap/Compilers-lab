%{
#include <stdio.h>
extern int yylex();
void yyerror(const char*);
%}


%union {
  int intval;
  float floatval;
  char *charval;
}

%token ARROW
%token INCREMENT
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
%token WHILE
%token BOOL
%token COMPLEX
%token IMAGINARY
%token SINGLE_COMMENT
%token MULTI_COMMENT
%token IDENTIFIER
%token <intval> INTEGER_NO
%token <intval> FLOAT_NO
%token <intval> CHARACTER
%token <intval> STRING
%token <intval> ENUMERATION_CONSTANT
%token PUNCTUATOR
%token WS

%start translation_unit

%%

primary_expression:
					IDENTIFIER
					|INTEGER_NO
					|FLOAT_NO
					|CHARACTER
					|STRING
					|'(' expression ')'
					;

postfix_expression:
					primary_expression
					|postfix_expression '[' expression ']'
					|postfix_expression '(' argument_expression_list_optional ')'
				  	|postfix_expression '.' IDENTIFIER
				  	|postfix_expression ARROW IDENTIFIER
				  	|postfix_expression INCREMENT 
				  	|postfix_expression DECREMENT
				  	|'(' type_name ')' '{' initializer_list '}'
				  	|'(' type_name ')' '{' initializer_list ',' '}'
				  ;

argument_expression_list_optional:
						  argument_expression_list
						  |
						  ;

argument_expression_list:
					  assignment_expression
					  |argument_expression_list ',' assignment_expression
					  ;

unary_expression:
				postfix_expression
				|INCREMENT unary_expression
				|DECREMENT unary_expression
				|unary_operator cast_expression
				|SIZEOF unary_expression
				|SIZEOF '(' type_name ')' 
				;					 

unary_operator:
			  '&'
			  |'*'
			  |'+'
			  |'-'
			  |'~'
			  |'!'
			  ;

cast_expression:
			   unary_expression
			   |'(' type_name ')' cast_expression
			   ;

multplicative_expression:
						cast_expression
						|multplicative_expression '*' cast_expression
						|multplicative_expression '/' cast_expression
						|multplicative_expression '%' cast_expression
						;

additive_expression:
				   multplicative_expression
				   |additive_expression '+' multplicative_expression
				   |additive_expression '-' multplicative_expression
				   ;

shift_expression:
				additive_expression
				|shift_expression LSHIFT additive_expression
				|shift_expression RSHIFT additive_expression
				;

relational_expression:
					 shift_expression
					 |relational_expression '<' shift_expression
					 |relational_expression '>' shift_expression
					 |relational_expression LESS_THAN_EQUAL_TO shift_expression
					 |relational_expression GREATER_THAN_EQUAL_TO shift_expression
					 ;

equality_expression:
				   relational_expression
				   |equality_expression DOUBLE_EQUAL relational_expression
				   |relational_expression NOT_EQUAL relational_expression
				   ;

AND_expression:
			  equality_expression
			  |AND_expression '&' equality_expression
			  ;

exclusive_OR_expression:
					   AND_expression
					   |exclusive_OR_expression '^' AND_expression
					   ;

inclusive_OR_expression:
					   exclusive_OR_expression
					   |inclusive_OR_expression '|' exclusive_OR_expression
					   ;

logical_AND_expression:
					  inclusive_OR_expression
					  |logical_AND_expression BINARY_AND inclusive_OR_expression
					  ;

logical_OR_expression:
					 logical_AND_expression
					 |logical_OR_expression BINARY_OR logical_AND_expression
					 ;

conditional_expression:
					  logical_OR_expression
					  |logical_OR_expression '?' expression ':' conditional_expression
					  ;

assignment_expression:
					 conditional_expression
					 |unary_expression assignment_operator assignment_expression
					 ;

assignment_expression_optional:
						 assignment_expression
						 |
						 ;

assignment_operator:
				   '='
				   |STAR_EQUAL
				   |SLASH_EQUAL
				   |PERCENTILE_EQUAL
				   |PLUS_EQUAL
				   |MINUS_EQUAL
				   |LEFT_SHIFT_EQUAL
				   |RIGHT_SHIFT_EQUAL
				   |AND_EQUAL
				   |XOR_EQUAL
				   |OR_EQUAL
				   ;						 

expression:
		  assignment_expression
		  |expression ',' assignment_expression
		  ;
		   
constant_expression:
				   conditional_expression
				   ;

expression_optional:
			  expression
			  |
			  ;

declaration:
		   declaration_specifiers init_declarator_list_optional ';'
		   ;

declaration_specifiers:
					  storage_class_specifier declaration_specifiers_optional
					  |type_specifier declaration_specifiers_optional
					  |type_qualifier declaration_specifiers_optional
					  |function_specifier declaration_specifiers_optional
					  ;

declaration_specifiers_optional:
						  declaration_specifiers
						  |
						  ;

init_declarator_list_optional:
						init_declarator_list
						|
						;

init_declarator_list:
				init_declarator 
				|init_declarator_list ',' init_declarator
				;

init_declarator:
			   declarator
			   |declarator '=' initializer
			   ;

storage_class_specifier:
					   EXTERN
					   |STATIC
					   |AUTO
					   |REGISTER
					   ;

type_specifier:
			  VOID
			  |CHAR
			  |SHORT
			  |INT
			  |LONG
			  |FLOAT
			  |DOUBLE
			  |SIGNED
			  |UNSIGNED
			  |BOOL
			  |COMPLEX
			  |IMAGINARY
			  |enum_specifier
			  ;

specifier_qualifier_list:
						type_specifier specifier_qualifier_list_optional
						|type_qualifier specifier_qualifier_list_optional
						;

specifier_qualifier_list_optional:
							specifier_qualifier_list
							|
							;

enum_specifier:
			  ENUM identifier_optional '{' enumerator_list '}'
			  |ENUM identifier_optional '{' enumerator_list ',' '}'
			  |ENUM IDENTIFIER
			  ;

enumerator_list:
			   ENUM
			   |enumerator_list ',' enumerator
			   ;

enumerator:
		  IDENTIFIER
		  |IDENTIFIER '=' constant_expression
		  ;

type_qualifier:
			  CONST
			  |RESTRICT
			  |VOLATILE
			  ;

function_specifier:
				  INLINE
				  ;

declarator:
		  pointer_optional direct_declarator
		  ;

direct_declarator:
				   IDENTIFIER
				   |'(' declarator ')'
				   |direct_declarator '[' type_qualifier_list_optional assignment_expression_optional ']'
				   |direct_declarator '[' STATIC type_qualifier_list_optional assignment_expression ']'
				   |direct_declarator '[' type_qualifier_list_optional '*' ']'
				   |direct_declarator '(' parameter_type_list ')'
				   |direct_declarator '(' identifier_list_optional ')'
				   ;

pointer:
	   '*' type_qualifier_list_optional
	   |'*' type_qualifier_list_optional pointer
	   ;

pointer_optional:
		   pointer
		   |
		   ;

type_qualifier_list:
				   type_qualifier
				   |type_qualifier_list type_qualifier
				   ;

type_qualifier_list_optional:
					   type_qualifier_list
					   |
					   ;

parameter_type_list:
				   parameter_list
				   |parameter_list ',' ELLIPSIS
				   ;

parameter_list:
			  parameter_declaration
			  |parameter_list ',' parameter_declaration
			  ;

parameter_declaration:
					 declaration_specifiers declarator
					 |declaration_specifiers
					 ;

identifier_list:
			   IDENTIFIER
			   |identifier_list ',' IDENTIFIER
			   ;

identifier_list_optional:
				   identifier_list
				   |
				   ;

type_name:
		 specifier_qualifier_list
		 ;

initializer:
		   assignment_expression
		   |'{' initializer_list '}'
		   |'{' initializer_list ',' '}'
		   ;

initializer_list:
				designation_optional initializer
				|initializer_list ',' designation_optional initializer
				;

designation:
		   designator_list '='
		   ;

designation_optional:
		   designation
		   |
		   ;

designator_list:
			   designator 
			   |designator_list designator
			   ;

designator:
		  '[' constant_expression ']'
		  |'.' IDENTIFIER
		  ;

statement:
		 labeled_statement
		 |compound_statement
		 |expression_statement
		 |selection_statement
		 |iteration_statement
		 |jump_statement
		 ;

labeled_statement:
				 IDENTIFIER ':' statement
				 |CASE constant_expression ':' statement
				 |DEFAULT ':' statement
				 ;

compound_statement:
				  '{' block_item_list_optional '}'
				  ;

block_item_list:
			   block_item 
			   |block_item_list block_item
			   ;

block_item_list_optional:
				   block_item_list
				   |
				   ;

block_item:
		  declaration
		  |statement
		  ;

expression_statement:
					expression_optional ';'
					;

selection_statement:
				   IF '(' expression ')' statement
				   |IF '(' expression ')' statement ELSE statement
				   |SWITCH '(' expression ')' statement
				   ;

iteration_statement:
				   WHILE '(' expression ')' statement
				   |DO statement WHILE '(' expression ')' ';'
				   |FOR '(' expression_optional ';' expression_optional ';' expression_optional ')' statement 
				   |FOR '(' declaration expression_optional ';' expression_optional ')' statement
				   ;

jump_statement:
			  GOTO IDENTIFIER ';'
			  |CONTINUE ';'
			  |BREAK ';'
			  |RETURN expression_optional ';'
			  ;

translation_unit:
				external_declaration
				|translation_unit external_declaration
				;

external_declaration:
					function_definition
					|declaration
					;

function_definition:
				   declaration_specifiers declarator declaration_list_optional compound_statement
				   ;

declaration_list:
				declaration
				|declaration_list declaration
				;

declaration_list_optional:
				declaration_list
				|
				;

identifier_optional:
			  IDENTIFIER
			  |
			  ;


%%

void yyerror(const char *s) {
    printf("Error occured : %s\n",s);
}
