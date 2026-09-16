# Genome and Transcriptome Assembly Course Repository

This is the repository for the semester project for the Genome and Transcriptome assembly course at the University of Bern. 
## Organisational matters
#### Scripts:
Scripts are housed in the /scripts directory. 
Most scripts use containers housed on the unibe cluster.
#### Data: 
Data is soft linked to the course data directory. For the course I am assigned to use the Azn-0 sample.



File structure as follows: 
```
project/
├── data/                    # Input data files
│   └──  raw/                # Original datasets
├── scripts/                 # Analysis scripts
├── results/                 # Output results
│   ├── figures/           # Visualisations
│   ├── assembly/          # Assembly results
│   ├── evaluation/         # Evaluation results
│   └──  quality_control/    # QC Results
└── README.md               # Documentation

```

## Tools 
Following is the list of tools used for the project:

1. FastQC
2. fastp
3. Genomescope Jellyfish
4. flye
5. hifiasm
6. LJA
7. Trinity
8. BUSCO
9. QUAST
10. nucmer
11. mummer


