#!/bin/bash

# dependency: fastANI version 1.1

# This script splits the fastANI run in batches of reference genomes
# to save memory. When the memory is overloaded, fastANI will abort
# without error message. If this happens, reduce the batch size.

fin_querypaths=$1
din_refgenomes=$2
threads=$3
batch_size=$4

dout=temp.uniquesuffix_1991

for dout_sub in $dout/{refgenome_paths,logs,fastanis_per_batch} ; do
  [ -d $dout_sub ] || mkdir -p $dout_sub
done

# make files with genome paths of refgenomes for fastANI:
# - all.txt: all genome paths
# - txt files with genome paths per batch of genomes
i=0
batch=0
for refgenome_path in $(ls $din_refgenomes/*.fna.gz) ; do
  if [ $((i % batch_size)) -eq 0 ] ; then 
    batch=$((batch + 1)) 
    fout_refgenome_paths_batch=$dout/refgenome_paths/batch$batch.txt
    cp /dev/null $fout_refgenome_paths_batch
  fi
  echo $refgenome_path >> $fout_refgenome_paths_batch
  i=$((i + 1))
done

# FastANI takes query and reference genomes.
# Approach to save memory: split the reference genomes in batches and run 
# once per batch; use all genomes as queries in each run.
# (The other way around saves no memory.)
for fin_batch in $dout/refgenome_paths/batch*.txt ; do

  re="(batch[0-9]+)"
  [[ $fin_batch =~ $re ]] && batch=${BASH_REMATCH[1]}

  echo
  echo Starting fastANI run on $batch
  echo

  fastANI \
    --queryList $fin_querypaths \
    --refList $fin_batch \
    --output $dout/fastanis_per_batch/$batch.txt \
    --threads $threads \
    2>&1 | tee $dout/logs/$batch.txt

done

# Concatenate the results of each batch in one large file. 
cat $dout/fastanis_per_batch/*.txt \
  > $dout/fastanis.txt

