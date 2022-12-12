# nf_findMotifs

A wrapper around `findMotifs.pl` from [Homer](http://homer.ucsd.edu/homer/motif/) to scan fasta files for motif enrichments.

<br>

![CI](https://github.com/ATpoint/nf_findMotifs/actions/workflows/CI.yml/badge.svg)
[![Nextflow](https://img.shields.io/badge/nextflow-%3E%3D21.10.6-green)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)

<br>

## Usage

Run in either of the two supported modes:

1) Use `--mode 'single'` which means that all fasta files provided in `--target` will be scanned against the one fasta file in `--background`.
2) Use `mode 'matched'` which means every of the target fasta files must have its own background file.

Using either 'human' or 'mouse' in `--species` automatically pulls the respective HOCOMOCO motif file for the analysis.

Use these commands, here using the test data in the `test/` folder of this repository and the provided Docker container:

```bash

#/ scan multiple targets against one background:
NXF_VER=21.10.6 nextflow run main.nf -profile docker \
    --mode 'single' --species 'mouse' \
    --target "$(realpath test)"'/set*_targets.fa' --background "$(realpath test)"'/set1_background.fa' \
    --outdir 'dir_test'

#/ scan each target against its background file:    
NXF_VER=21.10.6 nextflow run main.nf -profile docker \
    --mode 'matched' --species 'mouse' \
    --target "$(realpath test)"'/set*_targets.fa' --background "$(realpath test)"'/set*_background.fa' \
    --outdir 'dir_test'

```

## Output:

The output is a folder with the `findMotifs.pl` results. The folder name is a concat of the target basename and the background basename, delimited by `__vs__`, for example `set1_targets__vs__set1_background` when the files were called `set1_targets.fa` and `set1_background.fa`. The command lines and log files will be copied into that folder as well, so there is no need to keep the `work` directory upon completion.
