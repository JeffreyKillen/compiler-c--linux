/*
	File: types.h
	Modified by: Jeffrey Killen
	Last update: 8/12/20
	Purpose: The program contains the type definitions and the function prototypes
        for the type checking functions. Updated to include the additional criteria.
*/

// Compiler Theory and Design
// Duane J. Jarc

// This file contains type definitions and the function
// prototypes for the type checking functions

typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, BOOL_TYPE, REAL_TYPE, SENTINAL}; //sentinal is used by the case statement

void checkAssignment(Types lValue, Types rValue, string message);
Types checkArithmetic(Types left, Types right);
Types checkLogical(Types left, Types right);
Types checkRelational(Types left, Types right);

//test the not operate for semantic errors
Types checkNot(Types right);

//test the REM operands are integers
Types checkRem(Types left, Types right);

//tests for the IF statement
void checkCondition(Types cond);
Types checkIfStatements(Types state1, Types state2);

//tests for the case statement
void checkCaseExp(Types exp);
void checkCasesMatch(Types sCase, Types sCases);