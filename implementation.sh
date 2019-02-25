#!/bin/bash
# Author: Ahmed El Faleh.
# E-mail: ahmed.elfleh.1@gmail.com
# Automatic implementation of backup solution.

#Set colors
red="\e[91m"
norm="\e[0m"
yal="\e[93m"
cy="\e[36m"
mag="\e[35m"

# The variable of the needed apps to be installed, the apps should installed are rsnapshot and rsync
apps=rsnapshot

# Check if the apps are existing or not.
command -V $apps | cut -d ' ' -f1 | tr '\n' ' ' | grep -w "rsnapshot\|rsync" &>/dev/null
#for rr in ${apps[0]} ${apps[1]}; do `cat /bin/$rr` &> /dev/null

# If the apps are not installed the script will ask the user to enter the distribution.
if [ $? -ne 0 ]
	then

read -p "Please enter one of the following distribution:
	RedHat or CentOS - Ubuntu or Debian
	Please copy and paste from the above line: " info
read -r "distros" <<< "$info"

# This function is being used inside the if condition incase the installer package is not right one, that will happen when the user entered a wrong distribution.
insterr(){
if [ $? -ne 0 ]
                then
                        echo -e $red"Please enter the correct distribution name.
The package installer of the distribution you have entered is different than the package installer of current distribution.
You can check your distribution by executing this command $yal\"lsb_release -a | grep \"Distributor ID\" | cut -d\":\" -f2\"$red, then re-enter the correct distribution.
Or install \"rsnapshot & rsync\" first then re-run this script again $norm"

                exit 1
        fi
}
install1(){
		echo -e $cy"You have entered $distros"$norm
                sleep 2
                echo "Please wait while rsnapshot and rsync are being installed"
		sleep 2
                sudo yum install $apps -y &> /dev/null
}
install2(){
                echo -e $cy"You have entered $distros"$norm
                sleep 2
                echo "Please wait while rsnapshot and rsync are being installed"
                sleep 2
                sudo apt-get install $apps -y &> /dev/null
}


# If the distribution is Centos or RedHat "yum" will install rsnapshot and rsync.
	if [ "$distros" = RedHat ] || [ "$distros" = CentOS ]
		then
		install1
	# This function will run here if a distribution has been entered wrongly.
	insterr

	# If the distribution is  or RedHat "yum" will install rsnapshot and rsync.
	elif [ "$distros" = Ubuntu ] || [ "$distros" = Debain ]
                then
		install2
	insterr
	
# if the user enter a not valid distribution or on of the distribution that are not included into the above line, this message will appear to the user.
else
	echo -e $red"If you distribution is not included please install \"rsnapshot & rsync\" first then re-run this script again"$norm
		exit 1
	fi
fi; #done

# In case of the apps are already exist or being installed the script will do the following:
# 1- Remove the original /etc/rsnapshot.conf.
# 2- Copy the modified one.
# 3- Create the cronjobs under /etc/cron.d/backup.
sudo rm -rf /etc/rsnapshot.conf
sudo cp -a rsnapshot.conf /etc/
sleep 1
echo -e $cy"/etc/rsnapshot.conf has been modified"
bash cronscript.sh &> /dev/null
sleep 1
echo -e "Cron jobs has been created under /etc/cron.d/backup"$norm

# This function will be used after creating /orkitools/ directory.
cpfiles(){
	        sudo cp -at /orkitools/ report dbbackup
		sudo chmod -R 700 /orkitools/*
		sudo chown root:root /etc/rsnapshot.conf
		sudo chown root:root /etc/cron.d/backup

}

# Check if the /orkitools/ directory is exit or not, if not, it will be created.
if [ ! -d "/orkitools" ]
	then
		echo "/orkitools/ directory doesn't exist"; sleep 1
		sudo mkdir /orkitools; sleep 1
		echo -e $cy"/orkitools/ directory has been created"
		cpfiles; sleep 1
		echo -e "The required files have been copied successfully"$norm
else
		cpfiles; sleep 1
                echo -e $cy"The required files have been copied successfully"$norm
		
fi

# End if the script
sleep 1; echo -e $mag"Backup solution has been implemented successfully"$norm
