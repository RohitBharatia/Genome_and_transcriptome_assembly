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
PACBIO_FASTQ="${INPUT_DIR}/*.fastq.gz"

# -s 5G: This option sets the size of the hash table used by Jellyfish to count k-mers. In this case, it is set to 5 gigabytes (GB). The hash table is a data structure that stores the k-mers and their counts. A larger hash table can accommodate more unique k-mers, which is important for large datasets or when using larger k-mer sizes.
# -C: This option tells Jellyfish to count both the k-mers and their reverse complements. In DNA sequences, a k-mer and its reverse complement are considered equivalent because they represent the same sequence in opposite orientations. By counting both, you get a more accurate representation of the k-mer frequencies in the dataset.
# -m: This option specifies the length of the k-mers to be counted. In this case, it is set to 21, meaning that Jellyfish will count all unique sequences of 21 nucleotides (k-mers) in the input reads.
apptainer exec --bind /data $CONTAINER jellyfish count \
    -C -m 21 \
    -s 5G \
    -t $SLURM_CPUS_PER_TASK \
    -o $OUTPUT_DIR/reads.jf \
    <(zcat $PACBIO_FASTQ) 

apptainer exec --bind /data $CONTAINER jellyfish histo -t $SLURM_CPUS_PER_TASK "$OUTPUT_DIR/reads.jf" > "$OUTPUT_DIR/reads.histo"

echo "Task complete!"