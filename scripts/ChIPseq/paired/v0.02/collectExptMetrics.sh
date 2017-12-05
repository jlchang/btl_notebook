######################
#
#  collectExptMetrics.sh
#
#  collect metrics from all samples in input_data.tsv into one file
#
######################

#!/bin/bash

orig=`pwd`
expt=$(basename $orig)

if [ -e ${expt}.metrics ]
  then
    echo "metrics file already exists, try again after you:"
    echo "rm ${expt}.metrics"
    exit
fi

set -e
echo "analysis directory is $orig"

echo "Expt	Sample	Tot_Reads	PE_Reads	PE_rip	PE_FRIP	MAPQ_Reads	mapqPE_rip	mapqPE_FRIP	aquas_Reads	aquas_rip	aquas_FRIP	CASM_R1_TOT	R1_CHIMERAS	R1_ADAPTER	CASM_R2_TOT	R2_CHIMERAS	R2_ADAPTER	ELC_PAIRS	pDUPLICATION	EstLibSize	MapRaw_Reads	PrInSeq_Reads	PropPr_Reads	PrSing_Reads	allDup_Reads	mapq0_Reads	mapq5_Reads	mapq10_Reads	mapq28_Reads	mapq29_Reads" >> ${expt}.metrics

while IFS=$'\t': read sample fastq1 fastq2
do
  echo "collect metrics for ${orig}/${sample}_PE/${sample}.metrics"
  metrics=$(tail -n1 ${orig}/${sample}_PE/${sample}.metrics)
  echo -ne "$expt\t" >> ${expt}.metrics
  echo -ne "$sample\t" >> ${expt}.metrics
  echo "$metrics" >> ${expt}.metrics
done < input_data.tsv
#done < test.in
