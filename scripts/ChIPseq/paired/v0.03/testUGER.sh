######################
#
#  testUGER.sh
#
#  testing host avoidance syntax
#
######################


#!/bin/bash

source /broad/software/scripts/useuse
use UGER

set -e

UUID=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)

sampleNO=0

jobname="P${UUID}_$sampleNO"

UGERPARAMS="-cwd -N $jobname -b y"
#syntax for host avoidance conflicts with variable substitution for job name

echo "job to run: qsub $UGERPARAMS sleep 10"
#avoid UGER hosts, put exclusions in qsub line-cannot pass through variable
echo "excluding hosts uger-c066|uger-c024"
#example format below
#-l h='!(uger-c075|uger-c088)'

qsub $UGERPARAMS -l h="!(uger-c075|uger-c088)" sleep 10 
