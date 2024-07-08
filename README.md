# Gagos language

REQUISITOS:
- Lex
- Yacc
- Ruby

RODAR SCRIPT:
```console
$ chmod +x run_translator.sh
$ ./run_translator.sh example.gago
```

OU RODAR CADA ETAPA:
```console
$ flex translator.l
$ bison -d translator.y
$ gcc lex.yy.c translator.tab.c -o translator -lfl
$ ./translator < example.gago
$ ./translator example.gago > translated_code.rb
$ ruby translated_code.rb
```