#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=12g
#SBATCH --time=06:00:00
#SBATCH --job-name=gwas_summary
#SBATCH --output=./slurm-%x-%j.out #change based on your system
#SBATCH --error=./slurm-%x-%j.err #change based on your system
#SBATCH --mail-type=ALL
#SBATCH --mail-user=username@nottingham.ac.uk

#This script extracts the top GWAS hits based on p-value from PLINK results
#Inputs:- GWAS results file (CLF_GWAS_height.assoc.linear)
#Outputs:- Text file containing top 20 significant SNPs (CLF_GWAS_height_top20_hits.txt)

#activate conda environment
source $HOME/.bash_profile
conda activate Rotation3

#move to PLINK GWAS results directory
cd path/to/Plink #change path based on your system

# Extract top GWAS hits from additive model, sorted by p-value
#5=="ADD" selects additive genetic model
#9!="NA" removes variants with missing p-values
#sort -g -k9,9 sorts results numerically by p-value (ascending)
#head -n 20 selects top 20 most significant variants
awk '$5=="ADD" && $9!="NA" {print}' CLF_GWAS_height.assoc.linear | \
sort -g -k9,9 | \
head -n 20 > CLF_GWAS_height_top20_hits.txt

#confirmation messgae
echo "Top 20 GWAS hits saved to CLF_GWAS_height_top20_hits.txt"

#deactivate conda environment
conda deactivate
