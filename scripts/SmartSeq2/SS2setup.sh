#!/bin/bash

#####
#
# SS2setup.sh <SSF#> <analysis iteration>
#
#####

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

mkdir -p /btl/projects/SSF/SmartSeq2/SSF-$1/SSF-$1_SmartSeqAnalysisV1.1_$2

cp -i /cil/shed/apps/internal/wdl/smartseq.wdl /btl/projects/SSF/SmartSeq2/SSF-$1/

/cil/shed/sandboxes/jlchang/notebook/scripts/SmartSeq2/SS2json.sh $1 $2 > /btl/projects/SSF/SmartSeq2/SSF-$1/input_$2.json

#test=awk -F'"' 'NR==4 { print $4 }' /btl/projects/SSF/SmartSeq2/SSF-$1/input.json
#if [ -e $test ]
#  then
#    echo "WARNING: $test does not exist at location specified in json file"
#fi 
#    
