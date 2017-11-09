#!/bin/bash

set -e

currDir=$(pwd)
echo "current Directory is $currDir"
fastq="$currDir/fastq"
#echo "making $fastq"
#ls $fastq
#mkdir $fastq

path=$(cat orig_dataPath)
echo "obtain data from $path"

while IFS=$'\t': read sampleName barcode1 barcode2
do
  echo "/cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/aquas_scripts/aggregateFastqs.sh $fastq $path $sampleName $barcode1 $barcode2"
  /cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/aquas_scripts/aggregateFastqs.sh $fastq $path $sampleName $barcode1 $barcode2
done  < barcode_mapping.txt
