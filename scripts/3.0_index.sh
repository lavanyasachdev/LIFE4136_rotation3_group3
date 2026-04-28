#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=ref_index
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=20g
#SBATCH --time=6:00:00
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=fail
#SBATCH --mail-type=end
#SBATCH --output=./slurm-%x-%j.out
#SBATCH --error=./slurm-%x-%j.err

#this script builds a BWA index for the reference genome
#Input:reference.fna file
#output:indexed reference files (.amb, .ann, .bwt, .pac, .sa)

#activating conda environment
source $HOME/.bash_profile
conda activate Rotation3

#changing directory containing reference genome
cd ../data/reference #change path based on your system

#builds BWA index for reference genome
bwa index reference.fna

# Deactivate Conda
conda deactivate





