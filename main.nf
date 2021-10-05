#! /usr/bin/env nextflow

//
// Scan fasta files for motif enrichments
//

// --------------------------------------------------------------------------------------------------------------------

nextflow.enable.dsl=2

// --------------------------------------------------------------------------------------------------------------------

params.target     = ''        // path to the foreground fasta files
params.background = ''        // path to background fasta file(s). 
params.species    = 'mouse'   // species, will then download mouse or human hocomoco Homer files
params.threads    = 1   
params.mem        = 8.GB
params.outdir     = "./"
params.additional = ''        // additional params for findMotifs.pl
params.split_at   = '_'       // unique delimiter of input files to get basenames from, must be same between 
                              // fore(background in case of --mode matched
params.mode       = 'matched' // mode, either matched or single


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

// CASE 1: Each foreground has a matched background:
if(params.mode=="matched"){

    foreground  = Channel
                    .fromPath(params.target, checkIfExists: true)
                    .map { file -> tuple(file.baseName.split(params.split_at)[0], file) }

    background  = Channel
                    .fromPath(params.background, checkIfExists: true)
                    .map { file -> tuple(file.baseName.split(params.split_at)[0], file) }

    joined = foreground.join(background)
}

// CASE 2: Each foreground is to be run against the same background:
if(params.mode=="single"){

    foreground  = Channel
                    .fromPath(params.target, checkIfExists: true)
                    .map { file -> tuple(file.baseName.split(params.split_at)[0], file) }

    background  = Channel
                    .fromPath(params.background, checkIfExists: true)

    joined = foreground.combine(background)         

}


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

workflow MotifScan {

    DownloadMotifs(url_motif)

    findMotifs(joined, DownloadMotifs.out.motifs)

}

workflow { MotifScan() }
