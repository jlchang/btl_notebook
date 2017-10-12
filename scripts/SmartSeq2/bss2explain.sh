#!/bin/bash

####
#
# bss2explain.sh <workflowID>
# check workflow failure messages on btl-cromwell
#
####i

source /broad/software/scripts/useuse
use Python-2.7
echo "/cil/shed/apps/internal/widdler/widdler.py explain $1 -S btl-cromwell"
/cil/shed/apps/internal/widdler/widdler.py explain $1 -S btl-cromwell
