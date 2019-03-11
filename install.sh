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
distros=`cat /etc/os-release | grep -w ID | cut -d= -f2 | sed 's/"//g'`

# Check if the apps are existing or not.
command -V $apps | cut -d ' ' -f1 | tr '\n' ' ' | grep -w "rsnapshot\|rsync" &>/dev/null
#for rr in ${apps[0]} ${apps[1]}; do `cat /bin/$rr` &> /dev/null

# If the apps are not installed the script will grep the distribution name and install them.
if [ $? -ne 0 ]
	then
		echo "Rsnapshot and Rsync are not installed"
		echo "Selecting distribution, please wait"

install1(){
		echo -e $cy"Your distribution is $distros"$norm
                sleep 2
                echo "Please wait while rsnapshot and rsync are being installed"
		sleep 2
                yum install epel-release $apps -y &> /dev/null
}
install2(){
                echo -e $cy"Your distribution is $distros"$norm
                sleep 2
                echo "Please wait while rsnapshot and rsync are being installed"
                sleep 2
                apt-get install $apps -y &> /dev/null
}


# If the distribution is Centos or RedHat "yum" will install rsnapshot and rsync.
	if [ "$distros" = redHat ] || [ "$distros" = centOS ]
		then
		install1

	# If the distribution is  or RedHat "yum" will install rsnapshot and rsync.
	elif [ "$distros" = ubuntu ] || [ "$distros" = debain ]
                then
		install2
	else
		echo -e $red"Sorry, The program cannot install rsnapshot and rsyn on your operating system, please reinstall them and re-run the program again to automate the rest of backup process."$norm
		exit	
	fi
fi; #done

# In case of the apps are already exist or being installed the script will do the following:
# 1- Check if this server is a cPanel enhanced or not.
# 2- Remove the original /etc/rsnapshot.conf.
# 3- Copy the modified one according to #1.
# 4- Create the cronjobs under /etc/cron.d/backup.

cpchk=$(/usr/local/cpanel/cpanel -V 2>/dev/null)
rm -f /etc/rsnapshot.conf
if [ -z "$cpchk" ]
	then
		cp -a rsnapshotnoc /etc/rsnapshot.conf
	else
		cp -a rsnapshotc /etc/rsnapshot.conf
fi

sleep 1
echo -e $cy"/etc/rsnapshot.conf has been modified"
bash cronscript.sh &> /dev/null
sleep 1
echo -e "Cron jobs has been created under /etc/cron.d/backup"$norm

# This function will be used after creating /orkitools/ directory.
cpfiles(){
	         cp -at /orkitools/ report dbbackup
		 chmod -R 700 /orkitools/*
		 chown root:root /etc/rsnapshot.conf
		 chown root:root /etc/cron.d/backup

}

# Check if the /orkitools/ directory is exit or not, if not, it will be created.
if [ ! -d "/orkitools" ]
	then
		echo "/orkitools/ directory doesn't exist"; sleep 1
		mkdir /orkitools; sleep 1
		echo -e $cy"/orkitools/ directory has been created"
		cpfiles; sleep 1
		echo -e "The required files have been copied successfully"$norm
else
		cpfiles; sleep 1
                echo -e $cy"The required files have been copied successfully"$norm
		
fi

# End if the script
sleep 1; echo -e $mag"Backup solution has been implemented successfully"$norm
echo "Please re-check the /orkitools directory and rsnapshot.conf file and make sure that:
    1. The required files are exist in /orkitools.
    2. The required lines for the cPanel or NoncPanel are unhashed on demand in rsnapshot.conf"
