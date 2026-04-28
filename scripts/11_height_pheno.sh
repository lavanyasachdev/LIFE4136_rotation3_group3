#!/bin/bash

#This script extracts phenotype data from a CSV file for downstream analysis
#Inputs:- doggie_data.csv file located in ../data
#Outputs:- A phenotype file (height_pheno.txt)

#move to data directory with the csv file
cd ../data #change path based on your system
DATA=doggie_data.csv #input file

#Extract relevant columns from CSV
#-F',' sets comma as the delimiter
#NR>1 skips the header row
#print $2, $2, $3 outputs:
#Column 2 as Individual ID (IID)
#Column 3 as phenotype (e.g., height)
awk -F',' 'NR>1 {print $2, $2, $3}' $DATA > height_pheno.txt

