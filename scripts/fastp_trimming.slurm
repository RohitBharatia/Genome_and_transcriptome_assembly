#!/usr/bin/env bash
#SBATCH --job-name="fastp_trim_GTA_Course_rmb"
#SBATCH --output=/data/users/rbharatia/Genome_transcriptome_assembly/results/quality_control/trimmed_RNA/fastp_%j.out
#SBATCH --error=/data/users/rbharatia/Genome_transcriptome_assembly/logs/quality_control/fastp_%j.err
#SBATCH --time=02:00:00
#SBATCH --mem=40G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pibu_el8
#SBATCH --mail-user=rohit.bharatia@students.unibe.ch
#SBATCH --mail-type=end


#Setting paths

CONTAINER="/containers/apptainer/fastp_0.23.2--h5f740d0_3.sif"
INPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/data/RNAseq_Sha"
OUTPUT_DIR="//data/users/rbharatia/Genome_transcriptome_assembly/results/quality_control/trimmed_RNA"


# Run fastp using Apptainer Container


apptainer exec --bind /data ${CONTAINER} fastp -i $INPUT_DIR/*_1.fastq.gz -I $INPUT_DIR/*_2.fastq.gz \
    -o ${OUTPUT_DIR}/1_trimmed.fastq.gz -O ${OUTPUT_DIR}/2_trimmed.fastq.gz \
    -t $SLURM_CPUS_PER_TASK

echo "Task complete!"

