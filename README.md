# nf_findMotifs

A wrapper around `findMotifs.pl` from [Homer](http://homer.ucsd.edu/homer/motif/) to scan fasta files for motif enrichments.

![CI](https://github.com/ATpoint/nf_findMotifs/actions/workflows/CI.yml/badge.svg)
[![Nextflow](https://img.shields.io/badge/nextflow-%3E%3D21.10.6-green)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000&logo=data%3Aimage%2Fjpeg%3Bbase64%2C%2F9j%2F4AAQSkZJRgABAQAAkACQAAD%2F2wBDABwcHBwcHDAcHDBEMDAwRFxEREREXHRcXFxcXHSMdHR0dHR0jIyMjIyMjIyoqKioqKjExMTExNzc3Nzc3Nzc3Nz%2F2wBDASIkJDg0OGA0NGDmnICc5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ub%2FwAARCACAAHgDASIAAhEBAxEB%2F8QAGgAAAgMBAQAAAAAAAAAAAAAABAUAAgMBBv%2FEADMQAAIBAwIDBgYBAwUAAAAAAAECAAMEESExEpHRBRVBUVJxEyIyYYGxQhQzwUNTgpLh%2F8QAGAEAAwEBAAAAAAAAAAAAAAAAAAIDAQT%2FxAAfEQEBAQACAgMBAQAAAAAAAAAAAQIDESExEkFRIjL%2F2gAMAwEAAhEDEQA%2FADe5rX1PzHSTua19T8x0jYbTsAUdzWvqfmOknc1r6n5jpG8yq1kpDLn8eMAW9zWvqfmOko3ZNmmrOw9yOk0qXdR9F%2BUfbeCHU5OspOP9SvJ%2BIbHs4f6jn2x0lk7OsnVmDVMLvt0lYZb%2FANqr7CG8yS0Z3bQw7OsD%2FNx746TVeybNvpdz%2BR0kk%2B4nLOSn7W7mtfU%2FMdJO5rX1PzHSbJcOujfMIalRagyplM6lb2WdzWvqfmOknc1r6n5jpG8kZpR3Na%2Bp%2BY6SRvJAODadnBtMq9UUU4vHwEILelLi4FEYGrGKWZnPExyTOMxYlmOSZtRoNWbTQDcy8kzHPbdVkqM54UGTDqdid6h%2FA6w6nTSmvCgxLxLu%2FSk459h1taA%2Fjn31mop01BCqADvLznEvmIndp%2BoyNCkf449pg9r4ofwYZkHYzsS4lHRQyspwwwZFYqeJTgxo6K4wwzF1Wk1I66jwMjrHXllg2jWFQYOjTeJwSpBG4jOlUFRc%2BPjKY334rZWskkko1wbRPc1fi1DjYaCMq7%2FDolhvsPzEsrxz7S5L9NKdM1XCL4x0iLTUIuwgtlT4U%2BId2%2FUNi7vd6bjPU7Ud0poXc4UakmILjtaq5K244F8zqeXhO9r1yai242UcR9ztEsMw9rZ69aocu7H8n%2FGJjgeIEk0p06lVxTpqWY%2BAjMZj5dV09tP1N0ubin9FRh%2Bc%2FvM2fs%2B8QZamSPsQYHAHFn2jd1KyUWw%2FEcZIwceJ0noGUOpVtjEHY9HiqPXP8Rwj3OpnoZPTYUuhRipl6L8DjyOhhNymU4xuP1AJzWfGsOZJlRbjpgyS8vZgt63yIvmcxbvp5w69yXT2MFpqTUUHzE6M%2BnPvzo7VQqhR4CWkkkHQ8l2ln%2BtqZ%2B2PbEBjzti3IIul20Vv8RJKy%2BC1yF2d0bSr8Th4gRgjx%2FEEkgHsaF7bXGlNhnyOh5TC9sEuV40wKg2Pn9jPKw%2B37QuaGnFxr5N13i%2FH8b29BYUDb2qIww27e5hkGtbqndoXp5GDgg%2BBhMStcYcSlT4xRtpHEU1Bh2H3MlyRlF2p0ZfIySlr9Te0kbHoRtVdkxjxEzFZiQDiXrj5QfKCx2mckqp4lB85aAUcIylKgBDaYPjEdz2QQS1qdPS3%2BDL9sViPh0VODniOPttNLPtRKgFO5PC%2B3F4HoY079sIKlKpRbhqqUP36zOe3dadVOFwGU%2BeonjrhaaV6iUjlAcCNL2yxjJJJGAuzuGt7hXB0JCsPsek9hPCHY4nuV%2Bke0TTYtF7XNQMQMYz5Q52CqWPgIonNy6666V4537H29V6hIbGkk5aD5S3mZI%2BP8%2BS79%2BBDrxIRF8ZDaB1k4WyNjHK1oNkcB8IRFqsVIYeEPVhUXIgHkr6r8a6dxsDwj2H%2FALmCR1V7GqDWjUDfZtDzHSBP2fepvTJ9iDKSwoMEgcIJA8gTicmzW9wv1UnH%2FEyvwq3%2B2%2F8A1MYM5IStpdP9NJvyMfuH0eyKznNdgg8hqekzsA7G3NzcKP4qQzH22H5nr5jRoUrdPh0hgfv3l6jimvEZPWvs0ga6fAFMeOpgMszF2LNuZtb0%2BN8nZZyW%2FLTon8wdSTgphZJpJOmTrw564NpV1Drgyw2nZoLmUqcGdRyhyIZUphxrv5wJlKHDQA5KiuNOUvFoJGomy12H1awAySYCuh3yJf4qFS2dBvANJIMbqmNsmYPdO2i%2FL%2B4l5Mw8xaMqVVpjXfyi2pUao2W5ShJJydZZEZzwqJDW7rwrnMy4ql2CruY1poKahRK0qS0h5k7may3HjrzUt67SSSSUI4Np2J%2B%2Bbb0vyHWd75tvS%2FIdYA3lWUMMMMxV3zbel%2BQ6yd823pfkOsAMegRqmswKlfqGJl3zbel%2BQ6znfNqf4PyHWAazVf7VT2gR7VsjvTbkOsnetngrwPg77dZlnhsWnVVm%2BkZmY7TsRtTbkOs075tRsj8h1kZw%2FtVvJ%2BCUtWOtQ4%2BwhqoqDCjAirvm29L8h1k75tvS%2FIdZXOJPSd1abyRR3zbel%2BQ6yd823pfkOsYpvJE%2FfNt6X5DrJAP%2F2Q%3D%3D)](https://sylabs.io/docs/)  

## Usage

Run in either of the two supported modes:

1) Use `--mode 'single'` which means that all fasta files provided in `--target` will be scanned against the one fasta file in `--background`.
2) Use `--mode 'matched'` which means every of the target fasta files must have its own background file.

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
