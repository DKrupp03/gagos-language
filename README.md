# Gagos language

REQUISITOS:
- Lex
- Yacc
- Ruby

RODAR SCRIPT:
```console
$ ./run_translator.sh input.gago
```

OU RODAR CADA ETAPA:
```console
$ flex translator.l
$ bison -d translator.y
$ gcc lex.yy.c translator.tab.c -o translator -lfl
$ ./translator < input.gago
```