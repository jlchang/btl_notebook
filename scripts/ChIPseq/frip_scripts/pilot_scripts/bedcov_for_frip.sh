#!/bin/bash
#assumes run from /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271
#writes results to /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/FRIP

source /broad/software/scripts/useuse
use BEDTools

for i in $(ls -d1 A*); do
  pushd "${i}/${i}_analysis/peak/macs2/rep1"
  ls
  if [[ -e ${i}_R1_001.PE2SE.nodup.filt.narrowPeak.gz ]]; then
    gunzip ${i}_R1_001.PE2SE.nodup.filt.narrowPeak.gz
  fi
  bedtools coverage -a ${i}_R1_001.PE2SE.nodup.filt.narrowPeak -b ../../../align/rep1/${i}_R1_001.PE2SE.nodup.bam > /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/FRIP/${i}.bedcov
  awk '{ sum += $11 } END { print sum ; }' /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/FRIP/${i}.bedcov > /cil/shed/sandboxes/jlchang/ChIPseq/SSFDEV-271/FRIP/${i}.rip
  popd
done
