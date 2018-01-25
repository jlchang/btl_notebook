######################
#
#  bedcov_for_IGV_H3K27ac.sh
#
#  produce read counts in H3K27ac K562 peaks
#
######################


#!/bin/bash

eval export DK_ROOT="/broad/software/dotkit"; . /broad/software/dotkit/ksh/.dk_init
reuse -q .bedtools-2.26.0 


# set to print each command and exit script if any command fails
set -euxo pipefail

orig=`pwd`



while IFS=$'\t': read sample fastq1 fastq2
do
  cd ${sample}_PE
  echo "processing sample ${sample}"
  cat /btl/projects/ChIPseq/ENCODE/data/IGV_tracks/wgEncodeBroadHistoneK562H3k27acStdAln.sorted.bed | bedtools coverage -sorted -g /btl/projects/ChIPseq/ENCODE/data/IGV_tracks/chromosomes.txt -a - -b ${sample}.mapq1.PE.nodup.bam > ${sample}.mapq1.PE.nodup.H3K27ac.bedcov
  awk '{ sum += $11 } END { print sum ; }' ${sample}.mapq1.PE.nodup.H3K27ac.bedcov > ${sample}.mapq1.PE.nodup.H3K27ac.rip
  touch frip
  cd $orig
done < input_data.tsv
