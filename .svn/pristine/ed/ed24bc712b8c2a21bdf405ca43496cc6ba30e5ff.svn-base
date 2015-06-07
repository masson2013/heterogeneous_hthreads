#!/bin/bash
# *************************************
# Script to aid in downloading
# elf file to microblaze host
# *************************************
# Usage:
#" ./prog_download.sh <executableName>"
# *************************************

# Check arguments
if [ $# -ne 2 ]
then
    echo "Correct Usage:"
    echo " ./prog_download.sh  <executableName> <Num of Slaves> "
    exit
fi

# Grab command line arg
execName=$1


# Initialize processor number
# First Microblaze is Host!
pnum=$2


# Create temporary file
tempName="mblaze.opt"
touch $tempName

echo "Downloading the bitstream..."
impact -batch download.cmd
i=1
#programming the slaves
while [ $i -le $pnum ]; do
	echo "Downloading to slave $i  ..."
	let i++ 
	echo "connect mb mdm -debugdevice cpunr $i" > $tempName	
	echo "rst" >> $tempName
	echo "dow slave.elf " >> $tempName
	echo "run" >> $tempName	
	echo "exit" >> $tempName
	# Invoke XMD	
	xmd -opt $tempName
	echo "Complete"
done


# programming the host
echo "connect mb mdm -debugdevice cpunr 1" > $tempName
echo "debugconfig -reset_on_run disable" >> $tempName
echo "rst " >> $tempName
echo "dow $execName" >> $tempName
echo "run" >> $tempName
echo "exit" >> $tempName
# Invoke XMD
echo "Downloading to the host..."
xmd -opt $tempName
echo "Complete"

# Clean up after yourself
rm -f $tempName
