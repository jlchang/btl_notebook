#!/bin/bash

eval export DK_ROOT="/broad/software/dotkit"; . /broad/software/dotkit/ksh/.dk_init
reuse -q .r-3.3.0

orig=`pwd`

set -e
echo "analysis directory is $orig"

while IFS=$'\t': read sample fastq1 fastq2
do
  echo "run analysis for ${sample}"
  cd $orig/${sample}_PE
  echo "Rscript /cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.02/processMapqCounts.R"
  Rscript /cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.02/processMapqCounts.R
done < input_data.tsv
#done < test.in
