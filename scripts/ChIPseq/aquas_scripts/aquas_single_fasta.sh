#!/bin/bash

#$ -cwd

source /broad/software/scripts/useuse
use -q group=btl
use -q .aquas-201706
 
bds /cil/shed/apps/external/AQUAS/20170503_install/20170503_39a6383/chipseq_pipeline-master/chipseq.bds -no_par -true_rep -type histone -species hg19 -fastq1_1 $1 -out_dir $2

