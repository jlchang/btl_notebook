#!/bin/bash

ls -dr *_single | sort -t_ -k2,2 | sed 's/_single//g' > statsInput.txt

echo "Please review sample order and revise statsInput.txt file (if needed) before proceeding"
cat statsInput.txt
