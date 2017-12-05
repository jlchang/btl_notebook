######################
#
#  runAlignMark.sh
#
#  for samples in input_data.tsv, run alignMarkInput.sh for each sample
#
######################


#!/bin/bash

orig=`pwd`
source /broad/software/scripts/useuse
use UGER

set -e
echo "analysis directory is $orig"

while IFS=$'\t': read sample fastq1 fastq2
do
  echo "set up analysis dir for $i"
  cd $orig
  mkdir ${sample}_PE
  cd ${sample}_PE
  echo "job to run in analysis dir: qsub -cwd -l h_vmem=10G -l h_rt=4:00:00 -N ${sample} /cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/alignMarkInput.sh ${sample} ${fastq1} ${fastq2}"
  qsub -cwd -l h_vmem=10G -l h_rt=4:00:00 -l h="!(hw-uger*|uger-c012|uger-c041|ugerbm-d006)" -N S_${sample} /cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/alignMarkInput.sh ${sample} ${fastq1} ${fastq2}
done < input_data.tsv
#done < test.in
