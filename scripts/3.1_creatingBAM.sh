#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=makebam
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=20g
#SBATCH --time=48:00:00
#SBATCH --output=./slurm-%x-%A_%a.out
#SBATCH --error=./slurm-%x-%A_%a.err
#SBATCH --mail-user=username@exmail.nottingham.ac.uk
#SBATCH --mail-type=BEGIN,FAIL,END
#SBATCH --array=0-114

#this script performs alignment and BAM processing for multiple samples
#Inputs:- doggie_roots.txt: list of sample names (one per line)
#       - trimmed paired-end FASTQ files 
#       - reference genome file (reference.fna)

#Outputs:- Sorted BAM files 
#        - final duplicate removed BAM files (.rmd.bam)
#        - BAM index files (.bai)
#each slurm array task processes one sample from the list

#activating conda environment
source $HOME/.bash_profile
conda activate Rotation3

# directories (update paths according to your system)
BAMDIR=../BAM #output directory for BAM files
TRIMDIR=../trimmed #directory with trimmed fastq files
ROOTFILE=../data/doggie_roots.txt #file with sample names
REF=../data/reference/reference.fna #reference genome

#making and changing the directory for outputs
mkdir -p "$BAMDIR"
cd $BAMDIR || exit 1

# load sample list and select sample based on SLURM array index
mapfile -t ROOTS < $ROOTFILE
SAMPLE=${ROOTS[$SLURM_ARRAY_TASK_ID]}

# fastq files (paired-end)
FILE1=$TRIMDIR/${SAMPLE}_1.trimmed.fastq.gz
FILE2=$TRIMDIR/${SAMPLE}_2.trimmed.fastq.gz

# output files
SORTBAM=${SAMPLE}.sort.bam #intermediate sorted BAM
RMDBAM=${SAMPLE}.rmd.bam #final BAM after duplicate removal
METRICS=${SAMPLE}.metrics.txt #metrics output

echo "Processing sample: $SAMPLE"

# align reads to reference genome using bwa mem
#output is piped to samtools to convert to BAM and sort
bwa mem -M -t 8 $REF $FILE1 $FILE2 | \
samtools view -b | \
samtools sort -T $SAMPLE -o $SORTBAM

#Using picard to remove duplicates
#Duplicates are identical read pairs (same forward and reverse sequences)
#this step improves downstream analysis by removing PCR duplicates
java -Xmx4g -jar $EBROOTPICARD/picard.jar MarkDuplicates \
INPUT=$SORTBAM \
OUTPUT=$RMDBAM \
METRICS_FILE=$METRICS \
REMOVE_DUPLICATES=true \
ASSUME_SORTED=true \
VALIDATION_STRINGENCY=SILENT

# index the final BAM file
samtools index $RMDBAM

# remove intermediate sorted BAM file 
rm $SORTBAM

echo "Finished $SAMPLE"

# Deactivate Conda
conda deactivate





