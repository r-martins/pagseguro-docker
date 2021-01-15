#!/bin/bash

echo "Deseja rodar testes de compatibilidade? (y/n)"
read testit
if [ $testit == "y" ]; then
    . testit.sh
fi

echo "Insira o nome do zip. Ex: ricardomartins-pagseguro-2.2.0.zip"

read zipname

zip -r $zipname PagSeguro/ -x 'PagSeguro/.git/*' 'PagSeguro/.idea/*' 'PagSeguro/.gitignore' '*.DS_Store'
