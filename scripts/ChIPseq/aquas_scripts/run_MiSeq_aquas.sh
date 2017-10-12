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
  mkdir $i
  cd $i
  echo "job to run in analysis dir: qsub  -N J_${i} aquas_provide_fasta.sh $1/${i}_L001_R1_001.fastq.gz $1/${i}_L001_R2_001.fastq.gz ${i}_analysis"
  qsub  -N J_${i} /cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/aquas_provide_fasta.sh $1/${i}_L001_R1_001.fastq.gz $1/${i}_L001_R2_001.fastq.gz ${i}_analysis
done
