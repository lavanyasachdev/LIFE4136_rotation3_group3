#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=VCF
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8g
#SBATCH --time=48:00:00
#SBATCH --mail-user=username@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=fail
#SBATCH --mail-type=end
#SBATCH --output=./slurm-%x-%j.out
#SBATCH --error=./slurm-%x-%j.err
#SBATCH --array=0-38

#this script performs variant calling using bcftools on multiple genomic regions like chromosomes
#Inputs:-chr_names.txt: list of chromosome names
#       -Bam_list.txt: list of filtered BAM file paths
#       -reference.fna: Reference genome file

#Outputs:-compressed VCF files (.vcf.gz) for each chromosome
#        -VCF index files (.csi)

#each slurm array task processes one chromosome

#activating conda environment
source $HOME/.bash_profile
conda activate Rotation3

#loading bcftools module for variant calling
module load bcftools-uoneasy/1.19-GCC-13.2.0

#creating and changing to output directory
mkdir -p ../VCF
cd ../VCF

#loading chromosome names into array and seecting region based on SLURM array index
mapfile -t CHR < ../data/chr_names.txt
SAMPLE=${CHR[$SLURM_ARRAY_TASK_ID]}

#reference genome
REF=../data/reference/reference.fna #change location based on your system

#outpur VCF file (compressed)
OUT=./CLF.MQ20.${SAMPLE}.vcf.gz

#list of BAM files to include in variant calling
BAMLIST=../data/Bam_list.txt #change location based on  your system

#print current chromosome and output file
echo $SAMPLE
echo $OUT

#Variant calling pipeline
#bcftools mpileup generates genotype likelihoods from BAM files
bcftools mpileup \
  --threads 20 \ 
  -Ou \
  -f "$REF" \
  --min-MQ 20 \ #minimum mapping quality threshold
  --min-BQ 20 \ #minimum base quality threshold
  --platforms ILLUMINA \
  --annotate FORMAT/DP,FORMAT/AD \ #adds depth (DP) and allele depth (AD) information
  --bam-list "$BAMLIST" \
  -r "${SAMPLE}" | \ #restricts ananlysis to a specific chromosome
bcftools call \ #output is piped to bcftools call
  --threads 20 \
  -m \ #multiallelic caller
  -v \ #output variant sites only
  -a GQ,GP \ #annotate genotype quality and probabilities
  -Oz \ #output compressed VCF
  -o "$OUT"

#index the VCF file 
bcftools index $OUT

# Deactivate Conda
conda deactivate
