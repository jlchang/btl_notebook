#!/bin/bash

ls -1 *.fastq.gz | grep -v Undetermined | grep -v unknown | grep -v barcode | cut -d "." -f 1-3 | uniq > runInput.txt

echo "Please review sample order and revise runInput.txt file (if needed) before proceeding"
cat runInput.txt
