#!/bin/bash
#By ahmed El Faleh
#E-mail: ahmed.elfleh.1@gmail.com
#Automatic implement of  backup solution.
apps=( 'rsnapshot rsync' )
command -V $apps | cut -d ' ' -f1 | tr '\n' ' ' | grep -w "rsnapshot\|rsync"  &> /dev/null

if [ $? -ne 0 ]
	then

read -p "Please enter one of the following distribution:
	Centos - Ubuntu - Debain - RedHat
	Please copy and paste from the above line:  " info
read -r "distros" <<< "$info"

	if [ "$distros" = Centos ] || [ "$distros" = RedHat ]
		then
		echo "You have entered $distros"
 		sudo yum install $apps -y 2> /dev/null
	if [ $? -ne 0 ]
		then
			echo "Please enter the correct distribution name, or install \"rsnapshot & rsync\" first then re-run this script again"
		exit 1
	fi
	elif [ "$distros" = Ubuntu ] || [ "$distros" = Debain ]
                then

                echo "You have entered $distros"
                sudo apt-get install $apps -y 2> /dev/null
	if [ $? -ne 0 ]
                then
                        echo "Please enter the correct distribution name, or install \"rsnapshot & rsync\" first then re-run this script again"
                exit 1
        fi

	else
	echo "If you distribution is not included please install \"rsnapshot & rsync\" first then re-run this script again"
		exit 1
	fi
fi
sudo rm -rf /etc/rsnapshot.conf
sudo cp -a rsnapshot.conf /etc/
bash cronscript.sh
cpfiles(){
	        sudo cp -at /orkitools/ report dbbackup
}

if [ ! -d "/orkitools" ]
	then
		sudo mkdir /orkitools
		cpfiles 
else
		cpfiles
fi

sudo chmod -R 700 /orkitools/* && sudo chown root:root /etc/rsnapshot.conf && sudo chown root:root /etc/cron.d/backup
echo "Backup solution has been implemented successfully"
