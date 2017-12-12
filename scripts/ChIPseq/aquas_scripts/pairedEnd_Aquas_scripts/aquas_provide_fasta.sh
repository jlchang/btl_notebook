#!/bin/bash

#$ -cwd
#$ -l h_vmem=15G


source /broad/software/scripts/useuse
use -q group=btl
use -q .aquas-201706
 
bds /cil/shed/apps/external/AQUAS/20170503_install/20170503_39a6383/chipseq_pipeline-master/chipseq.bds -no_par -type histone -species hg19 -fastq1_1 $1 -fastq1_2 $2 -out_dir $3

