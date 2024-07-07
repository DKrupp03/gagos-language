%{
#include <stdio.h>
#include <stdlib.h>
#include "translator.tab.h"
%}

/* Regras de expressão regular para tokens */
%%

[0-9]+              { yylval.str = strdup(yytext); return NUMBER; }
"if"                { return IF; }
"else"              { return ELSE; }
"while"             { return WHILE; }
"for"               { return FOR; }
"print"             { return PRINT; }
"function"          { return FUNCTION; }
"return"            { return RETURN; }
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
[ \t\n]             { /* Ignorar espaços em branco */ }
.                   { printf("Caractere desconhecido: %s\n", yytext); exit(1); }

%%

int yywrap() {
    return 1;
}