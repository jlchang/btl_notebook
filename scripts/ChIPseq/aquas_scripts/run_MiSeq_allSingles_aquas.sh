#!/bin/bash

orig=`pwd`
source /broad/software/scripts/useuse
use UGER

set -e
echo "analysis directory is $orig"

cd $1
for i in $(ls -1 *.fastq.gz | grep -v Undetermined | cut -d "_" -f 1,2 | uniq)
do
  echo "set up analysis dir for $i"
  cd $orig
  mkdir ${i}_single
  cd ${i}_single
  echo "job to run in analysis dir: qsub -l h_vmem=5G -l h_rt=04:00:00 -N $i /btl/analysis/ChIPseq/scripts/aquas_single_fasta.sh $1/${i}_L001_R1_001.fastq.gz ${i}_single_analysis"
  qsub -l h_vmem=5G -l h_rt=04:00:00 -N $i /btl/analysis/ChIPseq/scripts/aquas_single_fasta.sh $1/${i}_L001_R1_001.fastq.gz ${i}_single_analysis
done
