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
/usr/local/bin/composer require ricardomartins/pagseguro --ignore-platform-reqs --no-cache
#git submodule update --recursive
bin/magento setup:upgrade
bin/magento deploy:mode:set --skip-compilation production
bin/magento module:disable Magento_AdminNotification Amazon_Core Klarna_Core Magento_NewRelicReporting Magento_GoogleAnalytics Magento_GoogleAdwords Magento_Fedex Amazon_Login Amazon_Payment Klarna_Ordermanagement Magento_SwaggerWebapi Magento_SwaggerWebapiAsync Magento_Swagger Vertex_Tax Magento_GoogleOptimizer Klarna_Kp Magento_TwoFactorAuth
bin/magento config:set --lock-env web/unsecure/base_url https://pagseguro-exemplo-m2.ricardomartins.net.br/
bin/magento config:set --lock-env web/secure/base_url https://pagseguro-exemplo-m2.ricardomartins.net.br/
bin/magento config:set --lock-env web/cookie/cookie_domain pagseguro-exemplo-m2.ricardomartins.net.br
bin/magento config:set --lock-env customer/address/street_lines 4
bin/magento config:set --lock-env system/smtp/disable 1
bin/magento config:set --lock-env admin/security/password_is_forced 0
redis-cli flushall
bin/magento setup:di:compile
bin/magento indexer:set-mode schedule
bin/magento setup:static-content:deploy pt_BR en_US
bin/magento maintenance:disable
bin/magento cache:enable
rm -f $deployLock
