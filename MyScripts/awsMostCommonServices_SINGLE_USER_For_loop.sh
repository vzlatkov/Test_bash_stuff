#!/bin/bash

# THOSE ARE COLOR VARIABLES
GREEN="\e[32m"
ENDCOLOR="\e[0m"

echo '**************************************************************************************************************************************************************************************************************'

fortune

echo '**************************************************************************************************************************************************************************************************************'


echo '**************************************************************************************************************************************************************************************************************'
echo -e "                                                                                               ${GREEN}Input AWS user name${ENDCOLOR}"
echo '**************************************************************************************************************************************************************************************************************'


#INPUT FOR THE AWS USER
read username


echo '**************************************************************************************************************************************************************************************************************'
echo -e "                                                                                          ${GREEN}Select desired output format (text/json/table)${ENDCOLOR}"
echo '**************************************************************************************************************************************************************************************************************'

#INPUT OUTPUT

read output


#echo '**************************************************************************************************************************************************************************************************************'
#echo -e "                                                                                          ${GREEN}Specify your desired regions and press enter (Region ex.:us-east-1 / ap-south-2 / etc.)${ENDCOLOR}"
#echo '**************************************************************************************************************************************************************************************************************'

#INPUT region

declare -a arr=("us-east-1" "us-east-2" "us-west-1" "us-west-2" "us-east-1" "ap-south-1" "ap-southeast-2" "ap-east-1" "ap-southeast-1" "ap-northeast-1" "ap-northeast-2" "ca-central-1" "eu-central-1" "eu-west-1" "eu-west-2" "eu-west-3" "eu-south-1" "eu-north-1" "me-south-1" "sa-east-1")

for i in "${arr[@]}"; do
	echo -e "${GREEN}EC2${ENDCOLOR}" && aws --region $i resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e ec2 && echo -e "${GREEN}RDS${ENDCOLOR}" && aws --region $i rds describe-db-instances --output $output --profile $username && echo -e "${GREEN}EC2${ENDCOLOR}" && aws --region $i ecs list-task-definitions --output $output --profile $username && echo -e "${GREEN}S3${ENDCOLOR}" && aws --region $i s3 ls --output $output --profile $username && echo - "${GREEN}SQS${ENDCOLOR}" && aws --region $i resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e sqs && echo -e "${GREEN}ELB${ENDCOLOR}" &&  aws --region $i elb describe-load-balancers --output $output --profile $username && echo -e "${GREEN}LAMBDA${ENDCOLOR}" && aws --region $i lambda list-functions --output $output --profile $username && echo -e "${GREEN}VPC${ENDCOLOR}" && aws --region $i resourcegroupstaggingapi get-resources --output $output --profile $username | grep -e vpc
	done
	

#echo "[profile $profile]\nregion = ${region[0]}\noutput = $output" 

#######################################################
#   ACTUAL COMMANDS START FORM HERE UNTILL THE END    #
#######################################################

#echo -e "${GREEN}EC2${ENDCOLOR}"

        #aws --region ${r[1]} resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e ec2
     #   aws --region ${r[2]} resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e ec2
      #  aws --region ${r[3]} resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e ec2
       # aws --region ${r[4]} resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e ec2
#######################################################
#echo -e "${GREEN}RDS${ENDCOLOR}"
#
 #       aws --region ${r[1]} rds describe-db-instances --output $output --profile $username
  #      aws --region ${r[2]} rds describe-db-instances --output $output --profile $username
   #     aws --region ${r[3]} rds describe-db-instances --output $output --profile $username
    #    aws --region ${r[4]} rds describe-db-instances --output $output --profile $username
######################################################
#echo -e "${GREEN}ECS${ENDCOLOR}"

#        aws --region ${r[1]} ecs list-task-definitions --output $output --profile $username
 #       aws --region ${r[3]} ecs list-task-definitions --output $output --profile $username
  #      aws --region ${r[2]} ecs list-task-definitions --output $output --profile $username
   #     aws --region ${r[4]} ecs list-task-definitions --output $output --profile $username
    #    aws --region ${r[1]} ecs list-services --output $output --profile $username
    #    aws --region ${r[2]} ecs list-services --output $output --profile $username
######################################################
#echo -e "${GREEN}S3${ENDCOLOR}"

 #       aws --region ${r[1]} s3 ls --output $output --profile $username
  #      aws --region ${r[2]} s3 ls --output $output --profile $username
  #      aws --region ${r[3]} s3 ls --output $output --profile $username
   #     aws --region ${r[4]} s3 ls --output $output --profile $username

#####################################################

#echo -e "${GREEN}SQS${ENDCOLOR}"

 #       aws --region ${r[1]} resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e sqs
  #      aws --region ${r[2]} resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e sqs
   #     aws --region ${r[3]} resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e sqs
    #    aws --region ${r[4]} resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e sqs
#####################################################
#echo -e "${GREEN}LAMBDA${ENDCOLOR}"

 #       aws --region ${r[1]} lambda list-functions --output $output --profile $username
  #      aws --region ${r[2]} lambda list-functions --output $output --profile $username
     #   aws --region ${r[3]} lambda list-functions --output $output --profile $username
      #  aws --region ${r[4]} lambda list-functions --output $output --profile $username

####################################################
#echo -e "${GREEN}ELB${ENDCOLOR}"

 #       aws --region ${r[1]} elb describe-load-balancers --output $output --profile $username
   #     aws --region ${r[2]} elb describe-load-balancers --output $output --profile $username
  #      aws --region ${r[3]} elb describe-load-balancers --output $output --profile $username
 #       aws --region ${r[4]} elb describe-load-balancers --output $output --profile $username
###################################################
#echo -e "${GREEN}VPC${ENDCOLOR}"

   #     aws --region ${r[1]} resourcegroupstaggingapi get-resources --output $output --profile $username | grep -e vpc
  #      aws --region ${r[2]} resourcegroupstaggingapi get-resources --output $output --profile $username | grep -e vpc
 #       aws --region ${r[3]} resourcegroupstaggingapi get-resources --output $output --profile $username | grep -e vpc
#        aws --region ${r[4]} resourcegroupstaggingapi get-resources --output $output --profile $username | grep -e vpc

###################################################

echo '**********************************************************************************************************************************************************************************************************'

echo -e "                                                                                               ${GREEN}DONE${ENDCOLOR}"

echo '**********************************************************************************************************************************************************************************************************'


#'ec2 | rds | ecs | s3 | sqs | elb | 53 | lambda | vpc'

                                                                                                                                          # 
