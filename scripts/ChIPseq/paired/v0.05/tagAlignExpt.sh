######################
#
#  tagAlignExpt.sh
#
#  create tagAlign files for all samples in input_data.tsv and rerun PPQT
#
######################

#!/bin/bash

eval export DK_ROOT="/broad/software/dotkit"; . /broad/software/dotkit/ksh/.dk_init
reuse -q .r-3.3.0
reuse -q .bedtools-2.26.0
reuse -q .samtools-1.5

# set to print each command and exit script if any command fails
set -euxo pipefail

orig=`pwd`
# suffix=$(basename $orig)
# ssf=$(basename $(dirname $(dirname $orig)))
# expt=${ssf}_${suffix}


SCRIPTDIR="/cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.05"

# if [ -e ${expt}.metrics ]
#   then
#     echo "metrics file already exists, try again after you:"
#     echo "rm ${expt}.metrics"
#     exit
# fi
# 
# set -e
# echo "analysis directory is $orig"

#mapq counting incorrect, removing as metric (20171214)
#echo "Expt	Sample	Ctrl	Tot_Reads	MAPQ0_Reads	mapq0PE_rip	mapq0PE_FRIP	R1_CHIMERAS	R1_ADAPTER	R2_CHIMERAS	R2_ADAPTER	pDUPLICATION	EstLibSize	MapRaw_Reads	PropPr_Reads	PrSing_Reads	mmdc_Reads	pDup_Reads	mapq0_Reads	mapq5_Reads	mapq10_Reads	mapq28_Reads	mapq29_Reads" >> ${expt}.metrics
# 
# echo "Expt	Sample	Ctrl	Tot_Reads	MAPQ1_Reads	mapq1PE_rip	mapq1PE_FRIP	R1_CHIMERAS	R1_ADAPTER	R2_CHIMERAS	R2_ADAPTER	pDUPLICATION	EstLibSize	RSC	NSC	QT	MapRaw_Reads	PropPr_Reads	PrSing_Reads	mmdc_Reads	pDup_Reads" >> ${expt}.metrics

while IFS=$'\t': read sample fastq1 fastq2
do
#  if [ -e ${sample}_PE/DONE ]
#  then
#    continue
#  fi

  cd ${sample}_PE 
  mv ${sample}.mapq1.PE.nodup.qc ${sample}.mapq1.PE.nodup.broken.qc
  mv ${sample}.mapq1.PE.nodup.pdf ${sample}.mapq1.PE.nodup.broken.pdf
  mv ${sample}.metrics ${sample}.broken.metrics
  samtools sort -n ${sample}.mapq1.PE.nodup.bam -o ${sample}.mapq1.PE.nodup.nmsrt.bam
  bedtools bamtobed -bedpe -mate1 -i ${sample}.mapq1.PE.nodup.nmsrt.bam | gzip -nc > ${sample}.mapq1.PE.nodup.bedpe.gz

  zcat ${sample}.mapq1.PE.nodup.bedpe.gz | awk 'BEGIN{OFS="\t"}{printf "%s\t%s\t%s\tN\t1000\t%s\n%s\t%s\t%s\tN\t1000\t%s\n",$1,$2,$3,$9,$4,$5,$6,$10}' | gzip -nc > ${sample}.mapq1.PE.nodup.tagAlign.gz


  zcat ${sample}.mapq1.PE.nodup.bedpe.gz | grep -v "chrM" | shuf -n 15000000 --random-source=/cil/shed/apps/external/AQUAS/genome_data/hg19/bwa_index/male.hg19.fa  | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,"N","1000",$9}' | gzip -nc > ${sample}.mapq1.PE.nodup.15M.tagAlign.gz

  Rscript /cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.04/run_spp.R -c=${sample}.mapq1.PE.nodup.15M.tagAlign.gz -savp -out=${sample}.mapq1.PE.nodup.15M.tagAlign.qc

  $SCRIPTDIR/gatherPairedAlignMarkDmetrics.sh ${sample} > ${sample}.metrics
  touch tagA
  cd $orig
#   metrics=$(tail -n1 ${orig}/${sample}_PE/${sample}.metrics)
#   echo -ne "$expt\t" >> ${expt}.metrics
#   echo -ne "$sample\t" >> ${expt}.metrics
#   echo -ne "$(grep $sample control_info.txt | cut -f 2)\t" >> ${expt}.metrics
#   echo "$metrics" >> ${expt}.metrics
done < input_data.tsv
#done < test.in
