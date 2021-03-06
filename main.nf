#! /usr/bin/env nextflow

nextflow.enable.dsl=2

//-----------------------------------------------------------------------

// A pipeline to wrap Homer findMotifs.pl

//-----------------------------------------------------------------------

// validate params and print summary messages:
evaluate(new File("${baseDir}/functions/validate_schema_params.nf"))

//-----------------------------------------------------------------------

// download HOCOMOCO reference motifs for mouse or human depending on hardcoded params.species
include { downloadMotifs } from './modules/download_motifs'

if(params.species == "mouse"){
    url_motif = "https://hocomoco11.autosome.ru/final_bundle/hocomoco11/core/MOUSE/mono/HOCOMOCOv11_core_MOUSE_mono_homer_format_0.0005.motif"
}
if(params.species == "human"){
    url_motif = "https://hocomoco11.autosome.ru/final_bundle/hocomoco11/core/HUMAN/mono/HOCOMOCOv11_core_HUMAN_mono_homer_format_0.0005.motif"
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
                    .map { file -> tuple(file.baseName, file) }

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

workflow { 

    MotifScan() 
    
    workflow.onComplete {
        println ""
        println "Pipeline completed!"
    }
    
}
