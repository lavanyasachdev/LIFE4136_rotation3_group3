#!/bin/bash

#this script extracts sample root names from paired-end FASTQ files
#Inputs:directory containing FASTQ files
#Outputs:a text file (doggie_roots.txt) containing unique sample root names

# Output file
output="../data/doggie_roots.txt" #change based on your system
> "$output"  # Clear file if it exists

# Loop through matching files
for file in /path/to/your/fastqs/*_1.fastq.gz; do #put your filepath here
        echo "Processing: $file"
        base=$(basename "$file")      # Remove folder path
        root="${base%%_1*}"           # Remove everything from _R onwards
        echo "$root" >> "$output"     # Append sample root name to output
done

#confirmation message
echo "Root names written to $output"


