#!/usr/bin/env bash
#SBATCH --job-name="quast_eval"
#SBATCH --output=/data/users/rbharatia/Genome_transcriptome_assembly/results/evaluation/quast/quast_flye_%j.out
#SBATCH --error=/data/users/rbharatia/Genome_transcriptome_assembly/logs/evaluation/quast/quast_flye_%j.err
#SBATCH --time=2:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pibu_el8
#SBATCH --mail-user=rohit.bharatia@students.unibe.ch
#SBATCH --mail-type=end


CONTAINER="/containers/apptainer/quast_5.2.0.sif"
INPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly"
OUTPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/results/evaluation/quast"
REFERENCE_DATA="/data/courses/assembly-annotation-course/references"


mkdir -p $OUTPUT_DIR/with_ref
mkdir -p $OUTPUT_DIR/no_ref

# --- Run 1: WITHOUT reference ---
apptainer exec --bind /data /containers/apptainer/quast_5.2.0.sif \
quast.py \
$INPUT_DIR/flye_assembly/assembly.fasta \
/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly/lja/assembly.fasta \
--labels flye,LJA \
--eukaryote \
--est-ref-size 119667750 \
--threads 16 \
-o $OUTPUT_DIR/no_ref

# --- Run 2: WITH reference ---
apptainer exec --bind /data /containers/apptainer/quast_5.2.0.sif \
quast.py \
$INPUT_DIR/flye_assembly/assembly.fasta \
/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly/lja/assembly.fasta \
--labels flye,LJA \
-r $REFERENCE_DATA/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa \
--features $REFERENCE_DATA/Arabidopsis_thaliana.TAIR10.57.gff3 \
--eukaryote \
--threads 16 \

echo "QUAST complete."