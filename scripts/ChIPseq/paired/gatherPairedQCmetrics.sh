#!/bin/bash

#sample="F05-CD-H3K27ac"
sample=$1

#Total Reads
TR=$(head -1 ${sample}.raw.flagstat | cut -d " " -f 1)

#PE Reads
PR=$(head -1 ${sample}.PE.nodup.flagstat | cut -d " " -f 1)

#aquasPE Reads
AR=$(head -1 ${sample}.aquasPE.nodup.flagstat | cut -d " " -f 1)

#CASM_R1_TOT
R1T=$(sed -n "8p" ${sample}.raw.dupmark.casm  | awk '{ print $2 }')
#CASM_R1_CHIMERAS
R1C=$(sed -n "8p" ${sample}.raw.dupmark.casm  | awk '{ print $23 }')
#CASM_R1_ADAPTER
R1A=$(sed -n "8p" ${sample}.raw.dupmark.casm  | awk '{ print $24 }')

#CASM_R2_TOT
R2T=$(sed -n "9p" ${sample}.raw.dupmark.casm  | awk '{ print $2 }')
#CASM_R2_CHIMERAS
R2C=$(sed -n "9p" ${sample}.raw.dupmark.casm  | awk '{ print $23 }')
#CASM_R2_ADAPTER
R2A=$(sed -n "9p" ${sample}.raw.dupmark.casm  | awk '{ print $24 }')

#ELC_READ_PAIRS_EXAMINED
elcpr=$(sed -n "8p" ${sample}.raw.elc  | awk '{ print $3 }')
#PERCENT_DUPLICATION
dup=$(sed -n "8p" ${sample}.raw.elc  | awk '{ print $9 }')
#ESTIMATED_LIBRARY_SIZE
els=$(sed -n "8p" ${sample}.raw.elc  | awk '{ print $10 }')

#PE_READS_in_H3K27ac_peaks
perip=$(cat ${sample}.PE.nodup.H3K27ac.rip)

#aquasPE_READS_in_H3K27ac_peaks
aqrip=$(cat ${sample}.aquasPE.nodup.H3K27ac.rip)

pefrip=$(echo "scale=4; $perip/$PR" | bc)
aqfrip=$(echo "scale=4; $aqrip/$AR" | bc)

echo -e "Tot_Reads\tPE_Reads\tPE_rip\tPE_FRIP\taquas_Reads\taquas_rip\taquas_FRIP\tCASM_R1_TOT\tR1_CHIMERAS\tR1_ADAPTER\tCASM_R2_TOT\tR2_CHIMERAS\tR2_ADAPTER\tELC_PAIRS\tpDUPLICATION\tEstLibSize"
echo -e "$TR\t$PR\t$perip\t$pefrip\t$AR\t$aqrip\t$aqfrip\t$R1T\t$R1C\t$R1A\t$R2T\t$R2C\t$R2A\t$elcpr\t$dup\t$els"


