#!/bin/bash

#This script extracts genome-wide significant SNPs from GWAS results
#Inputs: - GWAS association results file (CLF_GWAS_height.assoc.linear)
#        - Assumes p-values are in column 9
#Output: Text file (significant_snps.txt) containing SNPs with p-value < 5e-8

#change to directory with GWAS resluts
cd path/to/Plink #change based on your system

#filter SNPs with p-value below significance threshold
awk '$9 < 5e-8' CLF_GWAS_height.assoc.linear > significant_snps.txt
