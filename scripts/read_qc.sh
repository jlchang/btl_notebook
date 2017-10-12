#! /bin/bash

#$ -cwd
#$ -q gaag

eval `/broad/software/dotkit/init`
source /broad/software/scripts/useuse
reuse .gnuplot-4.4.0
reuse R-2.15
reuse Java-1.8
reuse Perl-5.10

/cil/shed/apps/internal/read_qc/read_qc_wrapper.pl -l SSFDEV-103.txt -B -N -T
