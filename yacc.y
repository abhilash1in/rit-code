%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	extern int yylineno;
	extern FILE *yyin;
	extern FILE *yyout;
	extern char *yytext;
	FILE *functions_h;
	FILE *functions_c;

%}

%token PRINT READ INTO ASSIGN INTEGER DECIMAL BOOLVAL CHARACTER NEWLINE SWAP FUNCTION BRACES OPENING_FLOWER CLOSING_FLOWER
%token WRITE APPEND FILE_STR FILENAME FUNCTION_NAME LOOP BEGIN_STR END
%token LE GE EQ NE GT LT DOT FOR WHILE IF ELSE ADD SUB MULT DIV MODULO

%nonassoc STRING
%nonassoc ID

%%
entry:	entry action	{fprintf(yyout, "\t%s", $2); }
	| action			{fprintf(yyout, "\t%s", $1); }
	;

action : print 			{$$ = $1;}
	| input 			{$$ = $1;}
	| assign 			{$$ = $1;}
	| swap	 			{$$ = $1;}
	| function 			{$$ = $1;}
	| fileops 			{$$ = $1;}
	| loops 			{$$ = $1;}
	| newline			{$$ = $1;}
	;

print : PRINT INTEGER NEWLINE {
			printf("rule: PRINT INTEGER\n");
			char* val = strdup($2);
			strcpy($$, "");
			strcat($$,"cout<<");
			strcat($$,val);
			strcat($$,"<<endl;\n");
		}
	| PRINT DECIMAL NEWLINE {
			printf("rule: PRINT DECIMAL\n");
			char* val = strdup($2);
			strcpy($$, "");
			strcat($$,"cout<<");
			strcat($$,val);
			strcat($$,"<<endl;\n");
		}
	| PRINT BOOLVAL NEWLINE {
			printf("rule: PRINT BOOLVAL\n");
			char* val = strdup($2);
			strcpy($$, "");
			strcat($$,"cout<<");
			strcat($$,val);
			strcat($$,"<<endl;\n");
		}
	| PRINT ID NEWLINE {
			printf("rule: PRINT ID\n");
			char* id = strdup($2);
			strcpy($$, "");
			strcat($$,"cout<<");
			strcat($$,id);
			strcat($$,"<<endl;\n");
		}
	| PRINT STRING NEWLINE	{
			printf("rule: PRINT STRING\n");
			char* str = strdup($2);
			strcpy($$, "");
			strcat($$,"cout<<");
			strcat($$,str);
			strcat($$,"<<endl;\n");
		}
	| PRINT STRING ID NEWLINE 	{
			printf("rule: PRINT STRING ID\n");
			char* str = strdup($2);
			char* id = strdup($3);
			strcpy($$, "");
			strcat($$,"cout<<");
			strcat($$,str);
			strcat($$,"<<");
			strcat($$,id);
			strcat($$,"<<endl;\n");
		}
	;

input:	READ INTO ID NEWLINE 	{
			printf("rule: READ INTO ID NEWLINE\n");
			char* str = strdup($3);
			strcpy($$,"");
			strcat($$,"cin>>");
			strcat($$,str);
			strcat($$,";\n");
		}
	;

assign: ID ASSIGN INTEGER NEWLINE {
			printf("rule: ID ASSIGN INTEGER NEWLINE\n");
			char* id = strdup($1);
			char* val = strdup($3);
			strcpy($$,"");
			strcat($$,"int ");
			strcat($$,id);
			strcat($$," = ");
			strcat($$,val);
			strcat($$,";\n");
		}
	| ID ASSIGN DECIMAL NEWLINE {
			printf("rule: ID ASSIGN DECIMAL NEWLINE\n");
			char* id = strdup($1);
			char* val = strdup($3);
			strcpy($$,"");
			strcat($$,"float ");
			strcat($$,id);
			strcat($$," = ");
			strcat($$,val);
			strcat($$,";\n");
		}
	| ID ASSIGN BOOLVAL NEWLINE {
			printf("rule: ID ASSIGN BOOLVAL NEWLINE\n");
			char* id = strdup($1);
			char* val = strdup($3);
			strcpy($$,"");
			strcat($$,"bool ");
			strcat($$,id);
			strcat($$," = ");
			strcat($$,val);
			strcat($$,";\n");
		}
	| ID ASSIGN STRING NEWLINE {
			printf("rule: ID ASSIGN STRING NEWLINE\n");
			char* id = strdup($1);
			char* val = strdup($3);
			strcpy($$,"");
			strcat($$,"string ");
			strcat($$,id);
			strcat($$," = ");
			strcat($$,val);
			strcat($$,";\n");
		}
	| ID ASSIGN CHARACTER NEWLINE {
			printf("rule: ID ASSIGN CHARACTER NEWLINE\n");
			char* id = strdup($1);
			char* val = strdup($3);
			strcpy($$,"");
			strcat($$,"char* ");
			strcat($$,id);
			strcat($$," = ");
			strcat($$,val);
			strcat($$,";\n");
		}
	| ID ASSIGN operand operator operand NEWLINE {
			printf("rule: ID ASSIGN operand operator operand NEWLINE\n");
			char* id = strdup($1);
			char* val1 = strdup($3);
			char* val2 = strdup($5);
			char* op = strdup($4);
			strcpy($$,"");
			strcat($$,id);
			strcat($$," = ");
			strcat($$,val1);
			strcat($$,op);
			strcat($$,val2);
			strcat($$,";\n");
		}
	;
swap: SWAP ID ID NEWLINE {
			printf("rule: SWAP ID ID NEWLINE\n");
			char* id1 = strdup($2);
			char* id2 = strdup($3);
			strcpy($$,"");
			strcat($$,"int temp = ");
			strcat($$, id1);
			strcat($$,";\n\t");
			strcat($$, id1);
			strcat($$," = ");
			strcat($$, id2);
			strcat($$,";\n\t");
			strcat($$, id2);
			strcat($$," = ");
			strcat($$, "temp");
			strcat($$,";\n");
		}
	;
function: FUNCTION functionname OPENING_FLOWER stmts CLOSING_FLOWER NEWLINE {
			printf("rule: FUNCTION functionname OPENING_FLOWER stmts CLOSING_FLOWER NEWLINE\n");
			char* function_name = strdup($2);
			char* stmts = strdup($4);
			//printf("STATEMENTS : %s ",stmts);
			//printf("$$: %s, $1: %s, $2: %s, $3: %s, $4: %s, $5: %s, $6: %s\n",$$,$1,$2,$3,$4,$5,$6);
			strcpy($$,"");
			char* signature = malloc(sizeof(char) * 100);
			strcat(signature,"void ");
			strcat(signature, function_name);

			char* definition = malloc(sizeof(char) * 1000);
			strcpy(definition,signature);

			strcat(signature, ";\n");
			fprintf(functions_h, signature);
			//free(signature);

			strcat(definition,"\t{\n");
			strcat(definition,stmts);
			strcat(definition,"}\n");
			fprintf(functions_c, definition);
			//free(definition);
		}
	| functionname NEWLINE{
		//printf("$$: %s, $1: %s, $2: %s\n",$$,$1,$2);
		char* func_name = strdup($1);
		strcpy($$,"");
		strcat($$,func_name);
		strcat($$,";\n");
	}
	;
functionname : FUNCTION_NAME {$$ = $1;}
	;
fileops: READ FILE_STR FILENAME NEWLINE {
			printf("rule: READ FILE FILENAME NEWLINE\n");
			char* filename = strdup($3);
			strcpy($$,"");
			strcat($$,"infile.open(");
			strcat($$,filename);
			strcat($$,");\n\t");
			strcat($$,"if(");
			strcat($$,"infile.is_open()){\n\t\t");
			strcat($$,"string buffer;\n\t\t");
			strcat($$,"while(");
			strcat($$,"getline(infile,buffer)){\n\t\t\t");
			strcat($$,"cout<<buffer<<endl;\n\t\t");
			strcat($$,"}\n\t");
			strcat($$,"infile.close();\n\t");
			strcat($$,"}\n\t");
			strcat($$,"else{\n\t\t");
			strcat($$,"cout<<\"File not found!\"<<endl;\n\t");
			strcat($$,"}\n");
			strcat($$,"\n");

		}
	| WRITE FILE_STR FILENAME STRING NEWLINE {
			printf("rule: WRITE FILE FILENAME STRING NEWLINE\n");
			char* filename = strdup($3);
			char* content = strdup($4);
			strcpy($$,"");
			strcat($$,"outfile.open(");
			strcat($$,filename);
			strcat($$,",fstream::out);\n\t");
			strcat($$,"outfile<<");
			strcat($$,content);
			strcat($$,"<<endl;\n\t");
			strcat($$,"outfile.close();\n");
		}
	| APPEND FILE_STR FILENAME STRING NEWLINE {
			printf("rule: APPEND FILE FILENAME STRING NEWLINE\n");
			char* filename = strdup($3);
			char* content = strdup($4);
			strcpy($$,"");
			strcat($$,"outfile.open(");
			strcat($$,filename);	
			strcat($$,",fstream::out | fstream::app);\n\t");
			strcat($$,"outfile<<");
			strcat($$,content);
			strcat($$,"<<endl;\n\t");
			strcat($$,"outfile.close();\n");
		}
	;
loops: LOOP IF operand comparator operand BEGIN_STR stmts END NEWLINE {
			printf("rule: LOOP IF operand comparator operand BEGIN_STR stmts END NEWLINE \n");
			char* comparator = strdup($4);
			char* op1 = strdup($3);
			char* op2 = strdup($5);
			char* stmts = strdup($7);
			//printf("STATEMENTS : %s ",stmts);
			strcpy($$,"");
			strcat($$,"while(");
			strcat($$, op1);
			strcat($$, comparator);
			strcat($$, op2);
			strcat($$, "){\n\t");
			strcat($$, stmts);
			strcat($$, "}\n");
		}
	;

stmts: stmts action { 
			strcat($$,"\t"); 
			strcat($$,$2); 
			strcat($$,"\t");
		}
	 | action		{ 
	 		strcpy($$,"");
			strcat($$,$1);
	 	}
	 ;

comparator: LE 		{ $$ = $1;}
	 | GE 			{ $$ = $1;}
	 | EQ 			{ $$ = $1;}
	 | NE 			{ $$ = $1;}
	 | GT 			{ $$ = $1;}
	 | LT 			{ $$ = $1;}
	 ;

operator: ADD 		{ $$ = $1;}
	 | SUB 			{ $$ = $1;}
	 | MULT 		{ $$ = $1;}
	 | DIV 			{ $$ = $1;}
	 | MODULO 		{ $$ = $1;}
	 ;

operand: ID 		{ $$ = $1;}
	 | INTEGER 		{ $$ = $1;}
	 | DECIMAL 		{ $$ = $1;}
	 ;

newline: NEWLINE 	{
			printf("rule: NEWLINE\n");
			strcpy($$,"");
			strcat($$,"cout<<endl;\n\n");
		}
	;
%%

void initOutput(FILE* o){
	fprintf(o,"#include <iostream>\n");
	fprintf(o,"#include <string>\n");
	fprintf(o,"#include <fstream>\n");
	fprintf(o,"#include \"functions.h\"\n");
	fprintf(o,"using namespace std;\n");
	fprintf(o,"ofstream outfile;\n");
	fprintf(o,"ifstream infile;\n");
	fprintf(o,"int main(int argc, char *argv[]){ \n");
}

void endOutput(FILE* o){
	fprintf(o,"}");
}

void initFunctions(FILE* header, FILE* cpp){
	fprintf(header,"#ifndef FUNCTIONS_H\n");
	fprintf(header,"#define FUNCTIONS_H\n\n");
	fprintf(header,"#include <iostream>\n");
	fprintf(header,"using namespace std;\n\n");

	fprintf(cpp,"#include \"functions.h\"\n");
}

void endFunctions(FILE* header){
	fprintf(header,"#endif");
}

int main(int argc, char *argv[])
{
	if(argc < 2){
		printf("Usage: ./a.out <input file name>\n");
		exit(1);
	}
	yyin = fopen(argv[1], "r");
	functions_h = fopen("functions.h", "w");
	functions_c = fopen("functions.cpp", "w");
	if(yyin == NULL || functions_h == NULL || functions_c == NULL){
		printf("could not open input/function file!");
		exit(0);
	}
	yyout = fopen("out.cpp","w");
	initOutput(yyout);
	initFunctions(functions_h,functions_c);

	if(!yyparse())
		printf("\nParsing complete\n");
	else{
		printf("\nParsing failed\n");
		exit(1);
	}

	endFunctions(functions_h);
	endOutput(yyout);
	//fclose(yyin);
    fclose(yyout);
    return 0;
}
         
yyerror(char *s) {
	printf("\n \nLine: %d, Message: %s, Cause: %s\n", yylineno, s, yytext );
}

yywrap()
{
	return 1;
}