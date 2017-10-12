#!/bin/bash
# script will create FRIP/H3K27ac directory under top level directory for output
# run this script from top level aquas analysis directory

echo "running bedcov_for_IGVH3K27ac.sh"
echo

target=$(pwd)
echo  "running script from $target"

read -r -p "Continue? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  exit
fi

if [[ ! -d FRIP/IGVH3K27ac ]]; then
  mkdir -p FRIP/IGVH3K27ac
#else
#  echo "FRIP/IGVH3K27ac directory already exists, exiting to prevent overwrite..."
#  exit
fi


source /broad/software/scripts/useuse
use BEDTools

echo "running FRIP on"
cat fripInput.txt

read -r -p "Continue? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  exit
fi


for i in $(cat fripInput.txt); do
  pushd "${i}_single/${i}_single_analysis/peak/macs2/rep1"
  ls
  echo "ready to calculate FRIP on IGV H3K27ac peaks"
  cat /btl/projects/ChIPseq/ENCODE/data/IGV_tracks/wgEncodeBroadHistoneK562H3k27acStdAln.bed | bedtools coverage -a - -b ../../../align/rep1/${i}.bam > ${target}/FRIP/IGVH3K27ac/${i}_IGVH3K27ac.bedcov
  awk '{ sum += $11 } END { print sum ; }' ${target}/FRIP/IGVH3K27ac/${i}_IGVH3K27ac.bedcov > ${target}/FRIP/IGVH3K27ac/${i}_IGVH3K27ac.rip
  popd
done
