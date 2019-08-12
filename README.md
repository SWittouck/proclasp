# Proclasp: classification of prokaryotic genomes on the species level

Proclasp is a simple tool to classify prokaryotic genomes on the species level, given a set of reference genomes with known species labels. 

Proclasp will report, for each query genome, the reference genome with the highest similariy, along with the fastANI value. The user can then judge for themselves whether the fastANI value is within species range or not. 

## Dependencies

* [fastANI](https://github.com/ParBLiSS/FastANI)
* [R](https://www.r-project.org/) version >= 3.5.1 
* R packages:
    * [tidyverse](https://www.tidyverse.org/) version >= 1.2.1

## Usage

```
usage: A tool to classify prokaryotic genomes on the species level
       [-h] [--qgenome_regex QGENOME_REGEX] [--rgenome_regex RGENOME_REGEX]
       [--threads THREADS] [--batch_size BATCH_SIZE]
       fin_querypaths din_refgenomes fin_speciestable fout

positional arguments:
  fin_querypaths        file with paths to the query genome fasta files
  din_refgenomes        directory containing the reference genome fasta files
  fin_speciestable      tab-separated file without header where the first
                        column contains the genome names and the second
                        contains the species labels
  fout                  name of the output file with the species
                        classifications

optional arguments:
  -h, --help            show this help message and exit
  --qgenome_regex QGENOME_REGEX
                        R-type regular expression to extract the query genome
                        name from its file path; by default this is the file
                        name, assuming a .fna suffix
  --rgenome_regex RGENOME_REGEX
                        R-type regular expression to extract the reference
                        genome name from its file path; by default this is the
                        file name, assuming a .fna suffix
  --threads THREADS     number of threads to use for the fastANI calculations;
                        the default is 4
  --batch_size BATCH_SIZE
                        number of query genomes to use per batch; the default
                        is 350, which will need ~ 4 GB of RAM
```

## Tutorial 

As a very quick tutorial, we will classify three genomes of the Lactobacillus Genus Complex. The necessary scripts and data are in the folder `lactobacillus`. 

First, we download the reference genomes. We use a reference dataset with one representative genome for each species of the Lactobacillus Genus Complex, containing a total of 239 genomes.  

    ./download_refgenomes.sh

Next, we download the three test genomes.

    ./download_testgenomes.sh

Finally, we classify them using proclasp:

    ./classify_testgenomes.sh

If all goes well, the output is a file called "testgenomes_species.csv", containing for each genome the most closely related species and the fastANI value to the representative genome of that species.

These scripts can easily be modified to classify any set of Lactobacillus genomes. 
