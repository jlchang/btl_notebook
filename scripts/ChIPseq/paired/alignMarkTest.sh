#!/usr/bin/env bash


eval export DK_ROOT="/broad/software/dotkit"; . /broad/software/dotkit/ksh/.dk_init
reuse -q .bwa-0.7.15
reuse -q .samtools-0.1.12a
reuse -q .java-jdk-1.8.0_121-x86-64
reuse -q .bedtools-2.26.0

# set to print each command and exit script if any command fails
set -euxo pipefail

# set exit script if any command fails (-e and -o pipefail) or unset variable found (-u)
#set -euo pipefail


# =============================
# Inputs:
# sampleName
# fastq1
# fastq2
# BWA genome index
# =============================

#sampleName
OFPREFIX="F05-CD-H3K27ac"
#OFPREFIX=$1

# fastq1
FASTQ_FILE_1="F05-CD-H3K27ac_S17_L001_R1_001.fastq.gz"
#FASTQ_FILE_1=$2
# fastq2
FASTQ_FILE_2="F05-CD-H3K27ac_S17_L001_R2_001.fastq.gz"
#FASTQ_FILE_2=$3

# BWA genome index
BWA_INDEX_NAME="/cil/shed/apps/external/AQUAS/genome_data/hg19/bwa_index/male.hg19.fa"
# threads
NTHREADS="1"


SAI_FILE_1="${OFPREFIX}_1.sai" 
SAI_FILE_2="${OFPREFIX}_2.sai" 
RAW_SAM_FILE="${OFPREFIX}.raw.sam.gz"
RAW_BAM_PREFIX="${OFPREFIX}"
RAW_BAM_FILE="${OFPREFIX}.bam"
RAW_BAM_FILE_MAPSTATS="${OFPREFIX}.flagstat.qc"


bwa aln -q 5 -l 32 -k 2 -t ${NTHREADS} ${BWA_INDEX_NAME} ${FASTQ_FILE_1} > ${SAI_FILE_1}
bwa aln -q 5 -l 32 -k 2 -t ${NTHREADS} ${BWA_INDEX_NAME} ${FASTQ_FILE_2} > ${SAI_FILE_2}
bwa sampe ${BWA_INDEX_NAME} ${SAI_FILE_1} ${SAI_FILE_2} ${FASTQ_FILE_1} ${FASTQ_FILE_2} | gzip -nc > ${RAW_SAM_FILE}
rm ${SAI_FILE_1} ${SAI_FILE_2}

# syntax sort syntax for samtools-0.1.12a, syntax for later versions of samtools will need modification
samtools view -bhS ${RAW_SAM_FILE} | samtools sort - ${RAW_BAM_PREFIX} 
rm ${RAW_SAM_FILE}
samtools flagstat ${RAW_BAM_FILE} > ${RAW_BAM_FILE_MAPSTATS}

FILT_BAM_PREFIX="${OFPREFIX}.filt.srt" 
FILT_BAM_FILE="${FILT_BAM_PREFIX}.bam" 
FULL_FILT_PREFIX="${OFPREFIX}.full_filt.srt"
FULL_FILT_BAM_FILE="${FULL_FILT_PREFIX}"
TMP_FILT_BAM_PREFIX="tmp.${FILT_BAM_PREFIX}.nmsrt" 
TMP_FILT_BAM_FILE="${TMP_FILT_BAM_PREFIX}.bam" 

MAPQ_THRESH=30

samtools view -bh -F 1804 -f 2 -q ${MAPQ_THRESH} ${RAW_BAM_FILE} | samtools sort -n - ${TMP_FILT_BAM_PREFIX} # Will produce name sorted BAM

# Remove orphan reads (pair was removed)
# and read pairs mapping to different chromosomes 
# Obtain position sorted BAM
# syntax sort syntax for samtools-0.1.12a, syntax for later versions of samtools will need modification
samtools fixmate ${TMP_FILT_BAM_FILE} ${OFPREFIX}.fixmate.tmp
samtools view -bh -F 1804 -f 2 ${OFPREFIX}.fixmate.tmp | samtools sort - ${FILT_BAM_PREFIX} 
rm ${OFPREFIX}.fixmate.tmp
rm ${TMP_FILT_BAM_FILE}
cp ${FILT_BAM_FILE} ${FULL_FILT_BAM_FILE}

# =============
# Mark duplicates
# =============

DUP_FILT_BAM_FILE="${FILT_BAM_PREFIX}.dupmark.bam" 
#MARKDUP="/seq/software/picard-public/current/picard.jar MarkDuplicates" 
MARKDUP="/seq/software/picard-public/2.14.0/picard.jar MarkDuplicates" 
DUP_FILE_QC="${FILT_BAM_PREFIX}.dup.qc"
java -Xmx4G -jar ${MARKDUP} INPUT=${FILT_BAM_FILE} OUTPUT=${DUP_FILT_BAM_FILE} METRICS_FILE=${DUP_FILE_QC} VALIDATION_STRINGENCY=LENIENT ASSUME_SORTED=true REMOVE_DUPLICATES=false
mv ${DUP_FILT_BAM_FILE} ${FILT_BAM_FILE}

java -Xmx4G -jar ${MARKDUP} INPUT=${RAW_BAM_FILE} OUTPUT=${RAW_BAM_PREFIX}.mdup.bam METRICS_FILE=${RAW_BAM_PREFIX}.mdup.qc VALIDATION_STRINGENCY=LENIENT ASSUME_SORTED=true REMOVE_DUPLICATES=false

samtools flagstat ${RAW_BAM_PREFIX}.mdup.bam >${RAW_BAM_PREFIX}.mdup.flagstat

# ============================ 
# Remove duplicates
# Index final position sorted BAM
# Create final name sorted BAM
# ============================ 
FINAL_BAM_PREFIX="${OFPREFIX}.filt.srt.nodup" 
FINAL_BAM_FILE="${FINAL_BAM_PREFIX}.bam" # To be stored 
FINAL_BAM_INDEX_FILE="${FINAL_BAM_PREFIX}.bai" 
FINAL_BAM_FILE_MAPSTATS="${FINAL_BAM_PREFIX}.flagstat.qc" # QC file 
FINAL_NMSRT_BAM_PREFIX="${OFPREFIX}.filt.nmsrt.nodup" 
FINAL_NMSRT_BAM_FILE="${FINAL_NMSRT_BAM_PREFIX}.bam" # To be stored
samtools view -F 1804 -f 2 -bh ${FILT_BAM_FILE} > ${FINAL_BAM_FILE} 
#samtools sort -n ${FINAL_BAM_FILE} ${FINAL_NMSRT_BAM_PREFIX}

samtools view -F 1804 -f 2 -bh ${RAW_BAM_PREFIX}.mdup.bam > ${RAW_BAM_PREFIX}.nodup.bam
samtools flagstat ${RAW_BAM_PREFIX}.nodup.bam > ${RAW_BAM_PREFIX}.nodup.flagstat

# Index Final BAM file
samtools index ${FINAL_BAM_FILE} ${FINAL_BAM_INDEX_FILE}
samtools flagstat ${FINAL_BAM_FILE} > ${FINAL_BAM_FILE_MAPSTATS}

# =============
# EstimateLibraryComplexity
# CollectAlignmentSummaryMetrics
# =============

ELC="/seq/software/picard-public/2.14.0/picard.jar EstimateLibraryComplexity"
CASM="/seq/software/picard-public/2.14.0/picard.jar CollectAlignmentSummaryMetrics"

java -Xmx4G -jar ${ELC} I=${FINAL_BAM_FILE} O=${FINAL_BAM_FILE}.elc

java -Xmx4G -jar ${CASM} R=${BWA_INDEX_NAME} I=${FINAL_BAM_FILE} O=${FINAL_BAM_FILE}.metrics
java -Xmx4G -jar ${CASM} R=${BWA_INDEX_NAME} I=${RAW_BAM_PREFIX}.mdup.bam O=${RAW_BAM_PREFIX}.mdup.metrics
java -Xmx4G -jar ${CASM} R=${BWA_INDEX_NAME} I=${RAW_BAM_PREFIX}.nodup.bam O=${RAW_BAM_PREFIX}.nodup.metrics

# =============
# run H3K27ac FRIP
# =============

cat /btl/projects/ChIPseq/ENCODE/data/IGV_tracks/wgEncodeBroadHistoneK562H3k27acStdAln.bed | bedtools coverage -a - -b ${FINAL_BAM_FILE} > ${FINAL_BAM_PREFIX}.H3K27ac.aquasbam.bedcov
awk '{ sum += $11 } END { print sum ; }' ${FINAL_BAM_PREFIX}.H3K27ac.aquasbam.bedcov > ${FINAL_BAM_PREFIX}.H3K27ac.aquasbam.rip
cat /btl/projects/ChIPseq/ENCODE/data/IGV_tracks/wgEncodeBroadHistoneK562H3k27acStdAln.bed | bedtools coverage -a - -b ${RAW_BAM_PREFIX}.nodup.bam > ${RAW_BAM_PREFIX}.H3K27ac.pairbam.bedcov
awk '{ sum += $11 } END { print sum ; }' ${RAW_BAM_PREFIX}.H3K27ac.pairbam.bedcov > ${RAW_BAM_PREFIX}.H3K27ac.pairbam.rip
