#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=12g
#SBATCH --time=06:00:00
#SBATCH --job-name=plink_qc_pca
#SBATCH --output=./slurm-%x-%j.out #change path according to your system
#SBATCH --error=./slurm-%x-%j.err #change path according to your system
#SBATCH --mail-type=ALL
#SBATCH --mail-user=username@nottingham.ac.uk

#This script performs PLINK-based quality control (QC) and principal component analysis (PCA)
#Inputs:- Final processed VCF file (CLF.filtered.Q30_DP10.imputed.fixedIDs.vcf.gz)
#Outputs:- PLINK binary files (.bed, .bim, .fam)
#        - Missingness reports
#        - QC-filtered dataset
#        - PCA results (eigenvalues and eigenvectors)

#activate conda environment
source $HOME/.bash_profile
conda activate Rotation3

#define base directory, input VCF and change into it
BASE=..
VCF=../../VCF_filtered/CLF.filtered.Q30_DP10.imputed.fixedIDs.vcf.gz
OUTDIR=$BASE/GWAS/Plink

#create and move into output directory
mkdir -p "$OUTDIR"
cd "$OUTDIR"

# Convert VCF to PLINK binary format
plink \
  --vcf "$VCF" \
  --double-id \ #assigns sample IDs 
  --allow-extra-chr \ #allows non-stranded chromosome names
  --set-missing-var-ids @:#:\$1:\$2 \ #assigns IDs to variants lacking identifiers
  --make-bed \ #creates PLINK binary files
  --out CLF_raw

# Check missingness
plink \
  --bfile CLF_raw \
  --missing \ #generates reports for missing genotype data
  --allow-extra-chr \
  --out CLF_missing

# QC filtering
plink \
  --bfile CLF_raw \
  --geno 0.3 \ #removes variants with >30% missing data
  --mind 0.2 \ #removes samples with >20% missing data
  --maf 0.01 \ #removes rare variants with minor allele frequency <1%
  --hwe 1e-6 \ #removes variants
  --make-bed \
  --allow-extra-chr \
  --out CLF_QC

# PCA
plink \
  --bfile CLF_QC \
  --pca 20 \ #gives the first 20 principal components
  --allow-extra-chr \
  --out CLF_PCA

#confirmation
echo "PLINK conversion, missingness check, QC, and PCA completed"

#Deactivate Conda Environment
conda deactivate
