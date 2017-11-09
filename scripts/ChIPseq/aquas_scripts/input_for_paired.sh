#!/bin/bash

ls -d */ | sed 's#/##g' > statsInput.txt

echo "Please review sample order and revise statsInput.txt file (if needed) before proceeding"
cat statsInput.txt
