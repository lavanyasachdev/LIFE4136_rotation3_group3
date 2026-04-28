#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=filterbam
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32g
#SBATCH --time=10:00:00
#SBATCH --mail-user=username@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=fail
#SBATCH --mail-type=end
#SBATCH --output=./slurm-%x-%j.out
#SBATCH --error=./slurm-%x-%j.err
#SBATCH --array=0-114

#this script filters BAM files to retain only high-quality, paired mapped reads

#Inputs:-doggie_roots.txt: list of sample names
#       -duplicate-removed BAM files (.rmd.bam) from previous step

#Outputs:-filtered BAM files (.mapped.bam)
#        -indexed BAM files (.bai)

#each slurm tast processes one sample

#activating conda environment
source $HOME/.bash_profile
conda activate Rotation3

#load samtools module(for BAM processing)
module load samtools-uoneasy/1.22.1-GCC-14.2.0

#create and change to output directory for filtered BAMs
mkdir -p ../filtered_BAM
cd ../filtered_BAM

#loading sample names (change path according to your sysytem)
mapfile -t ROOTS < ../data/doggie_roots.txt
SAMPLE=${ROOTS[$SLURM_ARRAY_TASK_ID]}

#defining input and output BAM files (change according to your system)
BAM=../BAM/"$SAMPLE".rmd.bam
FILTERED=./"$SAMPLE".mapped.bam

#filtering using samtools
samtools view -b -F 4 -b $BAM  | \ #remove unmapped reads
samtools view -b -F 256 | \ #remove secondary alignments
samtools view -q 20 -b | \ #keep reads with mapping quality greater than or equal to 20
samtools view -b -f 0x2 > $FILTERED #keeps properly paired reads

#index the filtered BAM files
samtools index $FILTERED

# Deactivate Conda
conda deactivate


