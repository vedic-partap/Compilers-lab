%{
	#include<bits/stdc++.h>
	#include "translator.h"	
	using namespace std;
	extern int yylex();
	extern int yyparse();
	void yyerror(string s);

	ofstream myfile1;
	ofstream myfile;
	QuadArray quadArray;									// Object of the class QuadArray which to generate and work on quads
	SymbolTable *ST = new SymbolTable;						// Pointer to Symbol Table Object
%}

%union{
	int intVal;								// Used for storing integer constant value
	double doubleVal;						// Used for storing double constant value
	string *name; 							// Used for storing String Literal
	SymTabEntry *symp;						// Pointer to a Symbol Table
	Attribute_SE *se_attr;					// Holds the attributes for statements and Expressions
	opcodeType op;
}


%token <name> ID 													// Attribute: name -> name of the Identifier
%token <intVal> INT_CONST 											// Attribute: intVal -> Stores the integer value of the string literal
%token <doubleVal> DOUBLE_CONST										// Attribute: doubleVal -> Stores the double value for a double Constant

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type <se_attr> expression constant_expression primary_expression

%start stmt_list

%%


stmt_list	: statement ';'
			| stmt_list statement ';'
			;


statement	: primary_expression '=' expression			{ 	
										ST->update($1->loc,$3->typeInfo, ST->offset);
										ST->offset = (ST->offset) + ($3->typeInfo->width);
										quadArray.emit($1->loc->name, $3->loc->name); 
														}
			;


primary_expression	: ID 		{	$$ = new Attribute_SE; $$->typeInfo = NULL; $$->loc = NULL; $$->initValue = NULL;
									$$->name = *($1);
									$$->loc = ST->lookup($$->name);
									$$->typeInfo = $$->loc->typeInfo;
									
								}

constant_expression	: INT_CONST {		$$ = new Attribute_SE; $$->typeInfo = NULL; $$->loc = NULL; $$->initValue = NULL;
										$$->loc = ST->gentemp();
										TypeInfo *type1 = new TypeInfo;
										type1->type = type_int;
										type1->_size = SIZE_OF_INT;
										type1->width = SIZE_OF_INT;

										$$->typeInfo = type1;
										$$->intVal = $1;
										$$->name = $$->loc->name;
										ST->update($$->loc,$$->typeInfo,ST->offset);
										ST->updateintVal($$->loc, $$->intVal);
										ST->offset = ST->offset + SIZE_OF_INT;
										quadArray.emit($$->loc->name,$$->intVal);
								}
					| DOUBLE_CONST {	$$ = new Attribute_SE; $$->typeInfo = NULL; $$->loc = NULL; $$->initValue = NULL;
										$$->loc = ST->gentemp();
										TypeInfo *type1 = new TypeInfo;
										type1->type = type_double;
										type1->_size = SIZE_OF_DOUBLE;
										type1->width = SIZE_OF_DOUBLE;
										
										$$->typeInfo = type1;
										$$->doubleVal = $1;
										$$->name = $$->loc->name;
										ST->update($$->loc,$$->typeInfo,ST->offset);
										ST->updatedoubleVal($$->loc, $$->doubleVal);
										ST->offset = ST->offset + SIZE_OF_DOUBLE;
										quadArray.emit($$->loc->name,$$->doubleVal);
									}
					;

expression	: expression '+' expression { 	$$ = new Attribute_SE; $$->typeInfo = NULL; $$->loc = NULL; $$->initValue = NULL;
												
											$$->loc = ST->gentemp();
											$$->typeInfo = new TypeInfo;
											$$->typeInfo->type = $1->typeInfo->type;
											$$->typeInfo->_size = $1->typeInfo->_size;
											$$->typeInfo->width = $1->typeInfo->width;

											$$->name = $$->loc->name;
											ST->update($$->loc,$$->typeInfo, ST->offset);
											ST->offset = (ST->offset) + ($$->typeInfo->width);
											quadArray.emit($$->loc->name, $1->loc->name, PLUS, $3->loc->name);
										}

			| expression '-' expression { 	$$ = new Attribute_SE; $$->typeInfo = NULL; $$->loc = NULL; $$->initValue = NULL;
												
											$$->loc = ST->gentemp();
											$$->typeInfo = new TypeInfo;
											$$->typeInfo->type = $1->typeInfo->type;
											$$->typeInfo->_size = $1->typeInfo->_size;
											$$->typeInfo->width = $1->typeInfo->width;

											$$->name = $$->loc->name;
											ST->update($$->loc,$$->typeInfo, ST->offset);
											ST->offset = (ST->offset) + ($$->typeInfo->width);
											quadArray.emit($$->loc->name, $1->loc->name, MINUS, $3->loc->name);
										}
			| expression '*' expression { 	$$ = new Attribute_SE; $$->typeInfo = NULL; $$->loc = NULL; $$->initValue = NULL;
												
											$$->loc = ST->gentemp();
											$$->typeInfo = new TypeInfo;
											$$->typeInfo->type = $1->typeInfo->type;
											$$->typeInfo->_size = $1->typeInfo->_size;
											$$->typeInfo->width = $1->typeInfo->width;

											$$->name = $$->loc->name;
											ST->update($$->loc,$$->typeInfo, ST->offset);
											ST->offset = (ST->offset) + ($$->typeInfo->width);
											quadArray.emit($$->loc->name, $1->loc->name, MULT, $3->loc->name);
										}

			| expression '/' expression { 	$$ = new Attribute_SE; $$->typeInfo = NULL; $$->loc = NULL; $$->initValue = NULL;
												
											$$->loc = ST->gentemp();
											$$->typeInfo = new TypeInfo;
											$$->typeInfo->type = $1->typeInfo->type;
											$$->typeInfo->_size = $1->typeInfo->_size;
											$$->typeInfo->width = $1->typeInfo->width;

											$$->name = $$->loc->name;
											ST->update($$->loc,$$->typeInfo, ST->offset);
											ST->offset = (ST->offset) + ($$->typeInfo->width);
											quadArray.emit($$->loc->name, $1->loc->name, DIV, $3->loc->name);
										}


			| '(' expression ')' 		{ 	$$ = new Attribute_SE; $$->typeInfo = NULL; $$->loc = NULL; $$->initValue = NULL;
											*($$) = *($2);
										}

			| '-' expression %prec UMINUS { 	$$ = new Attribute_SE; $$->typeInfo = NULL; $$->loc = NULL; $$->initValue = NULL;
												$$->loc = ST->gentemp();
												$$->name = $$->loc->name;
												$$->typeInfo = new TypeInfo;

												$$->typeInfo->type = $2->loc->typeInfo->type;
												$$->typeInfo->_size = $2->loc->typeInfo->_size;
												$$->typeInfo->width = $2->loc->typeInfo->width;
										
												ST->update($$->loc, $$->typeInfo, ST->offset);
												ST->offset = (ST->offset)+($$->typeInfo->width);
												quadArray.emit($$->loc->name,$2->loc->name, UNARY_MINUS); 

											}

			| primary_expression 		{ 	
											$$ = new Attribute_SE; $$->typeInfo = NULL; $$->loc = NULL; $$->initValue = NULL;
											*($$) = *($1);
										}
			
			| constant_expression 		{ 	$$ = new Attribute_SE; $$->typeInfo = NULL; $$->loc = NULL; $$->initValue = NULL;
											*($$) = *($1);
										}
			
			;

%%

void yyerror(string s) {
	cout<<"Error occured due to: "<<s<<endl;
}
