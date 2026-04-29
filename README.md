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
Input: 
FASTQ files

Output:
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

Inputs: 
- doggies.txt file that contains the list of FASTQ filenames
- FASTQ files 

Output:

- HTML quality reports
- ZIP quality reports

### Step 3 — Extract sample root names

Script:

```
2.0_roots.sh
```
Inputs:
directory containing FASTQ files

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

Inputs
- doggie_roots.txt file that contains the list of sample IDs
- raw FASTQ files
  
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

Input:
reference.fna file in data/reference


Output:

reference genome index files (.amb, .ann, .bwt, .pac, .sa)

### Step 6 — Align reads and create BAM files

Script:
```
3.1_creatingBAM.sh
```

Tools used:

- bwa mem
- samtools
- Picard

Inputs:
- doggie_roots.txt: list of sample names (one per line)
- trimmed paired-end FASTQ files
- reference genome file (reference.fna) in data/reference

Output:

- Sorted BAM files
- Duplicate-removed BAM files (.rmd.bam)
- BAM index files (.bai)

### Step 7 — Filter BAM files

Script:
```
4.0_bam_filter.sh
```
Inputs:
- doggie_roots.txt: list of sample names
- duplicate-removed BAM files (.rmd.bam) from previous step

Filtering criteria:

- Remove unmapped reads
- Remove secondary alignments
- Mapping quality ≥ 20
- Properly paired reads

Output:
- filtered BAM files (.mapped.bam)
- indexed BAM files (.bai)

### Step 8 - Create BAM list
Script:
```
4.1_bam_list.sh
```
Inputs:
filtered BAM files (.mapped.bam)

Output:
```
Bam_list.txt
```

### Step 9 - Variant Calling

Script:
```
5_VCF.sh
```

Tool used:

BCFtools

Inputs:
- chr_names.txt: list of chromosome names
- Bam_list.txt: list of filtered BAM file paths
- reference.fna: Reference genome file

Output:

- Compressed VCF files (.vcf.gz) for each chromosome
- VCF index files (.csi)

### Step 10 - Merge VCF files

Script:
```
6_vcf_merge.sh
```
Input: 
Individual VCF files (CLF.MQ20.*.vcf.gz)

Output:
- A merged VCF file (CLF.vcf.gz) and its index
- A text file (vcf_list.txt) listing all input vcfs

### Step 11 - Filter variants

Script:
```
7_filter_vcf.sh
```
Input:
Combined VCF file (CLF.vcf.gz) from previous step

Filtering thresholds:

```
QUAL ≥ 30
Depth ≥ 10
```
Output:
- Filtered VCF file (CLF.filtered.Q30_DP10.vcf.gz)
- Index file for filtered VCF
- SNP count file (CLF_SNP_count.txt)

### Step 12 - Genotype imputation

Script:
```
8_impute.sh
```
Inputs:
- filtered VCF file (CLF.filtered.Q30_DP10.vcf.gz)
- Beagle JAR file (beagle.28Jun21.220.jar) in /data

Output:
imputed VCF file (CLF.filtered.Q30_DP10.imputed)

### Step 13 - Fix sample IDs

Script
```
9_fix_ids.sh
```
Inputs: 
Imputed VCF file (CLF.filtered.Q30_DP10.imputed.vcf.gz)

Output:
- corrected VCF file (CLF.filtered.Q30_DP10.imputed.fixedIDs.vcf.gz)
- Index file for the updated VCF
- Temporary mapping file (sample_map.txt)

### Step 14 — PLINK quality control and PCA

Script:
```
10_plink_qc_pca.sh
```

QC thresholds:
```
geno 0.3
mind 0.2
maf 0.01
hwe 1e-6
```

Inputs:
Final processed VCF file (CLF.filtered.Q30_DP10.imputed.fixedIDs.vcf.gz)

Output:

- PLINK binary files (.bed, .bim, .fam)
- Missingness reports
- QC-filtered dataset
- PCA results (eigenvalues and eigenvectors)


### Step 15 — Prepare phenotype file

Script:
```
11_height_pheno.sh
```

Inputs: 
```
doggie_data.csv file located in /data
```

Output:
```
height_pheno.txt
```

### Step 16 - Run GWAS

Script:
```
12_gwas_height.sh
```

Tool used:
PLINK

Inputs: 
- QC-filtered genotype data (CLF_QC)
- Phenotype file (height_pheno.txt)
- PCA covariates (CLF_PCA.eigenvec)
  
Output:
GWAS results file

### Step 18 - summary of GWAS results

Script
```
13_GWAS_summary.sh
```

Inputs:
GWAS results file (CLF_GWAS_height.assoc.linear)
  
Output:
Text file containing top 20 significant SNPs (CLF_GWAS_height_top20_hits.txt)

### Step 18 - Generate Manhattan plot

Script:
```
14_manhattan_plot.sh
```

Inputs:

GWAS results file (CLF_GWAS_height.assoc.linear)
  
Output:
```
manhattan_plot.png
```

### Step 19 - Generate PCA plot

Script:
```
15_pca_plot.sh
```
Inputs: 
PCA eigenvector file (CLF_PCA.eigenvec)

Output:
```
PCA_plot.png
```

### Step 20 - Extract SNPs from GWAS result above a significance threshold

Script:
```
16_significant_snps.sh
```
Inputs: 
GWAS association results file (CLF_GWAS_height.assoc.linear)

Output:
```
significant_snps.txt
```


## Running the pipeline

Scripts must be executed using SLURM on the HPC system.

Example:
```bash
sbatch scripts/3.1_creatingBAM.sh
```

---

## Key outputs

The main outputs generated by this pipeline include:

- Quality control reports
- Trimmed sequencing reads
- Filtered BAM files
- Variant call files (VCF)
- Imputed genotype data
- PCA results
- GWAS results
- Manhattan plot
- PCA plot
- Significant SNP list


## Reproducibility

All scripts are provided with fixed parameters and Conda environments to ensure reproducibility.

Users must update file paths before running the pipeline.

Large sequencing files are excluded from this repository.

---

## Author

Lavanya Sachdev (mbxls9@nottingham.ac.uk)
MSc Bioinformatics 
University of Nottingham
