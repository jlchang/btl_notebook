#!/bin/sh -x

##########################################
#Procedure for doing the dowsampling for
#calculating saturation in ChipSeq data
#for the basic ChIP Sequencing SSF product
#Written by: Michele Busby
#			 Catherine Li
#Last Changed: 2/13/15
##########################################


INPUT_BAM=$1
OUTPUT_DIR=$2
CONTROL=$3 #Control bam or homer directory or NONE
PEAK_STYLE=$4 #Usually factor or histone
GENOME_FILE=$5
PAIRED_END=$6 #TRUE If paired end or else FALSE
N_READS=$7 #The number of reads being downsampled to
CONTROL_DIR=$8
SCRIPT_DIR=$9
#SEED=$10 #set further down, if not supplied, default seed is used

echo INPUT_BAM $INPUT_BAM
echo OUTPUT_DIR $OUTPUT_DIR
echo CONTROL $CONTROL
echo PEAK_STYLE $PEAK_STYLE
echo GENOME_FILE $GENOME_FILE
echo PAIRED_END $PAIRED_END
echo N_READS $N_READS
echo QUEUE $QUEUE
echo SCRIPT_DIR $SCRIPT_DIR




##########################################
#Call software installed at Broad
##########################################

source /broad/software/scripts/useuse
use .homer-4.7
use .bedtools-version-2.17.0
use .igvtools_2.1.7
use .samtools-0.1.18


##########################################
#Do stuff
#########################################

STEM=$(basename "${INPUT_BAM}" .bam)


if [ -d $OUTPUT_DIR/Downsampling ] ;
then
    echo "Output directory $OUTPUT_DIR/Downsampling exists."
else
   echo "Output directory $OUTPUT_DIR/Downsampling does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Downsampling
fi

if [ -d $OUTPUT_DIR/Downsampling/bams ] ;
then
    echo "Output directory $OUTPUT_DIR/Downsampling/bams exists."
else
   echo "Output directory $OUTPUT_DIR/Downsampling/bams  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Downsampling/bams
fi

if [ -d $OUTPUT_DIR/Downsampling/Tags ] ;
then
    echo "Output directory $OUTPUT_DIR/Downsampling/tags exists."
else
   echo "Output directory $OUTPUT_DIR/Downsampling/tags  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Downsampling/Tags
fi

if [ -d $OUTPUT_DIR/Downsampling/Peaks ] ;
then
    echo "Output directory $OUTPUT_DIR/Downsampling/tags exists."
else
   echo "Output directory $OUTPUT_DIR/Downsampling/tags  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Downsampling/Peaks
fi

if [ $# -eq 9 ]
  then
    echo "No seed argument supplied, using default seed"
    SEED=""
  else
    echo "Setting SEED to $10"
    SEED="-seed $10"
fi

#Downsample data
/cil/shed/apps/internal/bam_utilities/GetRandomSampleByRead/GetRandomByRead -bam $INPUT_BAM -out $OUTPUT_DIR/Downsampling/bams/$STEM.$N_READS.bam -nReads $N_READS $SEED

#Make tags and call peaks

if [ "$PAIRED_END" == "TRUE" ];
then
	makeTagDirectory $OUTPUT_DIR/Downsampling/Tags/$STEM.$N_READS $OUTPUT_DIR/Downsampling/bams/$STEM.$N_READS.bam -genome $GENOME_FILE -illuminaPE -tbp 1
else
makeTagDirectory $OUTPUT_DIR/Downsampling/Tags/$STEM.$N_READS $OUTPUT_DIR/Downsampling/bams/$STEM.$N_READS.bam -genome $GENOME_FILE
fi

if [ "$CONTROL" == "NONE" ];
then
	echo "findPeaks $OUTPUT_DIR/$STEM -style $PEAK_STYLE -o $OUTPUT_DIR/Peaks/$STEM.calls "
	findPeaks $OUTPUT_DIR/Downsampling/Tags/$STEM.$N_READS -style $PEAK_STYLE -o $OUTPUT_DIR/Downsampling/Peaks/$STEM.$N_READS.calls

else
	echo "findPeaks $OUTPUT_DIR/$STEM -style $PEAK_STYLE -o $OUTPUT_DIR/Peaks/$STEM.calls -i $CONTROL_DIR"
	findPeaks $OUTPUT_DIR/Downsampling/Tags/$STEM.$N_READS -style $PEAK_STYLE -o $OUTPUT_DIR/Downsampling/Peaks/$STEM.$N_READS.calls -i $CONTROL_DIR
fi

#Count peaks
N_PEAKS=$(grep -v "^#" $OUTPUT_DIR/Downsampling/Peaks/$STEM.$N_READS.calls | awk '{ sum += $7 } END { print sum }')
echo N_PEAKS is $N_PEAKS
printf "%s\t%f\t%f\n" $STEM $N_READS $N_PEAKS >>$OUTPUT_DIR/Downsampling/nPeaksDownsampling.$STEM.txt

#Clean up files
#rm -rf $OUTPUT_DIR/Downsampling
