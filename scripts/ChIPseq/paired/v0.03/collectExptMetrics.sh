######################
#
#  collectExptMetrics.sh
#
#  collect metrics from all samples in input_data.tsv into one file
#
######################

#!/bin/bash

orig=`pwd`
suffix=$(basename $orig)
ssf=$(basename $(dirname $(dirname $orig)))
expt=${ssf}_${suffix}


SCRIPTDIR="/cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.03"

if [ -e ${expt}.metrics ]
  then
    echo "metrics file already exists, try again after you:"
    echo "rm ${expt}.metrics"
    exit
fi

set -e
echo "analysis directory is $orig"

#mapq counting incorrect, removing as metric (20171214)
#echo "Expt	Sample	Ctrl	Tot_Reads	MAPQ0_Reads	mapq0PE_rip	mapq0PE_FRIP	R1_CHIMERAS	R1_ADAPTER	R2_CHIMERAS	R2_ADAPTER	pDUPLICATION	EstLibSize	MapRaw_Reads	PropPr_Reads	PrSing_Reads	mmdc_Reads	pDup_Reads	mapq0_Reads	mapq5_Reads	mapq10_Reads	mapq28_Reads	mapq29_Reads" >> ${expt}.metrics

echo "Expt	Sample	Ctrl	Tot_Reads	MAPQ0_Reads	mapq0PE_rip	mapq0PE_FRIP	R1_CHIMERAS	R1_ADAPTER	R2_CHIMERAS	R2_ADAPTER	pDUPLICATION	EstLibSize	MapRaw_Reads	PropPr_Reads	PrSing_Reads	mmdc_Reads	pDup_Reads" >> ${expt}.metrics

while IFS=$'\t': read sample fastq1 fastq2
do
  echo "collect metrics for ${orig}/${sample}_PE/${sample}.metrics"
#  cd ${sample}_PE
#  $SCRIPTDIR/gatherPairedAlignMarkDmetrics.sh ${sample} > ${sample}.metrics
#  cd $orig
  metrics=$(tail -n1 ${orig}/${sample}_PE/${sample}.metrics)
  echo -ne "$expt\t" >> ${expt}.metrics
  echo -ne "$sample\t" >> ${expt}.metrics
  echo -ne "$(grep $sample control_info.txt | cut -f 2)\t" >> ${expt}.metrics
  echo "$metrics" >> ${expt}.metrics
done < input_data.tsv
#done < test.in
