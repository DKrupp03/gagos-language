%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();
extern FILE *yyin;
char *concat(const char *s1, const char *s2);

%}

%union {
    char *str;
}

/* Declaração de tokens */
%token <str> ID STRING LPAREN RPAREN NUMBER PLUS MINUS TIMES DIVIDE ASSIGN IF ELSE WHILE FOR PRINT '>' '<' GE LE EQ NE LBRACE RBRACE FUNCTION RETURN
%left PLUS MINUS
%left TIMES DIVIDE
%right ASSIGN
%nonassoc IFX
%nonassoc ELSE

%type <str> factor statement statements expression assignment simple_expression term program function_declaration function_call parameter_list argument_list

%%

program:
    statements
    {
        printf("%s", $1);
    }
    ;

statements:
    statement { $$ = $1; }
    | statements statement { $$ = concat($1, $2); }
    ;

statement:
    expression ';'
    {
        $$ = concat($1, "\n");
    }
    | PRINT expression ';'
    {
        $$ = concat(concat("puts ", $2), "\n");
    }
    | PRINT STRING ';'
    {
        $$ = concat(concat("puts \"", $2), "\"\n");
    }
    | IF LPAREN expression RPAREN statement %prec IFX
    {
        $$ = concat(concat(concat("if ", $3), "\n"), $5);
    }
    | IF LPAREN expression RPAREN statement ELSE statement
    {
        $$ = concat(concat(concat(concat("if ", $3), $5), "else"), $7);
    }
    | WHILE LPAREN expression RPAREN statement
    {
        $$ = concat(concat(concat("while ", $3), " do"), $5);
    }
    | FOR LPAREN expression ';' expression ';' expression RPAREN statement
    {
        char *temp1 = concat(concat(concat(concat("for (", $3), "; "), $5), "; ");
        char *temp2 = concat(temp1, $7);
        $$ = concat(temp2, ")\n");
        $$ = concat($$, $9);
        free(temp1);
        free(temp2);
    }
    | LBRACE statements RBRACE
    {
        $$ = concat(concat("\n", $2), "end\n");
    }
    | function_declaration
    {
        $$ = $1;
    }
    ;

function_declaration:
    FUNCTION ID LPAREN parameter_list RPAREN LBRACE statements RBRACE
    {
        $$ = concat(concat(concat(concat(concat(concat("def ", $2), " "), $4), "\n"), $7), "end\n");
    }
    ;

parameter_list:
    ID
    {
        $$ = $1;
    }
    | parameter_list ',' ID
    {
        $$ = concat(concat($1, ", "), $3);
    }
    | /* vazio */
    {
        $$ = "";
    }
    ;

function_call:
    ID LPAREN argument_list RPAREN
    {
        $$ = concat(concat($1, " "), $3);
    }
    ;

argument_list:
    expression
    {
        $$ = $1;
    }
    | argument_list ',' expression
    {
        $$ = concat(concat($1, ", "), $3);
    }
    | /* vazio */
    {
        $$ = "";
    }
    ;

expression:
    assignment { $$ = $1; }
    | function_call { $$ = $1; }
    ;

assignment:
    ID ASSIGN expression
    {
        $$ = concat(concat($1, " = "), $3);
    }
    | simple_expression { $$ = $1; }
    ;

simple_expression:
    term { $$ = $1; }
    | simple_expression PLUS term
    {
        $$ = concat(concat($1, " + "), $3);
    }
    | simple_expression MINUS term
    {
        $$ = concat(concat($1, " - "), $3);
    }
    | simple_expression '>' term
    {
        $$ = concat(concat($1, " > "), $3);
    }
    | simple_expression '<' term
    {
        $$ = concat(concat($1, " < "), $3);
    }
    | simple_expression GE term
    {
        $$ = concat(concat($1, " >= "), $3);
    }
    | simple_expression LE term
    {
        $$ = concat(concat($1, " <= "), $3);
    }
    | simple_expression EQ term
    {
        $$ = concat(concat($1, " == "), $3);
    }
    | simple_expression NE term
    {
        $$ = concat(concat($1, " != "), $3);
    }
    ;

term:
    factor { $$ = $1; }
    | term TIMES factor
    {
        $$ = concat(concat($1, " * "), $3);
    }
    | term DIVIDE factor
    {
        $$ = concat(concat($1, " / "), $3);
    }
    ;

factor:
    NUMBER { $$ = $1; }
    | ID { $$ = $1; }
    | LPAREN expression RPAREN
    {
        $$ = concat(concat("(", $2), ")");
    }
    ;

%%

char *concat(const char *s1, const char *s2) {
    char *result = (char *)malloc(strlen(s1) + strlen(s2) + 1);
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}

int main(int argc, char **argv) {
    ++argv, --argc;  // Ignorar o nome do programa
    if (argc > 0)
        yyin = fopen(argv[0], "r");
    else
        yyin = stdin;

    yyparse();
    return 0;
}