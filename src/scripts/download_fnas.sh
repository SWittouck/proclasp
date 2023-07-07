#!/usr/bin/env bash

# set commandline arguments
fin=$1
dout=$2
filetype=${3:-_genomic.fna} # default is "_genomic.fna.gz"

# create output folder
[ -d $dout ] || mkdir -p $dout

# loop over assembly accessions
for acc in $(cat $fin | cut -f 1) ; do

  echo $acc
  url=ftp.ncbi.nlm.nih.gov/genomes/all/${acc:0:3}/${acc:4:3}/${acc:7:3}/${acc:10:3}/${acc}*/${acc}*${filetype}.gz

  exitcode=1 
  attempt=1
  while [[ $exitcode -ne 0 ]] && [[ $attempt -le 5 ]] ; do
    if [[ $attempt -ne 1 ]] ; then sleep 30 ; echo attempt $attempt ; fi
    rsync --copy-links --times --verbose \
      --exclude *_cds_from_genomic.fna.gz \
      --exclude *_rna_from_genomic.fna.gz \
      rsync://$url $dout # > /dev/null 2>&1
    exitcode=$?
    attempt=$((attempt + 1))
    # echo $exitcode $attempt
    if [[ $exitcode -ne 0 ]] && [[ $attempt -eq 6 ]] ; then 
      echo failure
      echo $acc >> $dout/failed.txt
    fi
  done

done
