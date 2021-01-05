#!/bin/bash
echo "Iniciando testes de compatibilidade PHP 7.1"
phpcs -p /Users/martins/Docker/pagseguro-docker/src/app/code/RicardoMartins/PagSeguro --standard=PHPCompatibility --runtime-set testVersion 7.1
echo "Iniciando testes de compatibilidade PHP 7.2"
phpcs -p /Users/martins/Docker/pagseguro-docker/src/app/code/RicardoMartins/PagSeguro --standard=PHPCompatibility --runtime-set testVersion 7.2
echo "Iniciando testes de compatibilidade PHP 7.3"
phpcs -p /Users/martins/Docker/pagseguro-docker/src/app/code/RicardoMartins/PagSeguro --standard=PHPCompatibility --runtime-set testVersion 7.3
echo "Iniciando testes de compatibilidade PHP 7.4"
phpcs -p /Users/martins/Docker/pagseguro-docker/src/app/code/RicardoMartins/PagSeguro --standard=PHPCompatibility --runtime-set testVersion 7.4
