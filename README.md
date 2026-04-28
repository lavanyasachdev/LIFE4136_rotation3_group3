# LIFE4136_rotation3_group3
LIFE4136 MSc Bioinformatics group project on GWAS

# Genome-Wide Association Study (GWAS) Pipeline for Canine Height

## Project overview

This repository contains a reproducible bioinformatics pipeline designed to process canine genomic sequencing data and identify genetic variants associated with height using genome-wide association analysis.

The workflow was developed for an MSc Bioinformatics project at the University of Nottingham and is designed to run on a High Performance Computing (HPC) system using SLURM jobs.

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

The dataset consists of paired-end Illumina sequencing data from domestic dogs, and the entire dataset is provided in the metadata.tsv file in the /data directory.

The phenotype analysed in this study is:

Height

This project aims to identify genetic variants associated with variation in canine height.

All necessary information and data are included in this repository but large sequencing files and intermediate outputs are not included due to file size limitations.

## Environment setup

This pipeline uses Conda environments to ensure reproducibility.

Two environments are required.

### Create the main analysis environment.

```bash
conda env create -f Rotation3.yml
conda activate Rotation3
```
This environment includes:

- FastQC
- fastp
- BWA
- SAMtools
- BCFtools
- Picard
- PLINK
- VCFtools

### Create the plotting environment

```bash
conda env create -f gwas_plots.yml
conda activate gwas_plots
```

This environment is used for:

- PCA plotting
- Manhattan plotting

Required R packages include:

- data.table
- ggplot2

## Optional preprocessing scripts

Some helper scripts in this repository generate intermediate text files required for downstream analysis.

These files are already provided in the `data/` directory to ensure the pipeline can be reproduced immediately without rerunning the initial preprocessing steps.

Therefore, the following scripts are optional and do not need to be executed unless the user wishes to regenerate these files from raw data:

| Script | Output file | Purpose |
|-------|------------|--------|
| 1.0_names.sh | doggies.txt | Extract FASTQ filenames |
| 2.0_roots.sh | doggie_roots.txt | Extract sample root names |
| 4.1_bam_list.sh | Bam_list.txt | Generate list of BAM files |
| 11_height_pheno.sh | height_pheno.txt | Create phenotype file |

These files are included in the repository to support reproducibility and allow the main analysis pipeline to run without repeating preprocessing steps.

### Pipeline workflow 

The scripts are numbered and must be run in sequential order.

Note: Some initial preprocessing outputs are already provided in the `data/` directory. These steps are documented for completeness but do not need to be rerun to reproduce the analysis.

### Step 1 — Extract FASTQ filenames

Script:

```
1.0_names.sh
```
This script extracts sample names from FASTQ files and creates file:
```
doggies.txt
```

### Step 2 — Run quality control

Script:
```
1.1_QC.sh
```

Tool used:

FastQC

Output:

- HTML quality reports
- ZIP quality reports

### Step 3 — Extract sample root names

Script:

```
2.0_roots.sh
```

Output:
```
doggie_roots.txt
```

### Step 4 — Trim sequencing reads

Script:

```
2.1_Fastp.sh
```

Tool used:

fastp

Output:

- Trimmed FASTQ files
- Quality reports

### Step 5 — Index reference genome

Script:
```
3.0_index.sh
```
Tool used:

BWA

Output:

