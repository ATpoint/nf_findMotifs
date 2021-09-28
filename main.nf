#! /usr/bin/env nextflow

//
// Scan fasta files for motif enrichments
//

// --------------------------------------------------------------------------------------------------------------------

nextflow.enable.dsl=2

// --------------------------------------------------------------------------------------------------------------------

params.targets    = ''
params.background = ''
params.species    = 'mouse'
params.threads    = 1
params.mem        = 1.GB
params.outdir     = "./"
params.additional = ''


// --------------------------------------------------------------------------------------------------------------------

// input fasta files:
targets    = Channel.fromPath(params.targets, checkIfExists: true)
background = Channel.fromPath(params.background, checkIfExists: true)

// download HOCOMOCO reference motifs for mouse or human:
if(params.species == "mouse"){
    url_motif = "https://hocomoco11.autosome.ru/final_bundle/hocomoco11/core/MOUSE/mono/HOCOMOCOv11_core_MOUSE_mono_homer_format_0.0005.motif"
} else {
    if(params.species == "human"){
        url_motif = "https://hocomoco11.autosome.ru/final_bundle/hocomoco11/core/HUMAN/mono/HOCOMOCOv11_core_HUMAN_mono_homer_format_0.0005.motif"
    } else {
        println("(Error) -- params.species must be <mouse/human>")
        exit 1
    }
}

process DownloadMotifs {

    input:
    val(url)

    output:
    path("*.motif"), emit: downloaded

    script:
    """
    wget -q $url
    """
}

process findMotifs {

    tag "$input_fa"

    cpus   params.threads
    memory params.mem

    publishDir params.outdir, mode: 'move'

    input:
    path(input_fa)
    path(background_fa)
    path(motifs_reference)

    output:
    path(foldername)

    script:
    n1 = [input_fa].join("").split("\\.")[0]
    n2 = [background_fa].join("").split("\\.")[0]
    foldername = [n1, n2].join('__vs__')

    """
    findMotifs.pl \
        $input_fa fasta $foldername -fasta $background_fa \
        -mcheck $motifs_reference -mknown $motifs_reference \
        -p $task.cpus $params.additional
    """

}

workflow MotifScan {

    DownloadMotifs(url_motif)

    findMotifs(targets, background, DownloadMotifs.out.downloaded)

}

workflow { MotifScan() }