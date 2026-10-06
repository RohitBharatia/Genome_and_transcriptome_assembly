#!/usr/bin/env bash
#SBATCH --job-name="merqury"
#SBATCH --output=/data/users/rbharatia/Genome_transcriptome_assembly/results/evaluation/merqury/merqury_%j.out
#SBATCH --error=/data/users/rbharatia/Genome_transcriptome_assembly/logs/evaluation/merqury/merqury_%j.err
#SBATCH --time=05:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=rohit.bharatia@students.unibe.ch

set -uo pipefail



# Project root 
PROJECT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly"

# Output folder for all Merqury results
OUTPUT_DIR="${PROJECT_DIR}/results/evaluation/merqury"

# Genome size in base pairs (number only, e.g. 135000000)
GENOME_SIZE=137300000

# Reads used to build the k-mer database (same reads you assembled from)
READS="${PROJECT_DIR}/data/Anz-0/ERR11437311.fastq.gz"

# Assemblies to evaluate: name -> fasta path
# Add, remove or rename entries to match what you actually assembled
declare -A ASSEMBLIES=(
  [flye]="/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly/flye_assembly/assembly.fasta"
  [lja]="/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly/lja/assembly.fasta"
)

# Container 
CONTAINER="/containers/apptainer/merqury_1.3.sif"

# ============================================================
# Pipeline
# ============================================================

mkdir -p "${OUTPUT_DIR}"

if [[ ! -f "${READS}" ]]; then
  echo "[ERROR] reads not found at ${READS}" >&2
  exit 1
fi

overall_status=0

# Get best k for this genome size
raw_k_output=$(apptainer exec --bind /data "${CONTAINER}" \
      sh /usr/local/share/merqury/best_k.sh "${GENOME_SIZE}")
echo "[DEBUG] best_k raw output: ${raw_k_output}"
K=$(echo "${raw_k_output}" | tail -n1 | awk '{print $NF}')
K=${K%.*}
echo "[INFO] using k=${K}"

# Build meryl db from reads
MERYL_DB="${OUTPUT_DIR}/reads.k${K}.meryl"
if [[ ! -d "${MERYL_DB}" ]]; then
  echo "[RUN] meryl count"
  apptainer exec --bind /data "${CONTAINER}" \
    meryl count k="${K}" threads="${SLURM_CPUS_PER_TASK}" memory=55 \
      "${READS}" output "${MERYL_DB}"
  status=$?
  if [[ $status -ne 0 ]]; then
    echo "[ERROR] meryl count failed (exit ${status}) - aborting, nothing downstream can work without the read db" >&2
    exit 1
  fi
fi

# Run merqury per assembly
for name in "${!ASSEMBLIES[@]}"; do
  fasta="${ASSEMBLIES[$name]}"

  if [[ ! -f "${fasta}" ]]; then
    echo "[SKIP] ${name}: input not found at ${fasta}"
    overall_status=1
    continue
  fi

  outdir="${OUTPUT_DIR}/merqury_${name}"
  rm -rf "${outdir}"
  mkdir -p "${outdir}"

  echo "[RUN] merqury ${name}"
  apptainer exec --bind /data --env MERQURY=/usr/local/share/merqury "${CONTAINER}" \
    bash -c "cd '${outdir}' && merqury.sh '${MERYL_DB}' '${fasta}' '${name}'"
  status=$?
  if [[ $status -ne 0 ]]; then
    echo "[ERROR] merqury ${name} failed (exit ${status})" >&2
    overall_status=1
  fi
  echo "[DONE] ${name}"
done

if [[ $overall_status -ne 0 ]]; then
  echo "One or more steps failed - check the .err log above" >&2
  exit 1
fi

echo "Task complete! Finished at $(date)"