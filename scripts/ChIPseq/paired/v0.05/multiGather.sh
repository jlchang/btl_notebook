######################
#
#  multiGather.sh
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

orig=`pwd`

SCRIPTDIR="/cil/shed/sandboxes/jlchang/notebook/scripts/ChIPseq/paired/v0.05"

while read run
    do
        cd $run
        $SCRIPTDIR/updateGather.sh
        cd $orig
    done < runs.txt


