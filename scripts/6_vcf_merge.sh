#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=VCF_concat
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8g
#SBATCH --time=48:00:00
#SBATCH --mail-user=username@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=fail
#SBATCH --mail-type=end
#SBATCH --output=./slurm-%x-%j.out #change location based on your system
#SBATCH --error=./slurm-%x-%j.err #change location based on your system

#this script concatenates multiple chromosome-level VCF files into a single VCF file

#Inputs:- Individual VCF files (CLF.MQ20.*.vcf.gz)
#Outputs:- A merged VCF file (CLF.vcf.gz) and its index
#         - A text file (vcf_list.txt) listing all input vcfs 

#activating conda environment
source $HOME/.bash_profile
conda activate Rotation3

#load bcftools module for VCF processsing (sometimes the environment was creating issues with dependencies)
module load bcftools-uoneasy/1.19-GCC-13.2.0

# Output file
output="../data/vcf_list.txt" #change accordingly
> "$output"  # Clear file if it exists

# Create sorted list of VCF files
# sort -V ensures natural (version-like) sorting (eg, chr1, chr2)
ls ../VCF/CLF.MQ20.*.vcf.gz | sort -V > ../data/vcf_list.txt

echo "vcf names written to ../data/vcf_list.txt"

# Concatenate all VCF files into a single compressed VCF
#--file-list provides the ordered list of files
#-Oz outputs compressed VCF (.vcf.gz)
bcftools concat \
  --file-list ../data/vcf_list.txt \
  -Oz \
  --output ../VCF/CLF.vcf.gz

# Index the final VCF for fast querying
bcftools index ../VCF/CLF.vcf.gz

# Deactivate Conda
conda deactivate

