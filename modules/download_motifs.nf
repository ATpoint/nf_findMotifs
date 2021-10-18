process downloadMotifs {

    cpus 1
    memory 1.GB

    publishDir params.outdir, mode: 'copy'

    input:
    val(url)

    output:
    path("*.motif"), emit: motifs

    script:
    """
    wget -q $url
    """
}
