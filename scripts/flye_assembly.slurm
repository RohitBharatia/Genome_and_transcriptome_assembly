#!/usr/bin/env bash
#SBATCH --job-name="Flye_assembly"
#SBATCH --output=/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly/flye_dir/flye_%j.out
#SBATCH --error=/data/users/rbharatia/Genome_transcriptome_assembly/logs/assembly/flye_asm/flye_%j.err
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pibu_el8
#SBATCH --mail-user=rohit.bharatia@students.unibe.ch
#SBATCH --mail-type=end


#SETTING PATHS
CONTAINER="/containers/apptainer/flye_2.9.5.sif"
Input_dir="/data/users/rbharatia/Genome_transcriptome_assembly/data/Anz-0"
Output_dir="/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly"

# Data is pacbio hifi long reads so using option --pacbio-hifi. 
apptainer exec --bind /data $CONTAINER flye --pacbio-hifi $Input_dir/*.fastq.gz \
    --out-dir $Output_dir/flye_assembly \
    -t $SLURM_CPUS_PER_TASK \

echo "Task complete!"