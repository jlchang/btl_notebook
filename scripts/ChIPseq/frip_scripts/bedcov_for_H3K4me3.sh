#!/bin/bash
# script will create FRIP/H3K4me3 directory under top level directory for output
# run this script from top level aquas analysis directory

echo "running bedcov_for_H3K4me3.sh"
echo

target=$(pwd)
echo  "running script from $target"

read -r -p "Continue? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  exit
fi

if [[ ! -d FRIP/H3K4me3 ]]; then
  mkdir -p FRIP/H3K4me3
else
  echo "FRIP/H3K4me3 directory already exists, exiting to prevent overwrite..."
  exit
fi


source /broad/software/scripts/useuse
use BEDTools

echo "running FRIP on"
ls -d1 *_S*_*

read -r -p "Continue? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  exit
fi


for i in $(ls -d1 *_S*_*); do
  pushd "${i}/${i}_analysis/peak/macs2/rep1"
  full=$(expr length $i)
  desired=$(expr $full - 7)
  name=${i:0:$desired}
  ls
  echo "ready to calculate FRIP on H3K4me3 peaks"
  cat /btl/projects/ChIPseq/ENCODE/data/H3K27ac_K562/H3K4me3_truth_ENCFF616DLO.bed | bedtools coverage -a - -b ../../../align/rep1/${name}_L001_R1_001.nodup.bam > ${target}/FRIP/H3K4me3/${name}_H3K4me3.bedcov
  awk '{ sum += $11 } END { print sum ; }' ${target}/FRIP/H3K4me3/${name}_H3K4me3.bedcov > ${target}/FRIP/H3K4me3/${name}_H3K4me3.rip
  popd
done
