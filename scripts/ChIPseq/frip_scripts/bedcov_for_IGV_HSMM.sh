#!/bin/bash
# script will create FRIP/HSMM directory under top level directory for output
# run this script from top level aquas analysis directory

echo "running bedcov_for_IGVHSMM.sh"
echo

target=$(pwd)
echo  "running script from $target"

read -r -p "Continue? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  exit
fi

if [[ ! -d FRIP/IGVHSMM ]]; then
  mkdir -p FRIP/IGVHSMM
else
  echo "FRIP/IGVHSMM directory already exists, exiting to prevent overwrite..."
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
  echo "ready to calculate FRIP on IGV H3KSMM peaks"
  cat /btl/projects/ChIPseq/ENCODE/data/IGV_tracks/wgEncodeBroadHistoneHsmmH3k27acStdPk.bed | bedtools coverage -a - -b ../../../align/rep1/${name}_L001_R1_001.nodup.bam > ${target}/FRIP/IGVHSMM/${name}_IGVHSMM.bedcov
  awk '{ sum += $4 } END { print sum ; }' ${target}/FRIP/IGVHSMM/${name}_IGVHSMM.bedcov > ${target}/FRIP/IGVHSMM/${name}_IGVHSMM.rip
  popd
done
