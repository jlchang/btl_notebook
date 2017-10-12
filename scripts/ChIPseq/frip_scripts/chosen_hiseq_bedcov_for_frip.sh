#!/bin/bash
# script will create FRIP directory under top level directory for output 
# run this script from top level aquas analysis directory

echo "running bedcov_for_frip.sh"
echo

target=$(pwd)
echo  "running script from $target"

read -r -p "Continue? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  exit  
fi

if [[ ! -d FRIP ]]; then
  mkdir FRIP
#else
#  echo "FRIP directory already exists, exiting to prevent overwrite..."
#  exit
fi



source /broad/software/scripts/useuse
use BEDTools

echo "running FRIP on"
cat fripInput.txt

read -r -p "Continue? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  exit
fi

for i in $(cat fripInput.txt); do
  pushd "${i}_single/${i}_single_analysis/peak/macs2/rep1"
  ls
  echo "checking if ${i}.nodup.filt.narrowPeak.gz exists"
  if [[ -e ${i}.nodup.filt.narrowPeak.gz ]]; then
    echo "need to unzip peak file"
    gunzip ${i}.nodup.filt.narrowPeak.gz
  fi
  echo "ready to calculate FRIP"
  bedtools coverage -a ${i}.nodup.filt.narrowPeak -b ../../../align/rep1/${i}.nodup.bam > ${target}/FRIP/${i}.bedcov
  awk '{ sum += $11 } END { print sum ; }' ${target}/FRIP/${i}.bedcov > ${target}/FRIP/${i}.rip
  popd
done
