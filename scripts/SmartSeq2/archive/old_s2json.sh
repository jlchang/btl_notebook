#!/bin/bash

####
#
# SS2json <SSF#> <analysis iteration>
# json provided as stdout
#
####

if [ $# -lt 2 ]
  then
    echo "ERROR - please provide both an SSF number and a value for the analysis iternation"
    exit
fi

echo "{"
echo -e "  \x22smrtseq.analysis_name\x22: \x22SSF-$1_SmartSeqAnalysisV1.1_$2\x22,"
echo -e "  \x22smrtseq.input_samples_files\x22: \x22/btl/projects/SSF/SmartSeq2/SSF-$1/input_data.tsv\x22,"
echo -e "  \x22smrtseq.output_dir\x22: \x22/btl/projects/SSF/SmartSeq2/SSF-$1/SSF-$1_SmartSeqAnalysisV1.1_$2\x22,"
echo -e "  \x22smrtseq.sample_set_id\x22:\x22SSF-$1\x22,"
echo -e "  \x22smrtseq.run_ercc\x22:\x22false\x22"
echo "}"
