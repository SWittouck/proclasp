#!/usr/bin/env Rscript 

library(tidyverse)

args <- commandArgs(trailingOnly=TRUE)

fin_speciestable <- args[1]
fin_anis <- args[2]
fout <- args[3]
qgenome_regex <- args[4]
rgenome_regex <- args[5]

refgenomes <- read_tsv(
  fin_speciestable,
  col_names = c("genome", "species")
)


anis <-
  read_tsv(fin_anis, col_names = F) %>%
  rename(qgenome_path = X1, rgenome_path = X2, ani = X3) %>%
  mutate(qgenome = str_extract(qgenome_path, !! qgenome_regex)) %>%
  mutate(rgenome = str_extract(rgenome_path, !! rgenome_regex)) %>%
  select(qgenome, rgenome, ani)

anis %>%
  left_join(refgenomes, by = c("rgenome" = "genome")) %>%
  filter(! is.na(species)) %>%
  group_by(qgenome, species) %>%
  arrange(desc(ani)) %>%
  slice(1) %>%
  ungroup() %>%
  group_by(qgenome) %>%
  arrange(qgenome, desc(ani)) %>%
  slice(1) %>%
  ungroup() %>%
  select(qgenome, species, ani) %>%
  write_csv(fout)

