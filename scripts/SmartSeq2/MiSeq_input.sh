#!/bin/bash

#####
#
# MiSeq_input.sh <path> <specie>
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

if [ $# -lt 2 ]
  then
    echo "ERROR (missing specie info) - please provide both a path to the fastqs and the specie (or majority specie) for the plate"
    exit
fi

if [ "$2" != "human" ] && [ "$2" != "mouse" ]
  then
    echo "ERROR - provided specie must be mouse or human"
    exit
fi

ls -1 $1/Data/Intensities/BaseCalls/*_R1_* | grep -v Undetermined > R1
ls -1 $1/Data/Intensities/BaseCalls/*_R2_* | grep -v Undetermined > R2
for i in $(cat R1); do basename $i | cut -d "_" -f 1-2 >> sample;  done
paste sample R1 R2 > all
sed "s/$/\t$2/g" all > input_data.tsv
rm sample R1 R2 all
echo "input_data.tsv created"
