#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8g
#SBATCH --time=02:00:00
#SBATCH --job-name=pca_plot
#SBATCH --output=./slurm-%x-%j.out #change based on your system
#SBATCH --error=./slurm-%x-%j.err #change based on your system
#SBATCH --mail-type=ALL
#SBATCH --mail-user=username@nottingham.ac.uk

#This script generates a PCA scatter plot from PLINK PCA results using R
#Inputs: - PCA eigenvector file (CLF_PCA.eigenvec)
#        - Requires R packages: data.table and ggplot2
#Output: PCA plot image (PCA_plot.png) 

#activate conda environment
source $HOME/.bash_profile
conda activate gwas_plots

#make directory for plots and change to it
mkdir -p ../GWAS/Plots
cd ../GWAS/Plots

#input data
DATA="path/to/CLF_PCA.eigenvec" #change based on your system

#run embedded R script
Rscript --vanilla - << EOF

#load required R libraries
library(data.table)
library(ggplot2)

#read PCA data
pca <- fread("$DATA")

#rename columns
colnames(pca)[3] <- "PC1"
colnames(pca)[4] <- "PC2"

#png output
png("PCA_plot.png", width=800, height=600)

#make PCA plot
print(
  ggplot(pca, aes(x=PC1, y=PC2)) +
    geom_point(size=2) +
    theme_minimal() +
    labs(
      title="PCA Plot",
      x="PC1",
      y="PC2"
    )
)

dev.off()

EOF

#Deactivate Conda environment
conda deactivate
