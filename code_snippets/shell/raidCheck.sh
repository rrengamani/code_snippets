#!/bin/bash

#title           :raidCheck.sh
#description     : gets the machine name and checks for raid failure.
#author          :rengamanir
#date            :20120425
#version         :1.0
#usage           : raidCheck <SYSTEM NAME>
#==============================================================================

LOG_FILE=raid_check_$1
SYSTEM=$1
MAILTO='youremail@domain.com'


if [ $# -ne 1 ]
then
	echo " System Name Missing. Usage: raidCheck <SYSTEM NAME>"
	exit 1
fi


ssh -nx $SYSTEM cat /proc/mdstat | egrep 'md.*raid' | fgrep -i '(f)' 

if [ $? -eq 0 ]
then
echo "The $SYSTEM system has RAID failures on it." >> $LOG_FILE
echo "Below is the output from /proc/mdstat" >> $LOG_FILE
echo "===========================================" >> $LOG_FILE
ssh -nx $SYSTEM cat /proc/mdstat | egrep 'md.*raid' | fgrep -i '(f)' >> $LOG_FILE
#	cat /proc/mdstat >> $LOG_FILE
	echo "===========================================" >> $LOG_FILE
	mailx -s 'RAID disk failure detected' $MAILTO < $LOG_FILE
fi

rm -f >> $LOG_FILE
