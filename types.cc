/*
	File: types.cc
	Modified by: Jeffrey Killen
	Last update: 8/12/20
	Purpose: This program contains the various type checking functions for the semantic
		error checking of the cmsc430 language.
*/

// Compiler Theory and Design
// Duane J. Jarc

// This file contains the bodies of the type checking functions

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{
	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
		appendError(GENERAL_SEMANTIC, "Type Mismatch On Variable Initialization" );

	//There is probably a clever way to do these two checks better
	if (lValue == INT_TYPE && rValue == REAL_TYPE)
		appendError(GENERAL_SEMANTIC, message);

	if(lValue == REAL_TYPE && rValue == INT_TYPE)
		appendError(GENERAL_SEMANTIC, message);
}

Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Numeric Type Required");
		return MISMATCH;
	}

	//if one is real, the return is real
	if (left == REAL_TYPE || right == REAL_TYPE)
	{
		return REAL_TYPE;
	}
	return INT_TYPE;
}


Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}	
		return BOOL_TYPE;
	return MISMATCH;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
	return BOOL_TYPE;
}

//make sure the not statement is applied to a boolean
Types checkNot(Types right)
{
	if( right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}

	return BOOL_TYPE;
}

//make sure the remainder operator has integers
Types checkRem(Types left, Types right)
{
	if (left != INT_TYPE || right != INT_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer Operands");
		return MISMATCH;
	}

	return INT_TYPE;
}

//check the if expression to make sure it is boolean
void checkCondition(Types cond)
{
	if (cond != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "If Condition Must Be Boolean");
	}
}

//check that the if statements have the same return type
Types checkIfStatements(Types state1, Types state2)
{
	if (state1 == MISMATCH || state2 == MISMATCH || state1 != state2)
	{
		appendError(GENERAL_SEMANTIC, "If - Then Type Mismatch");
		return MISMATCH;
	}

	if (state1 == BOOL_TYPE || state2 == BOOL_TYPE)
	{
		return BOOL_TYPE;
	}

	if (state1 == REAL_TYPE || state2 == REAL_TYPE)
	{
		return REAL_TYPE;
	}

	return INT_TYPE;

}

//check the case expression is an integer
void checkCaseExp(Types exp)
{
	if (exp != INT_TYPE)
		appendError(GENERAL_SEMANTIC, "Case Expression Not Integer");
}

//check that the cases either match, or there is a sentinal 
//doing it this way prints the error after the case statement block
//but it works
void checkCasesMatch(Types sCase, Types sCases)
{
	if (sCases == SENTINAL)
		return;
	if (sCase != sCases)
		appendError(GENERAL_SEMANTIC, "Case Types Mismatch");
		
}
