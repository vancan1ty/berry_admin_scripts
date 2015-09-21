#!/bin/bash
#Currell Berry
#this script gives me the "morning report" on my systems' status.
#the production version of this script should reside in /root/morning_report.sh
#recommend to call using CRON, and mail the results to yourself.

iserror=0;
datestr=$(date -Iminutes)
LOGFILE="/var/log/morningreport/$datestr"".txt"

touch $LOGFILE

echo "Hello, Currell.  Welcome to your morning report."
echo

exec 6>&1 #link fd #6 with stdout.
          #saves stdout.

exec > $LOGFILE #stdout replaced with $LOGFILE

#-------------------------------------------------------------#
# All output from commands in this block sent to file $LOGFILE>

date || iserror=1 

echo
echo "=========HD Status========="
sudo smartctl -H /dev/sda || iserror=1;
sudo smartctl -H /dev/sdb || iserror=1;
sudo smartctl -H /dev/sdc || iserror=1;

echo
echo "=========Ping Results========="
ping -c 1 cerq.cvberry.com || iserror=1;
ping -c 1 cvberry.com || iserror=1;
#check websites
curl --connect-timeout 1 cvberry.com > /dev/null 2>&1 || 
	(iserror=1 && echo "***curl cvberry.com failed***");
curl --connect-timeout 1 cerq.cvberry.com > /dev/null 2>&1 || 
	(iserror=1 && echo "***curl cerq.cvberry.com failed***");

echo
echo "=========Top CPU Users========="
ps -Ao user,uid,comm,pid,pcpu,pmem,rss,tty --sort=-pcpu | head -n 6

echo
echo "=========Top Memory Users========="
ps -Ao user,uid,comm,pid,pcpu,pmem,rss,tty --sort=-rss | head -n 6

echo
echo "=========Hard Drive Usage========="
df / /home /mnt/backdrive

#-------------------------------------------------------------#

exec 1>&6 6>&-      # Restore stdout and close file descriptor #6.

if [[ iserror=1 ]]
then
	echo "STATUS: *WARNING!*  An error has been detected"
else
	echo "STATUS: No errors were detected while running the morning report"
fi

cat $LOGFILE

exit $iserror
