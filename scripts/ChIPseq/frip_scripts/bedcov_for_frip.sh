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
else
  echo "FRIP directory already exists, exiting to prevent overwrite..."
  exit
fi


source /broad/software/scripts/useuse
use BEDTools

echo "running FRIP on"
ls -d1 *_S*_*

read -r -p "Continue? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  exit
fi

for i in $(ls -d1 *_S*_*); do
  pushd "${i}/${i}_analysis/peak/macs2/rep1"
  full=$(expr length $i)
  desired=$(expr $full - 7)
  name=${i:0:$desired}
  ls
  echo "checking if ${name}_L001_R1_001.nodup.filt.narrowPeak.gz exists"
  if [[ -e ${name}_L001_R1_001.nodup.filt.narrowPeak.gz ]]; then
    echo "need to unzip peak file"
    gunzip ${name}_L001_R1_001.nodup.filt.narrowPeak.gz
  fi
  echo "ready to calculate FRIP"
  bedtools coverage -a ${name}_L001_R1_001.nodup.filt.narrowPeak -b ../../../align/rep1/${name}_L001_R1_001.nodup.bam > ${target}/FRIP/${name}.bedcov
  awk '{ sum += $11 } END { print sum ; }' ${target}/FRIP/${name}.bedcov > ${target}/FRIP/${name}.rip
  popd
done
