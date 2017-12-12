######################
#
#  gatherPairedQCmetrics.sh
#
#  last step of alignMarkInput.sh to put gather metrics for the sample
#
######################


#!/bin/bash

#sample="F05-CD-H3K27ac"
sample=$1

#Total Reads
TR=$(head -1 ${sample}.raw.flagstat | cut -d " " -f 1)

#Mapped raw reads
MRR=$(sed -n "5p" ${sample}.raw.cleaned.dupmark.flagstat | grep mapped | awk '{ print $1}')

#Paired in Sequencing
PIS=$(sed -n "6p" ${sample}.raw.cleaned.dupmark.flagstat | grep sequencing | awk '{ print $1}')

#ProperlyPaired
PP=$(sed -n "9p" ${sample}.raw.cleaned.dupmark.flagstat | grep properly | awk '{ print $1}')

#Singletons
sing=$(sed -n "11p" ${sample}.raw.cleaned.dupmark.flagstat | grep singletons | awk '{ print $1}')

#all dups
adup=$(sed -n "4p" ${sample}.raw.cleaned.dupmark.flagstat | grep duplicates | awk '{ print $1}')

#with mate mapped to a different chr
mmdc=$(sed -n "12p" ${sample}.raw.cleaned.dupmark.flagstat | grep different | awk '{ print $1}')

#PE Reads
PR=$(head -1 ${sample}.PE.nodup.flagstat | cut -d " " -f 1)


#MAPQ Reads
MR=$(head -1 ${sample}.mapq0.PE.nodup.flagstat | cut -d " " -f 1)


#CASM_R1_TOT
R1T=$(sed -n "8p" ${sample}.raw.cleaned.dupmark.casm  | awk '{ print $2 }')
#CASM_R1_CHIMERAS
R1C=$(sed -n "8p" ${sample}.raw.cleaned.dupmark.casm  | awk '{ print $23 }')
#CASM_R1_ADAPTER
R1A=$(sed -n "8p" ${sample}.raw.cleaned.dupmark.casm  | awk '{ print $24 }')

#CASM_R2_TOT
R2T=$(sed -n "9p" ${sample}.raw.cleaned.dupmark.casm  | awk '{ print $2 }')
#CASM_R2_CHIMERAS
R2C=$(sed -n "9p" ${sample}.raw.cleaned.dupmark.casm  | awk '{ print $23 }')
#CASM_R2_ADAPTER
R2A=$(sed -n "9p" ${sample}.raw.cleaned.dupmark.casm  | awk '{ print $24 }')

#ELC_READ_PAIRS_EXAMINED
elcpr=$(sed -n "8p" ${sample}.raw.cleaned.elc  | awk '{ print $3 }')
#PERCENT_DUPLICATION
dup=$(sed -n "8p" ${sample}.raw.cleaned.elc  | awk '{ print $9 }')
#ESTIMATED_LIBRARY_SIZE
els=$(sed -n "8p" ${sample}.raw.cleaned.elc  | awk '{ print $10 }')

#PE_READS_in_H3K27ac_peaks
perip=$(cat ${sample}.PE.nodup.H3K27ac.rip)

#mapqPE_READS_in_H3K27ac_peaks
mperip=$(cat ${sample}.mapq0.PE.nodup.H3K27ac.rip)


pefrip=$(echo "scale=4; $perip/$PR" | bc)
mpefrip=$(echo "scale=4; $mperip/$MR" | bc)

#map0
mapq0=$(sed -n "1p" ${sample}.raw.cleaned.bam.below_Mapq30.count.bin | grep mapq0 | cut -f 4)

#map5
mapq5=$(sed -n "2p" ${sample}.raw.cleaned.bam.below_Mapq30.count.bin | grep mapq5 | cut -f 4)

#map10
mapq10=$(sed -n "3p" ${sample}.raw.cleaned.bam.below_Mapq30.count.bin | grep mapq10 | cut -f 4)

#map28
mapq28=$(sed -n "7p" ${sample}.raw.cleaned.bam.below_Mapq30.count.bin | grep mapq28 | cut -f 4)

#map29
mapq29=$(sed -n "8p" ${sample}.raw.cleaned.bam.below_Mapq30.count.bin | grep mapq29 | cut -f 4)

echo -e "Tot_Reads\tPE_Reads\tPE_rip\tPE_FRIP\tMAPQ0_Reads\tmapqPE_rip\tmapqPE_FRIP\tCASM_R1_TOT\tR1_CHIMERAS\tR1_ADAPTER\tCASM_R2_TOT\tR2_CHIMERAS\tR2_ADAPTER\tELC_PAIRS\tpDUPLICATION\tEstLibSize\tMapRaw_Reads\tPrInSeq_Reads\tPropPr_Reads\tPrSing_Reads\tallDup_Reads\tmapq0_Reads\tmapq5_Reads\tmapq10_Reads\tmapq28_Reads\tmapq29_Reads\tmmdc_Reads"
echo -e "$TR\t$PR\t$perip\t$pefrip\t$MR\t$mperip\t$mpefrip\t$R1T\t$R1C\t$R1A\t$R2T\t$R2C\t$R2A\t$elcpr\t$dup\t$els\t$MRR\t$PIS\t$PP\t$sing\t$adup\t$mapq0\t$mapq5\t$mapq10\t$mapq28\t$mapq29\t$mmdc"


