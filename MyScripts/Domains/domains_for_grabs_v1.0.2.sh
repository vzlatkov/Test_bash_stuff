#! /bin/bash

#Domains for grabs v 1.0.2.
#This is a script that should search the "WhoIs" database and provide information for the domain name's expiration date and last updated date.
#This revision should fix the grep issue and sort the results in a better way than the half-assed "grep" it usesd sup until now.
#Later on, it shsould be patched to be fed with information about the domains from a list ofs sdomain names.
#The final revision would try to automate the processs and feed the script from a site that stores data about domains dues to expire.
#Also, it would be a good idea to make it create a cronjob, that notifies the user couple of hours before the expiration date.



# Get a carriage return into `cr` -- there *has* to be a better way to do this
	cr=`echo $'\n.'`
	cr=${cr%.}

#echo the ">> insert here:"
	st=`echo '>> insert here: '`


echo '==================================================================================================================================='
echo '							
								 DOMAIN NAME
								 								       	'
echo '==================================================================================================================================='

	read -p "input a domain name $cr$cr$st" domain

echo 'CHECKING'
sleep 2
        echo $cr
        echo $cr
        echo $cr
        echo -ne '                                                                                                              (0%)\r'
        sleep 1
        echo -ne '####################################                                                                          (33%)\r'
        sleep 1
        echo -ne '#########################################################################                                     (66%)\r'
        sleep 1
        echo -ne '############################################################################################################# (100%)\r'
echo 'DONE'
echo '=================================================================================================================================='
	$cr
	$cr
	echo "The Expiration Date is:"
       	$cr
	whois $domain | grep -i "Expiration Date:" |awk '{print $5 $6}' #| echo "The Expiration Date is:" |
	$cr
	$cr
	#whois $domain | grep -i 'Pending'
	#whois $domain | grep -i 'redemption'
	#whois $domain | grep -i 'restore'
	#whois $domain | grep -i 'delete'
	#whois $domain | grep -i 'domain status'
	#whois $domain | grep --color -i expir*
	#whois $domain | grep --color -i creat*
	#whois $domain | grep --color -i updated 
	
echo '================================================================================================================================='
echo '	              							END						'
echo '================================================================================================================================='																	
