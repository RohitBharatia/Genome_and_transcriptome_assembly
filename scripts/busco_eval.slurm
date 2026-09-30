#!/usr/bin/env bash
#SBATCH --job-name="busco_eval"
#SBATCH --output=/data/users/rbharatia/Genome_transcriptome_assembly/results/evaluation/busco/busco_%j.out
#SBATCH --error=/data/users/rbharatia/Genome_transcriptome_assembly/logs/evaluation/busco/busco_%j.err
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pibu_el8
#SBATCH --mail-user=rohit.bharatia@students.unibe.ch
#SBATCH --mail-type=end

CONTAINER="/containers/apptainer/busco_5.7.1.sif"
INPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly"
OUTPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/results/evaluation/busco"

if [ ! -d $OUTDIR ]; then 
    echo "directory ${OUTDIR} created"
    # option -p create the parents' folders if they do not exist
    mkdir -p $OUTDIR
fi 

apptainer exec --bind /data ${CONTAINER} busco -i $INPUT_DIR/lja/assembly.fasta\
    -o ${OUTPUT_DIR}\
    --lineage brassicales_odb10 --mode genome --cpu $SLURM_CPUS_PER_TASK 

echo "Task complete!"

## WARNING. This script does not find the output directory properly. DO NOT USE THE -f command. 