#!/bin/bash

###This is a tool/utility that does different checks for an AWS account using the aws_cli. Inspired by the manual work I had to do and the fact that I am too fucking lazy to do such a manual labour.
###This is version 1.0.1
###In this revision the basic layout of the script will be created such as the UI and some of the options. Also, there are some pre-requsites that would be needed, so the script would make dependency checks as well.
###This is version 1.0.2 

cr=`echo $'\n'`
version="version 1.0.1"

####profile=cat ~/.aws/config | grep profile

#This checks if "dialog" and "aws_cli" are existing on the machine
echo which dialog 1> /dev/null

if [ $? != 0 ]
then sudo apt -y install dialog
fi

echo which aws 1> /dev/null

if [ $? != 0 ]
then sudo apt -y install aws
fi

#This is the dialog box's UI configuration
HEIGHT=15

WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="AWS Util $version"
TITLE="AWS Util $version"
MENU="Choose one of the following options:"
MENU2="Choose the desired AWS TAG"

OPTIONS=(1 "service"
         2 "monitoring"
         3 "zoo"
         4 "type")

CHOICE=$(dialog --clear \
		--backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
	clear

#if [ $OPTIONS=`1 "Tag1"` ];
#then 
#read -p "Please select the first tag $cr" TAG1

#elif [ $OPTIONS=`1 "Tag2"` ];
#then 
#read -p "Please select the first tag $cr" TAG2

#elif [ $OPTIONS=`1 "Tag3"` ];
#then 
#read -p "Please select the first tag $cr" TAG3 






case $CHOICE in
        1)
           aws ec2 describe-tags --filters "Name=tag:service,Values=*" --output text | awk '{print $5}' | sort | uniq && aws ec2 describe-tags --filters "Name=tag:Service,Values=*" --output text | awk '{print $5}' | sort | uniq
            ;;
        2)
           aws ec2 describe-tags --filters "Name=tag:Monitoring,Values=*" --output text | awk '{print $5}' | sort | uniq
            ;;
        3)
            aws ec2 describe-tags --filters "Name=tag:Zoo,Values=*" --output text | awk '{print $5}' | sort | uniq
            ;;
        4)  
            aws ec2 describe-tags --filters "Name=tag:Type,Values=*" --output text | awk '{print $5}' | sort | uniq   
            ;;
esac
#case $CHOICE2 in
 #       1)
  #         read -p "Please select region $cr" region
#
 #           ;;
  #      2)
	#	read -p "Please select a TAG (ex.:'tag=name_of_the_tag') $cr" tag
     #       ;;
      #  3)
       #     echo "You chose Option 3"
        #    ;;
#esac

aws ec2 describe-tags --filters "Name=tag:$TAG1,Values=*" --output text | awk '{print $5}' | sort | uniq
aws ec2 describe-tags --filters "Name=tag:$TAG2,Values=*" --output text | awk '{print $5}' | sort | uniq
aws ec2 describe-tags --filters "Name=tag:$TAG3,Values=*" --output text | awk '{print $5}' | sort | uniq
