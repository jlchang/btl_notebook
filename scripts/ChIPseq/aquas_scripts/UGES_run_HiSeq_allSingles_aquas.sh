#!/bin/bash


echo "Processing the following samples"

cat runInput.txt

read -r -p "Continue? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  exit
fi


orig=`pwd`
source /broad/software/scripts/useuse
use UGES

set -e
echo "analysis directory is $orig"

cd $1
echo "checking for data in $1, found:"
ls -1 *.fastq.gz | grep -v Undetermined | grep -v unknown | grep -v barcode | cut -d "." -f 1-3 | uniq

read -r -p "Continue? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  exit
fi

cd $orig
for i in $(cat runInput.txt)
do
  echo "set up analysis dir for $i"
  cd $orig
  mkdir ${i}_single
  cd ${i}_single
  echo "job to run in analysis dir: qsub -q btl -N $i aquas_provide_fasta.sh $1/${i}.fastq.gz ${i}_single_analysis"
  qsub -q btl -N $i ../aquas_single_fasta.sh $1/${i}.fastq.gz ${i}_single_analysis
done
