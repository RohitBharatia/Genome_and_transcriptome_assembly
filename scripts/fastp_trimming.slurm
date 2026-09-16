#!/usr/bin/env bash
#SBATCH --job-name="fastp_trim_GTA_Course_rmb"
#SBATCH --output=/data/users/rbharatia/Genome_transcriptome_assembly/results/quality_control/fastp_%j.out
#SBATCH --error=/data/users/rbharatia/Genome_transcriptome_assembly/logs/quality_control/fastp_%j.err
#SBATCH --time=01:00:00
#SBATCH --mem=20G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pshort_el8
#SBATCH --mail-user=rohit.bharatia@students.unibe.ch
#SBATCH --mail-type=end


#Setting paths

CONTAINER="/containers/apptainer/fastp_0.23.2--h5f740d0_3.sif"
INPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/data/Anz-0"
OUTPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/results/quality_control"

# Run fastp using Apptainer Container
apptainer exec --bind /data ${CONTAINER} fastp -i ${INPUT_DIR}/*.fastq.gz \
    -o ${OUTPUT_DIR}/trimmed.fastq.gz \
    -t $SLURM_CPUS_PER_TASK

echo "Task complete!"


#THIS STEP WAS NOT NEEDED FOR THE PROJECT. just keeping this file here because I wrote it. 