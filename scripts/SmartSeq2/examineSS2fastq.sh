#!/bin/bash

####
#
# xamineSS2fastq.sh
#
# count # of fastq reads per sample
#
####



set -e


while IFS=$'\t': read sample barcode1 barcode2 specie path
do
#    echo "assessing $sample"
    RC_BARCODE_2=( $(echo $barcode2 | rev | tr ATGC TACG))
    samplereads=0
    for i in $(ls -1  $path/*/*.${barcode1}_${RC_BARCODE_2}.unmapped.1.fastq.gz)
    do
        mycount=$(zcat $i | awk '{s++}END{print s/4}')
#        echo "$mycount reads in $i"
        samplereads=$(($mycount + $samplereads))
    done
    echo "$sample $samplereads"
done  < <(sort input_data.tsv)
