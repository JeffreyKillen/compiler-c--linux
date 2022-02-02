/*
	File: parser.y
	Modified by: Jeffrey Killen
	Last Update: 8/12/20
	Purpose: This program defines the tokens and grammer to be used by Bison. Additional coding enable semantic error checking.
		
*/

/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <string>
#include <vector>
#include <map>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols; //I always forget this line

%}

%error-verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL BOOL_LITERAL REAL_LITERAL

%token ADDOP MULOP RELOP ANDOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS

%token REMOP EXPOP ARROW CASE ELSE ENDCASE ENDIF IF OTHERS

%token REAL THEN WHEN OROP NOTOP

%type <type> type statement statement_ reductions expression relation term
	factor primary andexp exp notexp body function_header case cases

%%

//I had to rewrite the function production to fit the assignment criteria. This introduced a reduce/reduce error that I can not find.
//If you see it, please point it out to me.

function:	
	function_header optional_variable body {checkAssignment($1, $3, "Illegal Narrowing Function Return");} |
	error ';' ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' {$$ = $5;};

optional_variable:
	variable optional_variable |
	variable |
	;  //------------------------------------- I am thinking these are the reduce/reduce error

parameters:
	parameter ',' parameters |
	parameter |
	;  //------------------------------------- I am thinking these are the reduce/reduce error

parameter:
	IDENTIFIER ':' type ;

variable:
	IDENTIFIER ':' type IS statement_ 
		{if (symbols.find($1, $3)) 
		{
			appendError(DUPLICATE_IDENTIFIER, $1);
		} else
		{
		checkAssignment($3, $5, "Illegal Narrowing Variable Initialization");
		symbols.insert($1, $3);
		}} ;

type:
	INTEGER {$$ = INT_TYPE;}|
	BOOLEAN {$$ = BOOL_TYPE;}|
	REAL {$$ = REAL_TYPE;};

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' {$$ = $1;} |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	expression {$$ = $1;} |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {checkCondition($2); $$ = checkIfStatements($4, $6);}|
	CASE expression IS cases OTHERS ARROW statement_ ENDCASE {checkCaseExp($2);};

cases:
	case cases {checkCasesMatch($1, $2);} |
	{$$ = SENTINAL;};

case:
	WHEN INT_LITERAL ARROW statement_  {$$ = $4;} |
	error ';' {$$ = MISMATCH;};

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	{$$ = INT_TYPE;} ;
		    
expression:
	expression OROP andexp {$$ = checkLogical($1, $3);} |
	andexp ;

andexp:
	andexp ANDOP notexp {$$ = checkLogical($1, $3);} |
	notexp ;

notexp:
	NOTOP notexp {$$ = checkNot($2);} |
	relation ;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);} |
	term ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;
      
factor:
	factor MULOP exp {$$ = checkArithmetic($1, $3);} |
	factor REMOP exp {$$ = checkRem($1, $3);} |
	exp ;

exp:
	primary EXPOP exp {$$ = checkArithmetic($1, $3);} |
	primary;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL | 
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
