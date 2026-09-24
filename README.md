# Genome and Transcriptome Assembly Course Repository

This is the repository for the semester project for the Genome and Transcriptome assembly course at the University of Bern. 
## Organisational matters
#### Scripts:
Scripts are housed in the /scripts directory. 
Most scripts use containers housed on the unibe cluster.
#### Data: 
Data is soft linked to the course data directory. For the course I am assigned to use the Azn-0 sample.Reference to brassicales_odb10 lineage. 
#### Tools
Tools are listed below and were used as apptainers on the unibe HPC system.



File structure as follows: 
```
project/
├── data/                    # Input data files
│   ├──  Anz-0                # Original datasets
│   └── RNASeq_sha
├── scripts/                 # Analysis scripts
├── results/                 # Output results
│   ├── figures/           # Visualisations
│   ├── assembly/          # Assembly results
│   ├── evaluation/         # Evaluation results
│   └── quality_control/    # QC Results
└── README.md               # Documentation

```

## Tools 
Following is the list of tools used for the project:

1. FastQC - https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
2. fastp - https://github.com/OpenGene/fastp
3. Genomescope Jellyfish - http://genomescope.org/genomescope2.0/
4. flye - https://github.com/mikolmogorov/Flye
5. hifiasm - https://github.com/chhylp123/hifiasm
6. LJA - https://github.com/AntonBankevich/LJA
7. Trinity - https://github.com/trinityrnaseq/trinityrnaseq/wiki
8. BUSCO - https://busco.ezlab.org
9. QUAST - https://quast.sourceforge.net
10. merqury - https://github.com/marbl/merqury
11. nucmer & mummer - https://mummer4.github.io/manual/manual.html

## Following along:
The scripts were run in the following general order:
1. Quality control: FastQC
2. Trimming: Fastp
3. Quality control: FastQC  
4. Assemblies: flye, hifiasm, LJA, Trinity
5. Evaluation: BUSCO, Quast, merqury, mummer


