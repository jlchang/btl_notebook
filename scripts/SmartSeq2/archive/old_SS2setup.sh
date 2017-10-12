#!/bin/bash

#####
#
# SS2setup.sh <SSF#> <analysis iteration>
#
#####

# Any subsequent commands which fail will cause the shell script to exit immediately
set -e

if [ $# -lt 2 ]
  then
    echo "ERROR - please provide both an SSF number and a value for the analysis iteration"
    exit
fi

if [ -e /btl/projects/SSF/SmartSeq2/SSF-$1 ]
  then
    echo -n "An analysis directory already exists for SSF-$1, are you sure you wish to proceed? (y/n)"
    read 
    if ! [ $REPLY = "y" ]
      then
      exit
    fi
fi

### new feature of latest WDL is to create analysis directory based on path in json file
# having the gaag user create the directory prevents permission errors at the FinalCleanUp step
# mkdir -p /btl/projects/SSF/SmartSeq2/SSF-$1/SSF-$1_SmartSeqAnalysisV1.1_$2
# modified Jun 5 2017 to make just the top level directory
mkdir -p /btl/projects/SSF/SmartSeq2/SSF-$1

cp -i /cil/shed/apps/internal/wdl/smartseq.wdl /btl/projects/SSF/SmartSeq2/SSF-$1/

/cil/shed/sandboxes/jlchang/notebook/scripts/SmartSeq2/ss2json.sh $1 $2 > /btl/projects/SSF/SmartSeq2/SSF-$1/input_$2.json

echo "analysis directory created at /btl/projects/SSF/SmartSeq2/SSF-$1"

#test=awk -F'"' 'NR==4 { print $4 }' /btl/projects/SSF/SmartSeq2/SSF-$1/input.json
#if [ -e $test ]
#  then
#    echo "WARNING: $test does not exist at location specified in json file"
#fi 
echo
echo "create input_data.tsv then run the following commands:"
echo "use Python-2.7"
echo "/cil/shed/apps/internal/widdler/widdler.py run /btl/projects/SSF/SmartSeq2/SSF-$1/smartseq.wdl /btl/projects/SSF/SmartSeq2/SSF-$1/input_$2.json -S btl-cromwell"
echo
echo "record workflowID and monitor at http://btl-cromwell:9000/api/workflows/v2/<workflowID>/timing"
