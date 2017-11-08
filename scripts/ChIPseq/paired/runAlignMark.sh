#!/bin/bash



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
  echo "job to run in analysis dir: qsub -l h_vmem=8G -l h_rt=18:00:00 -N $i /btl/analysis/ChIPseq/scripts/aquas_HiSeq_single_fasta.sh $1/${i}.fastq.gz ${i}_single_analysis"
  qsub -l h_vmem=8G -l h_rt=18:00:00 -N $i /btl/analysis/ChIPseq/scripts/aquas_HiSeq_single_fasta.sh $1/${i}.fastq.gz ${i}_single_analysis
done
