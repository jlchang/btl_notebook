#!/bin/sh -x

##########################################
#Modification of ChipSeqProcessAllBamsInDirectory.sh script
#by Michele Busby
# to run downsample script at specific numbers of reads
# specified in ChipSeqSubsamplePipeline.sh
# modified by Jean Chang
# Last Changed: $Format:%ci$ ($Format:%H$)
# $Id$
##########################################

INPUT_DIR=$1
OUTPUT_DIR=$2
CONTROL=$3 #Control bam or homer directory or NONE
PEAK_STYLE=$4 #Usually factor or histone
GENOME_FILE=$5
PAIRED_END=$6 #TRUE If paired end or else FALSE
QUEUE=$7
SCRIPT_DIR=$8
#SUBSAMPLE_ITERATIONS=$9 set further down, default is 2 if not supplied

source /broad/software/scripts/useuse
use .homer-4.7
use .bedtools-2.17.0
use igvtools_2.3
use .samtools-0.1.18
use UGER

echo INPUT_DIR $INPUT_DIR
echo OUTPUT_DIR $OUTPUT_DIR
echo CONTROL $CONTROL
echo PEAK_STYLE $PEAK_STYLE
echo GENOME_FILE $GENOME_FILE
echo PAIRED_END $PAIRED_END
echo QUEUE $QUEUE
echo SCRIPT_DIR $SCRIPT_DIR


ORIGINAL_CONTROL_BAM=$CONTROL

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_DIR

#If output directory does not exist make it
if [ -d $OUTPUT_DIR ] ; then
    echo "Output directory $OUTPUT_DIR exists."
else
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR
fi

if [ -d $OUTPUT_DIR/Peaks ] ; then
    echo "Output directory $OUTPUT_DIR/Peaks exists."
else
   echo "Output directory $OUTPUT_DIR/Peaks  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Peaks
fi

if [ -d $OUTPUT_DIR/Peaks/bed ] ; then
    echo "Output directory $OUTPUT_DIR/Peaks/bed exists."
else
   echo "Output directory $OUTPUT_DIR/Peaks/bed  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Peaks/bed
fi

cp BTL-logo.png $OUTPUT_DIR

##########################################
#Get fileName
##########################################

fileNames=( $( ls $INPUT_DIR/*.bam) )


##########################################
#Make tag directory for control bam
##########################################



if [ "$CONTROL"  != "NONE" ]  &&   [ -f  "$CONTROL" ];
then
	echo "Control is a file, assuming bam"
	CONTROL_STEM=$(basename "${CONTROL}" .bam)
	ORIGINAL_CONTROL_BAM=$CONTROL

	echo CONTROL_STEM is $CONTROL_STEM

	CONTROL_BAM=$CONTROL;
	CONTROL_DIR="$OUTPUT_DIR/Tags/$CONTROL_STEM"

	if [ "$PAIRED_END" == "TRUE" ]; then
		echo "Paired end"
		echo "makeTagDirectory $OUTPUT_DIR/$CONTROL_STEM$CONTROL_BAM -genome $GENOME_FILE -illuminaPE -checkGC -tbp 1"
		makeTagDirectory $CONTROL_DIR $CONTROL_BAM -genome $GENOME_FILE  -illuminaPE -checkGC -tbp 1


	else
		echo "Not paired end"
		echo "makeTagDirectory $OUTPUT_DIR/$CONTROL_STEM $CONTROL_BAM -genome $GENOME_FILE -checkGC "
		makeTagDirectory $CONTROL_DIR $CONTROL_BAM -genome $GENOME_FILE -checkGC

	fi
elif [ "$CONTROL"  != "NONE" ]  &&  [ -d  "$CONTROL" ]; then
		echo "Control is a directory, assuming processed homer peaks"
		CONTROL_DIR="$CONTROL";
		echo "Control dir is $CONTROL_DIR "

else
	echo "Nothing found for control $CONTROL"
	CONTROL_DIR=$CONTROL
fi

echo Finished processing control

if [ $# -eq 8 ]
  then
    echo "No subsample iteration argument supplied, setting to 2 iterations"
    SUBSAMPLE_ITERATIONS=2
  else
    echo "Setting subsample iteration to $9"
    SUBSAMPLE_ITERATIONS=$9
fi

for f in ${fileNames[@]}; do

	echo processing filename $f

	if [ $f != $ORIGINAL_CONTROL_BAM ]
	then
	STEM=$(basename "${f}" .bam)

	echo "qsub -V -cwd -j y -b y -o $OUTPUT_DIR -q long -l h_vmem=32g sh $SCRIPT_DIR/ChipSeqSubsamplePipeline.sh $f $OUTPUT_DIR $CONTROL_DIR $PEAK_STYLE $GENOME_FILE $PAIRED_END $QUEUE $SCRIPT_DIR"

  	qsub -V -cwd -j y -b y -o $OUTPUT_DIR -q long -l h_vmem=32g sh $SCRIPT_DIR/ChipSeqSubsamplePipeline.sh $f $OUTPUT_DIR $CONTROL_DIR $PEAK_STYLE $GENOME_FILE $PAIRED_END $QUEUE $SCRIPT_DIR

	fi

done
