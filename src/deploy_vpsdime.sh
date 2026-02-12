#!/bin/bash
deployLock="/var/www/pagseguro-docker/src/var/.deploy.lock"
magentoDir="/var/www/pagseguro-docker/src"
if [ -f $deployLock ]
then
	echo "Deploy is locked by another process."
	exit 1
fi

touch $deployLock
cd $magentoDir
bin/magento maintenance:enable
git fetch origin
git checkout master
git reset --hard origin/master
mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 < pagseguro_exemplo_m2.sql
mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "UPDATE core_config_data set value='localhost' where path = 'catalog/search/opensearch_server_hostname';"
# Clear cache before config:set so old base URLs from dump are not used
redis-cli flushall
bin/magento cache:flush 2>/dev/null || true
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, value) VALUES ('catalog/search/engine','opensearch');"
../n98-magerun2.phar db:query "REPLACE INTO core_config_data SET scope = 'default', scope_id = 0, path = 'payment/ricardomartins_pagbank/public_key', value = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAr+ZqgD892U9/HXsa7XqBZUayPquAfh9xx4iwUbTSUAvTlmiXFQNTp0Bvt/5vK2FhMj39qSv1zi2OuBjvW38q1E374nzx6NNBL5JosV0+SDINTlCG0cmigHuBOyWzYmjgca+mtQu4WczCaApNaSuVqgb8u7Bd9GCOL4YJotvV5+81frlSwQXralhwRzGhj/A57CGPgGKiuPT+AOGmykIGEZsSD9RKkyoKIoc0OS8CPIzdBOtTQCIwrLn2FxI83Clcg55W8gkFSOS6rWNbG5qFZWMll6yl02HtunalHmUlRUL66YeGXdMDC2PuRcmZbGO5a/2tbVppW6mfSWG3NPRpgwIDAQAB', updated_at = '2025-04-15 01:28:41';"
../n98-magerun2.phar db:query "REPLACE INTO core_config_data SET scope = 'default', scope_id = 0, path = 'payment/ricardomartins_pagbank/connect_key', value = 'CONSANDBOX795E98520284853531616BF851FF2B', updated_at = '2025-11-10 22:26:15';"

rm -rf vendor
/usr/bin/php8.3 -dmemory_limit=-1 /usr/local/bin/composer install --ignore-platform-reqs
/usr/bin/php8.3 -dmemory_limit=-1 /usr/local/bin/composer require ricardomartins/pagbank-magento2 --ignore-platform-reqs --no-cache
#git submodule update --recursive
/usr/bin/php8.3 bin/magento setup:upgrade
bin/magento deploy:mode:set --skip-compilation production
bin/magento module:disable Magento_AdminNotification Klarna_KpGraphQl Klarna_Onsitemessaging Amazon_Core Klarna_Core Vertex_AddressValidation Magento_NewRelicReporting Magento_GoogleAnalytics Magento_GoogleAdwords Magento_Fedex Amazon_Login Amazon_Payment Klarna_Ordermanagement Magento_SwaggerWebapi Magento_SwaggerWebapiAsync Magento_Swagger Vertex_Tax Magento_GoogleOptimizer Klarna_Kp Magento_TwoFactorAuth Yotpo_Yotpo PayPal_Braintree
bin/magento config:set --lock-env web/unsecure/base_url https://pagbank-exemplo-m2.pbintegracoes.com/
bin/magento config:set --lock-env web/secure/base_url https://pagbank-exemplo-m2.pbintegracoes.com/
bin/magento config:set --lock-env web/cookie/cookie_domain pagbank-exemplo-m2.pbintegracoes.com
# Force update base URLs in all scopes (website/store) to avoid old values from dump
mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e "UPDATE core_config_data SET value='https://pagbank-exemplo-m2.pbintegracoes.com/' WHERE path IN ('web/unsecure/base_url', 'web/secure/base_url');"
bin/magento config:set --lock-env customer/address/street_lines 4
bin/magento config:set --lock-env system/smtp/disable 1
bin/magento config:set --lock-env admin/security/password_is_forced 0
#pagbank 4.x
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, scope, scope_id, value) VALUES ('payment/ricardomartins_pagbank/public_key', 'default', 0, 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAr+ZqgD892U9/HXsa7XqBZUayPquAfh9xx4iwUbTSUAvTlmiXFQNTp0Bvt/5vK2FhMj39qSv1zi2OuBjvW38q1E374nzx6NNBL5JosV0+SDINTlCG0cmigHuBOyWzYmjgca+mtQu4WczCaApNaSuVqgb8u7Bd9GCOL4YJotvV5+81frlSwQXralhwRzGhj/A57CGPgGKiuPT+AOGmykIGEZsSD9RKkyoKIoc0OS8CPIzdBOtTQCIwrLn2FxI83Clcg55W8gkFSOS6rWNbG5qFZWMll6yl02HtunalHmUlRUL66YeGXdMDC2PuRcmZbGO5a/2tbVppW6mfSWG3NPRpgwIDAQAB');"
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, scope, scope_id, value) VALUES ('payment/ricardomartins_pagbank/connect_key', 'default', 0, 'CONSANDBOX8F1E5FEC013685993973759AC5E79F');"
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc/active', '1');"
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_boleto/active', '1');"
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_pix/active', '1');"
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc/sort_order', '10');"
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_boleto/sort_order', '20');"
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_pix/sort_order', '30');"
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc_vault/active', '1');"
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc/title', 'Cartão de Crédito - via PagBank');"
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc/soft_descriptor', 'PagBankIntegracoes');"
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc/installments_options', 'external');"
#mysql -u pagbank_m2 -ppagbank_m2_pass -D pagbank_m2 -e  "INSERT INTO core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc/enable_installments_limit', '0');"

bin/magento config:set payment/ricardomartins_pagbank_cc/active 1
bin/magento config:set payment/ricardomartins_pagbank_boleto/active 1
bin/magento config:set payment/ricardomartins_pagbank_pix/active 1
bin/magento config:set payment/ricardomartins_pagbank_cc/sort_order 10
bin/magento config:set payment/ricardomartins_pagbank_boleto/sort_order 20
bin/magento config:set payment/ricardomartins_pagbank_pix/sort_order 30

redis-cli flushall
bin/magento indexer:set-mode schedule
bin/magento setup:upgrade
bin/magento setup:di:compile
# Remove old static files to avoid wrong baseUrl in requirejs-config.js
rm -rf pub/static/frontend pub/static/_cache pub/static/_requirejs
bin/magento setup:static-content:deploy pt_BR en_US --force
bin/magento maintenance:disable
bin/magento cache:enable
sudo service php8.3-fpm restart
rm -f $deployLock
