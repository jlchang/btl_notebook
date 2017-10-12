#!/bin/bash

echo "Reporting samples in this order:"

cat statsInput.txt 

read -r -p "Continue? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  exit
fi

echo "Total Reads"
for i in $(cat statsInput.txt); do ls -1 */*/qc/rep1/${i}_L001_R1_001.flagstat.qc | sort -n | xargs -n 1 head -1  | cut -d " " -f 1; done

echo "Analyzed Reads"
for i in $(cat statsInput.txt); do ls -1 */*/qc/rep1/${i}_L001_R1_001.nodup.flagstat.qc | sort -n | xargs -n 1 head -1 | cut -d " " -f 1; done
echo
echo "inputreads, %dup"
for i in $(cat statsInput.txt); do ls -1 */*/qc/rep1/${i}_L001_R1_001.dup.qc | xargs -n 1 sed -n 8p | awk '{ print $3,$9}'; done
echo
echo "RSC"
for i in $(cat statsInput.txt); do ls *_S*/*/qc/rep1/${i}_L001_R1_001.nodup.15M.cc.qc | xargs -n 1 awk '{ print $10 }'; done
echo
echo "make plots"
#source /broad/software/scripts/useuse
#use ImageMagick

#convert \( *_S?_single/*/qc/rep1/*_S1_*.nodup.15M.cc.plot.png *_S?_single/*/qc/rep1/*_S3_*.nodup.15M.cc.plot.png *_S?_single/*/qc/rep1/*_S5_*.nodup.15M.cc.plot.png -append \) \( *_S?_single/*/qc/rep1/*_S2_*.nodup.15M.cc.plot.png *_S?_single/*/qc/rep1/*_S4_*.nodup.15M.cc.plot.png *_S?_single/*/qc/rep1/*_S6_*.nodup.15M.cc.plot.png -append \) +append BTLDEV-1421.png

