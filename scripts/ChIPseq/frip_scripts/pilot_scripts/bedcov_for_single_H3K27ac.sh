#!/bin/bash
#assumes run from /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/singleFull 
#writes results to /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/singleFull/FRIP

source /broad/software/scripts/useuse
use BEDTools

for i in $(ls -d1 A*); do
  pushd "${i}/${i}_analysis/align/rep1"
  j=$( echo $i | awk 'BEGIN { FS = "_" } ; { print $1"_"$2"_"$3 }') 
  outputPath="/cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/singleFull/FRIP/${j}_H3K4me3"
  echo "bedtools coverage -a /btl/projects/ChIPseq/ENCODE/data/H3K27ac_K562/H3K27ac_truth_ENCFF038DDS.bed -b ${j}_R1_001.nodup.bam > ${outputPath}.bedcov"
  bedtools coverage -a /btl/projects/ChIPseq/ENCODE/data/H3K27ac_K562/H3K27ac_truth_ENCFF038DDS.bed -b ${j}_R1_001.nodup.bam > ${outputPath}.bedcov
  awk '{ sum += $11 } END { print sum ; }' ${outputPath}.bedcov > ${outputPath}.rip
  popd
done
