#! /usr/bin/env nextflow

nextflow.enable.dsl=2

//-----------------------------------------------------------------------

// A pipeline to wrap Homer findMotifs.pl

//-----------------------------------------------------------------------

// Check for the required nextflow version,
// print an introduction message summarizing workflow parameters
// and then validate the params, print summary of all valid params.
// That is all part of validateParams()

include { validateParams } from './functions/functions'
validateParams()

//-----------------------------------------------------------------------

// download HOCOMOCO reference motifs for mouse or human depending on hardcoded params.species
include { downloadMotifs } from './modules/download_motifs'

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

// --------------------------------------------------------------------------------------------------------------------

include { findMotifs } from './modules/find_motifs'

// CASE 1: Each foreground fasta file has a matched background:
if(params.mode=="matched"){

    foreground  = Channel
                    .fromPath(params.target, checkIfExists: true)
                    .map { file -> tuple(file.baseName.split(params.split_at)[0], file) }

    background  = Channel
                    .fromPath(params.background, checkIfExists: true)
                    .map { file -> tuple(file.baseName.split(params.split_at)[0], file) }

    joined = foreground.join(background)
}

// CASE 2: Each foreground fasta has the same background:
if(params.mode=="single"){

    foreground  = Channel
                    .fromPath(params.target, checkIfExists: true)
                    .map { file -> tuple(file.baseName.split(params.split_at)[0], file) }

    background  = Channel
                    .fromPath(params.background, checkIfExists: true)

    joined = foreground.combine(background)         

}

// --------------------------------------------------------------------------------------------------------------------

// define and execute the workflow:
workflow MotifScan {

    downloadMotifs(url_motif)

    findMotifs(joined, downloadMotifs.out.motifs)

}

workflow { MotifScan() }