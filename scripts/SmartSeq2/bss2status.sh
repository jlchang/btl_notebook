#!/bin/bash

####
#
# bss2status.sh <workflowID>
# check workflow status on btl-cromwell
#
####i

source /broad/software/scripts/useuse
use Python-2.7
echo "/cil/shed/apps/internal/widdler/widdler.py query $1 -s -S btl-cromwell"
echo "-m metadata    -l logs"
/cil/shed/apps/internal/widdler/widdler.py query $1 -s -S btl-cromwell
