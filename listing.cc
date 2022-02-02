/*
	File: listing.cc
	Modified by: Jeffrey Killen
	Last Update: 8/12/20
	Purpose: This program defines the error reporting for detected lexical and syntactic errors
		in the cmsc430 language. Updated to include new semantic error counts
*/

// Compiler Theory and Design
// Dr. Duane J. Jarc

// This file contains the bodies of the functions that produces the compilation
// listing

#include <cstdio>
#include <string>
#include <queue>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int lexicalErrors = 0;
static int syntaxErrors = 0;
static int semanticErrors = 0;
static queue<std::string> errors;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");
	if (totalErrors > 0) {
		printf("Lexical Errors %4d\n", lexicalErrors);
		printf("Syntax Errors %4d\n", syntaxErrors);
		printf("Semantic Errors %4d\n", semanticErrors);
	} else {
		printf("Compiled Successfully\n\n");
	}
	return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };

	if (errorCategory == LEXICAL)
		lexicalErrors++;

	if (errorCategory == SYNTAX)
		syntaxErrors++;

	if (errorCategory == GENERAL_SEMANTIC)
		semanticErrors++;

	if (errorCategory == UNDECLARED) //-----------------new 8/12/20
		semanticErrors++;

	if (errorCategory == DUPLICATE_IDENTIFIER) //-------new 8/12/20
		semanticErrors++;

	error = messages[errorCategory] + message;
	errors.push(error);
	totalErrors++;
}

void displayErrors()
{
	if (error != "")
		printf("%s\n", error.c_str());
	error = "";
}
