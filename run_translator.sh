#!/bin/bash

# Limpar arquivos antigos
rm -f lex.yy.c translator.tab.c translator.tab.h translator

# Compilar o lexer e o parser
flex -o lex.yy.c translator.l
bison -d -o translator.tab.c translator.y

# Compilar o código gerado pelo Flex e Bison
gcc -o translator lex.yy.c translator.tab.c -lfl

# Verificar se a compilação foi bem-sucedida
if [ ! -f translator ]; then
  echo "Erro na compilação do tradutor."
  exit 1
fi

# Executar o tradutor no código de entrada e salvar a saída em um arquivo temporário
./translator "$1" > translated_code.rb

# Verificar se o tradutor gerou saída
if [ ! -s translated_code.rb ]; then
  echo "Erro ao gerar código traduzido."
  rm -f translated_code.rb
  exit 1
fi

# Executar o código traduzido (Ruby)
ruby translated_code.rb

# Remover o arquivo temporário
rm -f translated_code.rb
