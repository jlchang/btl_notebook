#!/bin/bash

#####
#
# Miseq_SS2setup.sh <SSF#> <analysis iteration>
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

dirPath="/btl/analysis/SSF/SmartSeq2/MiSeq_QC"

if [ -e $dirPath/$1 ]
  then
    echo -n "An analysis directory already exists for $1, are you sure you wish to proceed? (y/n)"
    read 
    if ! [ $REPLY = "y" ]
      then
      exit
    fi
fi

mkdir -p $dirPath/$1

cp -i /cil/shed/apps/internal/wdl/smartseq_miseq.wdl $dirPath/$1/

#/cil/shed/sandboxes/jlchang/notebook/scripts/SmartSeq2/ss2json.sh $1 $2 > $dirPath/$1/input_$2.json
cat > $dirPath/$1/input_$2.json <<msg
{
  "smartseq_miseq.analysis_name": "$1_SmartSeqAnalysisV1.1_$2",
  "smartseq_miseq.input_samples_files": "$dirPath/$1/input_data.tsv",
  "smartseq_miseq.output_dir": "$dirPath/$1/$1_SmartSeqAnalysisV1.1_$2",
  "smartseq_miseq.sample_set_id": "$1",
  "smartseq_miseq.run_ercc": "false"
}
msg


echo "analysis directory created at $dirPath/$1"

#test=awk -F'"' 'NR==4 { print $4 }' $dirPath/$1/input.json
#if [ -e $test ]
#  then
#    echo "WARNING: $test does not exist at location specified in json file"
#fi 
echo
echo "create input_data.tsv then run the following commands:"
echo "use Python-2.7"
echo "/cil/shed/apps/internal/widdler/widdler.py run $dirPath/$1/smartseq_miseq.wdl $dirPath/$1/input_$2.json -D -o workflow_failure_mode:NoNewCalls -S btl-cromwell"
echo
echo "record workflowID and monitor at http://btl-cromwell:9000/api/workflows/v2/<workflowID>/timing"

###
#
# CHANGELOG
#
###

### 20180124
# user should input full JIRA ticket with prefix instead of just digits

### 20180117
# updated json keys to use new workflow name "smartseq_miseq" instead of "smrtseq"

### 20171029
# adapted SS2setup for MiSeq analysis

### 20171006
# new filesystem on iodine for SS2 analysis to alleviate I/O issues with Lightning (/btl/projects)
# extracted analysis location to variable at top of script
# incorporate steps from ss2json.sh into this script to eliminate needless dependencies

### 20170605 
# new feature of latest WDL is to create analysis directory based on path in json file
# having the gaag user create the directory prevents permission errors at the FinalCleanUp step
# mkdir -p /btl/projects/SSF/SmartSeq2/SSF-$1/SSF-$1_SmartSeqAnalysisV1.1_$2
# removed above line and make just the top level directory
