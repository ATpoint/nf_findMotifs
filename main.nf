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
params.mem        = 8.GB
params.outdir     = "./"
params.additional = ''


// --------------------------------------------------------------------------------------------------------------------

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

// Input data:
foreground  = Channel
                .fromPath(params.targets, checkIfExists: true)

// check if exists:
background  = Channel
                .fromPath(params.background, checkIfExists: true)


process DownloadMotifs {

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

process findMotifs {

    tag "$foreground"

    cpus   params.threads
    memory params.mem

    publishDir params.outdir, mode: 'move'

    input:
    path(foreground)
    path(background)
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

workflow MotifScan {

    DownloadMotifs(url_motif)

    findMotifs(foreground, params.background, DownloadMotifs.out.motifs)

}

workflow { MotifScan() }
