######################
#
#  batchTagAlignExpt.sh
#
#  create tagAlign files for all samples in input_data.tsv and rerun PPQT
#
######################

#!/bin/bash

eval export DK_ROOT="/broad/software/dotkit"; . /broad/software/dotkit/ksh/.dk_init
reuse -q .r-3.3.0
reuse -q .bedtools-2.26.0
reuse -q .samtools-1.5

sample=$1

# set to print each command and exit script if any command fails
set -euxo pipefail

orig=`pwd`

SCRIPTDIR="/cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.05"

#  mv ${sample}.mapq1.PE.nodup.qc ${sample}.mapq1.PE.nodup.broken.qc
#  mv ${sample}.mapq1.PE.nodup.pdf ${sample}.mapq1.PE.nodup.broken.pdf
#  mv ${sample}.metrics ${sample}.broken.metrics_v4
  samtools sort -n ${sample}.mapq1.PE.nodup.bam -o ${sample}.mapq1.PE.nodup.nmsrt.bam
  bedtools bamtobed -bedpe -mate1 -i ${sample}.mapq1.PE.nodup.nmsrt.bam | gzip -nc > ${sample}.mapq1.PE2SE.nodup.bedpe.gz

  zcat ${sample}.mapq1.PE2SE.nodup.bedpe.gz | awk 'BEGIN{OFS="\t"}{printf "%s\t%s\t%s\tN\t1000\t%s\n%s\t%s\t%s\tN\t1000\t%s\n",$1,$2,$3,$9,$4,$5,$6,$10}' | gzip -nc > ${sample}.mapq1.PE2SE.nodup.tagAlign.gz

  rm ${sample}.mapq1.PE.nodup.nmsrt.bam
  zcat ${sample}.mapq1.PE2SE.nodup.bedpe.gz | grep -v "chrM" | shuf -n 15000000 --random-source=/cil/shed/apps/external/AQUAS/genome_data/hg19/bwa_index/male.hg19.fa  | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,"N","1000",$9}' | gzip -nc > ${sample}.mapq1.PE2SE.nodup.15M.tagAlign.gz

  Rscript /cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.04/run_spp.R -c=${sample}.mapq1.PE2SE.nodup.15M.tagAlign.gz -savp -out=${sample}.mapq1.PE2SE.nodup.15M.tagAlign.qc

  $SCRIPTDIR/gatherPairedAlignMarkDmetrics.sh ${sample} > ${sample}.metrics
  touch tagA
