# nf_findMotifs

Homer `findMotifs.pl` via Nextflow. That's all.

<br>

![CI](https://github.com/ATpoint/nf_findMotifs/actions/workflows/CI.yml/badge.svg)
[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A521.04.0-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)

<br>

The command takes as only mandatory params a fasta file with target sequences (e.g. ChIP-seq peaks that are differential) and a fasta file with backgrounds (e.g. all peaks) and then runs the `findMotifs.pl` script from [Homer](http://homer.ucsd.edu/homer/motif/) to scan for enriched motifs. We hardcoded two reference sets of motifs to compare found motifs against which are the HOCOMOCO v11 sets for mouse and human. These can be specified via `--species mouse/human`. 

**Example:**

```nextflow

#/ run the example data in the test folder:
nextflow run main.nf -profile test,docker --species mouse`

#/ or provide targets and background:
nextflow run main.nf -profile test,docker \
    --targets $(realpath path/to/targets.bed) --background $(realpath path/to/bg.bed) \
    --species mouse \

```

Use `--outdir` to specify an overall output directory. The name of the folder that Homer creates for each run is a concat of the targets and background filename (without the suffix) delimited by `__vs__`.
Use `-profile docker/singularity/conda` if `findMotifs.pl` is not in PATH.