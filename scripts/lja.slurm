#!/usr/bin/env bash
#SBATCH --job-name="lja"
#SBATCH --output=/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly/lja/lja_%j.out
#SBATCH --error=/data/users/rbharatia/Genome_transcriptome_assembly/logs/assembly/lja/lja_%j.err
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pibu_el8
#SBATCH --mail-user=rohit.bharatia@students.unibe.ch
#SBATCH --mail-type=end

CONTAINER="/containers/apptainer/lja-0.2.sif"
INPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/data/Anz-0"
OUTPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly/lja"

apptainer exec --bind /data ${CONTAINER} lja -o $OUTPUT_DIR --reads $INPUT_DIR/*fastq.gz\
    -t $SLURM_CPUS_PER_TASK

echo "Task complete!"