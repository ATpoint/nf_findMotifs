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
    path("${foldername}_findMotifs.sh")
    path("${foldername}_findMotifs.log")

    script:
    n1 = [foreground].join("").split("\\.")[0]
    n2 = [background].join("").split("\\.")[0]
    foldername = [n1, n2].join('__vs__')
    
    """
    findMotifs.pl \
        $foreground fasta $foldername -fasta $background \
        -mcheck $motifs_reference -mknown $motifs_reference \
        -p $task.cpus $params.additional

    #/ publish command and log into the findMotifs.pl output folders:
    cat .command.sh > ${foldername}_findMotifs.sh
    cat .command.log > ${foldername}_findMotifs.log

    #/ return no software version as findMotifs.pl has no flag for that, check env.yml/container for it
    #/ currently it is 4.11

    """

}
