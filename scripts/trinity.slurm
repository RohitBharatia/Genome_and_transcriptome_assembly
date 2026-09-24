#!/usr/bin/env bash
#SBATCH --job-name="trinity"
#SBATCH --output=/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly/trinity/trinity_%j.out
#SBATCH --error=/data/users/rbharatia/Genome_transcriptome_assembly/logs/assembly/trinity/trinity_%j.err
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pibu_el8
#SBATCH --mail-user=rohit.bharatia@students.unibe.ch
#SBATCH --mail-type=end

module add Trinity/2.15.1-foss-2021a

INPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/data/RNAseq_Sha"
OUTPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly/trinity_results"

Trinity --seqType fq --max_memory $SLURM_MEM_PER_NODE --CPU $SLURM_CPUS_PER_TASK --left ${INPUT_DIR}/*_1.fastq.gz --right ${INPUT_DIR}/*_2.fastq.gz --output ${OUTPUT_DIR}
