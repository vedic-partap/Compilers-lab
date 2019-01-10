%{
	#include<bits/stdc++.h>
	#include "translator.h"
	#include "y.tab.h"
	using namespace std;

	extern YYSTYPE yylval;
	extern SymbolTable *ST;
%}


ID [_a-zA-Z][_a-zA-Z0-9]*

INT_CONST ([1-9][0-9]*)|[0]

DIG_SEQ [0-9]+
DEC "."
FRACTIONAL_CONST (({DIG_SEQ}?{DEC}{DIG_SEQ})|({DIG_SEQ}{DEC}))
SIGN ([+]|[-])
EXP_PART ([e]|[E]){SIGN}?{DIG_SEQ}
DOUBLE_CONST (({FRACTIONAL_CONST}{EXP_PART}?)|({DIG_SEQ}{EXP_PART}))

MULTI_LINE_COMMENT ("/"\*(([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*)\*+"/")

WILDCARD .
SINGLE_LINE_COMMENT ([/][/]{WILDCARD}*)


WS [ \t]
%%

{WS}				  {;}
[\n]				{;}
{SINGLE_LINE_COMMENT} 		  {;}
{MULTI_LINE_COMMENT}  		  {;}

"("                 { return (int)'('; }
")"                 { return (int)')'; }
"*"                 { return (int)'*'; }
"+"                 { return (int)'+'; }
"-"                 { return (int)'-'; }
"/"                 { return (int)'/'; }
";"                 { return (int)';'; }
"="                 { return (int)'='; }

{ID}                { string s(yytext); yylval.name = new string; *(yylval.name) = s; return ID;}
{INT_CONST}         { yylval.intVal = atoi(yytext); return INT_CONST;}
{DOUBLE_CONST}       { yylval.doubleVal = atof(yytext); return DOUBLE_CONST;}


%%