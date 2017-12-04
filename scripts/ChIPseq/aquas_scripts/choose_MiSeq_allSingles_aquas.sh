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
use UGER

set -e
echo "analysis directory is $orig"

for i in $(cat runInput.txt)
do
  echo "set up analysis dir for $i"
  cd $orig
  mkdir ${i}_single
  cd ${i}_single
  echo "job to run in analysis dir: qsub -l h_vmem=10G -l h_rt=04:00:00 -N $i /btl/analysis/ChIPseq/scripts/aquas_single_fasta.sh $1/${i}_L001_R1_001.fastq.gz ${i}_single_analysis"
  qsub -l h_vmem=10G -l h_rt=04:00:00  -l h="!(hw-uger*|uger-c060|uger-c023|ugerbm-d006)" -N $i /btl/analysis/ChIPseq/scripts/aquas_single_fasta.sh $1/${i}_L001_R1_001.fastq.gz ${i}_single_analysis
done
