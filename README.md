# nf_findMotifs

Homer `findMotifs.pl` via Nextflow. That's all.

<br>

![CI](https://github.com/ATpoint/nf_findMotifs/actions/workflows/CI.yml/badge.svg)
[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A521.04.0-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)

<br>

Scan for motif enrichment between two fasta files using `findMotifs.pl` script from [Homer](http://homer.ucsd.edu/homer/motif/).
There are two options available via `--mode matched/single`:

- **matched** means the user is supposed to provide pairs of fasta files, so each target file has its own background. It is expected that the files have proper names, so e.g. `set1_target.fa` and `set1_background.fa` which can be matched after stripping a unique delimiter, controlled by `--split_at` (default `_`). 
- **single** means that all target fasta files in `--target` will be compared to a single fasta in `--background`.

There are two hardcoded options for the motif file itself (in Homer format) via `--species houman/mouse` which then pulls from HOCOMOCO the motif files to compare enriched motifs against for identification.

**Example:**

```nextflow

#/ run the example data in the test folder:
nextflow run main.nf -profile test_single,docker --species mouse
nextflow run main.nf -profile test_matched,docker --species mouse


```

Use `--outdir` to specify an overall output directory. The name of the folder that Homer creates for each run is a concat of the targets and background filename (without the suffix) delimited by `__vs__`.
Use `-profile docker/singularity/conda` if `findMotifs.pl` is not in PATH.
