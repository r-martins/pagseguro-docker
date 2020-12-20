PagSeguro com Firestore e Docker

# Instalação

`git clone --recurse-submodules git@github.com:r-martins/pagseguro-docker.git [pastadestino]`

Configure o docker e importe o banco (documentarei melhor dpeois)

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