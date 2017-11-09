#!/bin/bash
# script will create FRIP/H1hesc directory under top level directory for output
# run this script from top level aquas analysis directory

cellType="H1hesc"

echo "running bedcov_for_IGV${cellType}.sh"
echo

target=$(pwd)
echo  "running script from $target"

read -r -p "Continue? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  exit
fi

if [[ ! -d FRIP/IGV${cellType} ]]; then
  mkdir -p FRIP/IGV${cellType}
else
  echo "FRIP/IGV${cellType} directory already exists, exiting to prevent overwrite..."
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
  echo "ready to calculate FRIP on IGV ${cellType} peaks"
  cat /btl/projects/ChIPseq/ENCODE/data/IGV_tracks/wgEncodeBroadHistoneH1hescH3k27acStdPk.bed | bedtools coverage -a - -b ../../../align/rep1/${name}_L001_R1_001.nodup.bam > ${target}/FRIP/IGV${cellType}/${name}_IGV${cellType}.bedcov
  awk '{ sum += $4 } END { print sum ; }' ${target}/FRIP/IGV${cellType}/${name}_IGV${cellType}.bedcov > ${target}/FRIP/IGV${cellType}/${name}_IGV${cellType}.rip
  popd
done
