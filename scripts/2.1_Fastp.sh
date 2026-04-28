#!/bin/bash
#SBATCH --job-name=fastp
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=16g
#SBATCH --time=10:00:00
#SBATCH --mail-user=your.username@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=fail
#SBATCH --mail-type=end
#SBATCH --array=0-115
#SBATCH --output=./slurm-%x-%j.out
#SBATCH --error=./slurm-%x-%j.err

#this script performs quality trimming and filtering of paired-end FASTQ files using fastp
#Inputs: - doggie_roots.txt file that contains the list of sample IDs
#        - raw FASTQ files 
#Output: Trimmed FASTQ files, quality reports and log files
#Ensure conda environment "Rotation3" is installed from the yaml file

#activate conda env
source $HOME/.bash_profile
conda activate Rotation3

#create output directory and set location to it
mkdir -p ../trimmed
cd ../trimmed

#doggie_roots.txt should be located one directory above in the data folder if not adjust the location based on your system
mapfile -t ROOTS < ../data/doggie_roots.txt

#directory with raw FASTQ files
#UPDATE THIS LOCATION OF FASTQ FILES BASED ON YOUR SYSTEM
SAMPLEDIR="/path/to/fastq/files/"
SAMPLE=${ROOTS[$SLURM_ARRAY_TASK_ID]} #to get sample ID
OUTDIR=./  #output directory for results

#creating input file paths
FILE1="$SAMPLEDIR""$SAMPLE"_1.fastq.gz
FILE2="$SAMPLEDIR""$SAMPLE"_2.fastq.gz

#running fastp
fastp --in1 $FILE1 --in2 $FILE2 \
        --out1 ${OUTDIR}/${SAMPLE}_1.trimmed.fastq.gz \
        --out2 ${OUTDIR}/${SAMPLE}_2.trimmed.fastq.gz \
        -l 50 \
        -h ${OUTDIR}/${SAMPLE}.html \
        &> ${OUTDIR}/${SAMPLE}.log

# Deactivate Conda
conda deactivate
