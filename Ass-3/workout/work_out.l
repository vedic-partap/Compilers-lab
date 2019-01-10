%{
#define	INT		10
#define	ID		11
#define	PLUS		12
#define	MULT		13
#define	ASSIGN		14
#define	LBRACE		15
#define	RBRACE		16
#define	CONST		17
#define	SEMICOLON	18
%}

INT 		"int"
ID 		[a-z][a-z0-9]*
PUNC 		[;]
CONST 		[0-9]+
WS 		[ \t\n]

%%
{INT}		{ return INT; }
{ID}		{ return ID; }
"+"		{ return PLUS; }
"*"		{ return MULT; }
"="		{ return ASSIGN; }
"{"		{ return LBRACE; }
"}"		{ return RBRACE; }
{PUNC}		{ return SEMICOLON; }
{CONST}		{ return CONST; }
{WS}		{/* Ignore whitespace */}
%%

int main(int argc,char *argv[]) {
	int token;
	while (token = yylex()) {
		switch (token) {
			case INT: 	printf("<KEYWORD, %d, %s>\n", token, yytext); 
				break;
			case ID: 	printf("<IDENTIFIER, %d, %s>\n", token, yytext); 
				break;
			case PLUS: 	printf("<OPERATOR, %d, %s>\n", token, yytext); 
				break;
			case MULT: 	printf("<OPERATOR, %d, %s>\n", token, yytext); 
				break;
			case ASSIGN: 	printf("<OPERATOR, %d, %s>\n", token, yytext); 
				break;
			case LBRACE: 	printf("<SPECIAL SYMBOL, %d, %s>\n", token, yytext); 
				break;
			case RBRACE: 	printf("<SPECIAL SYMBOL, %d, %s>\n", token, yytext); 
				break;
			case SEMICOLON: printf("<PUNCTUATION, %d, %s>\n", token, yytext); 
				break;
			case CONST: 	printf("<INTEGER CONSTANT, %d, %s>\n", token, yytext); 
				break;
		}
	}
	return 0;
}


