#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=64g
#SBATCH --time=02:00:00
#SBATCH --job-name=manhattan
#SBATCH --output=./slurm-%x-%j.out #change path based on your system
#SBATCH --error=./slurm-%x-%j.err #change path based on your system
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxls9@nottingham.ac.uk

#This script generates a Manhattan plot from GWAS results using R
#Inputs:- GWAS results file (CLF_GWAS_height.assoc.linear)
#       - Requires R packages: data.table and ggplot2
#Output: Manhattan plot image (manhattan_plot.png) 

#activate conda environment
source $HOME/.bash_profile
conda activate gwas_plots

#create and change to directory for plots
mkdir -p ../GWAS/Plots #change based on your system
cd ../GWAS/Plots

#input GWAs result file
#change based on your system
DATA="path/to/CLF_GWAS_height.assoc.linear"

#run embedded R script
Rscript --vanilla - << EOF

#load required libraries
library(data.table)
library(ggplot2)

#read GWAS data
gwas <- fread(
  "$DATA",
  select = c("CHR", "SNP", "BP", "TEST", "P")
)

#filter for additive model only
gwas <- gwas[TEST == "ADD"]

#remove missing or invalid p-values
gwas <- gwas[!is.na(P) & P > 0]

#calculate -log10 for plotting
gwas[, logP := -log10(P)]

#png output
png("manhattan_plot1.png", width=1200, height=600)

#make manhattan plot
print(
  ggplot(gwas, aes(x=BP, y=logP)) +
    geom_point(size=0.6) +

    geom_hline(
      yintercept = -log10(5e-8),
      linetype = "dashed",
      color = "red"
    ) +

    theme_minimal() +
    labs(
      title="GWAS Manhattan Plot",
      x="Genomic Position",
      y="-log10(P)"
    )
)
dev.off()

EOF

#Deactivate Conda environment
conda deactivate
