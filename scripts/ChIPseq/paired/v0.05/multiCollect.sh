######################
#
#  multiCollect.sh
#
#  script to visit all mapq1 analyses in runs.txt and rerun gather
#
######################

#!/bin/bash

#run from /btl/analysis/ChIPseq/mapq1/ where runs.txt lives

# generate list of analyses using
#cd /btl/analysis/ChIPseq/mapq1/
# ls -1d */*/* > runs.txt

# set to print each command and exit script if any command fails
set -euxo pipefail

curr=`pwd`

SCRIPTDIR="/cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.05"

while read run
    do
        cd $run
        orig=`pwd`
        suffix=$(basename $orig)
        type=$(basename $(dirname $orig))
        ssf=$(basename $(dirname $(dirname $orig)))
        expt=${ssf}_${type}_${suffix}

        result=${expt}.metrics_p5.1
        mv ${result} ${expt}.broken_p5.1
        $SCRIPTDIR/collectExptMetrics.sh
        cd $curr
    done < runs.txt


