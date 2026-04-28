#!/bin/bash

#this script creates a list of filtered BAM files paths for analysis

#Inputs:-filtered BAM files (.mapped.bam)
#outputs:-Bam_list.txt file containing full paths to all BAM files
#this file be used as input in next step

# Output file (goes to ../data)(change according to your system
output="../data/Bam_list.txt"
> "$output"  # Clear file if it exists

# Loop through matching files (change path according to your system)
for file in ../filtered_BAM/*.mapped.bam; do
    echo "$file" >> "$output" #Prints file path to output
done

#prints confirmation message
echo "BAM names written to $output"                   


