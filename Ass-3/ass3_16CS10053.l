%{
#include <stdio.h>
#include <string.h>

#define SINGLE_LINE_COMM 	1
#define MULTI_LINE_COMM 	2

// keywords
#define AUTO 				3
#define ENUM 				4
#define RESTRICT 			5
#define UNSIGNED 			6
#define BREAK 				7
#define EXTERN 				8
#define RETURN 				9
#define VOID 				10
#define CASE 				11
#define FLOAT 				12
#define SHORT 				13
#define VOLATILE 			14
#define CHAR 				15
#define FOR 				16
#define SIGNED 				17
#define WHILE 				18
#define CONST 				19
#define GOTO 				20
#define SIZEOF 				21
#define _BOOL 				22	
#define CONTINUE 			23
#define IF 					24
#define STATIC 				25
#define _COMPLEX 			26
#define DEFAULT 			27
#define INLILE 				28
#define STRUCT 				29
#define _IMAGINARY 			30
#define DO 					31
#define INT 				32
#define SWITCH 				33
#define DOUBLE 				34
#define LONG 				35
#define TYPEDEF 			36
#define ELSE 				37
#define REGISTER 			38
#define UNION 				39

#define IDENTIFIER 			40
#define INTEGER_CONSTANT 	41
#define FLOATING_CONSTANT 	42
#define CHARACTER_CONSTANT 	43
#define STRING_LITERAL 		44

// Puctuators
#define SQRBROPEN 			45
#define SQRBRCLOSE 			46
#define RORBROPEN 			47
#define RORBRCLOSE 			48
#define CURBROPEN 			49
#define CURBRCLOSE 			50
#define DOT 				51
#define ARWCOM 				52
#define INCRM 				53
#define DECRM 				54
#define AMPSND 				55
#define MUL 				56
#define ADD 				57
#define SUB 				58
#define NEG 				59
#define EXCLAIM 			60
#define DIV 				61
#define MODULO 				62
#define SHL 				63
#define SHR 				64
#define LST 	 			65
#define GRT 				66
#define LTE 				67
#define GTE 				68
#define EQL 				69
#define NEQ 				70
#define AND 				71
#define OR 					72
#define QUESTION 			73
#define COLON 				74
#define SEMICOLON 			75
#define DOTS 				76
#define ASSIGN 				77
#define STAREQ 				78
#define DIVEQ 				79
#define MODEQ 				80
#define PLUSEQ 				81
#define MINUSEQ 			82
#define SHLEQ 				83
#define SHREQ 				84
#define BINANDEQ 			85
#define BINXOREQ 			86
#define BINOREQ 			87
#define COMMA 				88
#define HASH 				89
%}

/* Regular Expression Definitions */
/*COMMENTS*/
SINGLE_LINE_COMM			[/][/][^\n]*
SEQUENCE 					[^*]|[*][^/]
MULTI_LINE_COMM 			[/][*]{SEQUENCE}*[*][/]


/*KEYWORDS*/
KEYWORD						"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"
	

/*IDENTIFIERS*/
DIGIT						[0-9]
IDENTIFIER_NONDIGIT 		"_"|[a-zA-Z]
IDENTIFIER 					{IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*
 

/*CONSTANTS*/
NONZERO_DIGIT				[1-9]
NONZERO_INTEGER_CONSTANT	{NONZERO_DIGIT}({NONZERO_DIGIT}|{DIGIT})*
INTEGER_CONSTANT			"0"|{NONZERO_INTEGER_CONSTANT}
CONSTANT_DIGIT				{INTEGER_CONSTANT}|{FLOATING_CONSTANT}
CONSTANT 					{CONSTANT_DIGIT}|{ENUMERATION_CONSTANT}|{CHARACTER_CONSTANT}

DIGIT_SEQUENCE				{DIGIT}+
SIGN 						"-"|"+"
EXPONENT_PART				("e"{SIGN}?{DIGIT_SEQUENCE})|("E"{SIGN}?{DIGIT_SEQUENCE})
FRACTIONAL_CONSTANT			({DIGIT_SEQUENCE}?"."{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}".")
FLOATING_CONSTANT			({DIGIT_SEQUENCE}{EXPONENT_PART})|({FRACTIONAL_CONSTANT}{EXPONENT_PART}?)

ENUMERATION_CONSTANT		{IDENTIFIER}

ESCAPE_SEQUENCE				"\'"|"\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
C_CHAR 						{ESCAPE_SEQUENCE}|[^("\'"|"\\"|"\n")]
C_CHAR_SEQUENCE				{C_CHAR}+
CHARACTER_CONSTANT			"\'"{C_CHAR_SEQUENCE}"\'"


/*STRING_LITERALS*/
S_CHAR  					{ESCAPE_SEQUENCE}|[^("\""|"\\"|"\n")]
S_CHAR_SEQUENCE				{S_CHAR}+
STRING_LITERAL 				"\""{S_CHAR_SEQUENCE}?"\""


/*PUNCTUATORS*/
PUNCTUATOR					"["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|","|"#"|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="


%%
{MULTI_LINE_COMM} 			{return MULTI_LINE_COMM;}
{SINGLE_LINE_COMM}			{return SINGLE_LINE_COMM;}


"auto" 						{ return AUTO; } 
"enum"						{ return ENUM; }
"restrict"					{ return RESTRICT; } 
"unsigned"					{ return UNSIGNED; }
"break"						{ return BREAK; }
"extern"					{ return EXTERN; }
"return"					{ return RETURN; }
"void"						{ return VOID; }
"case"						{ return CASE; }
"float"						{ return FLOAT; }
"short"						{ return SHORT; }
"volatile"					{ return VOLATILE; }
"char"						{ return CHAR; }
"for"						{ return FOR; }
"signed"					{ return SIGNED; }
"while"						{ return WHILE; }
"const"						{ return CONST; }
"goto"						{ return GOTO; }
"sizeof"					{ return SIZEOF; }
"_Bool"						{ return _BOOL; }
"continue"					{ return CONTINUE; }
"if"						{ return IF; }
"static"					{ return STATIC; }
"_Complex"					{ return _COMPLEX; }
"default"					{ return DEFAULT; }
"inline"					{ return INLILE; }
"struct"					{ return STRUCT; }
"_Imaginary"				{ return _IMAGINARY; }
"do"						{ return DO; }
"int"						{ return INT; }
"switch"					{ return SWITCH; }
"double"					{ return DOUBLE; }
"long"						{ return LONG; }
"typedef"					{ return TYPEDEF; }
"else"						{ return ELSE; }
"register"					{ return REGISTER; }
"union"						{ return UNION; }



{FLOATING_CONSTANT}	{
	return FLOATING_CONSTANT;
}

{INTEGER_CONSTANT}	{
	return INTEGER_CONSTANT;
}


{CHARACTER_CONSTANT} {
	return CHARACTER_CONSTANT;
}

{STRING_LITERAL} {
	return STRING_LITERAL;
}

{IDENTIFIER}	{
	return IDENTIFIER;
}
	"[" 					{ return SQRBROPEN;}
	"]" 					{ return SQRBRCLOSE;}
	"(" 					{ return RORBROPEN;}
	")" 					{ return RORBRCLOSE;}
	"{" 					{ return CURBROPEN;}
	"}" 					{ return CURBRCLOSE;}
	"." 					{ return DOT;}
	"->" 					{ return ARWCOM;}

	"++" 					{ return INCRM;}
	"--" 					{ return DECRM;}
	"&" 					{ return AMPSND;}
	"*" 					{ return MUL;}
	"+" 					{ return ADD;}
	"-" 					{ return SUB;}
	"~" 					{ return NEG;}
	"!" 					{ return EXCLAIM;}

	"/" 					{ return DIV;}
	"%" 					{ return MODULO;}
	"<<" 					{ return SHL;}
	">>" 					{ return SHR;}
	"<" 					{ return LST;}
	">" 					{ return GRT;}
	"<=" 					{ return LTE;}
	">=" 					{ return GTE;}
	"==" 					{ return EQL;}
	"!=" 					{ return NEQ;}
	"&&" 					{ return AND;}
	"||" 					{ return OR;}

	"?" 					{ return QUESTION;}
	":" 					{ return COLON;}
	";" 					{ return SEMICOLON;}
	"..." 					{ return DOTS;}
	"=" 					{ return ASSIGN;}
	"*=" 					{ return STAREQ;}
	"/=" 					{ return DIVEQ;}
	"%=" 					{ return MODEQ;}
	"+=" 					{ return PLUSEQ;}
	"-=" 					{ return MINUSEQ;}
	"<<="					 { return SHLEQ;}
	">>=" 					{ return SHREQ;}
	"&=" 					{ return BINANDEQ;}
	"^=" 					{ return BINXOREQ;}
	"|=" 					{ return BINOREQ;}
	"," 					{ return COMMA;}
	"#" 					{ return HASH;}
"\n"|" "|"\t"	{

}
%%
