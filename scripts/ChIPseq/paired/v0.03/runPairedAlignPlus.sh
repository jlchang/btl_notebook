######################
#
#  runPairedAlign.sh
#
#  for samples in input_data.tsv, run pairedAlignMarkD.sh for each sample
#
######################


#!/bin/bash

orig=`pwd`
source /broad/software/scripts/useuse
use UGER

SCRIPTDIR="/cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.03"


set -e
echo "analysis directory is $orig"

UUID=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 7 | head -n 1)
echo $UUID > UUID.txt
sampleNO=0

while IFS=$'\t': read sample fastq1 fastq2
do
  sampleNO=$((sampleNO++)) 
  echo "set up analysis dir for $i"
  cd $orig
  mkdir ${sample}_PE
  cd ${sample}_PE
  jobname="P${UUID}_$sampleNO"
  UGERPARAMS="-cwd -l h_vmem=10G -l h_rt=4:00:00 -N jobname"
    #to avoid bad UGER host(s) - must place on qsub line, can't use variable
    #h='!(uger-c075|uger-c088)\' "
  echo "job to run in analysis dir: qsub $UGERPARAMS $SCRIPTDIR/pairedAlignMarkD.sh ${sample} ${fastq1} ${fastq2}"
  qsub $UGERPARAMS $SCRIPTDIR/pairedAlignMarkD.sh ${sample} ${fastq1} ${fastq2}
done < input_data.tsv
#done < test.in
qsub 
