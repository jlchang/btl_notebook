#!/bin/bash

if [ $# -lt 1 ]
  then
    echo "ERROR - please provide a directory for collecting frip scores"
    exit
fi


if [ -e $1 ]
  then
    echo "Collecting FRIP scores from $1"
  else
    exit
fi

echo "Reporting samples in this order:"

cat statsInput.txt 

read -r -p "Continue? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  exit
fi

for i in $(cat statsInput.txt); do  cat $1/${i}_*.rip; done

