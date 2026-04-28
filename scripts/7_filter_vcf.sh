#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=filter_vcf
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8g
#SBATCH --time=48:00:00
#SBATCH --mail-user=username@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=fail
#SBATCH --mail-type=end
#SBATCH --output=./slurm-%x-%j.out #change path based on your system
#SBATCH --error=./slurm-%x-%j.err #change path based on your system

#this script filters a combined VCF file based on quality thresholds
#Input:- Combined VCF file (CLF.vcf.gz) from previous step
#Output:- Filtered VCF file (CLF.filtered.Q30_DP10.vcf.gz)
#       - Index file for filtered VCF
#       - SNP count file (CLF_SNP_count.txt)

#loading required modules for VCF processing (the conda env was having issues with dependencies) 
module purge
module load bcftools-uoneasy/1.19-GCC-13.2.0
module load vcftools-uoneasy/0.1.16-GCC-12.3.0

#create and move to output directory 
mkdir -p ../VCF_filtered
cd ../VCF_filtered

#define input and output files
#change paths based on your system
VCF=/path/to/your/VCF/CLF.vcf.gz
FILTERED_VCF=CLF.filtered.Q30_DP10.vcf.gz
COUNT_FILE=CLF_SNP_count.txt

# Filter VCF by quality
#QUAL < 30 removes low confidence variant calls
#DP < 10 removes variants with low sequencing depth
bcftools filter \
    -e 'QUAL<30 || INFO/DP<10' \
    "$VCF" \
    -Oz \
    -o "$FILTERED_VCF"

# Index filtered VCF
bcftools index "$FILTERED_VCF"

# Count SNPs
#-H removes header lines
#-v snps selects only SNP variants
FINAL_COUNT=$(bcftools view -H -v snps "$FILTERED_VCF" | wc -l)

# Write count to text file
echo "$FINAL_COUNT" > "$COUNT_FILE"

# Deactivate Conda
conda deactivate


