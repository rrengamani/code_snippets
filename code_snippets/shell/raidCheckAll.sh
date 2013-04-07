#!/bin/bash
#title           :raidCheckAll.sh
#pre-requisite   :Need a file which should have machine name one per line.
#description     :reads the machine name from MachineList file, checks for raid failure and triggers email.
#author          :rengamanir
#date            :20120425
#version         :1.0
#usage           : raidCheckAll.sh <Machine List File>
#==============================================================================

MachineList=$1

while read line 
do 
 ./raidCheck.sh $line
done < $MachineList

#remove temporary files created during the process.
rm raid_check_*
