#!/bin/bash

# 
# echo "Processing the following samples"
# 
# cat input_data.tsv
# 
# read -r -p "Continue? [y/N] " response
# if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
# then
#   exit
# fi
# 

orig=`pwd`
source /broad/software/scripts/useuse
use UGES

SCRIPTDIR=/cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/aquas_scripts/pairedEnd_Aquas_scripts

set -e
echo "analysis directory is $orig"

while IFS=$'\t': read sample fastq1 fastq2
do
  echo "set up analysis dir for ${sample}"
  cd $orig
  mkdir ${sample}_aquasPE
  cd ${sample}_aquasPE
  UGESPARAMS="-cwd -q btl -N S_${sample}"
    #syntax to use to avoid bad UGES host(s))
    #UGESPARAMS="-cwd -l h_vmem=10G -l h_rt=4:00:00 -l h=\'!(uger-c075|uger-c088)\' -N S_${sample}"
  echo "job to run in analysis dir: qsub $UGESPARAMS $SCRIPTDIR/aquas_provide_fasta.sh ${sample} ${fastq1} ${fastq2}"
  qsub $UGERPARAMS $SCRIPTDIR/aquas_provide_fasta.sh ${fastq1} ${fastq2} ${sample}_aquas
done < input_data.tsv
