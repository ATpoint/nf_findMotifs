# nf_findMotifs

A wrapper around `findMotifs.pl` from Homer to scan fasta files for motif enrichments.

<br>

![CI](https://github.com/ATpoint/nf_findMotifs/actions/workflows/CI.yml/badge.svg)
[![Nextflow](https://img.shields.io/badge/nextflow-%3E%3D21.10.6-green)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)

<br>

## Usage

The workflow is simple. We provide one or multiple fasta files as "target" and one or multiple fasta files as "background". `findMotifs.pl` will scan the target for motif enrichment relative to the background. As reference motif collection the pipeline will download the HOCOMOCO motif collection in Homer format. We hardcoded two options for `params.species`, which are `human` and `mouse`, to download the correct file for the respective species. The params definition works via `schema.nf` using [nf_blank](https://github.com/ATpoint/nf_blank).

Basic command:  

```bash

#/ scan multiple targets against one background:
NXF_VER=21.10.6 nextflow run main.nf -profile docker \
    --mode 'single' \
    --species 'mouse' \
    --target "$(realpath test)"'/set*_targets.fa' \
    --background "$(realpath test)"'/set1_background.fa' \
    --outdir 'dir_test'

#/ scan each target against its background file:    
NXF_VER=21.10.6 nextflow run main.nf -profile docker \
    --mode 'matched' \
    --species 'mouse' \
    --target "$(realpath test)"'/set*_targets.fa' \
    --background "$(realpath test)"'/set*_background.fa' \
    --outdir 'dir_test'

```

There are two `--mode` options:

- `matched` means that each single target fasta as its individual background file. In this case the basenames of the target and background files must be identical, e.g. `set1_target.fa` and `set1_background.fa`. The delimiter must be specified with `params.split_at` and is by default an underscore. 

- `single` means that each target will be scanned against the same background. In this case only a single background file must be provided. There is currently no check to enforce this, the user has to ensure it.

## Output:

The output will be folders in which `findMotifs.pl` stores the results. These will be a concat of the target basename and the background basename, delimited by `__vs__`, e.g. `set1_targets__vs__set1_background`, collected in a directory defined by `params.outdir`. Publishing mode `move` is hardcoded for this pipeline, the hidden `.sh` and `.log` files will be published to the `params.outdir`, so the `work` directory can safely be deleted upon successful run completion.
