######################
#
#  visitInputSamples.sh
#
#  
#
######################



#!/bin/bash

eval export DK_ROOT="/broad/software/dotkit"; . /broad/software/dotkit/ksh/.dk_init
reuse -q .r-3.3.0

orig=`pwd`
expt=$(basename $orig)

if [ -e ${expt}.metrics ]
  then
    echo "metrics file exists, replacing with new metrics file"
    echo "mv ${expt}.metrics ${expt}.metrics_orig"
    mv ${expt}.metrics ${expt}.metrics_orig
fi

set -e
echo "analysis directory is $orig"

echo "Expt	Sample	Tot_Reads	PE_Reads	PE_rip	PE_FRIP	MAPQ_Reads	mapqPE_rip	mapqPE_FRIP	aquas_Reads	aquas_rip	aquas_FRIP	CASM_R1_TOT	R1_CHIMERAS	R1_ADAPTER	CASM_R2_TOT	R2_CHIMERAS	R2_ADAPTER	ELC_PAIRS	pDUPLICATION	EstLibSize	MapRaw_Reads	PrInSeq_Reads	PropPr_Reads	PrSing_Reads	allDup_Reads	mapq0_Reads	mapq5_Reads	mapq10_Reads	mapq28_Reads	mapq29_Reads	mmdc_Reads" >> ${expt}.metrics

while IFS=$'\t': read sample fastq1 fastq2
do
  cd ${orig}/${sample}_PE
  if [ -e ${sample}.metrics ]
    then
    echo "replace old metrics file with additional metrics"
    mv ${sample}.metrics ${sample}.metrics_orig
  fi
  Rscript /cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.02/processMapqCounts.R
  /cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.02/gatherPairedQCmetrics.sh ${sample} > ${sample}.metrics
  echo "gather metrics for ${orig}/${sample}_PE/${sample}.metrics"
  cd ${orig}
  metrics=$(tail -n1 ${orig}/${sample}_PE/${sample}.metrics)
  echo -ne "$expt\t" >> ${expt}.metrics
  echo -ne "$sample\t" >> ${expt}.metrics
  echo "$metrics" >> ${expt}.metrics
done < input_data.tsv
#done < test.in

Rscript /cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.02/calcExptMetrics.R
