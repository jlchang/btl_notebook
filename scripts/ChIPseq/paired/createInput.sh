#!/bin/bash

#####
#
# create_input.sh <path> 
#  
#
#####


# Any subsequent commands which fail will cause the shell script to exit immediately
set -e

dirPath=$1/Data/Intensities/BaseCalls

if [  ! -d "$dirPath" ]
  then
    echo "Unable to find $dirPath, please check the provided path"
    exit
fi


ls -1 $1/Data/Intensities/BaseCalls/*_R1_* | grep -v Undetermined > R1
ls -1 $1/Data/Intensities/BaseCalls/*_R2_* | grep -v Undetermined > R2
for i in $(cat R1); do basename $i | cut -d "_" -f 1-2 >> sample;  done
paste sample R1 R2 > input_data.tsv
rm sample R1 R2
echo "input_data.tsv created"
