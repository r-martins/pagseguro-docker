#!/bin/bash
deployLock="/home/mguni_sqstudejfh/pagseguro-exemplo-m2.ricardomartins.net.br/var/.deploy.lock"
magentoDir="/home/mguni_sqstudejfh/pagseguro-exemplo-m2.ricardomartins.net.br"
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
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db < pagseguro_exemplo_m2.sql
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "UPDATE core_config_data set value='localhost' where path = 'catalog/search/elasticsearch7_server_hostname';"
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO core_config_data (path, value) VALUES ('catalog/search/engine','elasticsearch7');"
rm -rf vendor
php -dmemory_limit=-1 ~/bin/composer.phar install --ignore-platform-reqs
php -dmemory_limit=-1 ~/bin/composer.phar require ricardomartins/pagseguro ricardomartins/pagbank-magento2 --ignore-platform-reqs
#git submodule update --recursive
bin/magento setup:upgrade
bin/magento deploy:mode:set --skip-compilation production
bin/magento module:disable Magento_AdminNotification Klarna_KpGraphQl Klarna_Onsitemessaging Amazon_Core Klarna_Core Vertex_AddressValidation Magento_NewRelicReporting Magento_GoogleAnalytics Magento_GoogleAdwords Magento_Fedex Amazon_Login Amazon_Payment Klarna_Ordermanagement Magento_SwaggerWebapi Magento_SwaggerWebapiAsync Magento_Swagger Vertex_Tax Magento_GoogleOptimizer Klarna_Kp Magento_TwoFactorAuth Yotpo_Yotpo PayPal_Braintree
bin/magento config:set payment/rm_pagseguro/merchant_email testepagseguro2@ricardomartins.net.br
bin/magento config:set payment/rm_pagseguro/token d6e45405-cd1f-4a49-a9cd-ab696747a2459b60bdb1448ea31d4c487f2d9e3f85c1eb10-82f3-4302-bef5-9ca73ac0ea12
bin/magento config:set payment/rm_pagseguro/key PUBD5921FCBD1454F7B9C8E6D1566566FF6
bin/magento config:set payment/ricardomartins_pagbank/connect_key CONSANDBOXCA0E5C9805C352E75F211CA87BF1EB
bin/magento config:set --lock-env web/unsecure/base_url https://pagseguro-exemplo-m2.ricardomartins.net.br/
bin/magento config:set --lock-env web/secure/base_url https://pagseguro-exemplo-m2.ricardomartins.net.br/
bin/magento config:set --lock-env web/cookie/cookie_domain pagseguro-exemplo-m2.ricardomartins.net.br
bin/magento config:set --lock-env customer/address/street_lines 4
bin/magento config:set --lock-env system/smtp/disable 1
bin/magento config:set --lock-env admin/security/password_is_forced 0
#pagbank 4.x
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO magent1_db.core_config_data (path, scope, scope_id, value) VALUES ('payment/ricardomartins_pagbank/public_key', 'default', 0, 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAr+ZqgD892U9/HXsa7XqBZUayPquAfh9xx4iwUbTSUAvTlmiXFQNTp0Bvt/5vK2FhMj39qSv1zi2OuBjvW38q1E374nzx6NNBL5JosV0+SDINTlCG0cmigHuBOyWzYmjgca+mtQu4WczCaApNaSuVqgb8u7Bd9GCOL4YJotvV5+81frlSwQXralhwRzGhj/A57CGPgGKiuPT+AOGmykIGEZsSD9RKkyoKIoc0OS8CPIzdBOtTQCIwrLn2FxI83Clcg55W8gkFSOS6rWNbG5qFZWMll6yl02HtunalHmUlRUL66YeGXdMDC2PuRcmZbGO5a/2tbVppW6mfSWG3NPRpgwIDAQAB');"
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO magent1_db.core_config_data (path, scope, scope_id, value) VALUES ('payment/ricardomartins_pagbank/connect_key', 'default', 0, 'CONSANDBOX8F1E5FEC013685993973759AC5E79F');"
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO magent1_db.core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc/active', '1');"
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO magent1_db.core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_boleto/active', '1');"
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO magent1_db.core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_pix/active', '1');"
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO magent1_db.core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc/sort_order', '10');"
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO magent1_db.core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_boleto/sort_order', '20');"
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO magent1_db.core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_pix/sort_order', '30');"
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO magent1_db.core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc_vault/active', '1');"
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO magent1_db.core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc/title', 'Cartão de Crédito - via PagBank');"
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO magent1_db.core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc/soft_descriptor', 'PagBankIntegracoes');"
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO magent1_db.core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc/installments_options', 'external');"
mysql -u ricardo_user -p9erh74J5mfRvZrkZ -D magent1_db -e  "INSERT INTO magent1_db.core_config_data (path, value) VALUES ('payment/ricardomartins_pagbank_cc/enable_installments_limit', '0');"

bin/magento config:set payment/ricardomartins_pagbank_cc/active 1
bin/magento config:set payment/ricardomartins_pagbank_boleto/active 1
bin/magento config:set payment/ricardomartins_pagbank_pix/active 1
bin/magento config:set payment/ricardomartins_pagbank_cc/sort_order 10
bin/magento config:set payment/ricardomartins_pagbank_boleto/sort_order 20
bin/magento config:set payment/ricardomartins_pagbank_pix/sort_order 30

redis-cli flushall
bin/magento indexer:set-mode schedule
bin/magento setup:upgrade
bin/magento setup:static-content:deploy pt_BR en_US
bin/magento maintenance:disable
bin/magento cache:enable
bin/magento setup:di:compile
sudo service php8.1-fpm restart
rm -f $deployLock
