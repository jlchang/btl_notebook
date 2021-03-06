#!/bin/bash
#assumes run from /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271
#writes results to /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/FRIP

source /broad/software/scripts/useuse
use BEDTools

for i in $(ls -d1 A*); do
  pushd "${i}/${i}_analysis/peak/macs2/rep1"
  zcat /btl/projects/ChIPseq/ENCODE/data/H3K27ac_K562/H3K27ac_truth_ENCFF038DDS.bed.gz | bedtools coverage -a - -b ../../../align/rep1/${i}_R1_001.PE2SE.nodup.bam > /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/FRIP/${i}_H3K27ac.bedcov
  awk '{ sum += $11 } END { print sum ; }' /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/FRIP/${i}_H3K27ac.bedcov > /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/FRIP/${i}_H3K27ac.rip
  popd
done
