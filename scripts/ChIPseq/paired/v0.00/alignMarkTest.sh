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
#OFPREFIX="$1"

# fastq1
FASTQ_FILE_1="F05-CD-H3K27ac_S17_L001_R1_001.fastq.gz"
#FASTQ_FILE_1="$2"
# fastq2
FASTQ_FILE_2="F05-CD-H3K27ac_S17_L001_R2_001.fastq.gz"
#FASTQ_FILE_2="$3"

# BWA genome index
BWA_INDEX_NAME="/cil/shed/apps/external/AQUAS/genome_data/hg19/bwa_index/male.hg19.fa"
# threads
NTHREADS="1"


SAI_FILE_1="${OFPREFIX}_1.sai" 
SAI_FILE_2="${OFPREFIX}_2.sai" 
RAW_SAM_FILE="${OFPREFIX}.raw.sam.gz"
RAW_BAM_PREFIX="${OFPREFIX}.raw"
RAW_BAM_FILE="${RAW_BAM_PREFIX}.bam"
RAW_BAM_FILE_MAPSTATS="${RAW_BAM_PREFIX}.flagstat"


bwa aln -q 5 -l 32 -k 2 -t ${NTHREADS} ${BWA_INDEX_NAME} ${FASTQ_FILE_1} > ${SAI_FILE_1}
bwa aln -q 5 -l 32 -k 2 -t ${NTHREADS} ${BWA_INDEX_NAME} ${FASTQ_FILE_2} > ${SAI_FILE_2}
bwa sampe ${BWA_INDEX_NAME} ${SAI_FILE_1} ${SAI_FILE_2} ${FASTQ_FILE_1} ${FASTQ_FILE_2} | gzip -nc > ${RAW_SAM_FILE}
#clean up intermediate files
rm ${SAI_FILE_1} ${SAI_FILE_2}

# following command has sort syntax for samtools-0.1.12a, syntax for later versions of samtools will need modification
samtools view -bhS ${RAW_SAM_FILE} | samtools sort - ${RAW_BAM_PREFIX}
#clean up intermediate files
rm ${RAW_SAM_FILE}
samtools flagstat ${RAW_BAM_FILE} > ${RAW_BAM_FILE_MAPSTATS}



# =============
# create "aquas-flavored" bam
# MAPQ 30 & -F 1804 filtering
# fixmate and -F 1804 filtering
# =============

TMP_FILT_BAM_PREFIX="tmp.${OFPREFIX}.filt.srt.nmsrt" 
TMP_FILT_BAM_FILE="${TMP_FILT_BAM_PREFIX}.bam" 
FULL_FILT_BAM_PREFIX="${OFPREFIX}.full_filt"
FULL_FILT_BAM_FILE="${FULL_FILT_BAM_PREFIX}.bam"

MAPQ_THRESH=30

samtools view -bh -F 1804 -f 2 -q ${MAPQ_THRESH} ${RAW_BAM_FILE} | samtools sort -n - ${TMP_FILT_BAM_PREFIX} # Will produce name sorted BAM for fixmate

# Remove orphan reads (pair was removed)
# and read pairs mapping to different chromosomes 
# Obtain position sorted BAM
# following command has sort syntax for samtools-0.1.12a, syntax for later versions of samtools will need modification
samtools fixmate ${TMP_FILT_BAM_FILE} ${OFPREFIX}.fixmate.tmp
samtools view -bh -F 1804 -f 2 ${OFPREFIX}.fixmate.tmp | samtools sort - ${FULL_FILT_BAM_PREFIX} 

samtools flagstat ${FULL_FILT_BAM_FILE} > ${FULL_FILT_BAM_PREFIX}.flagstat

#clean up intermediate files
rm ${OFPREFIX}.fixmate.tmp
rm ${TMP_FILT_BAM_FILE}

# =============
# Mark duplicates
# =============

###"dup_filt" for dev, not keeping for prod
DUPMARK_FILT_BAM_PREFIX="${FULL_FILT_BAM_PREFIX}.dupmark"
DUPMARK_FILT_BAM_FILE="${DUPMARK_FILT_BAM_PREFIX}.bam" 
DUPMARK_FILT_QC="${DUPMARK_FILT_BAM_PREFIX}.markdupMetrics"
#MARKDUP="/seq/software/picard-public/current/picard.jar MarkDuplicates" 
MARKDUP="/seq/software/picard-public/2.14.0/picard.jar MarkDuplicates" 
java -Xmx4G -jar ${MARKDUP} INPUT=${FULL_FILT_BAM_FILE} OUTPUT=${DUPMARK_FILT_BAM_FILE} METRICS_FILE=${DUPMARK_FILT_QC} VALIDATION_STRINGENCY=LENIENT ASSUME_SORTED=true REMOVE_DUPLICATES=false

samtools flagstat ${DUPMARK_FILT_BAM_FILE} >${DUPMARK_FILT_BAM_PREFIX}.flagstat



DUPMARK_RAW_BAM_PREFIX="${RAW_BAM_PREFIX}.dupmark"
DUPMARK_RAW_BAM_FILE="${DUPMARK_RAW_BAM_PREFIX}.bam"
DUPMARK_RAW_BAM_QC="${DUPMARK_RAW_BAM_PREFIX}.markdupMetrics"
java -Xmx4G -jar ${MARKDUP} INPUT=${RAW_BAM_FILE} OUTPUT=${DUPMARK_RAW_BAM_FILE} METRICS_FILE=${DUPMARK_RAW_BAM_QC} VALIDATION_STRINGENCY=LENIENT ASSUME_SORTED=true REMOVE_DUPLICATES=false

samtools flagstat ${DUPMARK_RAW_BAM_FILE} >${DUPMARK_RAW_BAM_PREFIX}.flagstat

#clean up intermediate files
rm ${FULL_FILT_BAM_FILE}


# ============================ 
# Remove duplicates
# Index position sorted BAMs
##### (not necessary?) Create final name sorted BAM
# ============================ 
AQUAS_BAM_PREFIX="${OFPREFIX}.aquasPE.nodup" 
AQUAS_BAM_FILE="${AQUAS_BAM_PREFIX}.bam" # To be stored 
AQUAS_BAM_INDEX_FILE="${AQUAS_BAM_PREFIX}.bai" 
AQUAS_BAM_FILE_MAPSTATS="${AQUAS_BAM_PREFIX}.flagstat" # QC file 
#####AQUAS_NMSRT_BAM_PREFIX="${OFPREFIX}.aquasPE.nmsrt.nodup" 
#####AQUAS_NMSRT_BAM_FILE="${AQUAS_NMSRT_BAM_PREFIX}.bam" # To be stored
samtools view -F 1804 -f 2 -bh ${DUPMARK_FILT_BAM_FILE} > ${AQUAS_BAM_FILE} 
#####samtools sort -n ${AQUAS_BAM_FILE} ${AQUAS_NMSRT_BAM_PREFIX}



PAIRED_BAM_PREFIX="${OFPREFIX}.PE.nodup" 
PAIRED_BAM_FILE="${PAIRED_BAM_PREFIX}.bam" # To be stored 
PAIRED_BAM_INDEX_FILE="${PAIRED_BAM_PREFIX}.bai" 
PAIRED_BAM_FILE_MAPSTATS="${PAIRED_BAM_PREFIX}.flagstat" # QC file 
samtools view -F 1804 -f 2 -bh ${DUPMARK_RAW_BAM_FILE} > ${PAIRED_BAM_FILE}


# Index Final BAM files
samtools index ${AQUAS_BAM_FILE} ${AQUAS_BAM_INDEX_FILE}
samtools index ${PAIRED_BAM_FILE} ${PAIRED_BAM_INDEX_FILE}


# Final BAM flagstats
samtools flagstat ${AQUAS_BAM_FILE} > ${AQUAS_BAM_FILE_MAPSTATS}
samtools flagstat ${PAIRED_BAM_FILE} > ${PAIRED_BAM_FILE_MAPSTATS}


# =============
# EstimateLibraryComplexity
# CollectAlignmentSummaryMetrics
# =============

ELC="/seq/software/picard-public/2.14.0/picard.jar EstimateLibraryComplexity"
CASM="/seq/software/picard-public/2.14.0/picard.jar CollectAlignmentSummaryMetrics"

java -Xmx4G -jar ${ELC} I=${RAW_BAM_FILE} O=${RAW_BAM_PREFIX}.elc
java -Xmx4G -jar ${ELC} I=${DUPMARK_RAW_BAM_FILE} O=${DUPMARK_RAW_BAM_PREFIX}.elc
java -Xmx4G -jar ${ELC} I=${DUPMARK_FILT_BAM_FILE} O=${DUPMARK_FILT_BAM_PREFIX}.elc

java -Xmx4G -jar ${CASM} R=${BWA_INDEX_NAME} I=${AQUAS_BAM_FILE} O=${AQUAS_BAM_PREFIX}.casm
java -Xmx4G -jar ${CASM} R=${BWA_INDEX_NAME} I=${PAIRED_BAM_FILE} O=${PAIRED_BAM_PREFIX}.casm

java -Xmx4G -jar ${CASM} R=${BWA_INDEX_NAME} I=${DUPMARK_RAW_BAM_FILE} O=${DUPMARK_RAW_BAM_PREFIX}.casm

rm ${DUPMARK_RAW_BAM_FILE}
rm ${DUPMARK_FILT_BAM_FILE}



# =============
# run H3K27ac FRIP
# =============

cat /btl/projects/ChIPseq/ENCODE/data/IGV_tracks/wgEncodeBroadHistoneK562H3k27acStdAln.bed | bedtools coverage -a - -b ${AQUAS_BAM_FILE} > ${AQUAS_BAM_PREFIX}.H3K27ac.bedcov
awk '{ sum += $11 } END { print sum ; }' ${AQUAS_BAM_PREFIX}.H3K27ac.bedcov > ${AQUAS_BAM_PREFIX}.H3K27ac.rip
cat /btl/projects/ChIPseq/ENCODE/data/IGV_tracks/wgEncodeBroadHistoneK562H3k27acStdAln.bed | bedtools coverage -a - -b ${PAIRED_BAM_FILE} > ${PAIRED_BAM_PREFIX}.H3K27ac.bedcov
awk '{ sum += $11 } END { print sum ; }' ${PAIRED_BAM_PREFIX}.H3K27ac.bedcov > ${PAIRED_BAM_PREFIX}.H3K27ac.rip
