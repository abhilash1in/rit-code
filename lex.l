%{
	#include <stdio.h>
	#include "y.tab.h"  
%}

alpha	[a-zA-Z]
digit	[0-9]

%%
[ \t]							;
[ \n]							{ yylineno = yylineno + 1; return NEWLINE;}
"true"|"false"					{yylval = strdup(yytext); return BOOLVAL;}
write							return WRITE;
append							return APPEND;
file							return FILE_STR;
"()"							return BRACES;
"{"								return OPENING_FLOWER;
"}"								return CLOSING_FLOWER;
function						return FUNCTION;
read							return READ;
into							return INTO;
swap							return SWAP;
loop							{yylval = strdup(yytext); return LOOP;}
begin							{yylval = strdup(yytext); return BEGIN_STR;}
end 							{yylval = strdup(yytext); return END;}
for								{yylval = strdup(yytext); return FOR;}
while							{yylval = strdup(yytext); return WHILE;}
if								{yylval = strdup(yytext); return IF;}
else							{yylval = strdup(yytext); return ELSE;}
print							{yylval = strdup(yytext); return PRINT;}
\"{alpha}({alpha}|{digit}|"-"|"_")*\.[a-zA-Z]{3}\"						{yylval = strdup(yytext); return FILENAME;}
{alpha}({alpha}|{digit}|"-"|"_")*\(\)									{yylval = strdup(yytext); return FUNCTION_NAME;}
{digit}+						{yylval = strdup(yytext); return INTEGER;}
{digit}*(\.{digit}+)?			{yylval = strdup(yytext); return DECIMAL;}
{alpha}({alpha}|{digit})*		{yylval = strdup(yytext); return ID;}
\".[^\"]*\"						{yylval = strdup(yytext); return STRING;}
\'.*\'							{yylval = strdup(yytext); return CHARACTER;}
"="								{yylval = strdup(yytext); return ASSIGN;}
"<="							{yylval = strdup(yytext); return LE;}
">="							{yylval = strdup(yytext); return GE;}
"=="							{yylval = strdup(yytext); return EQ;}
"!="							{yylval = strdup(yytext); return NE;}
">"								{yylval = strdup(yytext); return GT;}
"<"								{yylval = strdup(yytext); return LT;}
"+"								{yylval = strdup(yytext); return ADD;}
"-"								{yylval = strdup(yytext); return SUB;}
"*"								{yylval = strdup(yytext); return MULT;}
"/"								{yylval = strdup(yytext); return DIV;}
"%"								{yylval = strdup(yytext); return MODULO;}
"."								{yylval = strdup(yytext); return DOT;}
\/\/.*							;
\/\*(.*\n)*.*\*\/				;
%%