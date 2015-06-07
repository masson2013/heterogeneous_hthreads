#!/bin/bash
# *************************************
# Script to aid in downloading
# elf file to microblaze host
# *************************************
# Usage:
#" ./prog_download.sh <executableName>"
# *************************************

# Check arguments
if [ $# -ne 1 ]
then
    echo "Correct Usage:"
    echo " ./prog_download.sh <executableName>"
    exit
fi

# Grab command line arg
execName=$1

# Initialize processor number
# First Microblaze is Host!
pnum=1

# Create temporary file
tempName="extra/mblaze.opt"
touch $tempName

# Write file contents
echo "connect mb mdm -debugdevice cpunr $pnum" > $tempName
#echo "debugconfig -reset_on_run enable" >> $tempName
#echo "stop" >> $tempName
#echo "rst" >> $tempName
echo "dow $execName" >> $tempName
echo "run" >> $tempName
echo "exit" >> $tempName

# Invoke XMD
echo "Downloading to $pnum..."
xmd -opt $tempName
echo "Complete"

# Clean up after yourself
rm -f $tempName
