#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=12g
#SBATCH --time=06:00:00
#SBATCH --job-name=gwas_height
#SBATCH --output=./slurm-%x-%j.out #change path based on your system
#SBATCH --error=./slurm-%x-%j.err #change path based on your system
#SBATCH --mail-type=ALL
#SBATCH --mail-user=username@nottingham.ac.uk

#This script performs a genome-wide association study (GWAS) for height using PLINK
#Inputs:- QC-filtered genotype data (CLF_QC)
#       - Phenotype file (height_pheno.txt)
#       - PCA covariates (CLF_PCA.eigenvec)
#Outputs:- GWAS results files

#activate conda environment
source $HOME/.bash_profile
conda activate Rotation3

#move to plink working directory 
cd path/to/Plink #change path based on your system

#define input and output file
PHENO=path/to/height_pheno.txt #change path based on your system
OUT=CLF_GWAS_height

#run GWAS linear regression
plink \
  --bfile CLF_QC \ #specifies QC-filtered genotype dataset
  --allow-extra-chr \ #allows non-standard chromosome names
  --allow-no-sex \ #allows analysis without sex information
  --pheno "$PHENO" \ #provides phenotype file
  --covar CLF_PCA.eigenvec \ #includes PCA covariates to correct for population structure
  --covar-number 1-3 \ #uses first 3 principal components
  --linear \ #performs linear regression GWAS
  --out "$OUT"

#confirmation message
echo "GWAS for height completed"

#Deactivate Conda Environment
conda deactivate
