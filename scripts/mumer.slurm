#!/usr/bin/env bash
#SBATCH --job-name="plot"
#SBATCH --output=/data/users/rbharatia/Genome_transcriptome_assembly/results/evaluation/mummer_%j.out
#SBATCH --error=/data/users/rbharatia/Genome_transcriptome_assembly/logs/evaluation/mummer_%j.err
#SBATCH --time=3:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=rohit.bharatia@students.unibe.ch

set -uo pipefail

# ============================================================
# USER CONFIG: replace every <PLACEHOLDER> below
# ============================================================

# Project root (submit the job from here; leave as is)
PROJECT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly"

# Output folder for all MUMmer results
OUTPUT_DIR="/data/users/rbharatia/Genome_transcriptome_assembly/results/evaluation"

# Reference genome (check which one your assignment tells you to use)
REF_DIR="/data/courses/assembly-annotation-course/references"
REFERENCE="${REF_DIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"

# Assemblies to evaluate: name -> fasta path
# Add, remove or rename entries to match what you actually assembled
declare -A ASSEMBLIES=(
  [flye]="/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly/flye_assembly/assembly.fasta"
  [lja]="/data/users/rbharatia/Genome_transcriptome_assembly/results/assembly/lja/assembly.fasta"
)

# Assembly-vs-assembly comparisons, using the names above
# One "nameA nameB" pair per entry; delete this list's contents if you only
# want comparisons against the reference
PAIRS=(
  "flye lja"
)

# Container (verify this path exists on your cluster)
CONTAINER="/containers/apptainer/mummer4_gnuplot.sif"

# ============================================================
# Pipeline (normally no changes needed below)
# ============================================================

mkdir -p "${OUTPUT_DIR}/vs_ref" "${OUTPUT_DIR}/pairwise" logs

run_nucmer_and_plot () {
  local prefix="$1" ref="$2" query="$3" outdir="$4"

  echo "[RUN] nucmer ${prefix}"
  apptainer exec --bind "${PROJECT_DIR}" --bind "${REF_DIR}" "${CONTAINER}" \
    nucmer --prefix="${outdir}/${prefix}" \
           --breaklen 1000 \
           --mincluster 1000 \
           --threads "${SLURM_CPUS_PER_TASK}" \
           "${ref}" "${query}"

  echo "[RUN] mummerplot ${prefix}"
  apptainer exec --bind "${PROJECT_DIR}" --bind "${REF_DIR}" "${CONTAINER}" \
    mummerplot --prefix="${outdir}/${prefix}" \
               -R "${ref}" -Q "${query}" \
               --filter -t png --large --layout --fat \
               "${outdir}/${prefix}.delta"

  echo "[DONE] ${prefix}"
}

# Each assembly vs reference genome
for name in "${!ASSEMBLIES[@]}"; do
  fasta="${ASSEMBLIES[$name]}"
  if [[ ! -f "${fasta}" ]]; then
    echo "[SKIP] ${name}: input not found at ${fasta}"
    continue
  fi
  run_nucmer_and_plot "${name}_vs_ref" "${REFERENCE}" "${fasta}" "${OUTPUT_DIR}/vs_ref"
done

# Assembly vs assembly
for pair in "${PAIRS[@]}"; do
  read -r a b <<< "${pair}"
  fasta_a="${ASSEMBLIES[$a]:-}"
  fasta_b="${ASSEMBLIES[$b]:-}"
  if [[ ! -f "${fasta_a}" || ! -f "${fasta_b}" ]]; then
    echo "[SKIP] ${a}_vs_${b}: missing input"
    continue
  fi
  run_nucmer_and_plot "${a}_vs_${b}" "${fasta_a}" "${fasta_b}" "${OUTPUT_DIR}/pairwise"
done

echo "[ALL DONE]"