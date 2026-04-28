#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=12g
#SBATCH --time=06:00:00
#SBATCH --job-name=fixID
#SBATCH --output=./slurm-%x-%j.out #change path based on your system
#SBATCH --error=./slurm-%x-%j.err #change path based on your system
#SBATCH --mail-type=ALL
#SBATCH --mail-user=username@nottingham.ac.uk

#This script updates sample IDs in an imputed VCF file
#Inputs: - Imputed VCF file (CLF.filtered.Q30_DP10.imputed.vcf.gz)
#Outputs: - VCF file with cleaned sample IDs (CLF.filtered.Q30_DP10.imputed.fixedIDs.vcf.gz)
#         - Index file for the updated VCF
#         - Temporary mapping file (sample_map.txt)

#Activating Conda Environment
source $HOME/.bash_profile
conda activate Rotation3

#move to directory containing filtered VCF 
cd ../VCF_filtered #change path based on your system

#define input and output files
INPUT=CLF.filtered.Q30_DP10.imputed.vcf.gz
FIXED=CLF.filtered.Q30_DP10.imputed.fixedIDs.vcf.gz

#extract sample names from VCf and create a mapping file
#bcftools query -l lists all sample IDs
#awk processes each ID:
#-splits by "/" to remove directory paths
#-removes ".mapped.bam" suffix
bcftools query -l "$INPUT" | \
awk '{split($0,a,"/"); n=a[length(a)]; sub(".mapped.bam","",n); print $0, n}' \
> sample_map.txt

#replace sample names in VCf using mapping file
#-s provides mapping file
#-o specifies output VCF
bcftools reheader \
  -s sample_map.txt \
  -o "$FIXED" \
  "$INPUT"

#index the updated VCF 
bcftools index "$FIXED"

#Deactivate Conda Environment
conda deactivate
