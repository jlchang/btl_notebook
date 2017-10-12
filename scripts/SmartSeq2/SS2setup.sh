#!/bin/bash

#####
#
# SS2setup.sh <SSF#> <analysis iteration>
#   changelog at bottom of script
#
#####

# Any subsequent commands which fail will cause the shell script to exit immediately
set -e

if [ $# -lt 2 ]
  then
    echo "ERROR - please provide both an SSF number and a value for the analysis iteration"
    exit
fi

dirPath="/btl/analysis/SSF/SmartSeq2"

if [ -e $dirPath/SSF-$1 ]
  then
    echo -n "An analysis directory already exists for SSF-$1, are you sure you wish to proceed? (y/n)"
    read 
    if ! [ $REPLY = "y" ]
      then
      exit
    fi
fi

mkdir -p $dirPath/SSF-$1

cp -i /cil/shed/apps/internal/wdl/smartseq.wdl $dirPath/SSF-$1/

#/cil/shed/sandboxes/jlchang/notebook/scripts/SmartSeq2/ss2json.sh $1 $2 > $dirPath/SSF-$1/input_$2.json
cat > $dirPath/SSF-$1/input_$2.json <<msg
{
  "smrtseq.analysis_name": "SSF-$1_SmartSeqAnalysisV1.1_$2",
  "smrtseq.input_samples_files": "/btl/analysis/SSF/SmartSeq2/SSF-$1/input_data.tsv",
  "smrtseq.output_dir": "/btl/analysis/SSF/SmartSeq2/SSF-$1/SSF-$1_SmartSeqAnalysisV1.1_$2",
  "smrtseq.sample_set_id": "SSF-$1",
  "smrtseq.run_ercc": "false"
}
msg


echo "analysis directory created at $dirPath/SSF-$1"

#test=awk -F'"' 'NR==4 { print $4 }' $dirPath/SSF-$1/input.json
#if [ -e $test ]
#  then
#    echo "WARNING: $test does not exist at location specified in json file"
#fi 
echo
echo "create input_data.tsv then run the following commands:"
echo "use Python-2.7"
echo "/cil/shed/apps/internal/widdler/widdler.py run $dirPath/SSF-$1/smartseq.wdl $dirPath/SSF-$1/input_$2.json -S btl-cromwell"
echo
echo "record workflowID and monitor at http://btl-cromwell:9000/api/workflows/v2/<workflowID>/timing"

###
#
# CHANGELOG
#
###



### 20171006
# new filesystem on iodine for SS2 analysis to alleviate I/O issues with Lightning (/btl/projects)
# extracted analysis location to variable at top of script
# incorporate steps from ss2json.sh into this script to eliminate needless dependencies

### 20170605 
# new feature of latest WDL is to create analysis directory based on path in json file
# having the gaag user create the directory prevents permission errors at the FinalCleanUp step
# mkdir -p /btl/projects/SSF/SmartSeq2/SSF-$1/SSF-$1_SmartSeqAnalysisV1.1_$2
# removed above line and make just the top level directory
