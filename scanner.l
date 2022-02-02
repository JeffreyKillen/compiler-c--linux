/*
	File: scanner.l
	Modified by: Jeffrey Killen
	Last update: 8/12/20
	Purpose: The program defines the lexeme/token pairs for Flex. Updated to add semantic type checking to 
		int real_literal and the boolean types
*/

/* Compiler Theory and Design
   Dr. Duane J. Jarc */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>

using namespace std;

#include "types.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n|\/\/.*\n
line		[\n]
id		[A-Za-z]([_]?[A-Za-z0-9])*
digit		[0-9]
int		{digit}+
real_literal {int}\.({int}?[eE]?[+-]?{int}+)*
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine(); }
"+"		{ ECHO; return(ADDOP); }
"-"		{ ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
"/"		{ ECHO; return(MULOP); }
"rem"	{ ECHO; return(REMOP); }
"**"	{ ECHO; return(EXPOP); }
"<"		{ ECHO; return(RELOP); }
"="		{ ECHO; return(RELOP); }
"/="	{ ECHO; return(RELOP); }
">"		{ ECHO; return(RELOP); }
">="	{ ECHO; return(RELOP); }
"<="	{ ECHO; return(RELOP); }
"=>"	{ ECHO; return(ARROW); }
true	{ ECHO; yylval.type = BOOL_TYPE; return(BOOL_LITERAL); }
false	{ ECHO; yylval.type = BOOL_TYPE; return(BOOL_LITERAL); }
case	{ ECHO; return(CASE); }
else	{ ECHO; return(ELSE); }
endcase	{ ECHO; return(ENDCASE); }
endif	{ ECHO; return(ENDIF); }
if		{ ECHO; return(IF); }
others	{ ECHO; return(OTHERS); }
real	{ ECHO; return(REAL); }
then	{ ECHO; return(THEN); }
when	{ ECHO; return(WHEN); }
or		{ ECHO; return(OROP); }
not		{ ECHO; return(NOTOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO;  yylval.type = INT_TYPE; return(INT_LITERAL); }
{real_literal} 	{ ECHO; yylval.type = REAL_TYPE; return(REAL_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%

