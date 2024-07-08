%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "translator.tab.h"

// Declarar externamente o yylval
extern YYSTYPE yylval;
%}

/* Regras de expressão regular para tokens */
%%

[0-9]+              { yylval.str = strdup(yytext); return NUMBER; }
"IFIF"              { return IF; }
"ELSESE"            { return ELSE; }
"WHIWHILE"          { return WHILE; }
"FOFOR"             { return FOR; }
"PRIPRINT"          { return PRINT; }
"FUFUNCTION"        { return FUNCTION; }
"RETUTURN"          { return RETURN; }
"--".*              { /* Ignorar comentários */ }
"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return TIMES; }
"/"                 { return DIVIDE; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
"{"                 { return LBRACE; }
"}"                 { return RBRACE; }
";"                 { return ';'; }
","                 { return ','; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }
"="                 { return ASSIGN; }
">"                 { return '>'; }
"<"                 { return '<'; }
">="                { return GE; }
"<="                { return LE; }
"=="                { return EQ; }
"!="                { return NE; }
\"[^\"]*\"          { yylval.str = strndup(yytext + 1, yyleng - 2); return STRING; }  // Remover as aspas
[ \t\n]+            { /* Ignorar espaços em branco */ }
.                   { printf("Caractere desconhecido: %s\n", yytext); exit(1); }

%%

int yywrap() {
    return 1;
}