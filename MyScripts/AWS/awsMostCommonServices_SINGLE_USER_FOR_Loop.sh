#!/bin/bash

# THOSE ARE COLOR VARIABLES
	GREEN="\e[32m"
	RED="\e[31m"
	ENDCOLOR="\e[0m"

	echo '**************************************************************************************************************************************************************************************************************'


	echo '**************************************************************************************************************************************************************************************************************'


	echo '**************************************************************************************************************************************************************************************************************'
	echo -e "                                                                                               ${GREEN}Input your AWS user name${ENDCOLOR}"
	echo '**************************************************************************************************************************************************************************************************************'



#INPUT FOR THE AWS USER
	
	read username



	echo '**************************************************************************************************************************************************************************************************************'
	echo -e "                                                                                    ${GREEN}Select the desired output format (text/json/table)${ENDCOLOR}"
	echo '**************************************************************************************************************************************************************************************************************'



#INPUT OUTPUT

	read output




	echo '**************************************************************************************************************************************************************************************************************'
	echo -e "                                                       ${GREEN}Specify your desired regions (or leave empty for all regions) and press enter (Region ex.:us-east-1 / ap-south-2 / etc.)${ENDCOLOR}"
	echo '**************************************************************************************************************************************************************************************************************'

	read region


#Break if mandatory arguments are not present

	if [ -z "$username" ];
	then
		echo -e "	    														   ${RED}WRONG/MISSING USERNAME. TRY AGAIN.${ENDCOLOR}"
		sleep 5
        echo -ne '                                  										(0%)\r'
        sleep 1
        echo -ne '####################################                  							(33%)\r'
        sleep 1
        echo -ne '######################################################################### 				        (66%)\r'
        sleep 1
        echo -ne '############################################################################################################# (100%)\r'
        echo -ne '\n'
	sleep 5
		clear
		exit;



	elif [ -z $output ];
	then
		echo -e " 				 										${RED}WRONG/MISSING OUTPUT TYPE. TRY AGAIN.${ENDCOLOR}"
		sleep 5
	echo -ne '                                                                                                              (0%)\r'
        sleep 1
        echo -ne '####################################                                                                          (33%)\r'
        sleep 1
        echo -ne '#########################################################################                                     (66%)\r'
        sleep 1
        echo -ne '############################################################################################################# (100%)\r'
	
		clear
		exit;
	fi
	
#This should read the 'read region' command input or go to the next "if statement" and read its declared variables.

	if [ $region -z ];
	then


#Declearing all of the regions out there 

	declare -a arr=("us-east-1" "us-east-2" "us-west-1" "us-west-2" "us-east-1" "ap-south-1" "ap-southeast-2" "ap-east-1" "ap-southeast-1" "ap-northeast-1" "ap-northeast-2" "ca-central-1" "eu-central-1" "eu-west-1" "eu-west-2" "eu-west-3" "eu-south-1" "eu-north-1" "me-south-1" "sa-east-1")



#For statement that outputs all of the resources that are in use by the top 10 services	for every single region depending on the declared/hard coded regions
	for i in "${arr[@]}"; do
	
		echo -e "${GREEN}EC2${ENDCOLOR}" && aws --region $i resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e ec2 && echo -e "${GREEN}RDS${ENDCOLOR}" && aws --region $i rds describe-db-instances --output $output --profile $username && echo -e "${GREEN}EC2${ENDCOLOR}" && aws --region $i ecs list-task-definitions --output $output --profile $username && echo -e "${GREEN}S3${ENDCOLOR}" && aws --region $i s3 ls --output $output --profile $username && echo - "${GREEN}SQS${ENDCOLOR}" && aws --region $i resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e sqs && echo -e "${GREEN}ELB${ENDCOLOR}" &&  aws --region $i elb describe-load-balancers --output $output --profile $username && echo -e "${GREEN}LAMBDA${ENDCOLOR}" && aws --region $i lambda list-functions --output $output --profile $username && echo -e "${GREEN}VPC${ENDCOLOR}" && aws --region $i resourcegroupstaggingapi get-resources --output $output --profile $username | grep -e vpc 
	done



#If you have declared a region - it uses it

	else
		echo -e "${GREEN}EC2${ENDCOLOR}" && aws --region $region resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e ec2 && echo -e "${GREEN}RDS${ENDCOLOR}" && aws --region $region rds describe-db-instances --output $output --profile $username && echo -e "${GREEN}EC2${ENDCOLOR}" && aws --region $region ecs list-task-definitions --output $output --profile $username && echo -e "${GREEN}S3${ENDCOLOR}" && aws --region $region s3 ls --output $output --profile $username && echo - "${GREEN}SQS${ENDCOLOR}" && aws --region $region resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e sqs && echo -e "${GREEN}ELB${ENDCOLOR}" &&  aws --region $region elb describe-load-balancers --output $output --profile $username && echo -e "${GREEN}LAMBDA${ENDCOLOR}" && aws --region $region lambda list-functions --output $output --profile $username && echo -e "${GREEN}VPC${ENDCOLOR}" && aws --region $region resourcegroupstaggingapi get-resources --output $output --profile $username | grep -e vpc
	fi


#Declares end of the script	
	
	echo '**********************************************************************************************************************************************************************************************************'

	echo -e "                                                                                               ${GREEN}DONE${ENDCOLOR}"
		
	echo '**********************************************************************************************************************************************************************************************************'
	sleep 15
	if [ "$USER" == root ];
		then  
	echo -ne '                                                                                                              (0%)\r'
        sleep 1
        echo -ne '####################################                                                                          (33%)\r'
        sleep 1
        echo -ne '#########################################################################                                     (66%)\r'
        sleep 1
        echo -ne '############################################################################################################# (100%)\r'
	sleep 1
		sudo -u xerxes firefox https://console.aws.amazon.com/console/home?region=us-east-1#;
	#elif firefox https://console.aws.amazon.com/console/home?region=us-east-1#;
	fi
