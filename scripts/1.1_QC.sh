#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=12g
#SBATCH --time=06:00:00
#SBATCH --job-name=QC
#SBATCH --output=./slurm-%x-%j.out
#SBATCH --error=./slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=username@nottingham.ac.uk
#SBATCH --array=0-230

#this script runs FastQC on multiple FASTQ files
#Inputs: - doggies.txt file that contains the list of FASTQ filenames
#        - FASTQ files 
#Output: FastQC reports (both .html and .zip) saved in a new directory called QC/
#Ensure conda environment "Rotation3" is installed from the yaml file

#Activating Conda Environment
source $HOME/.bash_profile
conda activate Rotation3

# Setting fastq file location
#doggies.txt should be located one directory above in the data folder if not adjust the location based on your system
mapfile -t NAMES < ../data/doggies.txt

mkdir QC #stores FastQC results

#directory with raw FASTQ files
#UPDATE THIS LOCATION OF FASTQ FILES BASED ON YOUR SYSTEM
SAMPLEDIR="/path/to/fastq/files/"
SAMPLE=${NAMES[$SLURM_ARRAY_TASK_ID]} #Makes smaple name for arrays
OUTDIR=./QC #Sets output directory for FASTQC results

#making input filepath
FILE="$SAMPLEDIR""$SAMPLE"

echo $FILE

# Running QC Analysis
fastqc \
 -t 4 \
 "$FILE" \
 -o "$OUTDIR"

# Deactivate Conda
conda deactivate


