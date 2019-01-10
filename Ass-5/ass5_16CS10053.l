%{
#include <stdio.h>
#include "ass5_16CS10053_translator.h"
#include "y.tab.h"
%}

SINGLELINE_COMMENT  \/\/.*
MULTILINE_COMMENT	"/"\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+"/"
IDENTIFIER			[_a-zA-Z][_a-zA-Z0-9]*
DIGIT		 		[0-9]
INTEGER_CONST		[1-9]{DIGIT}*|0
FLOATING_CONST		(((([0-9]+)?\.[0-9]+)|([0-9]+\.))([eE][+-]?[0-9]+)?)|([0-9]+[eE][+-]?[0-9]+)
ENUMERATION_CONST	[_a-zA-Z][_a-zA-Z0-9]* 
ESCAPE_SEQUENCE		\\['"?\\abfnrtv]
C_CHAR				[^'\\\n]|{ESCAPE_SEQUENCE}
C_CHAR_SEQUENCE		{C_CHAR}+
CHARACTER_CONST		\'{C_CHAR_SEQUENCE}\'
CONSTANT            {INTEGER_CONST}|{FLOATING_CONST}|{ENUMERATION_CONST}|{CHARACTER_CONST}
S_CHAR				[^"\\\n]|{ESCAPE_SEQUENCE}
PUNCTUATOR			"["|"]"|"."|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"("|")"|"{"|"}"|"%"|","|"<"|">"|"^"|"|"|"="|"?"|":"|";"|"#"
S_CHAR_SEQUENCE		{S_CHAR}+
STRING_LITERAL		\"{S_CHAR_SEQUENCE}?\"
WS 					[ \t\n]

%%
"->"				{return ARROW;}
"++"				{return INCREMENT;}
"--"				{return DECREMENT;}
"<<"				{return LSHIFT;}
">>"				{return RSHIFT;}
"<="				{return LESS_THAN_EQUAL_TO;}
">="				{return GREATER_THAN_EQUAL_TO;}
"=="				{return DOUBLE_EQUAL;}
"!="				{return NOT_EQUAL;}
"&&"				{return BINARY_AND;}
"||"				{return BINARY_OR;}
"..."				{return ELLIPSIS;}
"*="				{return STAR_EQUAL;}
"/="				{return SLASH_EQUAL;}
"%="				{return PERCENTILE_EQUAL;}
"+="				{return PLUS_EQUAL;}
"-="				{return MINUS_EQUAL;}
"<<="				{return LEFT_SHIFT_EQUAL;}
">>="				{return RIGHT_SHIFT_EQUAL;}
"&="				{return AND_EQUAL;}
"^="				{return XOR_EQUAL;}
"|="				{return OR_EQUAL;}
"auto"				{return AUTO;}
"break"				{return BREAK;}
"case"				{return CASE;}
"char"				{return CHAR;}
"const"				{return CONST;}
"continue"			{return CONTINUE;}
"default"			{return DEFAULT;}
"do"				{return DO;}
"double"			{return DOUBLE;}
"else"				{return ELSE;}
"enum"				{return ENUM;}
"extern"			{return EXTERN;}
"float"				{return FLOAT;}
"for"				{return FOR;}
"goto"				{return GOTO;}
"if"				{return IF;}
"inline"			{return INLINE;}
"int"				{return INT;}
"long"				{return LONG;}
"register"			{return REGISTER;}
"restrict"			{return RESTRICT;}
"return"			{return RETURN;}
"short"				{return SHORT;}
"signed"			{return SIGNED;}
"sizeof"			{return SIZEOF;}
"static"			{return STATIC;}
"struct"			{return STRUCT;}
"switch"			{return SWITCH;}
"typedef"			{return TYPEDEF;}
"union"				{return UNION;}
"unsigned"			{return UNSIGNED;}
"void"				{return VOID;}
"volatile"			{return VOLATILE;}
"while"				{return WHILE;}
"_Bool"				{return BOOL;}
"_Complex"			{return COMPLEX;}
"_Imaginary"		{return IMAGINARY;}
{IDENTIFIER}		{(yylval.id_attr).var = strdup(yytext);return IDENTIFIER;}
{INTEGER_CONST}		{yylval.intval = atoi(yytext); return INTEGER_NO;} 
{FLOATING_CONST}	{yylval.floatval = atof(yytext);return FLOAT_NO;}
{CHARACTER_CONST}	{yylval.charval = yytext[1];return CHARACTER;}
{STRING_LITERAL}	{yylval.strval = strdup(yytext); return STRING;}
{PUNCTUATOR}		{return yytext[0];}
{SINGLELINE_COMMENT}    {}
{MULTILINE_COMMENT}	{}
{WS}				{}
%%
