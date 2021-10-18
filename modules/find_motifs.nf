process findMotifs {

    tag "$sample_id"

    cpus   params.threads
    memory params.mem

    publishDir params.outdir, mode: 'move'

    input:
    tuple val(sample_id), path(foreground), path(background)
    path(motifs_reference)

    output:
    path(foldername)

    script:
    n1 = [foreground].join("").split("\\.")[0]
    n2 = [background].join("").split("\\.")[0]
    foldername = [n1, n2].join('__vs__')
    
    """
    findMotifs.pl \
        $foreground fasta $foldername -fasta $background \
        -mcheck $motifs_reference -mknown $motifs_reference \
        -p $task.cpus $params.additional
    """

}
