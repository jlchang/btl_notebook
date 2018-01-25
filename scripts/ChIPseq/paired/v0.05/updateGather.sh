######################
#
#  updateGather.sh
#
#  script to visit all mapq1 analyses and rerun gather and collect scripts 
#
######################

#!/bin/bash

#run from /btl/analysis/ChIPseq/mapq1/ where runs.txt lives

# generate list of analyses using
#cd /btl/analysis/ChIPseq/mapq1/
# ls -1d *-*/*/* > runs.txt

# set to print each command and exit script if any command fails
set -euxo pipefail

orig=`pwd`

SCRIPTDIR="/cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.05"

    while IFS=$'\t': read sample fastq1 fastq2
    do
        cd ${sample}_PE
        $SCRIPTDIR/gatherPairedAlignMarkDmetrics.sh $sample > ${sample}.Metrics
        cd $orig
    done < input_data.tsv
    $SCRIPTDIR/collectExptMetrics.sh

