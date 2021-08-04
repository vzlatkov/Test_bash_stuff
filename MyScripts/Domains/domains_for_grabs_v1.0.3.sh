#! /bin/bash

#Domains for grabs v 1.0.3.
#This is a script that should search the "WhoIs" database and provide information for the domain name's expiration date and last updated date.
#Applied (in version 1.0.2) a fix for the grep issue and sort the results in a better way than the half-assed "grep" it usesd sup until now.
#This revision (1.0.3) - patched to be fed with information about the domains from a list of domain names.
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
	
	#Input a single domain name
	read -p "input a domain name $cr$cr$st" domain
echo '	PATH TO A FILE CONTAINING DOMAINS'
	
	#Input the path to the file of domain names
	echo $cr
	
	read -p "input the ABSOLUTE path to file containing domain names $cr $cr $st" file

#For loop / no $domain condition:

if [ $domain -z ];
	then
for LINE in `cat "$file"`; do
	echo 'CHECKING'
	sleep 1
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
        echo "The Expiration Date for $LINE is:"
        $cr
        whois $LINE | grep -i "Expiration Date:" |awk '{print $5 $6}' #| echo "The Expiration Date is:" |
        $cr
        $cr
	done



elif [ $file -z ];	
	then


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

	fi
