#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=impute_vcf
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --ntasks-per-node=1
#SBATCH --mem=48g
#SBATCH --time=48:00:00
#SBATCH --mail-user=username@nottingham.ac.uk
#SBATCH --mail-type=BEGIN,FAIL,END
#SBATCH --output=./slurm-%x-%j.out #change path based on your system
#SBATCH --error=./slurm-%x-%j.err #change path based on your system

#this script performs genotype imputation on a filtered VCF using Beagle
#Inputs- filtered VCF file (CLF.filtered.Q30_DP10.vcf.gz)
#      - Beagle JAR file (beagle.28Jun21.220.jar)
#Outputs: - Imputed VCF files (CLF.filtered.Q30_DP10.imputed)

#activate conda environment
source $HOME/.bash_profile
conda activate Rotation3

#move to directory containing filtered VCF
cd ../VCF_filtered # change path based on your system

#define input and output files
VCF=CLF.filtered.Q30_DP10.vcf.gz
BEAGLE=beagle.28Jun21.220.jar
OUT=CLF.filtered.Q30_DP10.imputed

#run beagle for genotype imputation
java -Xmx28g -jar "$BEAGLE" \
    gt="$VCF" \ #input vcf file
    out="$OUT" \ #output file
    nthreads="$SLURM_CPUS_PER_TASK" #number of cpu threads allocated via SLURM

# Deactivate Conda Environment
conda deactivate

