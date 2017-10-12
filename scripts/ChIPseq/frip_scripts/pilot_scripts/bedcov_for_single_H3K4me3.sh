#!/bin/bash
#assumes run from /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/singleFull 
#writes results to /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/singleFull/FRIP

source /broad/software/scripts/useuse
use BEDTools

for i in $(ls -d1 A*); do
  pushd "${i}/${i}_analysis/align/rep1"
  j=$( echo $i | awk 'BEGIN { FS = "_" } ; { print $1"_"$2"_"$3 }') 
  bedtools coverage -a /btl/projects/ChIPseq/ENCODE/data/H3K27ac_K562/H3K4me3_truth_ENCFF616DLO.bed -b ${j}_R1_001.nodup.bam > /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/singleFull/FRIP/${j}_H3K4me3.bedcov
  awk '{ sum += $11 } END { print sum ; }' /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/singleFull/FRIP/${j}_H3K4me3.bedcov > /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/singleFull/FRIP/${j}_H3K4me3.rip
  popd
done
