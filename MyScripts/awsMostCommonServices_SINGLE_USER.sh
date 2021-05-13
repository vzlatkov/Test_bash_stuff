#!/bin/bash

# THOSE ARE COLOR VARIABLES
GREEN="\e[32m"
ENDCOLOR="\e[0m"


echo '**************************************************************************************************************************************************************************************************************'
echo -e "												${GREEN}Input AWS user name${ENDCOLOR}"
echo '**************************************************************************************************************************************************************************************************************'


#INPUT FOR THE AWS USER
read username


#######################################################
#   ACTUAL COMMANDS START FORM HERE UNTILL THE END    #
#######################################################

echo -e "${GREEN}EC2${ENDCOLOR}"

	aws resourcegroupstaggingapi get-resources --profile $username |grep -e ec2

#######################################################
echo -e "${GREEN}RDS${ENDCOLOR}"
 
	aws rds describe-db-instances --profile $username

######################################################
echo -e "${GREEN}ECS${ENDCOLOR}"

	aws ecs list-task-definitions --profile $username
	aws ecs list-services --profile $username
	aws ecs list-container-instances --profile $username

######################################################
echo -e "${GREEN}S3${ENDCOLOR}"

	aws s3 ls --profile $username

#####################################################

echo -e "${GREEN}SQS${ENDCOLOR}"

	aws resourcegroupstaggingapi get-resources --profile $username | grep -e sqs

#####################################################
echo -e "${GREEN}LAMBDA${ENDCOLOR}"

	aws lambda list-functions --profile $username

####################################################
echo -e "${GREEN}ELB${ENDCOLOR}"

	aws elb describe-load-balancers --profile $username

###################################################
echo -e "${GREEN}VPC${ENDCOLOR}"

	aws resourcegroupstaggingapi get-resources --profile $username | grep -e vpc

###################################################

echo '**********************************************************************************************************************************************************************************************************'

echo -e "												${GREEN}DONE${ENDCOLOR}"

echo '**********************************************************************************************************************************************************************************************************'


#'ec2 | rds | ecs | s3 | sqs | elb | 53 | lambda | vpc'

