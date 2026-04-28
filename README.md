# LIFE4136_rotation3_group3
LIFE4136 MSc Bioinformatics group project on GWAS

# Genome-Wide Association Study (GWAS) Pipeline for Canine Height

## Project overview

This repository contains a reproducible bioinformatics pipeline designed to process canine genomic sequencing data and identify genetic variants associated with height using genome-wide association analysis.

The workflow was developed for an MSc Bioinformatics project at the University of Nottingham and is designed to run on a High Performance Computing (HPC) system using SLURM job scheduling.

The pipeline begins with raw paired-end FASTQ files and performs:
- Quality control
- Read trimming
- Reference genome indexing
- Read alignment
- BAM filtering
- Variant calling
- VCF filtering
- Genotype imputation
- PLINK quality control
- Principal component analysis (PCA)
- Genome-wide association study (GWAS)
- Visualisation of results

## Dataset description

The dataset consists of paired-end Illumina sequencing data from domestic dogs.

The phenotype analysed in this study is:

Height

The aim of this project is to identify genetic variants associated with variation in canine height.

All necessary information and data are included in this repository but large sequencing files and intermediate outputs are not included due to file size limitations.
