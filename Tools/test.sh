#!/bin/bash

	echo '-------------------------------------------------------------'
	echo '			    DOMAIN CHECK			'
     	echo 'IF YOU WANT A FULL PORT SCAN, EXECUTE THE SCRIPT WITH ROOT PRIVILEGES	'
	
	echo 'Insert a domain/Ip' 

	read domain
	
	whois $domain | grep Registrar
	whois $domain | grep -i expiration
	whois $domain | grep Name Server
	whois $domain | grep Status
	dig a $domain
	ping -c 3 $domain

	echo $domain 'is resolving'

# Check the server which the domain name is pointed to for open ports
	

	echo '============================================================='
	echo '    CHECKING THE SERVER OF THE WEBSITE FOR OPEN PORTS'
	echo '============================================================='
	nmap -A -O -n $domain 
	echo 	''
	echo	''
	echo '			   END OF CHECK				   '
	grep '*/TCP' > ~/open_ports.log
# Get the site, download it to a directory and open the first 50 lines of it

#	wget $domain
#      	head -25 index.html	
#	rm -f index.html*
#	ls -a | grep html

# test domain's apache
#echo '			APACHE BENCHMARK IS STARTING'
#echo 'Select a number of requests'
#	read requests
#echo 'done'
#echo 'Seclect concurrency'
#	read concurrency
#echo 'done'
#echo '			      STARTING THE TEST'
#	ab -c $concurrency -n $requests  https://$domain/ 
	#2>/dev/null
