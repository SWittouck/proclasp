#!/usr/bin/env bash 

ls testgenomes/*.fna.gz > testgenomes_paths.txt

../proclasp/proclasp \
  testgenomes_paths.txt \
  lgc_representatives \
  lgc_representatives.tsv \
  testgenomes_species.csv \
  --qgenome_regex 'GC[AF]_[0-9]+\.[0-9]' \
  --rgenome_regex 'GC[AF]_[0-9]+\.[0-9]' \
  --threads 16 \
  --batch_size 900
