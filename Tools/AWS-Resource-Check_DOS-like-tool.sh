#!/bin/bash

###This is a tool/utility that does different checks for an AWS account using the aws_cli. Inspired by the manual work I had to do and the fact that I am too fucking lazy to do such a manual labour.
###This is version 1.0.1
###In this revision the basic layout of the script will be created such as the UI and some of the options. Also, there are some pre-requsites that would be needed, so the script would make dependency checks as well.


cr=`echo $'\n'`
version="version 1.0.1"

profile=cat ~/.aws/config | grep profile

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
MENU2="Choose your AWS username"

OPTIONS=(1 "Region"
         2 "Tag"
         3 "Service")
OPTIONS2=(1 "Region"
         2 "Tag"
         3 "Service")

CHOICE=$(dialog --clear \
		--backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
CHOICE2=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS2[@]}" \
                2>&1 >/dev/tty)
CHOICE3=$(dialog --clear \
		# --title "$TITLE" \
		 #--menu "$MENU2" \
		 #--textbox \
		 $HEIGHT $WIDTH $CHOICE_HEIGHT \
		 2>&1 >/dev/tty)
	clear
case $CHOICE in
        1)
           read -p "Please select region $cr" region
            ;;
        2)
            echo "You chose Option 2"
            ;;
        3)
            echo "You chose Option 3"
            ;;
esac
case $CHOICE2 in
        1)
           read -p "Please select region $cr" region

            ;;
        2)
		read -p "Please select a TAG (ex.:'tag=name_of_the_tag') $cr" tag
            ;;
        3)
            echo "You chose Option 3"
            ;;
esac

case $CHOICE3 in
  #      1)
 #          read -p "Please select region $cr" region
#
       #     ;;
      #  2)
     #           read -p "Please select a TAG (ex.:'tag=name_of_the_tag') $cr" tag
    #        ;;
   #     3)
  #          echo "You chose Option 3"
 #           ;;
esac

aws --region $region resourcegroupstaggingapi tag-resources --tags $tag --profile $CHOICE3


