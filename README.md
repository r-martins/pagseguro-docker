PagSeguro com Firestore e Docker

# Instalação

`git clone --recurse-submodules git@github.com:r-martins/pagseguro-docker.git [pastadestino]`

`bin/start` para iniciar os containers

`bin/mysql < src/pagseguro_exemplo_m2.sql` pra importar o bd

`bin/copytocontainer --all` se não tiver configurado pra sincronizar todas as pastas. Isto copiara o que tem no host pro container.

`bin/composer install`

`bin/magento setup-ssl pagseguro-exemplo-m2.test` pra configurar ssl


Abra o bin/setup, remova o --no-dev, e o rm -rf src que tem lá.

`bin/setup pagseguro-exemplo-m2.test` pra configurar o magento

`bin/magento setup:upgrade`

`bin/magento setup:di:compile`

Pronto. Acesse https://pagseguro-exemplo-m2.test


## Passos complementares
### Em ambiente de desenvolvimento
```
cd <pasta raiz do projeto>
mkdir -p src/app/code/RicardoMartins/PagSeguro
cd $_
git clone git@github.com:r-martins/PagSeguro-Magento-Transparente-M2.git .
cd -
bin/magento setup:upgrade
```

### Em ambiente de produção
```
cd <pasta raiz do projeto>
composer require ricardomartins/pagseguro
bin/magento setup:upgrade
```

### Automatic cache cleaner
O cache watcher/cleaner está disponível.<br/>
Para executá-lo use `bin/cli vendor/bin/cache-clean.js --watch`.