#!/usr/bin/env bash
#SBATCH --job-name="Jellyfish_counting_Azn-0_sample"
#SBATCH --output=/data/users/rbharatia/Genome_transcriptome_assembly/results/quality_control/jellyfish_%j.out
#SBATCH --error=/data/users/rbharatia/Genome_transcriptome_assembly/logs/quality_control/jellyfish_%j.err
#SBATCH --time=01:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pshort_el8
#SBATCH --mail-user=rohit.bharatia@students.unibe.ch
#SBATCH --mail-type=end

#Setting Paths

CONTAINER="/containers/apptainer/jellyfish-2.2.6--0.sif"
INPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/data/Anz-0"
OUTPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/results/quality_control"
PACBIO_FASTQ="${INPUT_DIR}/ERR11437354.fastq.gz"


apptainer exec --bind /data $CONTAINER jellyfish count \
    -C -m 21 \
    -s 5G \
    -t $SLURM_CPUS_PER_TASK \
    -o $OUTPUT_DIR/reads.jf \
    <(zcat $PACBIO_FASTQ) 

apptainer exec --bind /data $CONTAINER jellyfish histo -t $SLURM_CPUS_PER_TASK "$OUTPUT_DIR/reads.jf" > "$OUTPUT_DIR/reads.histo"

echo "Task complete!"