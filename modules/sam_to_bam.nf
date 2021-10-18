// Index a genome with bowtie2

process Sam2Bam {

    cpus   params.threads
    memory params.mem

    publishDir params.outdir, mode: params.pubmode

    input:
    tuple val(sample_id), path(sam)
        
    output:
    path("${sample_id}.bam"), emit: bam
    path("${sample_id}_Sam2Bam_versions.txt"), emit: software_versions
    path("${sample_id}_Sam2Bam.sh")
    path("${sample_id}_Sam2Bam.log")

    script: 
    """

    #/ the actual process:
    samtools view -@ $task.cpus -o ${sample_id}.bam $sam

    #/ get software version:
    echo "samtools:" \$(samtools --version | head -n 1 | cut -d " " -f2 ) > ${sample_id}_Sam2Bam_versions.txt

    #/ publish hidden files:
    cat .command.sh > ${sample_id}_Sam2Bam.sh
    cat .command.log > ${sample_id}_Sam2Bam.log

    """                

}