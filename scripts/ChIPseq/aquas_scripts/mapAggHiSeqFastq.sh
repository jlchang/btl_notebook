#!/bin/bash

set -e

currDir=$(pwd)
echo "current Directory is $currDir"
fastq="$currDir/fastq"
echo "making $fastq"
mkdir $fastq

path=$(cat fastqPath)
echo "obtain data from $path"

while IFS=$'\t': read barcode1 barcode2 sampleName
do
  echo "/cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/aquas_scripts/aggregateFastqs.sh $fastq $path $barcode1 $barcode2 $sampleName"
  /cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/aquas_scripts/aggregateFastqs.sh $fastq $path $barcode1 $barcode2 $sampleName
done  < barcode_mapping.txt
