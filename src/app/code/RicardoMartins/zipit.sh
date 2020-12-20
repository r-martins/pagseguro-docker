#!/bin/bash
echo "Insira o nome do zip. Ex: ricardomartins-pagseguro-2.2.0.zip"

read zipname

zip -r $zipname PagSeguro/ -x 'PagSeguro/.git/*' 'PagSeguro/.idea/*' 'PagSeguro/.gitignore'
