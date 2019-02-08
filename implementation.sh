#!/bin/bash
#By ahmed El Faleh
#E-mail: ahmed.elfleh.1@gmail.com
#Automatic implement of  backup solution.
apps=(rsnapshot rsync)
command -V ${apps[*]} | cut -d ' ' -f1 | tr '\n' ' ' | grep -w "rsnapshot\|rsync"

if [ $? -ne 0 ]
	then

read -p "Please enter one of the following distribution:
	RedHat or Centos - Ubuntu or Debian
	Please copy and paste from the above line:  " info
read -r "distros" <<< "$info"
insterr(){
if [ $? -ne 0 ]
                then
                        echo "Please enter the correct distribution name, or install \"rsnapshot & rsync\" first then re-run this script again"
                exit 1
        fi
}
	if [ "$distros" = Centos ] || [ "$distros" = RedHat ]
		then
		echo "You have entered $distros"
		sleep 1
		echo "Please wait while rsnapshot and rsync are being installed"
 		sudo yum install ${apps[*]} -y &> /dev/null
	insterr

	elif [ "$distros" = Ubuntu ] || [ "$distros" = Debain ]
                then

                echo "You have entered $distros"
		sleep 1
                echo "Please wait while rsnapshot and rsync are being installed"
                sudo apt-get install ${apps[*]} -y &> /dev/null
	insterr
	
else
	echo "If you distribution is not included please install \"rsnapshot & rsync\" first then re-run this script again"
		exit 1
	fi
fi
sudo rm -rf /etc/rsnapshot.conf
sudo cp -a rsnapshot.conf /etc/
sleep 1
echo "/etc/rsnapshot.conf has been modified"
bash cronscript.sh &> /dev/null
sleep 1
echo "Cron jobs has been created under /etc/cron.d/backup"

cpfiles(){
	        sudo cp -at /orkitools/ report dbbackup && sudo chmod -R 700 /orkitools/* && sudo chown root:root /etc/rsnapshot.conf && sudo chown root:root /etc/cron.d/backup

}

if [ ! -d "/orkitools" ]
	then
		echo "/orkitools/ directory doesn't exist"
		sleep 1
		sudo mkdir /orkitools
		sleep 1
		echo "/orkitools/ directory has been created"
		cpfiles
		sleep 1
		echo "The required files have been copied successfully"
else
		cpfiles
		sleep 1
                echo "The required files have been copied successfully"
		
fi

sleep 1

echo "Backup solution has been implemented successfully"
