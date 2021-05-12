#! /bin/bash

echo '==================================================================================================================================='
echo '							
								 DOMAIN NAME
								 								       	'
echo '==================================================================================================================================='

	read domain

	echo 'CHECKING'
echo '*'
echo '***'
echo '********'
echo 'DONE'
echo '=================================================================================================================================='

	whois $domain | grep 'No match for domain'
	whois $domain | grep -i 'Pending'
	whois $domain | grep -i 'redemption'
	whois $domain | grep -i 'restore'
	whois $domain | grep -i 'delete'
	whois $domain | grep -i 'domain status'
	whois $domain | grep --color -i expir*
	whois $domain | grep --color -i creat*
	whois $domain | grep --color -i updated 
	
echo '================================================================================================================================='
echo '								END						'
echo '================================================================================================================================='																	
