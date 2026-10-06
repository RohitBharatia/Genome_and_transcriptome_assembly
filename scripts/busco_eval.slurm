#!/usr/bin/env bash
#SBATCH --job-name="busco_eval"
#SBATCH --output=/data/users/rbharatia/Genome_transcriptome_assembly/results/evaluation/busco/trinity/busco_trinity_%j.out
#SBATCH --error=/data/users/rbharatia/Genome_transcriptome_assembly/logs/evaluation/busco/trinity/busco_trinity_%j.err
#SBATCH --time=1:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pshort_el8
#SBATCH --mail-user=rohit.bharatia@students.unibe.ch
#SBATCH --mail-type=end

#change error and output file paths to the ones you want in the SBATCH directives above.

#verify the outdir.

CONTAINER="/containers/apptainer/busco_5.7.1.sif"
INPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly/trinity_results"
OUTPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/results/evaluation/busco/trinity"

#change input directory to the one containing the assembly.fasta file
apptainer exec --bind /data/users/rbharatia/Genome_transcriptome_assembly ${CONTAINER} busco -i $INPUT_DIR/trinity_results.Trinity.fasta\
    -o ${OUTPUT_DIR}\
    --lineage brassicales_odb10 --mode transcriptome --cpu $SLURM_CPUS_PER_TASK \
    -f

echo "Task complete!"

## WARNING. This script does not find the output directory properly. DO NOT USE THE -f command. 