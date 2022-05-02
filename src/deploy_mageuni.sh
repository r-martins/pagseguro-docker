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
rm -rf vendor
php -dmemory_limit=-1 ~/bin/composer.phar install --ignore-platform-reqs
php -dmemory_limit=-1 ~/bin/composer.phar require ricardomartins/pagseguro --ignore-platform-reqs
#git submodule update --recursive
bin/magento setup:upgrade
bin/magento deploy:mode:set --skip-compilation production
bin/magento module:disable Magento_AdminNotification Klarna_KpGraphQl Klarna_Onsitemessaging Amazon_Core Klarna_Core Vertex_AddressValidation Magento_NewRelicReporting Magento_GoogleAnalytics Magento_GoogleAdwords Magento_Fedex Amazon_Login Amazon_Payment Klarna_Ordermanagement Magento_SwaggerWebapi Magento_SwaggerWebapiAsync Magento_Swagger Vertex_Tax Magento_GoogleOptimizer Klarna_Kp Magento_TwoFactorAuth Yotpo_Yotpo PayPal_Braintree
bin/magento config:set payment/rm_pagseguro/merchant_email testepagseguro2@ricardomartins.net.br
bin/magento config:set payment/rm_pagseguro/token d6e45405-cd1f-4a49-a9cd-ab696747a2459b60bdb1448ea31d4c487f2d9e3f85c1eb10-82f3-4302-bef5-9ca73ac0ea12
bin/magento config:set payment/rm_pagseguro/key PUBD5921FCBD1454F7B9C8E6D1566566FF6
bin/magento config:set --lock-env web/unsecure/base_url https://pagseguro-exemplo-m2.ricardomartins.net.br/
bin/magento config:set --lock-env web/secure/base_url https://pagseguro-exemplo-m2.ricardomartins.net.br/
bin/magento config:set --lock-env web/cookie/cookie_domain pagseguro-exemplo-m2.ricardomartins.net.br
bin/magento config:set --lock-env customer/address/street_lines 4
bin/magento config:set --lock-env system/smtp/disable 1
bin/magento config:set --lock-env admin/security/password_is_forced 0
redis-cli flushall
bin/magento indexer:set-mode schedule
bin/magento setup:upgrade
bin/magento setup:static-content:deploy pt_BR en_US
bin/magento maintenance:disable
bin/magento cache:enable
bin/magento setup:di:compile
sudo service php8.1-fpm restart
rm -f $deployLock
