#!/bin/bash

orig=`pwd`

set -e
echo "analysis directory is $orig"

while IFS=$'\t': read sample fastq1 fastq2
do
  echo "run analysis for ${sample}"
  cd $orig
  cd ${sample}_PE
  echo "/cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/gatherPairedQCmetrics.sh ${sample} > ${sample}.metrics "
  /cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/gatherPairedQCmetrics.sh ${sample} > ${sample}.metrics
done < input_data.tsv
#done < test.in
