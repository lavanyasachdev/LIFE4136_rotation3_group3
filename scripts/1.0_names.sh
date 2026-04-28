#!/bin/bash

#this script extracts sample (root) names from FASTQ filenames
#Input: FASTQ files 
#output: doggies.txt file containing unique sample root names

# Output file
output="../data/doggies.txt"
> "$output"  # Clear file if it exists

# Loop through matching files
for file in /share/BioinfMSc/Hannah_resources/doggies/fastqs/*.fastq.gz; do #change path to file based on your system
        echo "Processing: $file"
        base=$(basename "$file")      # Remove folder path
        root="${base%%_R*}"           # remove everything from _R onwards
        echo "$root" >> "$output"     # write root name to output file
done

#print confirmation
echo "Root names written to $output"

